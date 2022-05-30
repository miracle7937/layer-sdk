/// String extension that provides a way to replace diacritic characters.
extension StringDiacriticsExtension on String {
  /// Returns a string with diacritic characters replaced according
  /// to the [_replacementMap].
  String withoutDiacritics() {
    return split('').map((e) => _replacementMap[e] ?? e).join();
  }

  /// The diacritics replacement map.
  ///
  /// Source: http://pinyin.info/unicode/diacritics.html
  static const _replacementMap = {
    // capital letters
    '\u{00C1}': 'A', //	Á	Aacute	capital A with ACUTE
    '\u{0102}': 'A', //	Ă	Abreve	capital A with BREVE
    '\u{1EAE}': 'A', //	Ắ	uni1EAE	capital A with BREVE and ACUTE
    '\u{1EB6}': 'A', //	Ặ	uni1EB6	capital A with BREVE and DOT BELOW
    '\u{1EB0}': 'A', //	Ằ	uni1EB0	capital A with BREVE and GRAVE
    '\u{1EB2}': 'A', //	Ẳ	uni1EB2	capital A with BREVE and HOOK ABOVE
    '\u{1EB4}': 'A', //	Ẵ	uni1EB4	capital A with BREVE and TILDE
    '\u{01CD}': 'A', //	Ǎ	uni01CD	capital A with CARON
    '\u{00C2}': 'A', //	Â	Acircumflex	capital A with CIRCUMFLEX
    '\u{1EA4}': 'A', //	Ấ	uni1EA4	capital A with CIRCUMFLEX and ACUTE
    '\u{1EAC}': 'A', //	Ậ	uni1EAC	capital A with CIRCUMFLEX and DOT BELOW
    '\u{1EA6}': 'A', //	Ầ	uni1EA6	capital A with CIRCUMFLEX and GRAVE
    '\u{1EA8}': 'A', //	Ẩ	uni1EA8	capital A with CIRCUMFLEX and HOOK ABOVE
    '\u{1EAA}': 'A', //	Ẫ	uni1EAA	capital A with CIRCUMFLEX and TILDE
    '\u{00C4}': 'A', //	Ä	Adieresis	capital A with DIAERESIS
    '\u{1EA0}': 'A', //	Ạ	uni1EA0	capital A with DOT BELOW
    '\u{00C0}': 'A', //	À	Agrave	capital A with GRAVE
    '\u{1EA2}': 'A', //	Ả	uni1EA2	capital A with HOOK ABOVE
    '\u{0100}': 'A', //	Ā	Amacron	capital A with MACRON
    '\u{0104}': 'A', //	Ą	Aogonek	capital A with OGONEK
    '\u{00C5}': 'A', //	Å	Aring	capital A with RING ABOVE
    '\u{01FA}': 'A', //	Ǻ	Aringacute	capital A with RING ABOVE and ACUTE
    '\u{00C3}': 'A', //	Ã	Atilde	capital A with TILDE
    '\u{00C6}': 'AE', //	Æ	AE	capital AE
    '\u{01FC}': 'AE', //	Ǽ	AEacute	capital AE with ACUTE
    '\u{1E04}': 'B', //	Ḅ	uni1E04	capital B with DOT BELOW
    '\u{0181}': 'B', //	Ɓ	uni0181	capital B with HOOK
    '\u{0106}': 'C', //	Ć	Cacute	capital C with ACUTE
    '\u{010C}': 'C', //	Č	Ccaron	capital C with CARON
    '\u{00C7}': 'C', //	Ç	Ccedilla	capital C with CEDILLA
    '\u{0108}': 'C', //	Ĉ	Ccircumflex	capital C with CIRCUMFLEX
    '\u{010A}': 'C', //	Ċ	Cdotaccent	capital C with DOT ABOVE
    '\u{0186}': 'O', //	Ɔ	uni0186	capital OPEN O
    '\u{0297}': 'C', //	ʗ	uni0297	LATIN LETTER STRETCHED C
    '\u{010E}': 'D', //	Ď	Dcaron	capital D with CARON
    '\u{1E12}': 'D', //	Ḓ	uni1E12	capital D with CIRCUMFLEX BELOW
    '\u{1E0C}': 'D', //	Ḍ	uni1E0C	capital D with DOT BELOW
    '\u{018A}': 'D', //	Ɗ	uni018A	capital D with HOOK
    '\u{1E0E}': 'D', //	Ḏ	uni1E0E	capital D with LINE BELOW
    '\u{01F2}': 'Dz', //	ǲ	uni01F2	capital D with SMALL LETTER Z
    '\u{01C5}': 'Dz', //	ǅ	uni01C5	capital D with SMALL LETTER Z with CARON
    '\u{0110}': 'Dj', //	Đ	Dcroat	capital D with STROKE
    '\u{00D0}': 'Dj', //	Ð	Eth	capital ETH
    '\u{01F1}': 'DZ', //	Ǳ	uni01F1	capital DZ
    '\u{01C4}': 'DZ', //	Ǆ	uni01C4	capital DZ with CARON
    '\u{00C9}': 'E', //	É	Eacute	capital E with ACUTE
    '\u{0114}': 'E', //	Ĕ	Ebreve	capital E with BREVE
    '\u{011A}': 'E', //	Ě	Ecaron	capital E with CARON
    '\u{00CA}': 'E', //	Ê	Ecircumflex	capital E with CIRCUMFLEX
    '\u{1EBE}': 'E', //	Ế	uni1EBE	capital E with CIRCUMFLEX and ACUTE
    '\u{1EC6}': 'E', //	Ệ	uni1EC6	capital E with CIRCUMFLEX and DOT BELOW
    '\u{1EC0}': 'E', //	Ề	uni1EC0	capital E with CIRCUMFLEX and GRAVE
    '\u{1EC2}': 'E', //	Ể	uni1EC2	capital E with CIRCUMFLEX and HOOK ABOVE
    '\u{1EC4}': 'E', //	Ễ	uni1EC4	capital E with CIRCUMFLEX and TILDE
    '\u{00CB}': 'E', //	Ë	Edieresis	capital E with DIAERESIS
    '\u{0116}': 'E', //	Ė	Edotaccent	capital E with DOT ABOVE
    '\u{1EB8}': 'E', //	Ẹ	uni1EB8	capital E with DOT BELOW
    '\u{00C8}': 'E', //	È	Egrave	capital E with GRAVE
    '\u{1EBA}': 'E', //	Ẻ	uni1EBA	capital E with HOOK ABOVE
    '\u{0112}': 'E', //	Ē	Emacron	capital E with MACRON
    '\u{0118}': 'E', //	Ę	Eogonek	capital E with OGONEK
    '\u{1EBC}': 'E', //	Ẽ	uni1EBC	capital E with TILDE
    '\u{0190}': 'E', //	Ɛ	uni0190	capital OPEN E
    '\u{018F}': 'E', //	Ə	uni018F	capital SCHWA
    '\u{0191}': 'F', //	Ƒ	uni0191	capital F with HOOK
    '\u{01F4}': 'G', //	Ǵ	uni01F4	capital G with ACUTE
    '\u{011E}': 'G', //	Ğ	Gbreve	capital G with BREVE
    '\u{01E6}': 'G', //	Ǧ	Gcaron	capital G with CARON
    '\u{0122}': 'G', //	Ģ	Gcommaaccent	capital G with CEDILLA
    '\u{011C}': 'G', //	Ĝ	Gcircumflex	capital G with CIRCUMFLEX
    '\u{0120}': 'G', //	Ġ	Gdotaccent	capital G with DOT ABOVE
    '\u{1E20}': 'G', //	Ḡ	uni1E20	capital G with MACRON
    '\u{029B}': 'G', //	ʛ	uni029B	LATIN LETTER SMALL CAPITAL G with HOOK
    '\u{1E2A}': 'H', //	Ḫ	uni1E2A	capital H with BREVE BELOW
    '\u{0124}': 'H', //	Ĥ	Hcircumflex	capital H with CIRCUMFLEX
    '\u{1E24}': 'H', //	Ḥ	uni1E24	capital H with DOT BELOW
    '\u{0126}': 'H', //	Ħ	Hbar	capital H with STROKE
    '\u{00CD}': 'I', //	Í	Iacute	capital I with ACUTE
    '\u{012C}': 'I', //	Ĭ	Ibreve	capital I with BREVE
    '\u{01CF}': 'I', //	Ǐ	uni01CF	capital I with CARON
    '\u{00CE}': 'I', //	Î	Icircumflex	capital I with CIRCUMFLEX
    '\u{00CF}': 'I', //	Ï	Idieresis	capital I with DIAERESIS
    '\u{0130}': 'I', //	İ	Idotaccent	capital I with DOT ABOVE
    '\u{1ECA}': 'I', //	Ị	uni1ECA	capital I with DOT BELOW
    '\u{00CC}': 'I', //	Ì	Igrave	capital I with GRAVE
    '\u{1EC8}': 'I', //	Ỉ	uni1EC8	capital I with HOOK ABOVE
    '\u{012A}': 'I', //	Ī	Imacron	capital I with MACRON
    '\u{012E}': 'I', //	Į	Iogonek	capital I with OGONEK
    '\u{0128}': 'I', //	Ĩ	Itilde	capital I with TILDE
    '\u{0132}': 'IJ', //	Ĳ	IJ	LATIN CAPITAL LIGATURE IJ
    '\u{0134}': 'J', //	Ĵ	Jcircumflex	capital J with CIRCUMFLEX
    '\u{0136}': 'K', //	Ķ	Kcommaaccent	capital K with CEDILLA
    '\u{1E32}': 'K', //	Ḳ	uni1E32	capital K with DOT BELOW
    '\u{0198}': 'K', //	Ƙ	uni0198	capital K with HOOK
    '\u{1E34}': 'K', //	Ḵ	uni1E34	capital K with LINE BELOW
    '\u{0139}': 'L', //	Ĺ	Lacute	capital L with ACUTE
    '\u{023D}': 'L', //	Ƚ	uni023D	capital L with BAR
    '\u{013D}': 'L', //	Ľ	Lcaron	capital L with CARON
    '\u{013B}': 'L', //	Ļ	Lcommaaccent	capital L with CEDILLA
    '\u{1E3C}': 'L', //	Ḽ	uni1E3C	capital L with CIRCUMFLEX BELOW
    '\u{1E36}': 'L', //	Ḷ	uni1E36	capital L with DOT BELOW
    '\u{1E38}': 'L', //	Ḹ	uni1E38	capital L with DOT BELOW and MACRON
    '\u{1E3A}': 'L', //	Ḻ	uni1E3A	capital L with LINE BELOW
    '\u{013F}': 'L', //	Ŀ	Ldot	capital L with MIDDLE DOT
    '\u{01C8}': 'Lj', //	ǈ	uni01C8	capital L with SMALL LETTER J
    '\u{0141}': 'L', //	Ł	Lslash	capital L with STROKE
    '\u{01C7}': 'LJ', //	Ǉ	uni01C7	capital LJ
    '\u{1E3E}': 'M', //	Ḿ	uni1E3E	capital M with ACUTE
    '\u{1E40}': 'M', //	Ṁ	uni1E40	capital M with DOT ABOVE
    '\u{1E42}': 'M', //	Ṃ	uni1E42	capital M with DOT BELOW
    '\u{0143}': 'N', //	Ń	Nacute	capital N with ACUTE
    '\u{0147}': 'N', //	Ň	Ncaron	capital N with CARON
    '\u{0145}': 'N', //	Ņ	Ncommaaccent	capital N with CEDILLA
    '\u{1E4A}': 'N', //	Ṋ	uni1E4A	capital N with CIRCUMFLEX BELOW
    '\u{1E44}': 'N', //	Ṅ	uni1E44	capital N with DOT ABOVE
    '\u{1E46}': 'N', //	Ṇ	uni1E46	capital N with DOT BELOW
    '\u{01F8}': 'N', //	Ǹ	uni01F8	capital N with GRAVE
    '\u{019D}': 'N', //	Ɲ	uni019D	capital N with LEFT HOOK
    '\u{1E48}': 'N', //	Ṉ	uni1E48	capital N with LINE BELOW
    '\u{01CB}': 'Nj', //	ǋ	uni01CB	capital N with SMALL LETTER J
    '\u{00D1}': 'N', //	Ñ	Ntilde	capital N with TILDE
    '\u{01CA}': 'NJ', //	Ǌ	uni01CA	capital NJ
    '\u{00D3}': 'O', //	Ó	Oacute	capital O with ACUTE
    '\u{014E}': 'O', //	Ŏ	Obreve	capital O with BREVE
    '\u{01D1}': 'O', //	Ǒ	uni01D1	capital O with CARON
    '\u{00D4}': 'O', //	Ô	Ocircumflex	capital O with CIRCUMFLEX
    '\u{1ED0}': 'O', //	Ố	uni1ED0	capital O with CIRCUMFLEX and ACUTE
    '\u{1ED8}': 'O', //	Ộ	uni1ED8	capital O with CIRCUMFLEX and DOT BELOW
    '\u{1ED2}': 'O', //	Ồ	uni1ED2	capital O with CIRCUMFLEX and GRAVE
    '\u{1ED4}': 'O', //	Ổ	uni1ED4	capital O with CIRCUMFLEX and HOOK ABOVE
    '\u{1ED6}': 'O', //	Ỗ	uni1ED6	capital O with CIRCUMFLEX and TILDE
    '\u{00D6}': 'O', //	Ö	Odieresis	capital O with DIAERESIS
    '\u{1ECC}': 'O', //	Ọ	uni1ECC	capital O with DOT BELOW
    '\u{0150}': 'O', //	Ő	Ohungarumlaut	capital O with DOUBLE ACUTE
    '\u{00D2}': 'O', //	Ò	Ograve	capital O with GRAVE
    '\u{1ECE}': 'O', //	Ỏ	uni1ECE	capital O with HOOK ABOVE
    '\u{01A0}': 'O', //	Ơ	Ohorn	capital O with HORN
    '\u{1EDA}': 'O', //	Ớ	uni1EDA	capital O with HORN and ACUTE
    '\u{1EE2}': 'O', //	Ợ	uni1EE2	capital O with HORN and DOT BELOW
    '\u{1EDC}': 'O', //	Ờ	uni1EDC	capital O with HORN and GRAVE
    '\u{1EDE}': 'O', //	Ở	uni1EDE	capital O with HORN and HOOK ABOVE
    '\u{1EE0}': 'O', //	Ỡ	uni1EE0	capital O with HORN and TILDE
    '\u{014C}': 'O', //	Ō	Omacron	capital O with MACRON
    '\u{019F}': 'O', //	Ɵ	uni019F	capital O with MIDDLE TILDE
    '\u{01EA}': 'O', //	Ǫ	uni01EA	capital O with OGONEK
    '\u{00D8}': 'O', //	Ø	Oslash	capital O with STROKE
    '\u{01FE}': 'O', //	Ǿ	Oslashacute	capital O with STROKE and ACUTE
    '\u{00D5}': 'O', //	Õ	Otilde	capital O with TILDE
    '\u{0152}': 'OE', //	Œ	OE	LATIN CAPITAL LIGATURE OE
    '\u{0276}': 'OE', //	ɶ	uni0276	LATIN LETTER SMALL CAPITAL OE
    '\u{00DE}': 'P', //	Þ	Thorn	capital THORN
    '\u{0154}': 'R', //	Ŕ	Racute	capital R with ACUTE
    '\u{0158}': 'R', //	Ř	Rcaron	capital R with CARON
    '\u{0156}': 'R', //	Ŗ	Rcommaaccent	capital R with CEDILLA
    '\u{1E58}': 'R', //	Ṙ	uni1E58	capital R with DOT ABOVE
    '\u{1E5A}': 'R', //	Ṛ	uni1E5A	capital R with DOT BELOW
    '\u{1E5C}': 'R', //	Ṝ	uni1E5C	capital R with DOT BELOW and MACRON
    '\u{1E5E}': 'R', //	Ṟ	uni1E5E	capital R with LINE BELOW
    '\u{0281}': 'R', //	ʁ	uni0281	LATIN LETTER SMALL CAPITAL INVERTED R
    '\u{015A}': 'S', //	Ś	Sacute	capital S with ACUTE
    '\u{0160}': 'S', //	Š	Scaron	capital S with CARON
    '\u{015E}': 'S', //	Ş	Scedilla	capital S with CEDILLA
    '\u{015C}': 'S', //	Ŝ	Scircumflex	capital S with CIRCUMFLEX
    '\u{0218}': 'S', //	Ș	Scommaaccent	capital S with COMMA BELOW
    '\u{1E60}': 'S', //	Ṡ	uni1E60	capital S with DOT ABOVE
    '\u{1E62}': 'S', //	Ṣ	uni1E62	capital S with DOT BELOW
    '\u{1E9E}': 'S', //	ẞ	uni1E9E	capital SHARP S
    '\u{0164}': 'T', //	Ť	Tcaron	capital T with CARON
    '\u{0162}': 'T', //	Ţ	Tcommaaccent	capital T with CEDILLA
    '\u{1E70}': 'T', //	Ṱ	uni1E70	capital T with CIRCUMFLEX BELOW
    '\u{021A}': 'T', //	Ț	uni021A	capital T with COMMA BELOW
    '\u{1E6C}': 'T', //	Ṭ	uni1E6C	capital T with DOT BELOW
    '\u{1E6E}': 'T', //	Ṯ	uni1E6E	capital T with LINE BELOW
    '\u{0166}': 'T', //	Ŧ	Tbar	capital T with STROKE
    '\u{00DA}': 'U', //	Ú	Uacute	capital U with ACUTE
    '\u{016C}': 'U', //	Ŭ	Ubreve	capital U with BREVE
    '\u{01D3}': 'U', //	Ǔ	uni01D3	capital U with CARON
    '\u{00DB}': 'U', //	Û	Ucircumflex	capital U with CIRCUMFLEX
    '\u{00DC}': 'U', //	Ü	Udieresis	capital U with DIAERESIS
    '\u{01D7}': 'U', //	Ǘ	uni01D7	capital U with DIAERESIS and ACUTE
    '\u{01D9}': 'U', //	Ǚ	uni01D9	capital U with DIAERESIS and CARON
    '\u{01DB}': 'U', //	Ǜ	uni01DB	capital U with DIAERESIS and GRAVE
    '\u{01D5}': 'U', //	Ǖ	uni01D5	capital U with DIAERESIS and MACRON
    '\u{1EE4}': 'U', //	Ụ	uni1EE4	capital U with DOT BELOW
    '\u{0170}': 'U', //	Ű	Uhungarumlaut	capital U with DOUBLE ACUTE
    '\u{00D9}': 'U', //	Ù	Ugrave	capital U with GRAVE
    '\u{1EE6}': 'U', //	Ủ	uni1EE6	capital U with HOOK ABOVE
    '\u{01AF}': 'U', //	Ư	Uhorn	capital U with HORN
    '\u{1EE8}': 'U', //	Ứ	uni1EE8	capital U with HORN and ACUTE
    '\u{1EF0}': 'U', //	Ự	uni1EF0	capital U with HORN and DOT BELOW
    '\u{1EEA}': 'U', //	Ừ	uni1EEA	capital U with HORN and GRAVE
    '\u{1EEC}': 'U', //	Ử	uni1EEC	capital U with HORN and HOOK ABOVE
    '\u{1EEE}': 'U', //	Ữ	uni1EEE	capital U with HORN and TILDE
    '\u{016A}': 'U', //	Ū	Umacron	capital U with MACRON
    '\u{0172}': 'U', //	Ų	Uogonek	capital U with OGONEK
    '\u{016E}': 'U', //	Ů	Uring	capital U with RING ABOVE
    '\u{0168}': 'U', //	Ũ	Utilde	capital U with TILDE
    '\u{1E82}': 'W', //	Ẃ	Wacute	capital W with ACUTE
    '\u{0174}': 'W', //	Ŵ	Wcircumflex	capital W with CIRCUMFLEX
    '\u{1E84}': 'W', //	Ẅ	Wdieresis	capital W with DIAERESIS
    '\u{1E80}': 'W', //	Ẁ	Wgrave	capital W with GRAVE
    '\u{02AC}': 'W', //	ʬ	uni02AC	LATIN LETTER BILABIAL PERCUSSIVE
    '\u{00DD}': 'Y', //	Ý	Yacute	capital Y with ACUTE
    '\u{0176}': 'Y', //	Ŷ	Ycircumflex	capital Y with CIRCUMFLEX
    '\u{0178}': 'Y', //	Ÿ	Ydieresis	capital Y with DIAERESIS
    '\u{1E8E}': 'Y', //	Ẏ	uni1E8E	capital Y with DOT ABOVE
    '\u{1EF4}': 'Y', //	Ỵ	uni1EF4	capital Y with DOT BELOW
    '\u{1EF2}': 'Y', //	Ỳ	Ygrave	capital Y with GRAVE
    '\u{01B3}': 'Y', //	Ƴ	uni01B3	capital Y with HOOK
    '\u{1EF6}': 'Y', //	Ỷ	uni1EF6	capital Y with HOOK ABOVE
    '\u{0232}': 'Y', //	Ȳ	uni0232	capital Y with MACRON
    '\u{1EF8}': 'Y', //	Ỹ	uni1EF8	capital Y with TILDE
    '\u{0179}': 'Z', //	Ź	Zacute	capital Z with ACUTE
    '\u{017D}': 'Z', //	Ž	Zcaron	capital Z with CARON
    '\u{017B}': 'Z', //	Ż	Zdotaccent	capital Z with DOT ABOVE
    '\u{1E92}': 'Z', //	Ẓ	uni1E92	capital Z with DOT BELOW
    '\u{1E94}': 'Z', //	Ẕ	uni1E94	capital Z with LINE BELOW
    '\u{01B5}': 'Z', //	Ƶ	uni01B5	capital Z with STROKE
    // lowercase letters
    '\u{00E1}': 'a', //	á	aacute	lowercase A with ACUTE
    '\u{0103}': 'a', //	ă	abreve	lowercase A with BREVE
    '\u{1EAF}': 'a', //	ắ	uni1EAF	lowercase A with BREVE and ACUTE
    '\u{1EB7}': 'a', //	ặ	uni1EB7	lowercase A with BREVE and DOT BELOW
    '\u{1EB1}': 'a', //	ằ	uni1EB1	lowercase A with BREVE and GRAVE
    '\u{1EB3}': 'a', //	ẳ	uni1EB3	lowercase A with BREVE and HOOK ABOVE
    '\u{1EB5}': 'a', //	ẵ	uni1EB5	lowercase A with BREVE and TILDE
    '\u{01CE}': 'a', //	ǎ	uni01CE	lowercase A with CARON
    '\u{00E2}': 'a', //	â	acircumflex	lowercase A with CIRCUMFLEX
    '\u{1EA5}': 'a', //	ấ	uni1EA5	lowercase A with CIRCUMFLEX and ACUTE
    '\u{1EAD}': 'a', //	ậ	uni1EAD	lowercase A with CIRCUMFLEX and DOT BELOW
    '\u{1EA7}': 'a', //	ầ	uni1EA7	lowercase A with CIRCUMFLEX and GRAVE
    '\u{1EA9}': 'a', //	ẩ	uni1EA9	lowercase A with CIRCUMFLEX and HOOK ABOVE
    '\u{1EAB}': 'a', //	ẫ	uni1EAB	lowercase A with CIRCUMFLEX and TILDE
    '\u{00E4}': 'a', //	ä	adieresis	lowercase A with DIAERESIS
    '\u{1EA1}': 'a', //	ạ	uni1EA1	lowercase A with DOT BELOW
    '\u{00E0}': 'a', //	à	agrave	lowercase A with GRAVE
    '\u{1EA3}': 'a', //	ả	uni1EA3	lowercase A with HOOK ABOVE
    '\u{0101}': 'a', //	ā	amacron	lowercase A with MACRON
    '\u{0105}': 'a', //	ą	aogonek	lowercase A with OGONEK
    '\u{00E5}': 'a', //	å	aring	lowercase A with RING ABOVE
    '\u{01FB}': 'a', //	ǻ	aringacute	lowercase A with RING ABOVE and ACUTE
    '\u{00E3}': 'a', //	ã	atilde	lowercase A with TILDE
    '\u{00E6}': 'ae', //	æ	ae	lowercase AE
    '\u{01FD}': 'ae', //	ǽ	aeacute	lowercase AE with ACUTE
    '\u{0251}': 'a', //	ɑ	uni0251	lowercase ALPHA
    '\u{0250}': 'a', //	ɐ	uni0250	lowercase TURNED A
    '\u{0252}': 'a', //	ɒ	uni0252	lowercase TURNED ALPHA
    '\u{1E05}': 'b', //	ḅ	uni1E05	lowercase B with DOT BELOW
    '\u{0253}': 'b', //	ɓ	uni0253	lowercase B with HOOK
    '\u{0107}': 'c', //	ć	cacute	lowercase C with ACUTE
    '\u{010D}': 'c', //	č	ccaron	lowercase C with CARON
    '\u{00E7}': 'c', //	ç	ccedilla	lowercase C with CEDILLA
    '\u{0109}': 'c', //	ĉ	ccircumflex	lowercase C with CIRCUMFLEX
    '\u{0255}': 'c', //	ɕ	uni0255	lowercase C with CURL
    '\u{010B}': 'c', //	ċ	cdotaccent	lowercase C with DOT ABOVE
    '\u{010F}': 'd', //	ď	dcaron	lowercase D with CARON
    '\u{1E13}': 'd', //	ḓ	uni1E13	lowercase D with CIRCUMFLEX BELOW
    '\u{1E0D}': 'd', //	ḍ	uni1E0D	lowercase D with DOT BELOW
    '\u{0257}': 'd', //	ɗ	uni0257	lowercase D with HOOK
    '\u{1E0F}': 'd', //	ḏ	uni1E0F	lowercase D with LINE BELOW
    '\u{0111}': 'dj', //	đ	dcroat	lowercase D with STROKE
    '\u{0256}': 'd', //	ɖ	uni0256	lowercase D with TAIL
    '\u{02A4}': 'dz', //	ʤ	uni02A4	lowercase DEZH DIGRAPH
    '\u{01F3}': 'dz', //	ǳ	uni01F3	lowercase DZ
    '\u{02A3}': 'dz', //	ʣ	uni02A3	lowercase DZ DIGRAPH
    '\u{02A5}': 'dz', //	ʥ	uni02A5	lowercase DZ DIGRAPH with CURL
    '\u{01C6}': 'dz', //	ǆ	uni01C6	lowercase DZ with CARON
    '\u{00F0}': 'dj', //	ð	eth	lowercase ETH
    '\u{00E9}': 'e', //	é	eacute	lowercase E with ACUTE
    '\u{0115}': 'e', //	ĕ	ebreve	lowercase E with BREVE
    '\u{011B}': 'e', //	ě	ecaron	lowercase E with CARON
    '\u{00EA}': 'e', //	ê	ecircumflex	lowercase E with CIRCUMFLEX
    '\u{1EBF}': 'e', //	ế	uni1EBF	lowercase E with CIRCUMFLEX and ACUTE
    '\u{1EC7}': 'e', //	ệ	uni1EC7	lowercase E with CIRCUMFLEX and DOT BELOW
    '\u{1EC1}': 'e', //	ề	uni1EC1	lowercase E with CIRCUMFLEX and GRAVE
    '\u{1EC3}': 'e', //	ể	uni1EC3	lowercase E with CIRCUMFLEX and HOOK ABOVE
    '\u{1EC5}': 'e', //	ễ	uni1EC5	lowercase E with CIRCUMFLEX and TILDE
    '\u{00EB}': 'e', //	ë	edieresis	lowercase E with DIAERESIS
    '\u{0117}': 'e', //	ė	edotaccent	lowercase E with DOT ABOVE
    '\u{1EB9}': 'e', //	ẹ	uni1EB9	lowercase E with DOT BELOW
    '\u{00E8}': 'e', //	è	egrave	lowercase E with GRAVE
    '\u{1EBB}': 'e', //	ẻ	uni1EBB	lowercase E with HOOK ABOVE
    '\u{0113}': 'e', //	ē	emacron	lowercase E with MACRON
    '\u{0119}': 'e', //	ę	eogonek	lowercase E with OGONEK
    '\u{1EBD}': 'e', //	ẽ	uni1EBD	lowercase E with TILDE
    '\u{0292}': 'e', //	ʒ	uni0292	lowercase EZH
    '\u{01EF}': 'e', //	ǯ	uni01EF	lowercase EZH with CARON
    '\u{0293}': 'e', //	ʓ	uni0293	lowercase EZH with CURL
    '\u{0258}': 'e', //	ɘ	uni0258	lowercase REVERSED E
    '\u{025C}': 'e', //	ɜ	uni025C	lowercase REVERSED OPEN E
    '\u{025D}': 'e', //	ɝ	uni025D	lowercase REVERSED OPEN E with HOOK
    '\u{0259}': 'e', //	ə	uni0259	lowercase SCHWA
    '\u{025A}': 'e', //	ɚ	uni025A	lowercase SCHWA with HOOK
    '\u{029A}': 'e', //	ʚ	uni029A	lowercase CLOSED OPEN E
    '\u{025E}': 'e', //	ɞ	uni025E	lowercase CLOSED REVERSED OPEN E
    '\u{0192}': 'f', //	ƒ	florin	lowercase F with HOOK
    '\u{02A9}': 'f', //	ʩ	uni02A9	lowercase FENG DIGRAPH
    '\u{FB01}': 'fi', //	ﬁ	fi	LATIN SMALL LIGATURE FI
    '\u{FB02}': 'fl', //	ﬂ	fl	LATIN SMALL LIGATURE FL
    '\u{01F5}': 'g', //	ǵ	uni01F5	lowercase G with ACUTE
    '\u{011F}': 'g', //	ğ	gbreve	lowercase G with BREVE
    '\u{01E7}': 'g', //	ǧ	gcaron	lowercase G with CARON
    '\u{0123}': 'g', //	ģ	gcommaaccent	lowercase G with CEDILLA
    '\u{011D}': 'g', //	ĝ	gcircumflex	lowercase G with CIRCUMFLEX
    '\u{0121}': 'g', //	ġ	gdotaccent	lowercase G with DOT ABOVE
    '\u{0260}': 'g', //	ɠ	uni0260	lowercase G with HOOK
    '\u{1E21}': 'g', //	ḡ	uni1E21	lowercase G with MACRON
    '\u{0261}': 'g', //	ɡ	uni0261	lowercase SCRIPT G
    '\u{0263}': 'g', //	ɣ	uni0263	lowercase GAMMA
    '\u{1E2B}': 'h', //	ḫ	uni1E2B	lowercase H with BREVE BELOW
    '\u{0125}': 'h', //	ĥ	hcircumflex	lowercase H with CIRCUMFLEX
    '\u{1E25}': 'h', //	ḥ	uni1E25	lowercase H with DOT BELOW
    '\u{0266}': 'h', //	ɦ	uni0266	lowercase H with HOOK
    '\u{1E96}': 'h', //	ẖ	uni1E96	lowercase H with LINE BELOW
    '\u{0127}': 'h', //	ħ	hbar	lowercase H with STROKE
    '\u{0267}': 'h', //	ɧ	uni0267	lowercase HENG with HOOK
    '\u{0265}': 'h', //	ɥ	uni0265	lowercase TURNED H
    '\u{02AE}': 'h', //	ʮ	uni02AE	lowercase TURNED H with FISHHOOK
    '\u{02AF}': 'h', //	ʯ	uni02AF	lowercase TURNED H with FISHHOOK and TAIL
    '\u{00ED}': 'i', //	í	iacute	lowercase I with ACUTE
    '\u{012D}': 'i', //	ĭ	ibreve	lowercase I with BREVE
    '\u{01D0}': 'i', //	ǐ	uni01D0	lowercase I with CARON
    '\u{00EE}': 'i', //	î	icircumflex	lowercase I with CIRCUMFLEX
    '\u{00EF}': 'i', //	ï	idieresis	lowercase I with DIAERESIS
    '\u{1ECB}': 'i', //	ị	uni1ECB	lowercase I with DOT BELOW
    '\u{00EC}': 'i', //	ì	igrave	lowercase I with GRAVE
    '\u{1EC9}': 'i', //	ỉ	uni1EC9	lowercase I with HOOK ABOVE
    '\u{012B}': 'i', //	ī	imacron	lowercase I with MACRON
    '\u{012F}': 'i', //	į	iogonek	lowercase I with OGONEK
    '\u{0268}': 'i', //	ɨ	uni0268	lowercase I with STROKE
    '\u{0129}': 'i', //	ĩ	itilde	lowercase I with TILDE
    '\u{0269}': 'i', //	ɩ	uni0269	lowercase IOTA
    '\u{0131}': 'i', //	ı	dotlessi	lowercase DOTLESS I
    '\u{0133}': 'ij', //	ĳ	ij	LATIN SMALL LIGATURE IJ
    '\u{025F}': 'j', //	ɟ	uni025F	lowercase DOTLESS J with STROKE
    '\u{01F0}': 'j', //	ǰ	uni01F0	lowercase J with CARON
    '\u{0135}': 'j', //	ĵ	jcircumflex	lowercase J with CIRCUMFLEX
    '\u{029D}': 'j', //	ʝ	uni029D	lowercase J with CROSSED-TAIL
    '\u{0237}': 'j', //	ȷ	uni0237	lowercase DOTLESS J
    '\u{0284}': 'j', //	ʄ	uni0284	lowercase DOTLESS J with STROKE and HOOK
    '\u{0137}': 'k', //	ķ	kcommaaccent	lowercase K with CEDILLA
    '\u{1E33}': 'k', //	ḳ	uni1E33	lowercase K with DOT BELOW
    '\u{0199}': 'k', //	ƙ	uni0199	lowercase K with HOOK
    '\u{1E35}': 'k', //	ḵ	uni1E35	lowercase K with LINE BELOW
    '\u{0138}': 'k', //	ĸ	kgreenlandic	lowercase KRA
    '\u{029E}': 'k', //	ʞ	uni029E	lowercase TURNED K
    '\u{013A}': 'l', //	ĺ	lacute	lowercase L with ACUTE
    '\u{019A}': 'l', //	ƚ	uni019A	lowercase L with BAR
    '\u{026C}': 'l', //	ɬ	uni026C	lowercase L with BELT
    '\u{013E}': 'l', //	ľ	lcaron	lowercase L with CARON
    '\u{013C}': 'l', //	ļ	lcommaaccent	lowercase L with CEDILLA
    '\u{1E3D}': 'l', //	ḽ	uni1E3D	lowercase L with CIRCUMFLEX BELOW
    '\u{1E37}': 'l', //	ḷ	uni1E37	lowercase L with DOT BELOW
    '\u{1E39}': 'l', //	ḹ	uni1E39	lowercase L with DOT BELOW and MACRON
    '\u{1E3B}': 'l', //	ḻ	uni1E3B	lowercase L with LINE BELOW
    '\u{0140}': 'l', //	ŀ	ldot	lowercase L with MIDDLE DOT
    '\u{026B}': 'l', //	ɫ	uni026B	lowercase L with MIDDLE TILDE
    '\u{026D}': 'l', //	ɭ	uni026D	lowercase L with RETROFLEX HOOK
    '\u{0142}': 'l', //	ł	lslash	lowercase L with STROKE
    '\u{019B}': 'l', //	ƛ	uni019B	lowercase LAMBDA with STROKE
    '\u{026E}': 'l', //	ɮ	uni026E	lowercase LEZH
    '\u{01C9}': 'lj', //	ǉ	uni01C9	lowercase LJ
    '\u{02AA}': 'ls', //	ʪ	uni02AA	lowercase LS DIGRAPH
    '\u{02AB}': 'lz', //	ʫ	uni02AB	lowercase LZ DIGRAPH
    '\u{1E3F}': 'm', //	ḿ	uni1E3F	lowercase M with ACUTE
    '\u{1E41}': 'm', //	ṁ	uni1E41	lowercase M with DOT ABOVE
    '\u{1E43}': 'm', //	ṃ	uni1E43	lowercase M with DOT BELOW
    '\u{0271}': 'm', //	ɱ	uni0271	lowercase M with HOOK
    '\u{026F}': 'm', //	ɯ	uni026F	lowercase TURNED M
    '\u{0270}': 'm', //	ɰ	uni0270	lowercase TURNED M with LONG LEG
    '\u{0149}': 'n', //	ŉ	napostrophe	lowercase N PRECEDED BY APOSTROPHE
    '\u{0144}': 'n', //	ń	nacute	lowercase N with ACUTE
    '\u{0148}': 'n', //	ň	ncaron	lowercase N with CARON
    '\u{0146}': 'n', //	ņ	ncommaaccent	lowercase N with CEDILLA
    '\u{1E4B}': 'n', //	ṋ	uni1E4B	lowercase N with CIRCUMFLEX BELOW
    '\u{1E45}': 'n', //	ṅ	uni1E45	lowercase N with DOT ABOVE
    '\u{1E47}': 'n', //	ṇ	uni1E47	lowercase N with DOT BELOW
    '\u{01F9}': 'n', //	ǹ	uni01F9	lowercase N with GRAVE
    '\u{0272}': 'n', //	ɲ	uni0272	lowercase N with LEFT HOOK
    '\u{1E49}': 'n', //	ṉ	uni1E49	lowercase N with LINE BELOW
    '\u{0273}': 'n', //	ɳ	uni0273	lowercase N with RETROFLEX HOOK
    '\u{00F1}': 'n', //	ñ	ntilde	lowercase N with TILDE
    '\u{01CC}': 'nj', //	ǌ	uni01CC	lowercase NJ
    '\u{014B}': 'n', //	ŋ	eng	lowercase ENG
    '\u{014A}': 'n', //	Ŋ	Eng	capital ENG
    '\u{00F3}': 'o', //	ó	oacute	lowercase O with ACUTE
    '\u{014F}': 'o', //	ŏ	obreve	lowercase O with BREVE
    '\u{01D2}': 'o', //	ǒ	uni01D2	lowercase O with CARON
    '\u{00F4}': 'o', //	ô	ocircumflex	lowercase O with CIRCUMFLEX
    '\u{1ED1}': 'o', //	ố	uni1ED1	lowercase O with CIRCUMFLEX and ACUTE
    '\u{1ED9}': 'o', //	ộ	uni1ED9	lowercase O with CIRCUMFLEX and DOT BELOW
    '\u{1ED3}': 'o', //	ồ	uni1ED3	lowercase O with CIRCUMFLEX and GRAVE
    '\u{1ED5}': 'o', //	ổ	uni1ED5	lowercase O with CIRCUMFLEX and HOOK ABOVE
    '\u{1ED7}': 'o', //	ỗ	uni1ED7	lowercase O with CIRCUMFLEX and TILDE
    '\u{00F6}': 'o', //	ö	odieresis	lowercase O with DIAERESIS
    '\u{1ECD}': 'o', //	ọ	uni1ECD	lowercase O with DOT BELOW
    '\u{0151}': 'o', //	ő	ohungarumlaut	lowercase O with DOUBLE ACUTE
    '\u{00F2}': 'o', //	ò	ograve	lowercase O with GRAVE
    '\u{1ECF}': 'o', //	ỏ	uni1ECF	lowercase O with HOOK ABOVE
    '\u{01A1}': 'o', //	ơ	ohorn	lowercase O with HORN
    '\u{1EDB}': 'o', //	ớ	uni1EDB	lowercase O with HORN and ACUTE
    '\u{1EE3}': 'o', //	ợ	uni1EE3	lowercase O with HORN and DOT BELOW
    '\u{1EDD}': 'o', //	ờ	uni1EDD	lowercase O with HORN and GRAVE
    '\u{1EDF}': 'o', //	ở	uni1EDF	lowercase O with HORN and HOOK ABOVE
    '\u{1EE1}': 'o', //	ỡ	uni1EE1	lowercase O with HORN and TILDE
    '\u{014D}': 'o', //	ō	omacron	lowercase O with MACRON
    '\u{01EB}': 'o', //	ǫ	uni01EB	lowercase O with OGONEK
    '\u{00F8}': 'o', //	ø	oslash	lowercase O with STROKE
    '\u{01FF}': 'o', //	ǿ	oslashacute	lowercase O with STROKE and ACUTE
    '\u{00F5}': 'o', //	õ	otilde	lowercase O with TILDE
    '\u{025B}': 'e', //	ɛ	uni025B	lowercase OPEN E
    '\u{0254}': 'o', //	ɔ	uni0254	lowercase OPEN O
    '\u{0275}': 'o', //	ɵ	uni0275	lowercase BARRED O
    '\u{0298}': 'o', //	ʘ	uni0298	LATIN LETTER BILABIAL CLICK
    '\u{0153}': 'oe', //	œ	oe	LATIN SMALL LIGATURE OE
    '\u{0278}': 'p', //	ɸ	uni0278	lowercase PHI
    '\u{00FE}': 'p', //	þ	thorn	lowercase THORN
    '\u{02A0}': 'q', //	ʠ	uni02A0	lowercase Q with HOOK
    '\u{0155}': 'r', //	ŕ	racute	lowercase R with ACUTE
    '\u{0159}': 'r', //	ř	rcaron	lowercase R with CARON
    '\u{0157}': 'r', //	ŗ	rcommaaccent	lowercase R with CEDILLA
    '\u{1E59}': 'r', //	ṙ	uni1E59	lowercase R with DOT ABOVE
    '\u{1E5B}': 'r', //	ṛ	uni1E5B	lowercase R with DOT BELOW
    '\u{1E5D}': 'r', //	ṝ	uni1E5D	lowercase R with DOT BELOW and MACRON
    '\u{027E}': 'r', //	ɾ	uni027E	lowercase R with FISHHOOK
    '\u{1E5F}': 'r', //	ṟ	uni1E5F	lowercase R with LINE BELOW
    '\u{027C}': 'r', //	ɼ	uni027C	lowercase R with LONG LEG
    '\u{027D}': 'r', //	ɽ	uni027D	lowercase R with TAIL
    '\u{027F}': 'r', //	ɿ	uni027F	lowercase REVERSED R with FISHHOOK
    '\u{0279}': 'r', //	ɹ	uni0279	lowercase TURNED R
    '\u{027B}': 'r', //	ɻ	uni027B	lowercase TURNED R with HOOK
    '\u{027A}': 'r', //	ɺ	uni027A	lowercase TURNED R with LONG LEG
    '\u{015B}': 's', //	ś	sacute	lowercase S with ACUTE
    '\u{0161}': 's', //	š	scaron	lowercase S with CARON
    '\u{015F}': 's', //	ş	scedilla	lowercase S with CEDILLA
    '\u{015D}': 's', //	ŝ	scircumflex	lowercase S with CIRCUMFLEX
    '\u{0219}': 's', //	ș	scommaaccent	lowercase S with COMMA BELOW
    '\u{1E61}': 's', //	ṡ	uni1E61	lowercase S with DOT ABOVE
    '\u{1E63}': 's', //	ṣ	uni1E63	lowercase S with DOT BELOW
    '\u{0282}': 's', //	ʂ	uni0282	lowercase S with HOOK
    '\u{017F}': 's', //	ſ	longs	lowercase LONG S
    '\u{0283}': 's', //	ʃ	uni0283	lowercase ESH
    '\u{0286}': 's', //	ʆ	uni0286	lowercase ESH with CURL
    '\u{00DF}': 's', //	ß	germandbls	lowercase SHARP S
    '\u{0285}': 's', //	ʅ	uni0285	lowercase SQUAT REVERSED ESH
    '\u{0165}': 't', //	ť	tcaron	lowercase T with CARON
    '\u{0163}': 't', //	ţ	tcommaaccent	lowercase T with CEDILLA
    '\u{1E71}': 't', //	ṱ	uni1E71	lowercase T with CIRCUMFLEX BELOW
    '\u{021B}': 't', //	ț	uni021B	lowercase T with COMMA BELOW
    '\u{1E97}': 't', //	ẗ	uni1E97	lowercase T with DIAERESIS
    '\u{1E6D}': 't', //	ṭ	uni1E6D	lowercase T with DOT BELOW
    '\u{1E6F}': 't', //	ṯ	uni1E6F	lowercase T with LINE BELOW
    '\u{0288}': 't', //	ʈ	uni0288	lowercase T with RETROFLEX HOOK
    '\u{0167}': 't', //	ŧ	tbar	lowercase T with STROKE
    '\u{02A8}': 't', //	ʨ	uni02A8	lowercase TC DIGRAPH with CURL
    '\u{02A7}': 't', //	ʧ	uni02A7	lowercase TESH DIGRAPH
    '\u{02A6}': 't', //	ʦ	uni02A6	lowercase TS DIGRAPH
    '\u{0287}': 't', //	ʇ	uni0287	lowercase TURNED T
    '\u{0289}': 'u', //	ʉ	uni0289	lowercase U BAR
    '\u{00FA}': 'u', //	ú	uacute	lowercase U with ACUTE
    '\u{016D}': 'u', //	ŭ	ubreve	lowercase U with BREVE
    '\u{01D4}': 'u', //	ǔ	uni01D4	lowercase U with CARON
    '\u{00FB}': 'u', //	û	ucircumflex	lowercase U with CIRCUMFLEX
    '\u{00FC}': 'u', //	ü	udieresis	lowercase U with DIAERESIS
    '\u{01D8}': 'u', //	ǘ	uni01D8	lowercase U with DIAERESIS and ACUTE
    '\u{01DA}': 'u', //	ǚ	uni01DA	lowercase U with DIAERESIS and CARON
    '\u{01DC}': 'u', //	ǜ	uni01DC	lowercase U with DIAERESIS and GRAVE
    '\u{01D6}': 'u', //	ǖ	uni01D6	lowercase U with DIAERESIS and MACRON
    '\u{1EE5}': 'u', //	ụ	uni1EE5	lowercase U with DOT BELOW
    '\u{0171}': 'u', //	ű	uhungarumlaut	lowercase U with DOUBLE ACUTE
    '\u{00F9}': 'u', //	ù	ugrave	lowercase U with GRAVE
    '\u{1EE7}': 'u', //	ủ	uni1EE7	lowercase U with HOOK ABOVE
    '\u{01B0}': 'u', //	ư	uhorn	lowercase U with HORN
    '\u{1EE9}': 'u', //	ứ	uni1EE9	lowercase U with HORN and ACUTE
    '\u{1EF1}': 'u', //	ự	uni1EF1	lowercase U with HORN and DOT BELOW
    '\u{1EEB}': 'u', //	ừ	uni1EEB	lowercase U with HORN and GRAVE
    '\u{1EED}': 'u', //	ử	uni1EED	lowercase U with HORN and HOOK ABOVE
    '\u{1EEF}': 'u', //	ữ	uni1EEF	lowercase U with HORN and TILDE
    '\u{016B}': 'u', //	ū	umacron	lowercase U with MACRON
    '\u{0173}': 'u', //	ų	uogonek	lowercase U with OGONEK
    '\u{016F}': 'u', //	ů	uring	lowercase U with RING ABOVE
    '\u{0169}': 'u', //	ũ	utilde	lowercase U with TILDE
    '\u{028A}': 'u', //	ʊ	uni028A	lowercase UPSILON
    '\u{028B}': 'v', //	ʋ	uni028B	lowercase V with HOOK
    '\u{028C}': 'v', //	ʌ	uni028C	lowercase TURNED V
    '\u{1E83}': 'w', //	ẃ	wacute	lowercase W with ACUTE
    '\u{0175}': 'w', //	ŵ	wcircumflex	lowercase W with CIRCUMFLEX
    '\u{1E85}': 'w', //	ẅ	wdieresis	lowercase W with DIAERESIS
    '\u{1E81}': 'w', //	ẁ	wgrave	lowercase W with GRAVE
    '\u{028D}': 'w', //	ʍ	uni028D	lowercase TURNED W
    '\u{00FD}': 'y', //	ý	yacute	lowercase Y with ACUTE
    '\u{0177}': 'y', //	ŷ	ycircumflex	lowercase Y with CIRCUMFLEX
    '\u{00FF}': 'y', //	ÿ	ydieresis	lowercase Y with DIAERESIS
    '\u{1E8F}': 'y', //	ẏ	uni1E8F	lowercase Y with DOT ABOVE
    '\u{1EF5}': 'y', //	ỵ	uni1EF5	lowercase Y with DOT BELOW
    '\u{1EF3}': 'y', //	ỳ	ygrave	lowercase Y with GRAVE
    '\u{01B4}': 'y', //	ƴ	uni01B4	lowercase Y with HOOK
    '\u{1EF7}': 'y', //	ỷ	uni1EF7	lowercase Y with HOOK ABOVE
    '\u{0233}': 'y', //	ȳ	uni0233	lowercase Y with MACRON
    '\u{1EF9}': 'y', //	ỹ	uni1EF9	lowercase Y with TILDE
    '\u{028E}': 'y', //	ʎ	uni028E	lowercase TURNED Y
    '\u{017A}': 'z', //	ź	zacute	lowercase Z with ACUTE
    '\u{017E}': 'z', //	ž	zcaron	lowercase Z with CARON
    '\u{0291}': 'z', //	ʑ	uni0291	lowercase Z with CURL
    '\u{017C}': 'z', //	ż	zdotaccent	lowercase Z with DOT ABOVE
    '\u{1E93}': 'z', //	ẓ	uni1E93	lowercase Z with DOT BELOW
    '\u{1E95}': 'z', //	ẕ	uni1E95	lowercase Z with LINE BELOW
    '\u{0290}': 'z', //	ʐ	uni0290	lowercase Z with RETROFLEX HOOK
    '\u{01B6}': 'z', //	ƶ	uni01B6	lowercase Z with STROKE
  };
}
