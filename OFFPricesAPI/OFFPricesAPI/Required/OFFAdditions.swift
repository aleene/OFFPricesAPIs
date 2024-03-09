//
//  OFFAdditions.swift
//  OFFPrices
//
//  Created by aleene 13/10/2022
//
// This file contains all the additional files related to OpenFoodFacts. These files improve the readability of the code. These files can be used for any other OFF-related project as well. REQUIRED

import Foundation

public struct OFFBarcode {

    /// error strings of OFFBarcode
    public struct Error {
         static let BarcodeLength = "OFFBarcode: Barcode length is not a UPC, EAN8 or EAN13 code"
    }
    
    // the barcode string
    public var barcode: String {
        didSet {
            if !isCorrect {
                print(OFFBarcode.Error.BarcodeLength)
            }
        }
    }
    
    /// does the barcode have an UPC length (12)?
    public var isUPC: Bool { barcode.count == 12 }
    
    /// does the barcode have an EAN-8 length (8)?
    public var isEAN8: Bool { barcode.count == 8 }

    /// does the barcode have an EAN-13 length (13)?
    public var isEAN13: Bool { barcode.count == 13 }

    /// Does the barcode has a correct length (8, 12 or 12 digits)
    public var isCorrect: Bool { isEAN8 || isUPC || isEAN13 }

}

