module Typing exposing
    ( newData, typeTo, getState, getFixed, getRest, getHistory
    , makeRomaji
    , romanTable, defaultPriorities, setPriorities
    , setEfficiency, setFavoriteKeys, setFavoriteStart
    , insertLowPriorities, getSamePriority
    , Data, Rules, PrintRule, State(..)
    )

{-| Japanese Typing Library for Elm.


# Core

@docs newData, typeTo, getState, getFixed, getRest, getHistory
@docs makeRomaji


# Rules

@docs romanTable, defaultPriorities, setPriorities
@docs setEfficiency, setFavoriteKeys, setFavoriteStart
@docs insertLowPriorities, getSamePriority


# Types

@docs Data, Rules, PrintRule, State

-}


type alias Rule =
    { input : String
    , output : String
    , priority : Int
    }


{-| 変換テーブルです。
-}
type alias Rules =
    List Rule


{-| ローマ字入力のテーブルです。
-}
romanTable : Rules
romanTable =
    [ Rule "-" "ー" 0
    , Rule "~" "〜" 0
    , Rule "." "。" 0
    , Rule "," "、" 0
    , Rule "[" "「" 0
    , Rule "]" "」" 0
    , Rule "va" "ゔぁ" 0
    , Rule "vi" "ゔぃ" 0
    , Rule "vu" "ゔ" 0
    , Rule "ve" "ゔぇ" 0
    , Rule "vo" "ゔぉ" 0
    , Rule "vya" "ゔゃ" 0
    , Rule "vyi" "ゔぃ" 0
    , Rule "vyu" "ゔゅ" 0
    , Rule "vye" "ゔぇ" 0
    , Rule "vyo" "ゔょ" 0
    , Rule "kya" "きゃ" 0
    , Rule "kyi" "きぃ" 0
    , Rule "kyu" "きゅ" 0
    , Rule "kye" "きぇ" 0
    , Rule "kyo" "きょ" 0
    , Rule "gya" "ぎゃ" 0
    , Rule "gyi" "ぎぃ" 0
    , Rule "gyu" "ぎゅ" 0
    , Rule "gye" "ぎぇ" 0
    , Rule "gyo" "ぎょ" 0
    , Rule "sya" "しゃ" 0
    , Rule "syi" "しぃ" 0
    , Rule "syu" "しゅ" 0
    , Rule "sye" "しぇ" 0
    , Rule "syo" "しょ" 0
    , Rule "sha" "しゃ" 0
    , Rule "shi" "し" 0
    , Rule "shu" "しゅ" 0
    , Rule "she" "しぇ" 0
    , Rule "sho" "しょ" 0
    , Rule "zya" "じゃ" 0
    , Rule "zyi" "じぃ" 0
    , Rule "zyu" "じゅ" 0
    , Rule "zye" "じぇ" 0
    , Rule "zyo" "じょ" 0
    , Rule "tya" "ちゃ" 0
    , Rule "tyi" "ちぃ" 0
    , Rule "tyu" "ちゅ" 0
    , Rule "tye" "ちぇ" 0
    , Rule "tyo" "ちょ" 0
    , Rule "cha" "ちゃ" 0
    , Rule "chi" "ち" 0
    , Rule "chu" "ちゅ" 0
    , Rule "che" "ちぇ" 0
    , Rule "cho" "ちょ" 0
    , Rule "cya" "ちゃ" 0
    , Rule "cyi" "ちぃ" 0
    , Rule "cyu" "ちゅ" 0
    , Rule "cye" "ちぇ" 0
    , Rule "cyo" "ちょ" 0
    , Rule "dya" "ぢゃ" 0
    , Rule "dyi" "ぢぃ" 0
    , Rule "dyu" "ぢゅ" 0
    , Rule "dye" "ぢぇ" 0
    , Rule "dyo" "ぢょ" 0
    , Rule "tsa" "つぁ" 0
    , Rule "tsi" "つぃ" 0
    , Rule "tse" "つぇ" 0
    , Rule "tso" "つぉ" 0
    , Rule "tha" "てゃ" 0
    , Rule "thi" "てぃ" 0
    , Rule "thu" "てゅ" 0
    , Rule "the" "てぇ" 0
    , Rule "tho" "てょ" 0
    , Rule "dha" "でゃ" 0
    , Rule "dhi" "でぃ" 0
    , Rule "dhu" "でゅ" 0
    , Rule "dhe" "でぇ" 0
    , Rule "dho" "でょ" 0
    , Rule "twa" "とぁ" 0
    , Rule "twi" "とぃ" 0
    , Rule "twu" "とぅ" 0
    , Rule "twe" "とぇ" 0
    , Rule "two" "とぉ" 0
    , Rule "dwa" "どぁ" 0
    , Rule "dwi" "どぃ" 0
    , Rule "dwu" "どぅ" 0
    , Rule "dwe" "どぇ" 0
    , Rule "dwo" "どぉ" 0
    , Rule "nya" "にゃ" 0
    , Rule "nyi" "にぃ" 0
    , Rule "nyu" "にゅ" 0
    , Rule "nye" "にぇ" 0
    , Rule "nyo" "にょ" 0
    , Rule "hya" "ひゃ" 0
    , Rule "hyi" "ひぃ" 0
    , Rule "hyu" "ひゅ" 0
    , Rule "hye" "ひぇ" 0
    , Rule "hyo" "ひょ" 0
    , Rule "bya" "びゃ" 0
    , Rule "byi" "びぃ" 0
    , Rule "byu" "びゅ" 0
    , Rule "bye" "びぇ" 0
    , Rule "byo" "びょ" 0
    , Rule "pya" "ぴゃ" 0
    , Rule "pyi" "ぴぃ" 0
    , Rule "pyu" "ぴゅ" 0
    , Rule "pye" "ぴぇ" 0
    , Rule "pyo" "ぴょ" 0
    , Rule "fa" "ふぁ" 0
    , Rule "fi" "ふぃ" 0
    , Rule "fe" "ふぇ" 0
    , Rule "fo" "ふぉ" 0
    , Rule "fya" "ふゃ" 0
    , Rule "fyu" "ふゅ" 0
    , Rule "fyo" "ふょ" 0
    , Rule "mya" "みゃ" 0
    , Rule "myi" "みぃ" 0
    , Rule "myu" "みゅ" 0
    , Rule "mye" "みぇ" 0
    , Rule "myo" "みょ" 0
    , Rule "rya" "りゃ" 0
    , Rule "ryi" "りぃ" 0
    , Rule "ryu" "りゅ" 0
    , Rule "rye" "りぇ" 0
    , Rule "ryo" "りょ" 0
    , Rule "nn" "ん" 0
    , Rule "n" "ん" 0
    , Rule "xn" "ん" 0
    , Rule "a" "あ" 0
    , Rule "i" "い" 0
    , Rule "u" "う" 0
    , Rule "wu" "う" 0
    , Rule "e" "え" 0
    , Rule "o" "お" 0
    , Rule "xa" "ぁ" 0
    , Rule "xi" "ぃ" 0
    , Rule "xu" "ぅ" 0
    , Rule "xe" "ぇ" 0
    , Rule "xo" "ぉ" 0
    , Rule "la" "ぁ" 0
    , Rule "li" "ぃ" 0
    , Rule "lu" "ぅ" 0
    , Rule "le" "ぇ" 0
    , Rule "lo" "ぉ" 0
    , Rule "lyi" "ぃ" 0
    , Rule "xyi" "ぃ" 0
    , Rule "lye" "ぇ" 0
    , Rule "xye" "ぇ" 0
    , Rule "ye" "いぇ" 0
    , Rule "ka" "か" 0
    , Rule "ki" "き" 0
    , Rule "ku" "く" 0
    , Rule "ke" "け" 0
    , Rule "ko" "こ" 0
    , Rule "xka" "ヵ" 0
    , Rule "xke" "ヶ" 0
    , Rule "lka" "ヵ" 0
    , Rule "lke" "ヶ" 0
    , Rule "ga" "が" 0
    , Rule "gi" "ぎ" 0
    , Rule "gu" "ぐ" 0
    , Rule "ge" "げ" 0
    , Rule "go" "ご" 0
    , Rule "sa" "さ" 0
    , Rule "si" "し" 0
    , Rule "su" "す" 0
    , Rule "se" "せ" 0
    , Rule "so" "そ" 0
    , Rule "ca" "か" 0
    , Rule "ci" "し" 0
    , Rule "cu" "く" 0
    , Rule "ce" "せ" 0
    , Rule "co" "こ" 0
    , Rule "qa" "くぁ" 0
    , Rule "qi" "くぃ" 0
    , Rule "qu" "く" 0
    , Rule "qe" "くぇ" 0
    , Rule "qo" "くぉ" 0
    , Rule "kwa" "くぁ" 0
    , Rule "gwa" "ぐぁ" 0
    , Rule "gwi" "ぐぃ" 0
    , Rule "gwu" "ぐぅ" 0
    , Rule "gwe" "ぐぇ" 0
    , Rule "gwo" "ぐぉ" 0
    , Rule "za" "ざ" 0
    , Rule "zi" "じ" 0
    , Rule "zu" "ず" 0
    , Rule "ze" "ぜ" 0
    , Rule "zo" "ぞ" 0
    , Rule "ja" "じゃ" 0
    , Rule "ji" "じ" 0
    , Rule "ju" "じゅ" 0
    , Rule "je" "じぇ" 0
    , Rule "jo" "じょ" 0
    , Rule "jya" "じゃ" 0
    , Rule "jyi" "じぃ" 0
    , Rule "jyu" "じゅ" 0
    , Rule "jye" "じぇ" 0
    , Rule "jyo" "じょ" 0
    , Rule "ta" "た" 0
    , Rule "ti" "ち" 0
    , Rule "tu" "つ" 0
    , Rule "tsu" "つ" 0
    , Rule "te" "て" 0
    , Rule "to" "と" 0
    , Rule "da" "だ" 0
    , Rule "di" "ぢ" 0
    , Rule "du" "づ" 0
    , Rule "de" "で" 0
    , Rule "do" "ど" 0
    , Rule "xtu" "っ" 0
    , Rule "xtsu" "っ" 0
    , Rule "ltu" "っ" 0
    , Rule "ltsu" "っ" 0
    , Rule "na" "な" 0
    , Rule "ni" "に" 0
    , Rule "nu" "ぬ" 0
    , Rule "ne" "ね" 0
    , Rule "no" "の" 0
    , Rule "ha" "は" 0
    , Rule "hi" "ひ" 0
    , Rule "hu" "ふ" 0
    , Rule "fu" "ふ" 0
    , Rule "he" "へ" 0
    , Rule "ho" "ほ" 0
    , Rule "ba" "ば" 0
    , Rule "bi" "び" 0
    , Rule "bu" "ぶ" 0
    , Rule "be" "べ" 0
    , Rule "bo" "ぼ" 0
    , Rule "pa" "ぱ" 0
    , Rule "pi" "ぴ" 0
    , Rule "pu" "ぷ" 0
    , Rule "pe" "ぺ" 0
    , Rule "po" "ぽ" 0
    , Rule "ma" "ま" 0
    , Rule "mi" "み" 0
    , Rule "mu" "む" 0
    , Rule "me" "め" 0
    , Rule "mo" "も" 0
    , Rule "xya" "ゃ" 0
    , Rule "lya" "ゃ" 0
    , Rule "ya" "や" 0
    , Rule "wyi" "ゐ" 0
    , Rule "xyu" "ゅ" 0
    , Rule "lyu" "ゅ" 0
    , Rule "yu" "ゆ" 0
    , Rule "wye" "ゑ" 0
    , Rule "xyo" "ょ" 0
    , Rule "lyo" "ょ" 0
    , Rule "yo" "よ" 0
    , Rule "ra" "ら" 0
    , Rule "ri" "り" 0
    , Rule "ru" "る" 0
    , Rule "re" "れ" 0
    , Rule "ro" "ろ" 0
    , Rule "xwa" "ゎ" 0
    , Rule "lwa" "ゎ" 0
    , Rule "wa" "わ" 0
    , Rule "wi" "うぃ" 0
    , Rule "we" "うぇ" 0
    , Rule "wo" "を" 0
    , Rule "wha" "うぁ" 0
    , Rule "whi" "うぃ" 0
    , Rule "whu" "う" 0
    , Rule "whe" "うぇ" 0
    , Rule "who" "うぉ" 0
    , Rule "qqa" "っくぁ" 0
    , Rule "qqi" "っくぃ" 0
    , Rule "qqu" "っく" 0
    , Rule "qqe" "っくぇ" 0
    , Rule "qqo" "っくぉ" 0
    , Rule "vva" "っゔぁ" 0
    , Rule "vvi" "っゔぃ" 0
    , Rule "vvu" "っゔ" 0
    , Rule "vve" "っゔぇ" 0
    , Rule "vvo" "っゔぉ" 0
    , Rule "vvya" "っゔゃ" 0
    , Rule "vvyi" "っゔぃ" 0
    , Rule "vvyu" "っゔゅ" 0
    , Rule "vvye" "っゔぇ" 0
    , Rule "vvyo" "っゔょ" 0
    , Rule "lla" "っぁ" 0
    , Rule "lli" "っぃ" 0
    , Rule "llu" "っぅ" 0
    , Rule "lle" "っぇ" 0
    , Rule "llo" "っぉ" 0
    , Rule "llyi" "っぃ" 0
    , Rule "llye" "っぇ" 0
    , Rule "llka" "っヵ" 0
    , Rule "llke" "っヶ" 0
    , Rule "lltu" "っっ" 0
    , Rule "llya" "っゃ" 0
    , Rule "llyu" "っゅ" 0
    , Rule "llyo" "っょ" 0
    , Rule "llwa" "っゎ" 0
    , Rule "xxn" "っん" 0
    , Rule "xxa" "っぁ" 0
    , Rule "xxi" "っぃ" 0
    , Rule "xxu" "っぅ" 0
    , Rule "xxe" "っぇ" 0
    , Rule "xxo" "っぉ" 0
    , Rule "xxyi" "っぃ" 0
    , Rule "xxye" "っぇ" 0
    , Rule "xxka" "っヵ" 0
    , Rule "xxke" "っヶ" 0
    , Rule "xxtu" "っっ" 0
    , Rule "xxya" "っゃ" 0
    , Rule "xxyu" "っゅ" 0
    , Rule "xxyo" "っょ" 0
    , Rule "xxwa" "っゎ" 0
    , Rule "kkya" "っきゃ" 0
    , Rule "kkyi" "っきぃ" 0
    , Rule "kkyu" "っきゅ" 0
    , Rule "kkye" "っきぇ" 0
    , Rule "kkyo" "っきょ" 0
    , Rule "kka" "っか" 0
    , Rule "kki" "っき" 0
    , Rule "kku" "っく" 0
    , Rule "kke" "っけ" 0
    , Rule "kko" "っこ" 0
    , Rule "kkwa" "っくぁ" 0
    , Rule "ggya" "っぎゃ" 0
    , Rule "ggyi" "っぎぃ" 0
    , Rule "ggyu" "っぎゅ" 0
    , Rule "ggye" "っぎぇ" 0
    , Rule "ggyo" "っぎょ" 0
    , Rule "gga" "っが" 0
    , Rule "ggi" "っぎ" 0
    , Rule "ggu" "っぐ" 0
    , Rule "gge" "っげ" 0
    , Rule "ggo" "っご" 0
    , Rule "ggwa" "っぐぁ" 0
    , Rule "ggwi" "っぐぃ" 0
    , Rule "ggwu" "っぐぅ" 0
    , Rule "ggwe" "っぐぇ" 0
    , Rule "ggwo" "っぐぉ" 0
    , Rule "ssya" "っしゃ" 0
    , Rule "ssyi" "っしぃ" 0
    , Rule "ssyu" "っしゅ" 0
    , Rule "ssye" "っしぇ" 0
    , Rule "ssyo" "っしょ" 0
    , Rule "ssha" "っしゃ" 0
    , Rule "sshi" "っし" 0
    , Rule "sshu" "っしゅ" 0
    , Rule "sshe" "っしぇ" 0
    , Rule "ssho" "っしょ" 0
    , Rule "ssa" "っさ" 0
    , Rule "ssi" "っし" 0
    , Rule "ssu" "っす" 0
    , Rule "sse" "っせ" 0
    , Rule "sso" "っそ" 0
    , Rule "zzya" "っじゃ" 0
    , Rule "zzyi" "っじぃ" 0
    , Rule "zzyu" "っじゅ" 0
    , Rule "zzye" "っじぇ" 0
    , Rule "zzyo" "っじょ" 0
    , Rule "zza" "っざ" 0
    , Rule "zzi" "っじ" 0
    , Rule "zzu" "っず" 0
    , Rule "zze" "っぜ" 0
    , Rule "zzo" "っぞ" 0
    , Rule "jja" "っじゃ" 0
    , Rule "jji" "っじ" 0
    , Rule "jju" "っじゅ" 0
    , Rule "jje" "っじぇ" 0
    , Rule "jjo" "っじょ" 0
    , Rule "jjya" "っじゃ" 0
    , Rule "jjyi" "っじぃ" 0
    , Rule "jjyu" "っじゅ" 0
    , Rule "jjye" "っじぇ" 0
    , Rule "jjyo" "っじょ" 0
    , Rule "ttya" "っちゃ" 0
    , Rule "ttyi" "っちぃ" 0
    , Rule "ttyu" "っちゅ" 0
    , Rule "ttye" "っちぇ" 0
    , Rule "ttyo" "っちょ" 0
    , Rule "ttsa" "っつぁ" 0
    , Rule "ttsi" "っつぃ" 0
    , Rule "ttse" "っつぇ" 0
    , Rule "ttso" "っつぉ" 0
    , Rule "ttha" "ってゃ" 0
    , Rule "tthi" "ってぃ" 0
    , Rule "tthu" "ってゅ" 0
    , Rule "tthe" "ってぇ" 0
    , Rule "ttho" "ってょ" 0
    , Rule "ttwa" "っとぁ" 0
    , Rule "ttwi" "っとぃ" 0
    , Rule "ttwu" "っとぅ" 0
    , Rule "ttwe" "っとぇ" 0
    , Rule "ttwo" "っとぉ" 0
    , Rule "tta" "った" 0
    , Rule "tti" "っち" 0
    , Rule "ttu" "っつ" 0
    , Rule "ttsu" "っつ" 0
    , Rule "tte" "って" 0
    , Rule "tto" "っと" 0
    , Rule "ddya" "っぢゃ" 0
    , Rule "ddyi" "っぢぃ" 0
    , Rule "ddyu" "っぢゅ" 0
    , Rule "ddye" "っぢぇ" 0
    , Rule "ddyo" "っぢょ" 0
    , Rule "ddha" "っでゃ" 0
    , Rule "ddhi" "っでぃ" 0
    , Rule "ddhu" "っでゅ" 0
    , Rule "ddhe" "っでぇ" 0
    , Rule "ddho" "っでょ" 0
    , Rule "ddwa" "っどぁ" 0
    , Rule "ddwi" "っどぃ" 0
    , Rule "ddwu" "っどぅ" 0
    , Rule "ddwe" "っどぇ" 0
    , Rule "ddwo" "っどぉ" 0
    , Rule "dda" "っだ" 0
    , Rule "ddi" "っぢ" 0
    , Rule "ddu" "っづ" 0
    , Rule "dde" "っで" 0
    , Rule "ddo" "っど" 0
    , Rule "hhya" "っひゃ" 0
    , Rule "hhyi" "っひぃ" 0
    , Rule "hhyu" "っひゅ" 0
    , Rule "hhye" "っひぇ" 0
    , Rule "hhyo" "っひょ" 0
    , Rule "hha" "っは" 0
    , Rule "hhi" "っひ" 0
    , Rule "hhu" "っふ" 0
    , Rule "hhe" "っへ" 0
    , Rule "hho" "っほ" 0
    , Rule "ffa" "っふぁ" 0
    , Rule "ffi" "っふぃ" 0
    , Rule "ffe" "っふぇ" 0
    , Rule "ffo" "っふぉ" 0
    , Rule "ffya" "っふゃ" 0
    , Rule "ffyu" "っふゅ" 0
    , Rule "ffyo" "っふょ" 0
    , Rule "ffu" "っふ" 0
    , Rule "bbya" "っびゃ" 0
    , Rule "bbyi" "っびぃ" 0
    , Rule "bbyu" "っびゅ" 0
    , Rule "bbye" "っびぇ" 0
    , Rule "bbyo" "っびょ" 0
    , Rule "bba" "っば" 0
    , Rule "bbi" "っび" 0
    , Rule "bbu" "っぶ" 0
    , Rule "bbe" "っべ" 0
    , Rule "bbo" "っぼ" 0
    , Rule "ppya" "っぴゃ" 0
    , Rule "ppyi" "っぴぃ" 0
    , Rule "ppyu" "っぴゅ" 0
    , Rule "ppye" "っぴぇ" 0
    , Rule "ppyo" "っぴょ" 0
    , Rule "ppa" "っぱ" 0
    , Rule "ppi" "っぴ" 0
    , Rule "ppu" "っぷ" 0
    , Rule "ppe" "っぺ" 0
    , Rule "ppo" "っぽ" 0
    , Rule "mmya" "っみゃ" 0
    , Rule "mmyi" "っみぃ" 0
    , Rule "mmyu" "っみゅ" 0
    , Rule "mmye" "っみぇ" 0
    , Rule "mmyo" "っみょ" 0
    , Rule "mma" "っま" 0
    , Rule "mmi" "っみ" 0
    , Rule "mmu" "っむ" 0
    , Rule "mme" "っめ" 0
    , Rule "mmo" "っも" 0
    , Rule "yye" "っいぇ" 0
    , Rule "yya" "っや" 0
    , Rule "yyu" "っゆ" 0
    , Rule "yyo" "っよ" 0
    , Rule "rrya" "っりゃ" 0
    , Rule "rryi" "っりぃ" 0
    , Rule "rryu" "っりゅ" 0
    , Rule "rrye" "っりぇ" 0
    , Rule "rryo" "っりょ" 0
    , Rule "rra" "っら" 0
    , Rule "rri" "っり" 0
    , Rule "rru" "っる" 0
    , Rule "rre" "っれ" 0
    , Rule "rro" "っろ" 0
    , Rule "wwu" "っう" 0
    , Rule "wwyi" "っゐ" 0
    , Rule "wwye" "っゑ" 0
    , Rule "wwa" "っわ" 0
    , Rule "wwi" "っうぃ" 0
    , Rule "wwe" "っうぇ" 0
    , Rule "wwo" "っを" 0
    , Rule "wwha" "っうぁ" 0
    , Rule "wwhi" "っうぃ" 0
    , Rule "wwhu" "っう" 0
    , Rule "wwhe" "っうぇ" 0
    , Rule "wwho" "っうぉ" 0
    , Rule "ccha" "っちゃ" 0
    , Rule "cchi" "っち" 0
    , Rule "cchu" "っちゅ" 0
    , Rule "cche" "っちぇ" 0
    , Rule "ccho" "っちょ" 0
    , Rule "ccya" "っちゃ" 0
    , Rule "ccyi" "っちぃ" 0
    , Rule "ccyu" "っちゅ" 0
    , Rule "ccye" "っちぇ" 0
    , Rule "ccyo" "っちょ" 0
    , Rule "cca" "っか" 0
    , Rule "cci" "っし" 0
    , Rule "ccu" "っく" 0
    , Rule "cce" "っせ" 0
    , Rule "cco" "っこ" 0
    , Rule "a" "a" 0
    , Rule "b" "b" 0
    , Rule "c" "c" 0
    , Rule "d" "d" 0
    , Rule "e" "e" 0
    , Rule "f" "f" 0
    , Rule "g" "g" 0
    , Rule "h" "h" 0
    , Rule "i" "i" 0
    , Rule "j" "j" 0
    , Rule "k" "k" 0
    , Rule "l" "l" 0
    , Rule "m" "m" 0
    , Rule "n" "n" 0
    , Rule "o" "o" 0
    , Rule "p" "p" 0
    , Rule "q" "q" 0
    , Rule "r" "r" 0
    , Rule "s" "s" 0
    , Rule "t" "t" 0
    , Rule "u" "u" 0
    , Rule "v" "v" 0
    , Rule "w" "w" 0
    , Rule "x" "x" 0
    , Rule "y" "y" 0
    , Rule "z" "z" 0
    , Rule "A" "A" 0
    , Rule "B" "B" 0
    , Rule "C" "C" 0
    , Rule "D" "D" 0
    , Rule "E" "E" 0
    , Rule "F" "F" 0
    , Rule "G" "G" 0
    , Rule "H" "H" 0
    , Rule "I" "I" 0
    , Rule "J" "J" 0
    , Rule "K" "K" 0
    , Rule "L" "L" 0
    , Rule "M" "M" 0
    , Rule "N" "N" 0
    , Rule "O" "O" 0
    , Rule "P" "P" 0
    , Rule "Q" "Q" 0
    , Rule "R" "R" 0
    , Rule "S" "S" 0
    , Rule "T" "T" 0
    , Rule "U" "U" 0
    , Rule "V" "V" 0
    , Rule "W" "W" 0
    , Rule "X" "X" 0
    , Rule "Y" "Y" 0
    , Rule "Z" "Z" 0
    , Rule "0" "0" 0
    , Rule "1" "1" 0
    , Rule "2" "2" 0
    , Rule "3" "3" 0
    , Rule "4" "4" 0
    , Rule "5" "5" 0
    , Rule "6" "6" 0
    , Rule "7" "7" 0
    , Rule "8" "8" 0
    , Rule "9" "9" 0
    , Rule "`" "`" 0
    , Rule "~" "~" 0
    , Rule "!" "!" 0
    , Rule "@" "@" 0
    , Rule "#" "#" 0
    , Rule "$" "$" 0
    , Rule "%" "%" 0
    , Rule "^" "^" 0
    , Rule "&" "&" 0
    , Rule "*" "*" 0
    , Rule "(" "(" 0
    , Rule ")" ")" 0
    , Rule "-" "-" 0
    , Rule "_" "_" 0
    , Rule "=" "=" 0
    , Rule "+" "+" 0
    , Rule "[" "[" 0
    , Rule "]" "]" 0
    , Rule "{" "{" 0
    , Rule "}" "}" 0
    , Rule "\\" "\\" 0
    , Rule "|" "|" 0
    , Rule ";" ";" 0
    , Rule ":" ":" 0
    , Rule "'" "'" 0
    , Rule "\"" "\"" 0
    , Rule "," "," 0
    , Rule "<" "<" 0
    , Rule "." "." 0
    , Rule ">" ">" 0
    , Rule "/" "/" 0
    , Rule "?" "?" 0
    , Rule " " " " 0
    ]


