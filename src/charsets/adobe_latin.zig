const CharacterSet = @import("CharacterSet.zig");

/// https://adobe-type-tools.github.io/adobe-latin-charsets/adobe-latin-1.html
pub const adobe_latin_1 = CharacterSet.fromRanges("Adobe Latin 1", &.{
    .{ 0x0020, 0x007E }, // Basic Latin
    .{ 0x00A0, 0x00FF }, // Latin-1 Supplement
    .{ 0x0131, 0x0131 }, // dotless i
    .{ 0x0152, 0x0153 }, // OE ligatures
    .{ 0x02C6, 0x02C6 }, // circumflex
    .{ 0x02DA, 0x02DA }, // ring above
    .{ 0x02DC, 0x02DC }, // small tilde
    .{ 0x2013, 0x2014 }, // en/em dash
    .{ 0x2018, 0x201A }, // single quotes
    .{ 0x201C, 0x201E }, // double quotes
    .{ 0x2022, 0x2022 }, // bullet
    .{ 0x2026, 0x2026 }, // ellipsis
    .{ 0x2039, 0x203A }, // angle quotes
    .{ 0x20AC, 0x20AC }, // euro sign
    .{ 0xFB01, 0xFB02 }, // fi/fl ligatures
});

/// https://adobe-type-tools.github.io/adobe-latin-charsets/adobe-latin-2.html
pub const adobe_latin_2 = CharacterSet.fromRanges("Adobe Latin 2", &.{
    .{ 0x0020, 0x007E }, // Basic Latin
    .{ 0x00A0, 0x00FF }, // Latin-1 Supplement (adds NO-BREAK SPACE + SOFT HYPHEN vs AL1)
    .{ 0x0131, 0x0131 }, // dotless i
    .{ 0x0141, 0x0142 }, // L/l with stroke
    .{ 0x0152, 0x0153 }, // OE ligatures
    .{ 0x0160, 0x0161 }, // S/s with caron
    .{ 0x0178, 0x0178 }, // Y with dieresis
    .{ 0x017D, 0x017E }, // Z/z with caron
    .{ 0x0192, 0x0192 }, // florin
    .{ 0x02C6, 0x02C7 }, // circumflex, caron
    .{ 0x02C9, 0x02C9 }, // modifier letter macron (new vs AL1)
    .{ 0x02D8, 0x02DD }, // breve → double acute
    .{ 0x03C0, 0x03C0 }, // Greek pi (new vs AL1)
    .{ 0x2013, 0x2014 }, // en/em dash
    .{ 0x2018, 0x201A }, // single quotes
    .{ 0x201C, 0x201E }, // double quotes
    .{ 0x2020, 0x2022 }, // dagger, double dagger, bullet
    .{ 0x2026, 0x2026 }, // ellipsis
    .{ 0x2030, 0x2030 }, // per mille
    .{ 0x2039, 0x203A }, // angle quotes
    .{ 0x2044, 0x2044 }, // fraction slash
    .{ 0x20AC, 0x20AC }, // euro
    .{ 0x2113, 0x2113 }, // script small l (new vs AL1)
    .{ 0x2122, 0x2122 }, // trade mark
    .{ 0x2126, 0x2126 }, // ohm sign (new vs AL1)
    .{ 0x212E, 0x212E }, // estimated symbol (new vs AL1)
    .{ 0x2202, 0x2202 }, // partial differential (new vs AL1)
    .{ 0x2206, 0x2206 }, // increment (new vs AL1)
    .{ 0x220F, 0x220F }, // n-ary product (new vs AL1)
    .{ 0x2211, 0x2212 }, // summation, minus
    .{ 0x2215, 0x2215 }, // division slash (new vs AL1)
    .{ 0x2219, 0x221A }, // bullet operator, radical (new vs AL1)
    .{ 0x221E, 0x221E }, // infinity (new vs AL1)
    .{ 0x222B, 0x222B }, // integral (new vs AL1)
    .{ 0x2248, 0x2248 }, // almost equal (new vs AL1)
    .{ 0x2260, 0x2260 }, // not equal (new vs AL1)
    .{ 0x2264, 0x2265 }, // less/greater or equal (new vs AL1)
    .{ 0x25CA, 0x25CA }, // lozenge
    .{ 0xFB01, 0xFB02 }, // fi/fl ligatures
});

