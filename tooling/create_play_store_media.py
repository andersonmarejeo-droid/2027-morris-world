from __future__ import annotations

from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageFilter


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / ".codex-remote-attachments" / "01a0ca43-ff0f-7fb1-ad5b-3333fba102e5" / "0a07c7c8-caf0-48a1-84c2-5ba670a197e1"
SOURCE_ADDITIONAL = ROOT / ".codex-remote-attachments" / "01a0ca43-ff0f-7fb1-ad5b-3333fba102e5" / "5da8b888-54af-4904-9450-11d357874392"
OUTPUT = ROOT / "assets" / "store_listing" / "play_2026"
BACKGROUND = ROOT / "assets" / "store_listing" / "promo_2026" / "hero_background.png"
FONT_REGULAR = Path("C:/Windows/Fonts/segoeui.ttf")
FONT_BOLD = Path("C:/Windows/Fonts/segoeuib.ttf")

W, H = 1080, 1920
INK = (14, 33, 34)
CREAM = (251, 246, 230)
MINT = (132, 224, 202)


def font(path: Path, size: int) -> ImageFont.FreeTypeFont:
    return ImageFont.truetype(str(path), size)


def cover_background(size: tuple[int, int], tint: tuple[int, int, int] = (4, 36, 41)) -> Image.Image:
    bg = Image.open(BACKGROUND).convert("RGB")
    scale = max(size[0] / bg.width, size[1] / bg.height)
    bg = bg.resize((round(bg.width * scale), round(bg.height * scale)), Image.Resampling.LANCZOS)
    left, top = (bg.width - size[0]) // 2, (bg.height - size[1]) // 2
    bg = bg.crop((left, top, left + size[0], top + size[1]))
    wash = Image.new("RGB", size, tint)
    return Image.blend(bg, wash, 0.46)


def rounded_screenshot(canvas: Image.Image, source: Image.Image, box: tuple[int, int, int, int], radius: int = 42) -> None:
    x, y, w, h = box
    screenshot = source.convert("RGB")
    screenshot.thumbnail((w, h), Image.Resampling.LANCZOS)
    x += (w - screenshot.width) // 2
    y += (h - screenshot.height) // 2

    shadow = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    shadow_draw = ImageDraw.Draw(shadow)
    shadow_draw.rounded_rectangle((x - 5, y + 12, x + screenshot.width + 5, y + screenshot.height + 18), radius=radius + 8, fill=(0, 0, 0, 122))
    shadow = shadow.filter(ImageFilter.GaussianBlur(22))
    canvas.paste(shadow, (0, 0), shadow)

    border = Image.new("RGBA", (screenshot.width + 18, screenshot.height + 18), (0, 0, 0, 0))
    ImageDraw.Draw(border).rounded_rectangle((0, 0, border.width - 1, border.height - 1), radius=radius + 9, fill=(249, 246, 234, 255))
    canvas.paste(border, (x - 9, y - 9), border)
    mask = Image.new("L", screenshot.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, screenshot.width - 1, screenshot.height - 1), radius=radius, fill=255)
    canvas.paste(screenshot, (x, y), mask)


def add_header(canvas: Image.Image, title: str, subtitle: str, label: str = "3  •  9  •  12 TAŞ") -> None:
    draw = ImageDraw.Draw(canvas)
    draw.rounded_rectangle((76, 76, 344, 124), radius=24, fill=(8, 63, 70, 240))
    draw.text((99, 82), label, font=font(FONT_BOLD, 25), fill=MINT)
    title_font = font(FONT_BOLD, 64)
    draw.multiline_text((76, 158), title, font=title_font, fill=CREAM, spacing=1, stroke_width=0)
    title_box = draw.multiline_textbbox((76, 158), title, font=title_font, spacing=1)
    subtitle_font = font(FONT_REGULAR, 31)
    draw.text((80, title_box[3] + 12), subtitle, font=subtitle_font, fill=(219, 233, 224))


def add_footer(canvas: Image.Image) -> None:
    draw = ImageDraw.Draw(canvas)
    draw.text((78, 1871), "ZP GAMES", font=font(FONT_BOLD, 23), fill=(221, 229, 218))
    draw.text((1002, 1873), "STRATEJİ  •  DOSTÇA REKABET", font=font(FONT_BOLD, 16), fill=(185, 213, 203), anchor="ra")