type alias ConvertBuf =
    { inputBuffer : String
    , tmpFixed : Maybe Rule
    , candidates : List Rule
    }


{-| タイピングに利用されるデータです。
-}
type Data
    = Data
        { fixedWords : String
        , restWords : String
        , convertBuf : ConvertBuf
        , state : State
        , history : String
        , rules : List Rule
        }


{-| Dataの状態です。

    getState data

-}
type State
    = Waiting
    | Typing
    | Miss
    | Finish


{-| タイピングすべき文字列とRulesからDataを生成します。
-}
newData : String -> Rules -> Data
newData words rules =
    let
        sf : Rule -> Rule -> Order
        sf a b =
            compare b.priority a.priority
    in
    Data
        { fixedWords = ""
        , restWords = words
        , convertBuf = ConvertBuf "" Nothing (List.sortWith sf rules)
        , state = Waiting
        , history = ""
        , rules = List.sortWith sf rules
        }


{-| 仮確定を確定させ次に進めたデータを返す
-}
nextData : Rule -> Data -> Data
nextData fixedRule (Data data) =
    let
        newFix =
            data.fixedWords ++ fixedRule.output

        newRest =
            String.dropLeft (String.length fixedRule.output) data.restWords
    in
    Data
        { fixedWords = newFix
        , restWords = newRest
        , convertBuf =
            ConvertBuf
                ""
                Nothing
                data.rules
        , state =
            if String.length newRest == 0 then
                Finish

            else
                Typing
        , history = data.history
        , rules = data.rules
        }