public enum ISO4217: String {
    case tzs = "TZS"
    case ChileanPeso = "CLP"
    case skk = "SKK"
    case kzt = "KZT"
    case nio = "NIO"
    case uzs = "UZS"
    case kyd = "KYD"
    case yur = "YUR"
    case tryy = "TRY"
    case BangladeshiTaka = "BDT"
    case mxp = "MXP"
    case ved = "VED"
// case Testing = "XTS"
    case ydd = "YDD"
    case rub = "RUB"
    case frf = "FRF"
    case hrd = "HRD"
    case uah = "UAH"
    case arp = "ARP"
    case omr = "OMR"
    case mro = "MRO"
    case scr = "SCR"
    case myr = "MYR"
    case lvl = "LVL"
    case BelarusianRuble = "BYN"
    case pei = "PEI"
    case azm = "AZM"
    case vnd = "VND"
    case ilr = "ILR"
    case slw = "SLE"
    case ron = "RON"
    case maf = "MAF"
    case luc = "LUC"
    case WIRFranc = "CHW"
    case tjr = "TJR"
    case AlgerianDinar = "DZD"
    case fkp = "FKP"
    case luf = "LUF"
    case mur = "MUR"
    case mru = "MRU"
    case kro = "KRO"
    case pyg = "PYG"
    case ugs = "UGS"
    case lak = "LAK"
    case zmk = "ZMK"
    case xbc = "XBC"
    case AzerbaijaniManat = "AZN"
    case BurundianFranc = "BIF"
    case xaf = "XAF"
    case hrk = "HRK"
    case std = "STD"
    case ils = "ILS"
    case byb = "BYB"
    case zrz = "ZRZ"
//    case WIREuro = "CHE"
    case pte = "PTE"
    case AngolanKwanza = "AOA"
    case kpw = "KPW"
    case mkn = "MKN"
    case aor = "AOR"
    case usd = "USD"
    case mlf = "MLF"
    case bad = "BAD"
    case mtl = "MTL"
    case xpf = "XPF"
    case mwk = "MWK"
    case thb = "THB"
    case BahamianDollar = "BSD"
    case lrd = "LRD"
    case BruneiDollar = "BND"
    case gek = "GEK"
    case hkd = "HKD"
    case uyp = "UYP"
    case zwr = "ZWR"
    case BosniaNdHerzegovinaConveribleMark = "BAM"
    case cle = "CLE"
    case AfghanAfghani = "AFN"
    case kmf = "KMF"
    case uyw = "UYW"
    case lkr = "LKR"
    case xcd = "XCD"
    case ArmeniaDram = "AMD"
    case tnd = "TND"
    case htg = "HTG"
    case xsu = "XSU"
    case gmd = "GMD"
    case svc = "SVC"
    case tpe = "TPE"
    case bol = "BOL"
    case CostaRicanColon = "CRC"
    case xfu = "XFU"
    case cuc = "CUC"
    case EritreanNakfa = "ERN"
    case mop = "MOP"
    case ats = "ATS"
    case csk = "CSK"
    case zar = "ZAR"
    case cyp = "CYP"
    case rhd = "RHD"
    case csd = "CSD"
    case ves = "VES"
    case ColombianPeso = "COP"
    case mzn = "MZN"
    case twd = "TWD"
    case brr = "BRR"
    case cnh = "CNH"
    case gnf = "GNF"
    case DanishKrone = "DKK"
    case gqe = "GQE"
    case BotswanaPula = "BWP"
    case szl = "SZL"
    case kgs = "KGS"
    case tmm = "TMM"
    case yum = "YUM"
    case nzd = "NZD"
    case uyu = "UYU"
    case kwd = "KWD"
    case bec = "BEC"
    case mvr = "MVR"
    case NetherlandsAntilleanGuilder = "ANG"
    case Euro = "EUR"
    case yun = "YUN"
    case ilp = "ILP"
    case CanadianDollar = "CAD"
    case rsd = "RSD"
    case stm = "STN"
    case mdl = "MDL"
    case huf = "HUF"
//    case Palladium = "XPD"
    case CongoleseFranc = "CDF"
    case sll = "SLL"
    case ugx = "UGX"
    case yer = "YER"
    case CzechKoruna = "CZK"
    case bef = "BEF"
    case pes = "PES"
//    case NoCurrency = "XXX"
    case xbb = "XBB"
    case nad = "NAD"
    case mdc = "MDC"
    case lul = "LUL"
    case ban = "BAN"
    case zal = "ZAL"
    case Boliviano = "BOB"
    case hnl = "HNL"
    case xof = "XOF"
    case itl = "ITL"
    case ArgentinePeso = "ARS"
    case BarbadosDollar = "BBD"
    case bre = "BRE"
    case qar = "QAR"
    case inr = "INR"
    case xba = "XBA"
    case isk = "ISK"
    case lyd = "LYD"
    case gbp = "GBP"
    case BhutaneseNgultrum = "BTN"
    case nok = "NOK"
    case adp = "ADP"
    case aon = "AON"
    case AustralianDollar = "AUD"
    case Renminbi = "CNY"
    case gel = "GEL"
    case pgk = "PGK"
    case ghs = "GHS"
    case zrn = "ZRN"
    case lvr = "LVR"
//    case Gold = "XAU"
    case idr = "IDR"
    case AlbianLek = "ALL"
    case mad = "MAD"
    case sbd = "SBD"
    case bgo = "BGO"
    case ecv = "ECV"
    case arm = "ARM"
    case arl = "ARL"
    case npr = "NPR"
//    case Silver = "XAG"
    case gwe = "GWE"
    case syp = "SYP"
    case pen = "PEN"
    case brb = "BRB"
    case byr = "BYR"
    case rur = "RUR"
    case php = "PHP"
    case jpy = "JPY"
    case yud = "YUD"
    case sdg = "SDG"
    case sar = "SAR"
    case pab = "PAB"
    case mcf = "MCF"
    case pkr = "PKR"
    case mvp = "MVP"
    case xbd = "XBD"
//    case BolivianMvdol = "BOV"
    case DominicanPeso = "DOP"
    case nic = "NIC"
    case usn = "USN"
    case fjd = "FJD"
    case kes = "KES"
    case DjiboutianFranc = "DJF"
    case gtq = "GTQ"
    case tmt = "TMT"
    case cnx = "CNX"
    case jod = "JOD"
    case vef = "VEF"
//    case UnidadDeValorReal = "COU"
    case BermudianDOllar = "BMD"
    case mnt = "MNT"
    case mxv = "MXV"
    case vuv = "VUV"
    case bgm = "BGM"
    case gns = "GNS"
    case khr = "KHR"
    case mmk = "MMK"
//    case Platinum = "XPT"
    case brz = "BRZ"
    case ttd = "TTD"
    case gip = "GIP"
    case lsl = "LSL"
    case jmd = "JMD"
    case ecs = "ECS"
//   case EuropeanCurrencyUnit = "XEU"
    case bgl = "BGL"
    case wst = "WST"
    case BelizianDollar = "BZD"
    case xdr = "XDR"
    case zwd = "ZWD"
    case xfo = "XFO"
    case uak = "UAK"
    case tjs = "TJS"
    case ghc = "GHC"
    case SwissFranc = "CHF"
    case sfs = "AFA"
    case mxn = "MXN"
    case srd = "SRD"
    case veb = "VEB"
    case bel = "BEL"
    case ngk = "NLG"
    case eek = "EEK"
    case irr = "IRR"
    case gwp = "GWP"
    case dem = "DEM"
    case ArubanFlorin = "AWG"
    case mga = "MGA"
    case rwf = "RWF"
    case xua = "XUA"
    case EthiopianBirr = "ETB"
    case esp = "ESP"
    case krh = "KRH"
    case lbp = "LBP"
    case esb = "ESB"
    case CubanPeso = "CUP"
    case srg = "SRG"
    case mgf = "MGF"
    case ngn = "NGN"
    case ltl = "LTL"
    case sit = "SIT"
    case rol = "ROL"
    case aok = "AOK"
    case BrazilianReal = "BRL"
    case sgd = "SGD"
    case isj = "ISJ"
    case gyd = "GYD"
    case brc = "BRC"
    case BahrainiDinar = "BHD"
    case EgyptianPound = "EGP"
    case iqd = "IQD"
    case vnn = "VNN"
    case mzm = "MZM"
    case plz = "PLZ"
    case ssp = "SSP"
    case BulgarianLev = "BGN"
    case ltt = "LTT"
    case xre = "XRE"
    case shp = "SHP"
    case krw = "KRW"
    case grd = "GRD"
    case sdd = "SDD"
    case trl = "TRL"
    case sos = "SOS"
    case brn = "BRN"
    case sdp = "SDP"
    case CapeVerdeanEscudo = "CVE"
    case iep = "IEP"
//    case UndidadDeFomento = "CLF"
    case mtp = "MTP"
    case mze = "MZE"
    case sek = "SEK"
    case top = "TOP"
    case sur = "SUR"
    case fim = "FIM"
    case zmw = "ZMW"
    case uyi = "UYI"
    case mkd = "MKD"
    case ddm = "DDM"
    case uss = "USS"
    case alk = "ALK"
    case pln = "PLN"
    case zwl = "ZWL"
    case buk = "BUK"
    case ara = "ARA"
    case UnitedArabEmiratesDirham = "AED"
    case esa = "ESA"
    case bop = "BOP"
}

