# CLAUDE.md

## Güvenlik denetimi (security-audit)

Bu depoda Cloudflare'in `security-audit` skill'i bulunur: `.claude/skills/security-audit/` (kaynak: github.com/cloudflare/security-audit-skill, commit c1c8a8c; MIT lisansı aynı klasörde).

- **Ne zaman:** bu depoya yapılan her push'tan sonra ve her sürüm / yama yayınından önce.
- **Nasıl:** skill'i tam denetim modunda çalıştır. Hedef bu depodur; çıktı dizini depo dışında olur (`~/security-audit-skill/<depo>/run-<N>`). Önceki çalıştırmaların `coverage-ledger.json` ve `findings.json` dosyaları varsa onları kullanıp değişen kodu öncelikli denetle.
- **Güvenlik kuralı:** hedef kod yalnız işletim sistemi seviyesinde yalıtılmış bir ortamda çalıştırılır; böyle bir ortam yoksa bulgu `needs_validation` olarak kalır. Canlı sistemlere ve paylaşılan servislere istek atılmaz.
- **Sonuç:** `confirmed` bulgular önem derecesi ve önerilen düzeltmesiyle kullanıcıya bildirilir; yüksek ve kritik bulgular yayından önce bildirilir.

## Yanıt üslubu (caveman)

Bu depoda `.claude/skills/caveman/` ve `.claude/skills/ultracave/` bulunur (kaynak: github.com/JuliusBrussee/caveman, commit 9b24366; Apache-2.0, LICENSE ve NOTICE klasörlerde).

- **Sohbet yanıtları caveman sesiyle verilir:** önce cevap, sonra neden, sonra sonraki adım. Selamlama, tekrar ve kapanış cümlesi yok. Her teknik bilgi korunur; değil, asla, yalnız gibi sözcükler düşmez; kod, komut, yol, sayı ve hata metni aynen kalır.
- **Dil:** yanıt kullanıcının dilinde verilir (Türkçe).
- **Kalıcı metinler normal yazılır:** kod, yorum, commit mesajı, doküman, sürüm notu, PR ve bilet.
- **Tam cümleye dönülen yerler:** güvenlik uyarısı, geri alınamaz işlem onayı, sırası karışabilecek adımlar, kafası karışan kullanıcı ve kullanıcıya sorulan soru.
- **Kapatmak için:** "stop caveman" ya da "normal mode".