{-| Dataの状態を返します。
-}
getState : Data -> State
getState (Data data) =
    data.state


{-| 入力し終わって確定した文字列を返します。
-}
getFixed : Data -> String
getFixed (Data data) =
    data.fixedWords


{-| 入力されていない文字列を返します。
-}
getRest : Data -> String
getRest (Data data) =
    data.restWords


{-| 入力したキーを返します。
-}
getHistory : Data -> String
getHistory (Data data) =
    data.history


{-| Dataに入力をします。
-}
typeTo : String -> Data -> Data
typeTo input (Data data) =
    Data { data | history = data.history ++ input }
        |> typeTo_ input


typeTo_ : String -> Data -> Data
typeTo_ input (Data data) =
    let
        sumInput =
            data.convertBuf.inputBuffer ++ input

        nextCandidates =
            List.filter (\r -> String.startsWith sumInput r.input) data.convertBuf.candidates

        acceptCandidates =
            List.filter (\r -> String.startsWith r.output data.restWords) nextCandidates

        tmpFixed =
            List.filter (\r -> sumInput == r.input) acceptCandidates |> List.head

        nl =
            List.length nextCandidates

        al =
            List.length acceptCandidates
    in
    if nl > 0 && al == 0 then
        -- 候補はあるが、正候補はない。ミス。
        Data { data | state = Miss }

    else if nl == 0 && al == 0 then
        --  候補も正候補もない。
        case data.convertBuf.tmpFixed of
            Nothing ->
                -- 仮確定してるルールもないので受け付けない。ミス。
                Data { data | state = Miss }

            Just tmp ->
                -- 仮確定してるルールはある(主にn)。仮確定を確定させ次に進めてしまう。
                -- 迷う。「ん」に対して「nk」などの動作が変わる。
                -- そのままresを返すと、実入力に近い感じになる。「んk」,fix="ん",rest="",1miss,state=Miss
                -- ミスの場合は巻き戻すような動作にすると、「」,fix="",rest="ん",1miss,state=Miss
                -- 利用側で似たような巻き戻しを行った場合、missまで巻き戻されるので、ミス数やstate=Missは利用側で管理することになる
                -- 追記
                -- missプロパティをこのライブラリで管理することをやめた。それにそのまま返す方式。
                -- そのまま返すか、Missの場合は元のを返すか迷う。
                typeTo_ input (nextData tmp (Data data))

    else if al == 1 then
        case tmpFixed of
            Nothing ->
                Data
                    { data
                        | convertBuf = ConvertBuf sumInput tmpFixed nextCandidates
                        , state = Typing
                    }

            Just tmp ->
                -- 1つに確定。
                nextData tmp (Data data)

    else
        -- 確定したものはあるが、まだ変化する可能性はある。
        Data
            { data
                | convertBuf = ConvertBuf sumInput tmpFixed nextCandidates
                , state = Typing
            }


