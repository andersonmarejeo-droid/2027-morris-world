# 3-9-12 Taş — Play Store materials and declarations (draft)

**Status:** working draft; not submitted to Google Play and not legal advice  
**Prepared:** 2 October 2026  
**Product contact in the current privacy page:** Mustafa Polat · ZP GAMES · andersonmarejeo@gmail.com

**Historical Play Console check (28 September 2026):** the app was still a draft; the
dashboard shows 7/11 setup tasks complete. The visible unfinished tasks are
target audience, Data Safety, category/contact details, and the store listing.
Closed testing has not started and currently shows 0 enrolled testers. Opening
the default Turkish listing confirmed that the app name is already filled in,
while the short description, full description, feature graphic, and phone
screenshots still need completion. Nothing was saved or published during this
check.

This pack is based on the source currently in this checkout, not on an
inspected Play release bundle. A release can differ when Dart build flags,
manifest merging, AdMob IDs, or Firebase Remote Config values change. Review
the exact AAB and every answer in Play Console before making a legal
declaration or publishing a listing.

## Store listing copy

**App name**  
3-9-12 Taş

**Short description (TR, 75/80 characters)**  
3, 9 ve 12 taş oyunlarını çevrimdışı keşfet; her hamlede yeni strateji kur.

**Full description (TR, draft)**

Üç klasik taş oyununu tek uygulamada keşfet: 3 Taş, 9 Taş ve 12 Taş.

Taşlarını dikkatle yerleştir, üçlüleri tamamla ve rakibinin hamlelerini
önceden düşün. Bilgisayara karşı tek başına oyna ya da aynı cihazı paylaşarak
karşılıklı mücadele et. Oyunların temel yerel modları internet bağlantısı
olmadan oynanabilir.

Tahta ve taş görünümünü kişiselleştir; dil, ses, titreşim ve hamle ipuçlarını
tercihine göre ayarla. Oyun kayıtları ve tercihler cihazında tutulur.

**Bu sürümde öne çıkarılmayan özellikler:** çevrimiçi eşleştirme, sıralamalar,
ödüller, sohbet, hesapla ilerleme eşitleme veya uygulama içi satın alma.
Kaynakta bulunan çevrimiçi Firebase adayı varsayılan olarak kapalıdır; tam
olarak mağazaya yüklenecek AAB ayrıca doğrulanmalıdır.

**Category:** Games → Board (Play Console formunda mevcut seçimi tekrar
doğrula).  
**Privacy policy:** https://tas-4e90e.web.app/privacy-policy  
**Developer contact:** andersonmarejeo@gmail.com

## Image and video pack

- `assets/store_listing/feature_graphic_tr.png` — 1024 × 500 PNG, opaque,
  monochrome artwork-only option.
- `assets/store_listing/feature_graphic_tr_title.png` — 1024 × 500 PNG,
  opaque, with the exact title “3-9-12 TAŞ”; this is the recommended draft
  feature graphic for the Turkish listing.
- `assets/store_listing/feature_graphic_artwork_source.png` — editable-source
  artwork before store sizing.
- `assets/store_listing/feature_graphic_title_artwork_source.png` — source for
  the titled variation before store sizing.
- `assets/branding/play_store_icon_512.png` — existing 512 × 512 listing icon;
  inspect it at Play Console size before upload.
- `test/store_listing_capture_test.dart` — reproducible test harness for
  Turkish app screenshots. The intended outputs are
  `screenshot_home_tr.png` and `screenshot_game_{three,nine,twelve}_tr.png`.
  To capture them, run `flutter test --no-pub --update-goldens
  test/store_listing_capture_test.dart`. They have **not** been captured yet;
  a different active Flutter tool currently holds the SDK's startup lock, so
  this session's capture command could not start. Do not remove that lock or
  upload fabricated substitutes; retry once the running Flutter operation
  finishes.
- No promotional video was made. A Play listing video should be a real screen
  recording of the final build, mainly actual gameplay, with visible moves and
  no unimplemented online/reward claims. Use the final AAB on a test device,
  record a short 20–30 second portrait/landscape capture, upload it to YouTube
  as public or unlisted with embedding enabled, and paste that YouTube URL into
  the listing. Do not turn the still artwork into a pretend gameplay video.
  A concrete 25-second recording plan is included below.

