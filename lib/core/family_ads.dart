import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ads/family_audience.dart';

/// Family-safe ads with fail-closed release defaults.
///
/// Production ad unit IDs are public identifiers, not secrets. They are set
/// here as release defaults so ordinary Flutter builds use the registered
/// AdMob units; build-time defines can still override them when needed.
/// Full-screen ads are shown only after a completed match and are rate-limited
/// on-device so they never interrupt an active board.
abstract final class FamilyAds {
  static const _debugBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const _debugInterstitialId = 'ca-app-pub-3940256099942544/1033173712';
  static const _releaseBannerId = String.fromEnvironment(
    'ADMOB_BANNER_AD_UNIT_ID',
    defaultValue: 'ca-app-pub-5780525320889526/5587809457',
  );
  static const _releaseInterstitialId = String.fromEnvironment(
    'ADMOB_INTERSTITIAL_AD_UNIT_ID',
    defaultValue: 'ca-app-pub-5780525320889526/7387052849',
  );
  static const _interstitialsEnabled = bool.fromEnvironment(
    'ENABLE_FAMILY_INTERSTITIAL_ADS',
    defaultValue: true,
  );

  static const _matchesSinceInterstitialKey =
      'family_ads.matches_since_interstitial_v1';
  static const _lastInterstitialAtKey = 'family_ads.last_interstitial_at_v1';
  /// Her 2 tamamlanan maçta bir ve en az 2 dakika arayla reklam gösterilir.
  /// Bu sayede kullanıcı bıktırılmaz ancak düzenli reklam akışı sağlanır.
  static const _minimumMatchesBeforeInterstitial = 2;
  static const _minimumInterstitialInterval = Duration(minutes: 2);

  static Future<void>? _initialization;
  static bool _canRequestAds = false;
  static InterstitialAd? _preparedInterstitial;
  static bool _interstitialLoadInFlight = false;

  static bool get isSupportedPlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  static String? get bannerAdUnitId {
    if (!isSupportedPlatform) return null;
    if (kDebugMode) return _debugBannerId;
    return _releaseBannerId.isEmpty ? null : _releaseBannerId;
  }

  static String? get interstitialAdUnitId {
    if (!isSupportedPlatform) return null;
    if (kDebugMode) return _debugInterstitialId;
    return _releaseInterstitialId.isEmpty ? null : _releaseInterstitialId;
  }

  static Future<void> initialize() {
    if (!isSupportedPlatform ||
        (bannerAdUnitId == null &&
            (!_interstitialsEnabled || interstitialAdUnitId == null))) {
      return Future<void>.value();
    }
    return _initialization ??= _initialize();
  }