{-| 表示するローマ字を設定するのに使います。

    Typing.romanTable
        |> Typing.setPriorities
            [ Typing.PrintRule "n" "ん" 3
            , Typing.PrintRule "xn" "ん" 2
            , Typing.PrintRule "nn" "ん" 1
            ]

-}
type alias PrintRule =
    { input : String
    , output : String
    , priority : Int
    }


{-| デフォルトの優先度をルールに適用します。

    defaultPriorities romanTable

-}
defaultPriorities : Rules -> Rules
defaultPriorities rules =
    rules
        |> insertLowPriorities
            [ PrintRule "n" "ん" 3
            , PrintRule "nn" "ん" 2
            , PrintRule "xn" "ん" 1
            ]
        -- chiなど下がる 指定したければsetEfficiencyよりも上に
        |> insertLowPriorities (setEfficiency romanTable)
        |> insertLowPriorities
            (setFavoriteKeys [ "sy", "j", "k", "f", "ty", "si", "se" ]
                romanTable
            )
        -- ty > cy > ch
        |> insertLowPriorities
            (setFavoriteKeys [ "cy" ]
                romanTable
            )
        -- ltu/xtuやla/xaなど
        |> insertLowPriorities
            (setFavoriteStart [ "l" ]
                romanTable
            )