/// Enumeration of the ISO 639-1 languages and codes as raw values
public enum ISO693_1: String {
    case abkhazian = "ab"
    case afar = "aa"
    case afrikaans = "af"
    case akan = "ak"
    case albanian = "sq"
    case amharic = "am"
    case arabic = "ar"
    case aragonese = "an"
    case armenian = "hy"
    case assamese = "as"
    case avaric = "av"
    case avestan = "ae"
    case aymara = "ay"
    case azerbaijani = "az"
    case bambara = "bm"
    case bashkir = "ba"
    case basque = "eu"
    case belarusian = "be"
    case bengali = "bn"
    case bislama = "bi"
    case bosnian = "bs"
    case breton = "br"
    case bulgarian = "bg"
    case burmese = "my"
    case catalan = "ca"
    case chamorro = "ch"
    case chechen = "ce"
    case chichewa = "ny"
    case chinese = "zh"
    case churchSlavonic = "cu"
    case chuvash = "cv"
    case cornish = "kw"
    case corsican = "co"
    case cree = "cr"
    case croatian = "hr"
    case czech = "cs"
    case danish = "da"
    case divehi = "dv"
    case dutch = "nl"
    case dzongkha = "dz"
    case english = "en"
    case esperanto = "eo"
    case estonian = "et"
    case ewe = "ee"
    case faroese = "fo"
    case fijian = "fj"
    case finnish = "fi"
    case french = "fr"
    case westernFrisian = "fy"
    case fulah = "ff"
    case gaelic = "gd"
    case galician = "gl"
    case ganda = "lg"
    case georgian = "ka"
    case german = "de"
    case greek = "el"
    case kalaallisut = "kl"
    case guarani = "gn"
    case gujarati = "gu"
    case haitian = "ht"
    case hausa = "ha"
    case hebrew = "he"
    case herero = "hz"
    case hindi = "hi"
    case hiriMotu = "ho"
    case hungarian = "hu"
    case icelandic = "is"
    case ido = "io"
    case igbo = "ig"
    case indonesian = "id"
    case interlingua = "ia"
    case interlingue = "ie"
    case inuktitut = "iu"
    case inupiaq = "ik"
    case irish = "ga"
    case italian = "it"
    case japanese = "ja"
    case javanese = "jv"
    case kannada = "kn"
    case kanuri = "kr"
    case kashmiri = "ks"
    case kazakh = "kk"
    case centralKhmer = "km"
    case kikuyu = "ki"
    case kinyarwanda = "rw"
    case kirghiz = "ky"
    case komi = "kv"
    case kongo = "kg"
    case korean = "ko"
    case kuanyama = "kj"
    case kurdish = "ku"
    case lao = "lo"
    case latin = "la"
    case latvian = "lv"
    case limburgan = "li"
    case lingala = "ln"
    case lithuanian = "lt"
    case lubaKatanga = "lu"
    case luxembourgish = "lb"
    case macedonian = "mk"
    case malagasy = "mg"
    case malay = "ms"
    case malayalam = "ml"
    case maltese = "mt"
    case manx = "gv"
    case maori = "mi"
    case marathi = "mr"
    case marshallese = "mh"
    case mongolian = "mn"
    case nauru = "na"
    case navajo = "nv"
    case northNdebele = "nd"
    case southNdebele = "nr"
    case ndonga = "ng"
    case nepali = "ne"
    case norwegian = "no"
    case norwegianBokmål = "nb"
    case norwegianNynorsk = "nn"
    case sichuanYi = "ii"
    case occitan = "oc"
    case ojibwa = "oj"
    case oriya = "or"
    case oromo = "om"
    case ossetian = "os"
    case pali = "pi"
    case pashto = "ps"
    case persian = "fa"
    case polish = "pl"
    case portuguese = "pt"
    case punjabi = "pa"
    case quechua = "qu"
    case romanian  = "ro"
    case romansh = "rm"
    case rundi = "rn"
    case russian = "ru"
    case northernSami = "se"
    case samoan = "sm"
    case sango = "sg"
    case sanskrit = "sa"
    case sardinian = "sc"
    case serbian = "sr"
    case shona = "sn"
    case sindhi = "sd"
    case sinhala = "si"
    case slovak = "sk"
    case slovenian = "sl"
    case somali = "so"
    case southernSotho = "st"
    case spanish = "es"
    case sundanese = "su"
    case swahili = "sw"
    case swati = "ss"
    case swedish = "sv"
    case tagalog = "tl"
    case tahitian = "ty"
    case tajik = "tg"
    case tamil = "ta"
    case tatar = "tt"
    case telugu = "te"
    case thai = "th"
    case tibetan = "bo"
    case tigrinya = "ti"
    case tonga = "to"
    case tsonga = "ts"
    case tswana = "tn"
    case turkish = "tr"
    case turkmen = "tk"
    case twi = "tw"
    case uighur = "ug"
    case ukrainian = "uk"
    case urdu = "ur"
    case uzbek = "uz"
    case venda = "ve"
    case vietnamese = "vi"
    case volapük = "vo"
    case walloon = "wa"
    case welsh = "cy"
    case wolof = "wo"
    case xhosa = "xh"
    case yiddish = "yi"
    case yoruba = "yo"
    case zhuang = "za"
    case zulu = "zu"
    
