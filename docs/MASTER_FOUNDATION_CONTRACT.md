# Master Foundation Contract — v0.3

Bu belge 3 Taş, 9 Taş ve 12 Taş için değişmeyecek ortak uygulama kurallarını tanımlar.

## 1. Ekran ve scroll sözleşmesi
- Feature ekranları doğrudan `Scaffold` oluşturmaz; `AppScreenShell` kullanır.
- Standart dikey sayfada tek scroll sahibi `AppScreenShell` içindeki `CustomScrollView` olur.
- Yatay hazır mesaj şeridi gibi semantik yatay listeler istisnadır.
- Async ekranlarda loading/error/empty/content durumları açıkça ele alınır.
- Küçük ekran, büyük yazı ve RTL scroll testleri release kapısının parçasıdır.

## 2. Navigasyon sözleşmesi
- Uygulama sayfaları `AppRouter` ve `AppRoutes` üzerinden açılır.
- Feature katmanında `Navigator.push*` yasaktır.
- Geçersiz/deep-link route ana sayfaya sessiz düşmez; kontrollü hata ekranı açılır.
- Release sürümünde teknik exception kullanıcıya gösterilmez.
- Tüm route geçişleri `MotionTokens` ile aynı animasyon süresini/easing'i kullanır ve RTL yönünü gözetir.

## 3. Maç yaşam döngüsü
- Oyun durumu `GameScreen` içinde değildir; `MatchSessionController` tek kaynak olur.
- Onaylanmış her hamleden sonra SQLite snapshot yazılır.
- Snapshot yazıları sıralı kuyruktadır; hızlı dokunma veya lifecycle olayı eski state'in yeni state'i ezmesine izin vermez.
- Pause/hide/detach durumlarında snapshot tekrar yazılır.
- Aktif yerel maç geri tuşunda: Oyuna dön / Kaydet ve çık / Maçı bitir seçeneklerini kullanır.
- Kaydetme başarısızsa oyun kapatılmaz ve hata kullanıcıya gösterilir.
- Kaydet ve çık sonrası ana ekranda “Maça devam et” görünür.
- Tamamlanmış/terk edilmiş maç “devam eden maç” sayılmaz.
- Gelecekte online/Meydan Okuma tekrar maçı aynı `matchId/challengeId` ile yeniden açılmaz; yeni kimlik oluşturulur.

## 4. Feedback ve ses sözleşmesi
- Feature ekranlarında doğrudan `HapticFeedback`, `SystemSound` veya `AudioPlayer` çağrısı yapılmaz.
- Oyun mantığı `GameFeedback` arayüzüne bağlıdır; platform implementasyonu `AppFeedbackService` olur.
- Tüm oyunlar aynı olayları kullanır: selected / placed / moved / mill / capture / success.
- Ahşap-mermer-taş kaydırma dosyaları eklendiğinde yalnızca feedback/audio katmanı değişir.

## 5. Motion sözleşmesi
- Feature dosyalarında özel `Duration(milliseconds: ...)` kullanılmaz.
- Standartlar `MotionTokens.fast/normal/slow/celebration` üzerinden gelir.
- 3/9/12 Taş aynı hareket dilini kullanır; yalnız tahta geometrisi/ruleset değişir.

## 6. Yerelleştirme
- Kullanıcıya görünen metin feature koduna sabitlenmez.
- Yeni anahtar bütün ARB dosyalarında bulunmadan değişiklik tamamlanmış sayılmaz.
- TR/EN/DE/AR/HI dahil kritik ekranlarda dar ekran ve büyük yazı kontrolleri yapılır.

## 7. Özellik doğruluğu
- Henüz uygulanmamış özellik kullanıcıya çalışıyormuş gibi sunulmaz.
- v0.3'te AI seviyeleri devre dışıdır; gerçek AI motoru bağlanınca etkinleştirilir.
- Yerel maçta online hızlı mesaj şeridi gösterilmez.
- Sessiz/no-op ana menü eylemi bırakılmaz; eksik özellik kontrollü bildirim verir.

## 8. Release kapısı
1. `flutter pub get`
2. `flutter gen-l10n`
3. `flutter analyze`
4. `flutter test`
5. mimari guard
6. cihazda scroll/back/pause-resume testi
7. istenirse `flutter build apk --release`

Bir adım başarısızsa yeni özellik eklenmez; önce temel hata düzeltilir.