getPriority : Rule -> List PrintRule -> Int
getPriority rule prs =
    case prs of
        [] ->
            rule.priority

        x :: xs ->
            if rule.input == x.input && rule.output == x.output then
                x.priority

            else
                getPriority rule xs


{-| 優先度をRulesにセットします。
-}
setPriorities : List PrintRule -> Rules -> Rules
setPriorities printRules rules =
    List.map
        (\rule ->
            { rule | priority = getPriority rule printRules }
        )
        rules


{-| コスパによる優先度を設定します。

"xtu" "っ" => 1/3=0.33
"xtsu" "っ" => 1/4=0.25

-}
setEfficiency : Rules -> List PrintRule
setEfficiency rules =
    -- 他ので愚直に設定すれば使わなくてもいいかも。
    -- 必要キー数を得るのに使うかも。
    -- それは結構怪しい。
    -- 「うぃるす」をuxirusuと出してしまうので、2桁目の優先度を設定した。
    let
        calcEfficiencyA r =
            toFloat (String.length r.output) / toFloat (String.length r.input)

        efficiencies =
            List.map (\rule -> calcEfficiencyA rule) rules

        max =
            List.maximum efficiencies
                |> Maybe.withDefault 1

        min =
            List.minimum efficiencies
                |> Maybe.withDefault 0

        -- なんとなく00～99の間にしたい
        calcEfficiencyB x =
            ((x - min) / (max - min)) * 90 |> round

        outputLength r =
            clamp 1 9 (String.length r.output)
    in
    List.map2
        (\rule efficiency ->
            { rule | priority = calcEfficiencyB efficiency + outputLength rule }
        )
        rules
        efficiencies