def make_promo(filename: str, source_name: str, title: str, subtitle: str, crop: tuple[int, int, int, int] | None = None, mode_pills: bool = False, additional: bool = False) -> None:
    image = cover_background((W, H))
    source_dir = SOURCE_ADDITIONAL if additional else SOURCE
    source = Image.open(source_dir / source_name).convert("RGB")
    if crop:
        source = source.crop(crop)
    add_header(image, title, subtitle)
    if mode_pills:
        rounded_screenshot(image, source, (142, 486, 796, 1010), radius=32)
        draw = ImageDraw.Draw(image)
        pills = [(82, 1578, 516, 1686, "Yapay zekâya karşı"), (564, 1578, 998, 1686, "Aynı cihazda iki kişi")]
        for x1, y1, x2, y2, text in pills:
            draw.rounded_rectangle((x1, y1, x2, y2), radius=50, fill=(249, 247, 237), outline=(135, 221, 203), width=3)
            draw.text(((x1 + x2) // 2, (y1 + y2) // 2), text, font=font(FONT_BOLD, 24), fill=INK, anchor="mm")
    else:
        # Fit the complete original screen without cropping or rebuilding any UI.
        rounded_screenshot(image, source, (142, 350, 796, 1490), radius=36)
    add_footer(image)
    image.save(OUTPUT / filename, "JPEG", quality=94, optimize=True, progressive=True, subsampling=0)


def make_feature_graphic() -> None:
    size = (1024, 500)
    image = cover_background(size, (3, 38, 44))
    # Subtle left-side veil protects title readability while leaving the generated stones visible.
    veil = Image.new("RGBA", size, (0, 0, 0, 0))
    pix = veil.load()
    for x in range(size[0]):
        alpha = round(158 * max(0.0, 1 - x / 760))
        for y in range(size[1]):
            pix[x, y] = (2, 28, 34, alpha)
    image = Image.alpha_composite(image.convert("RGBA"), veil)
    draw = ImageDraw.Draw(image)
    draw.rounded_rectangle((53, 56, 309, 96), radius=20, fill=(9, 66, 72, 245))
    draw.text((72, 58), "STRATEJİ • TAHTA OYUNLARI", font=font(FONT_BOLD, 17), fill=MINT)
    draw.text((53, 128), "3 • 9 • 12", font=font(FONT_BOLD, 68), fill=CREAM)
    draw.text((53, 206), "TAŞ", font=font(FONT_BOLD, 60), fill=CREAM)
    draw.text((58, 294), "Üç klasik oyun.\nBir sonraki hamle senin.", font=font(FONT_REGULAR, 25), fill=(226, 238, 229), spacing=9)
    draw.text((58, 428), "ZP GAMES", font=font(FONT_BOLD, 17), fill=(205, 230, 216))

    source = Image.open(SOURCE / "2-1000035642.jpg").convert("RGB")
    board = source.crop((30, 466, 627, 1056))
    board.thumbnail((413, 413), Image.Resampling.LANCZOS)
    x, y = 555, 44
    card = Image.new("RGBA", (445, 445), (0, 0, 0, 0))
    ImageDraw.Draw(card).rounded_rectangle((0, 0, 444, 444), radius=45, fill=(249, 248, 239, 255))
    image.alpha_composite(card, (x - 16, y - 16))
    mask = Image.new("L", board.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, board.width - 1, board.height - 1), radius=30, fill=255)
    image.paste(board, (x + (413 - board.width) // 2, y + (413 - board.height) // 2), mask)
    image.convert("RGB").save(OUTPUT / "play_feature_1024x500.png", "PNG", optimize=True)


def write_alt_text() -> None:
    lines = [
        "01_three_stones.jpg — 3 Taş maç ekranında siyah ve beyaz taşlarla oynanan oyun tahtası.",
        "02_nine_stones.jpg — 9 Taş oyununda eşmerkezli karelerden oluşan tahta ve taşlar.",
        "03_twelve_stones.jpg — 12 Taş oyununda oyuncu panelleri ve oyun tahtası.",
        "04_game_modes.jpg — 3 Taş, 9 Taş ve 12 Taş oyun seçeneklerinin listesi.",
        "05_opponent_modes.jpg — Arkadaş meydan okuması, bilgisayar ve aynı cihaz seçenekleri.",
        "06_friends.jpg — Arkadaşlar listesi ve meydan okuma düğmeleri.",
        "07_rankings.jpg — Dünya, ülke ve arkadaşlar sıralama sekmeleriyle puan listesi.",
        "08_settings.jpg — Dil seçimi ve oyun ayarları ekranı.",
        "play_feature_1024x500.png — 3, 9 ve 12 Taş oyun adının yanında 3 Taş oyun tahtası.",
    ]
    (OUTPUT / "alt_text_tr.txt").write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    OUTPUT.mkdir(parents=True, exist_ok=True)
    specs = [
        ("01_three_stones.jpg", "2-1000035642.jpg", "ÜÇ TAŞTA\nHER HAMLE ÖNEMLİ", "Klasik stratejinin hızlı ve keyifli hâli"),
        ("02_nine_stones.jpg", "4-1000035649.jpg", "DOKUZ TAŞTA\nSTRATEJİNİ KUR", "Taşlarını yerleştir, doğru anı bekle", None, False, True),
        ("03_twelve_stones.jpg", "1-1000035641.jpg", "ON İKİ TAŞTA\nSTRATEJİNİ KUR", "Taşlarını koru, doğru anı bekle"),
        ("04_game_modes.jpg", "2-1000035647.jpg", "ÜÇ KLASİK OYUN\nBİR ARADA", "3 Taş, 9 Taş ve 12 Taş seçenekleri", (0, 0, 639, 795), False, True),
        ("05_opponent_modes.jpg", "3-1000035648.jpg", "RAKİBİNİ\nSEN SEÇ", "Bilgisayar, arkadaşın ya da birlikte", (35, 490, 610, 1110), True, True),
        ("06_friends.jpg", "5-1000035645.jpg", "ARKADAŞLARINLA\nMEYDAN OKU", "Arkadaşını seç, oyuna başla"),
        ("07_rankings.jpg", "1-1000035646.jpg", "SIRALAMAN\nSENİN ELİNDE", "Dünya, ülke ve arkadaş listeleri", None, False, True),
        ("08_settings.jpg", "4-1000035644.jpg", "DİL SEÇENEKLERİ\nSENİN TERCİHİN", "Farklı dillerde oyun deneyimi", (28, 255, 632, 1135)),
    ]
    for spec in specs:
        if len(spec) == 6:
            make_promo(*spec)
        else:
            make_promo(*spec)
    make_feature_graphic()
    write_alt_text()
    for path in sorted(OUTPUT.glob("*.jpg")) + [OUTPUT / "play_feature_1024x500.png"]:
        with Image.open(path) as check:
            print(f"{path.name}: {check.size[0]}x{check.size[1]}, {path.stat().st_size} bytes")


if __name__ == "__main__":
    main()