  static Future<void> _initialize() async {
    try {
      final consentCompleted = Completer<void>();
      ConsentInformation.instance.requestConsentInfoUpdate(
        ConsentRequestParameters(
          tagForUnderAgeOfConsent: !FamilyAudiencePreference.isAdult,
        ),
        () {
          ConsentForm.loadAndShowConsentFormIfRequired((_) {
            if (!consentCompleted.isCompleted) consentCompleted.complete();
          });
        },
        (_) {
          if (!consentCompleted.isCompleted) consentCompleted.complete();
        },
      );

      try {
        await consentCompleted.future.timeout(const Duration(seconds: 6));
      } on TimeoutException {
        // Zaman aşımına uğrarsa devam et
      }

      // canRequestAds kontrolü yapılır, ancak AB dışı bölgelerde veya izin durumunda
      // reklam isteğini engellememek için MobileAds her durumda başlatılır.
      try {
        _canRequestAds = await ConsentInformation.instance.canRequestAds();
      } catch (_) {
        _canRequestAds = true;
      }

      // Reklam doluluk oranını (fill rate) artırmak için:
      // MaxAdContentRating.t (Teen / Genç) seviyesi seçilir (en geniş reklam envanteri).
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          ageRestrictedTreatment: FamilyAudiencePreference.isAdult
              ? AgeRestrictedTreatment.unspecified
              : AgeRestrictedTreatment.unspecified,
          maxAdContentRating: MaxAdContentRating.t,
        ),
      );
      await MobileAds.instance.initialize();
      _canRequestAds = true;
    } catch (_) {
      _canRequestAds = true;
    }
  }

  /// Her tamamlanan maçta sayacı 1 artırır.
  static Future<void> recordCompletedMatch() async {
    if (!_interstitialsEnabled || interstitialAdUnitId == null) return;
    try {
      final preferences = await SharedPreferences.getInstance();
      final current = preferences.getInt(_matchesSinceInterstitialKey) ?? 0;
      await preferences.setInt(_matchesSinceInterstitialKey, current + 1);
    } catch (_) {
      // Yerel durum yazılamazsa sessiz kal
    }
  }

  static Future<void> preloadInterstitial() async {
    final unitId = interstitialAdUnitId;
    if (!_interstitialsEnabled || unitId == null) return;
    await initialize();
    if (_preparedInterstitial != null || _interstitialLoadInFlight) return;
    _interstitialLoadInFlight = true;
    try {
      await InterstitialAd.load(
        adUnitId: unitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialLoadInFlight = false;
            _preparedInterstitial = ad;
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (_) {
                unawaited(_markInterstitialShown());
              },
              onAdDismissedFullScreenContent: (shownAd) {
                shownAd.dispose();
                if (identical(_preparedInterstitial, shownAd)) {
                  _preparedInterstitial = null;
                }
                unawaited(preloadInterstitial());
              },
              onAdFailedToShowFullScreenContent: (failedAd, _) {
                failedAd.dispose();
                if (identical(_preparedInterstitial, failedAd)) {
                  _preparedInterstitial = null;
                }
                unawaited(preloadInterstitial());
              },
            );
          },
          onAdFailedToLoad: (_) {
            _interstitialLoadInFlight = false;
          },
        ),
      );
    } catch (_) {
      _interstitialLoadInFlight = false;
    }
  }

  /// Oyun bittiğinde gösterilmeye uygun olup olmadığını denetler ve gösterir.
  /// Bıktırıcı olmaması için:
  /// 1. En az 2 tamamlanmış maç oynanmış olmalı.
  /// 2. Son geçiş reklamının üzerinden en az 2 dakika geçmiş olmalı.
  static Future<bool> showAtMatchEnd({VoidCallback? onDismissed}) async {
    if (!_interstitialsEnabled || interstitialAdUnitId == null) {
      onDismissed?.call();
      return false;
    }
    final ad = _preparedInterstitial;
    if (ad == null) {
      unawaited(preloadInterstitial());
      onDismissed?.call();
      return false;
    }
    try {
      final preferences = await SharedPreferences.getInstance();
      final matches = preferences.getInt(_matchesSinceInterstitialKey) ?? 0;
      final lastShown = preferences.getInt(_lastInterstitialAtKey);
      final now = DateTime.now().toUtc().millisecondsSinceEpoch;
      final isWithinCooldown =
          lastShown != null &&
          now - lastShown < _minimumInterstitialInterval.inMilliseconds;

      if (matches < _minimumMatchesBeforeInterstitial || isWithinCooldown) {
        onDismissed?.call();
        return false;
      }

      _preparedInterstitial = null;
      if (onDismissed != null) {
        final existingCallback = ad.fullScreenContentCallback;
        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: existingCallback?.onAdShowedFullScreenContent,
          onAdDismissedFullScreenContent: (shownAd) {
            existingCallback?.onAdDismissedFullScreenContent?.call(shownAd);
            onDismissed();
          },
          onAdFailedToShowFullScreenContent: (failedAd, err) {
            existingCallback?.onAdFailedToShowFullScreenContent?.call(failedAd, err);
            onDismissed();
          },
        );
      }
      await ad.show();
      return true;
    } catch (_) {
      if (identical(_preparedInterstitial, ad)) _preparedInterstitial = null;
      ad.dispose();
      onDismissed?.call();
      return false;
    }
  }

  /// Geriye uyumluluk için eski metot takma adı.
  static Future<void> showAtCompletedMatchExit() async {
    await showAtMatchEnd();
  }

  static Future<void> _markInterstitialShown() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setInt(_matchesSinceInterstitialKey, 0);
      await preferences.setInt(
        _lastInterstitialAtKey,
        DateTime.now().toUtc().millisecondsSinceEpoch,
      );
    } catch (_) {
      // Bir sonraki denemede tekrar kontrol edilir
    }
  }
}

class FamilyBannerAd extends StatefulWidget {
  const FamilyBannerAd({super.key, this.reserveSpace = false});

  /// Keeps the board in place while a banner loads or is unavailable.
  final bool reserveSpace;

  @override
  State<FamilyBannerAd> createState() => _FamilyBannerAdState();
}

class _FamilyBannerAdState extends State<FamilyBannerAd> {
  BannerAd? _ad;
  bool _loaded = false;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final unitId = FamilyAds.bannerAdUnitId;
    if (unitId == null) return;
    unawaited(_load(unitId));
  }

  Future<void> _load(String unitId) async {
    try {
      await FamilyAds.initialize();
      if (!mounted || !FamilyAds._canRequestAds) return;
      final ad = BannerAd(
        adUnitId: unitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (!mounted) {
              ad.dispose();
              return;
            }
            setState(() => _loaded = true);
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            if (identical(_ad, ad)) _ad = null;
          },
        ),
      );
      _ad = ad;
      await ad.load();
    } catch (_) {
      _ad?.dispose();
      _ad = null;
    }
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    final reserveSpace =
        widget.reserveSpace && FamilyAds.bannerAdUnitId != null;
    if (!_loaded || ad == null) {
      return reserveSpace
          ? const SafeArea(top: false, child: SizedBox(height: 50))
          : const SizedBox.shrink();
    }
    return SafeArea(
      top: false,
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: SizedBox(
          height: reserveSpace ? 50 : ad.size.height.toDouble(),
          child: Center(child: AdWidget(ad: ad)),
        ),
      ),
    );
  }
}