setFavorite : (String -> String -> Bool) -> List String -> Rules -> List PrintRule
setFavorite fun keys rules =
    List.map
        (\rule ->
            { rule
                | priority =
                    if List.any (\k -> fun k rule.input) keys then
                        1

                    else
                        0
            }
        )
        rules


{-| たぶんs/c, j/z, k/c, f/h, t/cと、sy,shのy/hで使います。
-}
setFavoriteKeys : List String -> Rules -> List PrintRule
setFavoriteKeys keys rules =
    setFavorite String.contains keys rules


{-| たぶんx,lから始まるltu,xtuなどの設定に使います。
-}
setFavoriteStart : List String -> Rules -> List PrintRule
setFavoriteStart keys rules =
    setFavorite String.startsWith keys rules


getPower : Int -> Int
getPower max =
    let
        f m p =
            if m < p then
                p

            else if m > 10000000 then
                1

            else
                f m (p * 10)
    in
    f max 10


{-| Rulesに設定されている優先度より低く、新たに優先度を設定します。
-}
insertLowPriorities : List PrintRule -> Rules -> Rules
insertLowPriorities priorities rules =
    let
        ps =
            List.map (\p -> p.priority) priorities

        max =
            List.maximum ps
                |> Maybe.withDefault 1

        power =
            getPower max
    in
    List.map
        (\rule ->
            { rule | priority = rule.priority * power + getPriority rule priorities }
        )
        rules