    /// The ISO language name string. Note that there might exist alternative spellings
    var description: String {
        switch self {
        case .abkhazian: return "abkhazian"
        case .afar: return "afar"
        case .afrikaans: return "afrikaans"
        case .akan: return "akan"
        case .albanian: return "albanian"
        case .amharic: return "amharic"
        case .arabic: return "arabic"
        case .aragonese: return "aragonese"
        case .armenian: return "armenian"
        case .assamese: return "assamese"
        case .avaric: return "avaric"
        case .avestan: return "avestan"
        case .aymara: return "aymara"
        case .azerbaijani: return "azerbaijani"
        case .bambara: return "bambara"
        case .bashkir: return "bashkir"
        case .basque: return "basque"
        case .belarusian: return "belarusian"
        case .bengali: return "bengali"
        case .bislama: return "bislama"
        case .bosnian: return "bosnian"
        case .breton: return "breton"
        case .bulgarian: return "bulgarian"
        case .burmese: return "burmese"
        case .catalan: return "catalan"
        case .chamorro: return "chamorro"
        case .chechen: return "chechen"
        case .chichewa: return "chichewa"
        case .chinese: return "chinese"
        case .churchSlavonic: return "church slavonic"
        case .chuvash: return "chuvash"
        case .cornish: return "cornish"
        case .corsican: return "corsican"
        case .cree: return "cree"
        case .croatian: return "croatian"
        case .czech: return "czech"
        case .danish: return "danish"
        case .divehi: return "divehi"
        case .dutch: return "dutch"
        case .dzongkha: return "dzongkha"
        case .english: return "english"
        case .esperanto: return "esperanto"
        case .estonian: return "estonian"
        case .ewe: return "ewe"
        case .faroese: return "faroese"
        case .fijian: return "fijian"
        case .finnish: return "finnish"
        case .french: return "french"
        case .westernFrisian: return "western frisian"
        case .fulah: return "fulah"
        case .gaelic: return "gaelic"
        case .galician: return "galician"
        case .ganda: return "ganda"
        case .georgian: return "georgian"
        case .german: return "german"
        case .greek: return "greek"
        case .kalaallisut: return "kalaallisut"
        case .guarani: return "guarani"
        case .gujarati: return "gujarati"
        case .haitian: return "haitian"
        case .hausa: return "hausa"
        case .hebrew: return "hebrew"
        case .herero: return "herero"
        case .hindi: return "hindi"
        case .hiriMotu: return "hiri motu"
        case .hungarian: return "hungarian"
        case .icelandic: return "icelandic"
        case .ido: return "ido"
        case .igbo: return "igbo"
        case .indonesian: return "indonesian"
        case .interlingua: return "interlingua"
        case .interlingue: return "interlingue"
        case .inuktitut: return "inuktitut"
        case .inupiaq: return "inupiaq"
        case .irish: return "irish"
        case .italian: return "italian"
        case .japanese: return "japanese"
        case .javanese: return "javanese"
        case .kannada: return "kannada"
        case .kanuri: return "kanuri"
        case .kashmiri: return "kanuri"
        case .kazakh: return "kazakh"
        case .centralKhmer: return "central khmer"
        case .kikuyu: return "kikuyu"
        case .kinyarwanda: return "kinyarwandav"
        case .kirghiz: return "kirghiz"
        case .komi: return "komi"
        case .kongo: return "kongo"
        case .korean: return "korean"
        case .kuanyama: return "kuanyama"
        case .kurdish: return "kurdish"
        case .lao: return "lao"
        case .latin: return "latin"
        case .latvian: return "latvian"
        case .limburgan: return "limburgan"
        case .lingala: return "lingala"
        case .lithuanian: return "lithuanian"
        case .lubaKatanga: return "luba-katanga"
        case .luxembourgish: return "luxembourgish"
        case .macedonian: return "macedonian"
        case .malagasy: return "malagasy"
        case .malay: return "malay"
        case .malayalam: return "malayalam"
        case .maltese: return "maltese"
        case .manx: return "manx"
        case .maori: return "maori"
        case .marathi: return "marathi"
        case .marshallese: return "marshallese"
        case .mongolian: return "mongolian"
        case .nauru: return "nauru"
        case .navajo: return "navajo"
        case .northNdebele: return "north ndebele"
        case .southNdebele: return "south ndebele"
        case .ndonga: return "ndonga"
        case .nepali: return "nepali"
        case .norwegian: return "norwegian"
        case .norwegianBokmål: return "norwegian bokmål"
        case .norwegianNynorsk: return "norwegian nynorsk"
        case .sichuanYi: return "sichuan yi"
        case .occitan: return "occitan"
        case .ojibwa: return "ojibwa"
        case .oriya: return "oriya"
        case .oromo: return "oromo"
        case .ossetian: return "ossetian"
        case .pali: return "pali"
        case .pashto: return "pashto"
        case .persian: return "persian"
        case .polish: return "polish"
        case .portuguese: return "portuguese"
        case .punjabi: return "punjabi"
        case .quechua: return "quechua"
        case .romanian : return "romanian"
        case .romansh: return "romansh"
        case .rundi: return "rundi"
        case .russian: return "russian"
        case .northernSami: return "northern sami"
        case .samoan: return "samoan"
        case .sango: return "sango"
        case .sanskrit: return "sanskrit"
        case .sardinian: return "sardinian"
        case .serbian: return "serbian"
        case .shona: return "shona"
        case .sindhi: return "sindhi"
        case .sinhala: return "sinhala"
        case .slovak: return "slovak"
        case .slovenian: return "slovenian"
        case .somali: return "somali"
        case .southernSotho: return "southern sotho"
        case .spanish: return "spanish"
        case .sundanese: return "sundanese"
        case .swahili: return "swahili"
        case .swati: return "swati"
        case .swedish: return "swedish"
        case .tagalog: return "tagalog"
        case .tahitian: return "tahitian"
        case .tajik: return "tajik"
        case .tamil: return "tamil"
        case .tatar: return "tatar"
        case .telugu: return "telugu"
        case .thai: return "thai"
        case .tibetan: return "tibetan"
        case .tigrinya: return "tigrinya"
        case .tonga: return "tonga"
        case .tsonga: return "tsonga"
        case .tswana: return "tswana"
        case .turkish: return "turkish"
        case .turkmen: return "turkmen"
        case .twi: return "twi"
        case .uighur: return "uighur"
        case .ukrainian: return "ukrainian"
        case .urdu: return "urdu"
        case .uzbek: return "uzbek"
        case .venda: return "venda"
        case .vietnamese: return "vietnamese"
        case .volapük: return "volapük"
        case .walloon: return "walloon"
        case .welsh: return "welsh"
        case .wolof: return "wolof"
        case .xhosa: return "xhosa"
        case .yiddish: return "yiddish"
        case .yoruba: return "yoruba"
        case .zhuang: return "zhuang"
        case .zulu: return "zulu"
        }
    }

}

/// The ISO country and region names
public enum Country: String {
    case france
    case unitedKingdom
    case netherlands
    
    var key: String {
        switch self {
        case .france: return "en:france"
        case .unitedKingdom: return "en:united-kingdom"
        case .netherlands: return "en:netherlands"
        }
    }
    
}
/**
An enumerator type describing all possible OpenFoodFacts product types that are supported
 
Values:
    - food - for food products
    - petFood - for petfood products
    - beauty - for beauty products
    - product - for any other product (not food, petfood, beauty)
*/
public enum OFFProductType: String {
    case food
    case petFood
    case beauty
    case product
    
    /// A a human readable description of the current value for Product Type.
    var description: String {
        switch self {
        case .food:
            return "Food product"
        case .petFood:
            return "Petfood product"
        case .beauty:
            return "Beauty product"
        case .product:
            return "General product"
        }
    }
    
}