/// https://adobe-type-tools.github.io/adobe-latin-charsets/adobe-latin-3.html
pub const adobe_latin_3 = CharacterSet.fromRanges("Adobe Latin 3", &.{
    .{ 0x0020, 0x007E }, // Basic Latin
    .{ 0x00A0, 0x00FF }, // Latin-1 Supplement
    // Latin Extended-A — CE block
    .{ 0x0100, 0x0107 }, // A/a macron, breve, ogonek; C/c acute
    .{ 0x010C, 0x0113 }, // C/c caron; D/d caron, stroke; E/e macron
    .{ 0x0116, 0x011B }, // E/e dot, ogonek, caron
    .{ 0x011E, 0x011F }, // G/g breve
    .{ 0x0122, 0x0123 }, // G/g cedilla
    .{ 0x012A, 0x012B }, // I/i macron
    .{ 0x012E, 0x0131 }, // I/i ogonek, dot; dotless i
    .{ 0x0136, 0x0137 }, // K/k cedilla
    .{ 0x0139, 0x013E }, // L/l acute, cedilla, caron
    .{ 0x0141, 0x0148 }, // L/l stroke; N/n acute, cedilla, caron
    .{ 0x014C, 0x014D }, // O/o macron
    .{ 0x0150, 0x0153 }, // O/o double acute; OE ligatures
    .{ 0x0154, 0x015B }, // R/r acute, cedilla, caron; S/s acute
    .{ 0x015E, 0x0161 }, // S/s cedilla, caron
    .{ 0x0162, 0x0165 }, // T/t cedilla, caron
    .{ 0x016A, 0x016B }, // U/u macron
    .{ 0x016E, 0x0173 }, // U/u ring, double acute, ogonek
    .{ 0x0178, 0x017E }, // Y dieresis; Z/z acute, dot, caron
    .{ 0x0192, 0x0192 }, // florin
    .{ 0x0218, 0x021B }, // S/s, T/t with comma below (Romanian)
    .{ 0x02C6, 0x02C7 }, // circumflex, caron
    .{ 0x02C9, 0x02C9 }, // modifier letter macron
    .{ 0x02D8, 0x02DD }, // breve → double acute
    .{ 0x03C0, 0x03C0 }, // Greek pi
    .{ 0x2013, 0x2014 }, // en/em dash
    .{ 0x2018, 0x201A }, // single quotes
    .{ 0x201C, 0x201E }, // double quotes
    .{ 0x2020, 0x2022 }, // dagger, double dagger, bullet
    .{ 0x2026, 0x2026 }, // ellipsis
    .{ 0x2030, 0x2030 }, // per mille
    .{ 0x2039, 0x203A }, // angle quotes
    .{ 0x2044, 0x2044 }, // fraction slash
    .{ 0x20AC, 0x20AC }, // euro
    .{ 0x20BA, 0x20BA }, // Turkish lira (new vs AL2)
    .{ 0x20BD, 0x20BD }, // ruble (new vs AL2)
    .{ 0x2113, 0x2113 }, // script small l
    .{ 0x2122, 0x2122 }, // trade mark
    .{ 0x2126, 0x2126 }, // ohm
    .{ 0x212E, 0x212E }, // estimated
    .{ 0x2202, 0x2202 }, // partial differential
    .{ 0x2206, 0x2206 }, // increment
    .{ 0x220F, 0x220F }, // n-ary product
    .{ 0x2211, 0x2212 }, // summation, minus
    .{ 0x2215, 0x2215 }, // division slash
    .{ 0x2219, 0x221A }, // bullet operator, radical
    .{ 0x221E, 0x221E }, // infinity
    .{ 0x222B, 0x222B }, // integral
    .{ 0x2248, 0x2248 }, // almost equal
    .{ 0x2260, 0x2260 }, // not equal
    .{ 0x2264, 0x2265 }, // less/greater or equal
    .{ 0x25CA, 0x25CA }, // lozenge
    .{ 0xFB01, 0xFB02 }, // fi/fl ligatures
});