dropHead : String -> String -> String
dropHead head str =
    if String.startsWith head str then
        String.dropLeft (String.length head) str

    else
        str


makeRomaji_ : Data -> List Rule -> Maybe Data
makeRomaji_ (Data data) candidates =
    case data.state of
        Finish ->
            Just (Data data)

        Miss ->
            Nothing

        _ ->
            case candidates of
                [] ->
                    Nothing

                c :: cs ->
                    let
                        input =
                            dropHead data.convertBuf.inputBuffer c.input

                        (Data nd) =
                            typeTo input (Data data)

                        rest =
                            case nd.convertBuf.tmpFixed of
                                Nothing ->
                                    nd.restWords

                                Just r ->
                                    String.dropLeft (String.length r.output) data.restWords

                        nc =
                            List.filter (\r -> String.startsWith r.output rest) data.rules
                    in
                    case makeRomaji_ (Data nd) nc of
                        Nothing ->
                            makeRomaji_ (Data data) cs

                        Just rd ->
                            Just rd


{-| 入力すべきローマ字を返します。
-}
makeRomaji : Data -> Maybe String
makeRomaji (Data data) =
    let
        candidates =
            List.filter (\r -> String.startsWith r.output data.restWords) data.convertBuf.candidates
    in
    makeRomaji_ (Data { data | history = "" }) candidates
        |> Maybe.map (\fd -> getHistory fd)


{-| 優先度の頭がないかチェックするために使う(手動で目視)。
-}
getSamePriority : Rules -> Rules
getSamePriority rules =
    case rules of
        [] ->
            []

        x :: xs ->
            let
                ( same1, non ) =
                    List.partition (\r -> x.output == r.output) rules

                same2 =
                    List.sortBy .priority same1
                        |> List.reverse
            in
            case same2 of
                [] ->
                    getSamePriority xs

                s :: ss ->
                    let
                        same3 =
                            List.filter (\r -> s.priority == r.priority) ss
                    in
                    if same3 == [] then
                        getSamePriority non

                    else
                        s :: same3 ++ getSamePriority non