The current official Play guidance specifies a 1024 × 500 feature graphic and
screenshots of genuine in-app experience; listing video is supplied as a
YouTube URL. See [Play preview assets](https://support.google.com/googleplay/android-developer/answer/9866151?hl=en-GB).

## Play Console declaration worksheet — review against the final AAB

### Target audience and Families

**Do not submit “all ages” solely because the game is family-friendly.** The
current source displays a broad audience choice on first use: “under 18 or
prefer not to say” versus “18 or older.” It does not ask for a birth date or
exact age, and this self-selected choice is not age verification. Under-18 or
unknown users can play offline, while the invite-code online room is blocked
for them. For an enabled online release, Firebase creates anonymous account
identifiers and processes room/game state for the two players. Assess the
actual intended child age bands and disclose the feature and Firebase data
accurately in Play Console. A family-friendly theme by itself does not decide
the declared audience or satisfy child-safety requirements.

The app is a non-violent abstract board game. That fact alone does not decide
which age bands to select. Choose the actual intended age groups, and then
review the Families requirements for ads, external links, and child-directed
features. A child-target declaration is the developer's compliance
responsibility; the age choice in this build is not proof of an age.

Official references: [target audience](https://support.google.com/googleplay/android-developer/answer/9867159?hl=en) · [Families policy](https://support.google.com/googleplay/android-developer/answer/9893335?hl=en).

### Data Safety — source-based inventory, not final checkbox answers

Google requires the declaration to account for the shipped app **and its
third-party SDKs**. Use this inventory to answer the form only after checking
the final release bundle and its runtime behavior.

| Source / feature | Data visible in source | Current condition / declaration check |
| --- | --- | --- |
| Local profile and settings | Nickname, country code, language, sound/haptics, board and accessibility preferences | Stored on device; no account sync in the default source configuration |
| Local games | Board state, move progress, game variant | Stored in the local match repository; not sent to a server in offline mode |
| Firebase private-room candidate | Anonymous Firebase UID; random room key; variant, room/player status, board/move state, revision and timestamps | Firebase initializes only when the online lobby is opened; an anonymous UID is created when a player creates or joins a room. Confirm the exact AAB flags and Console values |
| Google Mobile Ads SDK | SDK documentation lists IP address (which may indicate general location), product/ad interactions, diagnostic data, and device/account identifiers among data the SDK may collect/share | `google_mobile_ads` is included; child age treatment is applied for under-18/unknown users, requests are non-personalized, and the maximum rating is G. AdMob production IDs are now configured in source; verify the final merged manifest and SDK versions in the AAB |
| Analytics / remote crash reporting | No Firebase Analytics or remote crash-reporting initialization found in the inspected source | Recheck the final dependency manifest and build |
| External sharing | A user can choose to open WhatsApp or a web share link | The selected external app handles any information the user chooses to share under its own terms |

The current Android source manifest explicitly includes the `AD_ID` permission
for Google Mobile Ads. Do not describe this build as having that permission
removed. This permission alone does not prove that the SDK transmits the ID on
every request. The source applies child age treatment for under-18/unknown
users before SDK initialization, non-personalized requests, and a G maximum
content rating. Google documents child-directed age treatment as preventing
advertising-ID transmission and interest-based advertising. AdMob now has a
registered Android app and two production units:
`ca-app-pub-5780525320889526~7725964197`, banner
`ca-app-pub-5780525320889526/5587809457`, and interstitial
`ca-app-pub-5780525320889526/7387052849`. These are public AdMob identifiers,
not credentials. The banner is reserved for the bottom of the match screen.
The interstitial is limited in-app to the exit from a completed match after at
least three completed matches, and no more than once every two hours; AdMob also
has a server-side cap of one impression per user per 120 minutes. AdMob's
high-engagement ad setting is disabled. The Android manifest uses the
registered production app ID by default; verify the merged manifest in the
final AAB. AdMob currently reports that store details/review are still pending,
so production ad delivery is not yet confirmed. The app-specific AdMob filter
allows only G-rated ads, blocks all 11 standard sensitive categories, and keeps
alcohol and gambling blocked; this stricter inventory may reduce earnings.

The Dart source invokes Google's UMP consent-information update, shows a
consent form when required, and checks `canRequestAds()` before initializing
the ads SDK. The account's AdMob/Privacy & messaging setup still needs review;
configure and test the required consent flow in the EEA, UK, and Switzerland on
the final release. If consent is unavailable, ad requests should remain off. Also verify
that the exact Android ads SDK version in the AAB is on Play's self-certified
ads SDK list for a child-targeted app. The currently uploaded version 35 AAB
contains Play services ads 25.4.0, above the list's 19.0.0 minimum, and its
manifest contains both the registered AdMob app ID and `AD_ID` permission.
Recheck these when building a later release. Child-directed request flags
alone do not replace the SDK-list check.

References: [Google AdMob consent requirements](https://support.google.com/admob/answer/13554116?hl=en) · [Play self-certified ads SDKs](https://support.google.com/googleplay/android-developer/answer/12955712?hl=en).

Provisional questions to resolve in the Data Safety form:

1. Verify that the uploaded AAB includes the configured production ad units;
   the SDK is initialized when a match-screen banner/interstitial request is
   prepared, not on the home-screen launch.
2. Which exact Google Mobile Ads Android SDK version and Firebase SDK versions
   are packaged, and what does each SDK disclose as collected/shared?
3. Is the candidate online backend enabled in that AAB and in Remote Config?
   If yes, include Firebase anonymous user IDs and room/game activity in the
   declaration.
4. Can the user request deletion of online data? Source supports room closure
   by its host; there is no automatic expiry promise. Keep the contact path in
   the privacy policy accurate.
5. Confirm encryption in transit, purpose categories, optionality, retention,
   and deletion answers against the final SDK and backend configuration.

Google's [Data Safety guidance](https://support.google.com/googleplay/android-developer/answer/10787469?hl=en-AE)
states that the developer is responsible for accurate disclosures, including
third-party SDK behavior. Google's [Mobile Ads data disclosure](https://developers.google.com/admob/android/privacy/play-data-disclosure)
is the starting point for the ad SDK inventory, not a substitute for verifying
the version and configuration actually shipped.

### Content rating and other declarations

- IARC source-based draft: no violence, sexual content, fear, gambling, or
  user-generated text/chat found; no billing SDK or purchase flow found.
  Confirm each answer in the actual questionnaire. If private online play is
  enabled in the submitted AAB, describe the player-to-player interaction
  accurately even though there is no chat or public room list.
- Confirm “contains ads” against the exact AAB. The source has a banner
  component and Google Mobile Ads SDK, even though the release ad-unit setting
  may currently be empty.
- No in-app purchase flow or billing SDK was found in the source inspected for
  this draft. Recheck the final AAB/dependency report before declaring this.
- The privacy policy is already present at the URL above. It is not edited or
  republished by this draft; review the advertising SDK disclosures, target
  audience, and deletion/contact wording before treating it as final legal
  approval.

## Local legal-document drafts

- [Turkish terms-of-use draft](TERMS_OF_USE_DRAFT_TR.md) — owner/legal review
  and missing business/contact details are explicitly marked before use.

## Real gameplay capture plan (25 seconds)

Record this from the exact release candidate on a clean test device. Keep the
device language Turkish, hide notifications/status-bar clutter, use normal
game speed, and capture at native screen resolution. Do not add fake menus,
online players, rewards, ratings, or other features that are not active in the
release.

| Time | Shot | What the viewer should see |
| --- | --- | --- |
| 0–3 s | Home screen | The actual 3-9-12 Taş home screen; pause briefly so the three variants are legible. |
| 3–8 s | Variant selection | Open 3 Taş, then show a real local match beginning. |
| 8–14 s | Play | Place a few legal moves and complete a mill; leave the board unobstructed. |
| 14–19 s | Another variant | Return home and open 9 Taş or 12 Taş, showing the genuine board layout. |
| 19–23 s | Visual choice | If the release exposes it, briefly show the actual board appearance selector and select one visibly different theme. |
| 23–25 s | End frame | Return to the real home screen or leave the board visible; do not fake a store badge or call to action inside the app. |

For the listing, upload the final recording to YouTube with embedding enabled,
no age restriction, and ads disabled, then enter its URL in the Video field.
The current Console says the video must be public or unlisted; an actual upload
cannot be made until a real device recording exists and the owner chooses the
YouTube audience/visibility settings.

## Terms of use — non-public wording outline for owner/legal review

The current source provides local board-game play and has no purchase or
subscription flow. A concise terms page can cover: (1) publisher and contact
details; (2) permitted personal use and intellectual-property ownership; (3)
local saves and optional invite-code play if that feature is in the released
build; (4) no ranking, prizes, or guaranteed online availability; (5) external
services such as Google/Firebase/WhatsApp governed by their own terms; (6)
how to report a privacy or safety concern; and (7) consumer rights that cannot
be limited by contract.

Do not publish this outline as binding terms until the publisher's legal
address, applicable-law wording, age/audience position, and any consumer-rights
language have been reviewed. Those details cannot be safely inferred from the
repository. This document is a preparation aid, not a substitute for legal
advice or for the Play Console's developer attestations.