/// https://adobe-type-tools.github.io/adobe-latin-charsets/adobe-latin-4.html
/// NOTE: AL4 also defines 2 combined (multi-codepoint) sequences:
///   G + COMBINING TILDE (0047,0303) and g + COMBINING TILDE (0067,0303)
/// These cannot be u21 and are excluded here for the moment.
pub const adobe_latin_4 = CharacterSet.fromRanges("Adobe Latin 4", &.{
    .{ 0x0020, 0x007E }, // Basic Latin
    .{ 0x00A0, 0x00FF }, // Latin-1 Supplement
    // Latin Extended-A — now nearly complete
    .{ 0x0100, 0x012B }, // A macron → I macron (full contiguous block in AL4)
    .{ 0x012E, 0x0131 }, // I ogonek, I dot, dotless i
    .{ 0x0134, 0x0138 }, // J circumflex, K cedilla, kra
    .{ 0x0139, 0x0149 }, // L acute → n preceded by apostrophe (incl. new Ldot, n-apostrophe)
    .{ 0x014C, 0x014D }, // O/o macron
    .{ 0x0150, 0x0153 }, // O/o double acute, OE ligatures
    .{ 0x0154, 0x0165 }, // R acute → T caron (incl. new S circumflex)
    .{ 0x0168, 0x0173 }, // U tilde → U ogonek (incl. new U tilde, U breve)
    .{ 0x0174, 0x017E }, // W/Y circumflex (new); Y dieresis; Z acute → z caron
    // Latin Extended-B
    .{ 0x018F, 0x018F }, // schwa capital (new)
    .{ 0x0192, 0x0192 }, // florin
    .{ 0x01A0, 0x01A1 }, // O/o with horn
    .{ 0x01AF, 0x01B0 }, // U/u with horn
    .{ 0x01CD, 0x01DC }, // A/I/O/U caron variants + U dieresis tonal (new)
    .{ 0x01E6, 0x01E7 }, // G/g with caron (new)
    .{ 0x0218, 0x021B }, // S/s, T/t with comma below (Romanian)
    .{ 0x0237, 0x0237 }, // dotless j (new)
    // IPA Extensions
    .{ 0x0251, 0x0251 }, // Latin small letter alpha
    .{ 0x0259, 0x0259 }, // Latin small letter schwa
    .{ 0x0261, 0x0261 }, // Latin small letter script g
    // Spacing Modifier Letters
    .{ 0x02BB, 0x02BC }, // turned comma, apostrophe (new)
    .{ 0x02BE, 0x02BF }, // right/left half ring (new)
    .{ 0x02C6, 0x02CC }, // circumflex → low vertical line (02C8-02CC new vs AL3)
    .{ 0x02D8, 0x02DD }, // breve → double acute
    // Combining Diacritical Marks
    .{ 0x0300, 0x0304 }, // grave, acute, circumflex, tilde, macron
    .{ 0x0306, 0x030C }, // breve → caron (0305 OVERLINE not included)
    .{ 0x031B, 0x031B }, // combining horn
    .{ 0x0323, 0x0324 }, // dot below, diaeresis below
    .{ 0x0326, 0x0328 }, // comma below, cedilla, ogonek
    .{ 0x032E, 0x032E }, // breve below
    .{ 0x0331, 0x0331 }, // macron below
    .{ 0x03C0, 0x03C0 }, // Greek pi
    // Latin Extended Additional
    .{ 0x1E0C, 0x1E0F }, // D with dot/line below
    .{ 0x1E20, 0x1E21 }, // G with macron
    .{ 0x1E24, 0x1E25 }, // H with dot below
    .{ 0x1E2A, 0x1E2B }, // H with breve below
    .{ 0x1E36, 0x1E3B }, // L with dot below (incl. macron variants), line below
    .{ 0x1E42, 0x1E49 }, // M/N with dot below/above, N with line below
    .{ 0x1E5A, 0x1E63 }, // R with dot/line below; S with dot above/below
    .{ 0x1E6C, 0x1E6F }, // T with dot/line below
    .{ 0x1E80, 0x1E85 }, // W grave/acute/dieresis
    .{ 0x1E8E, 0x1E8F }, // Y with dot above
    .{ 0x1E92, 0x1E93 }, // Z with dot below
    .{ 0x1E97, 0x1E97 }, // t with diaeresis
    .{ 0x1E9E, 0x1E9E }, // capital sharp S
    .{ 0x1EA0, 0x1EF9 }, // Vietnamese (full contiguous block)
    // General Punctuation
    .{ 0x2007, 0x2007 }, // figure space (new)
    .{ 0x2010, 0x2010 }, // hyphen (new)
    .{ 0x2012, 0x2015 }, // figure dash, en/em dash, horizontal bar
    .{ 0x2018, 0x201A }, // single quotes
    .{ 0x201C, 0x201E }, // double quotes
    .{ 0x2020, 0x2022 }, // dagger, double dagger, bullet
    .{ 0x2026, 0x2026 }, // ellipsis
    .{ 0x2030, 0x2030 }, // per mille
    .{ 0x2032, 0x2033 }, // prime, double prime (new)
    .{ 0x2039, 0x203A }, // angle quotes
    .{ 0x2044, 0x2044 }, // fraction slash
    // Superscripts & Subscripts
    .{ 0x2070, 0x2070 }, // superscript 0 (new)
    .{ 0x2074, 0x2079 }, // superscript 4–9 (new)
    .{ 0x207D, 0x207F }, // superscript parens, n (new)
    .{ 0x2080, 0x2089 }, // subscript 0–9 (new)
    .{ 0x208D, 0x208E }, // subscript parens (new)
    // Currency (scattered — no useful ranges)
    .{ 0x20A1, 0x20A1 }, // colon sign
    .{ 0x20A4, 0x20A4 }, // lira sign
    .{ 0x20A6, 0x20A7 }, // naira, peseta
    .{ 0x20AB, 0x20AC }, // dong, euro
    .{ 0x20B1, 0x20B2 }, // peso, guarani
    .{ 0x20B5, 0x20B5 }, // cedi
    .{ 0x20B9, 0x20BA }, // Indian rupee, Turkish lira
    .{ 0x20BD, 0x20BD }, // ruble
    // Letterlike
    .{ 0x2113, 0x2113 }, // script small l
    .{ 0x2117, 0x2117 }, // sound recording copyright (new)
    .{ 0x2120, 0x2120 }, // service mark (new)
    .{ 0x2122, 0x2122 }, // trade mark
    .{ 0x2126, 0x2126 }, // ohm
    .{ 0x212E, 0x212E }, // estimated
    // Number Forms
    .{ 0x2153, 0x2154 }, // 1/3, 2/3 (new)
    .{ 0x215B, 0x215E }, // 1/8 → 7/8 (new)
    // Arrows
    .{ 0x2190, 0x2193 }, // ←↑→↓ (new)
    // Mathematical Operators
    .{ 0x2202, 0x2202 }, // partial differential
    .{ 0x2206, 0x2206 }, // increment
    .{ 0x220F, 0x220F }, // n-ary product
    .{ 0x2211, 0x2212 }, // summation, minus
    .{ 0x2215, 0x2215 }, // division slash
    .{ 0x2219, 0x221A }, // bullet operator, radical
    .{ 0x221E, 0x221E }, // infinity
    .{ 0x222B, 0x222B }, // integral
    .{ 0x2248, 0x2248 }, // almost equal
    .{ 0x2260, 0x2260 }, // not equal
    .{ 0x2264, 0x2265 }, // less/greater or equal
    // Geometric Shapes
    .{ 0x25A0, 0x25A0 }, // black square (new)
    .{ 0x25B2, 0x25B3 }, // black/white up triangle (new)
    .{ 0x25B6, 0x25B7 }, // black/white right triangle (new)
    .{ 0x25BC, 0x25BD }, // black/white down triangle (new)
    .{ 0x25C0, 0x25C1 }, // black/white left triangle (new)
    .{ 0x25C6, 0x25C6 }, // black diamond (new)
    .{ 0x25CA, 0x25CA }, // lozenge
    .{ 0xFB01, 0xFB02 }, // fi/fl ligatures
});

// TODO: adobe latin 5
// it has 439 combined sequences and honestly it's just not worth any headache
