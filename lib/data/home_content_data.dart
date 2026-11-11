import 'package:flutter/material.dart';
import '../models/academy_models.dart';
import '../theme/app_theme.dart';

final List<ScienceCategoryItem> homeSciencesList = [
  const ScienceCategoryItem(
    id: 'tafseer',
    arabicName: 'التفسير',
    kurdishName: 'تەفسیر',
    icon: Icons.menu_book_rounded,
    color: AppColors.teal700,
  ),
  const ScienceCategoryItem(
    id: 'hadith',
    arabicName: 'علوم الحديث',
    kurdishName: 'فەرموودە',
    icon: Icons.history_edu_rounded,
    color: AppColors.blue600,
  ),
  const ScienceCategoryItem(
    id: 'aqeedah',
    arabicName: 'العقيدة',
    kurdishName: 'عەقیدە',
    icon: Icons.verified_user_rounded,
    color: AppColors.amber600,
  ),
  const ScienceCategoryItem(
    id: 'fiqh',
    arabicName: 'الفقه',
    kurdishName: 'فیقهـ',
    icon: Icons.balance_rounded,
    color: AppColors.emerald600,
  ),
  const ScienceCategoryItem(
    id: 'nahw',
    arabicName: 'النحو',
    kurdishName: 'نەحو',
    icon: Icons.edit_note_rounded,
    color: AppColors.purple600,
  ),
  const ScienceCategoryItem(
    id: 'usul_fiqh',
    arabicName: 'أصول الفقه',
    kurdishName: 'ئوسوڵی فیقهـ',
    icon: Icons.account_balance_rounded,
    color: AppColors.indigo600,
  ),
  const ScienceCategoryItem(
    id: 'seerah',
    arabicName: 'السيرة النبوية',
    kurdishName: 'سیرە',
    icon: Icons.mosque_rounded,
    color: AppColors.amber600,
  ),
  const ScienceCategoryItem(
    id: 'sarf',
    arabicName: 'الصرف',
    kurdishName: 'سەرف',
    icon: Icons.translate_rounded,
    color: AppColors.teal600,
  ),
  const ScienceCategoryItem(
    id: 'logic',
    arabicName: 'المنطق',
    kurdishName: 'مەنتیق',
    icon: Icons.psychology_rounded,
    color: AppColors.sky600,
  ),
  const ScienceCategoryItem(
    id: 'balagha',
    arabicName: 'البلاغة',
    kurdishName: 'بەلاغە',
    icon: Icons.auto_awesome_rounded,
    color: AppColors.rose600,
  ),
  const ScienceCategoryItem(
    id: 'quran_sciences',
    arabicName: 'علوم القرآن',
    kurdishName: 'زانستەکانی قورئان',
    icon: Icons.import_contacts_rounded,
    color: AppColors.emerald600,
  ),
  const ScienceCategoryItem(
    id: 'tazkiyah',
    arabicName: 'التزكية',
    kurdishName: 'تەزکیە',
    icon: Icons.spa_rounded,
    color: AppColors.teal800,
  ),
];

class DailyLearningEntry {
  final String id;
  final String badge;
  final String title;
  final String arabicQuote;
  final String kurdishExplanation;
  final String source;

  const DailyLearningEntry({
    required this.id,
    required this.badge,
    required this.title,
    required this.arabicQuote,
    required this.kurdishExplanation,
    required this.source,
  });
}

const List<DailyLearningEntry> dailyLearningEntries = [
  DailyLearningEntry(
    id: 'daily_1',
    badge: 'فەرموودەی پیرۆزی ڕۆژ • پاداشتی زانستخواز',
    title: 'فێربوونی ڕۆژانە',
    arabicQuote:
        '«مَنْ سَلَكَ طَرِيقًا يَلْتَمِسُ فِيهِ عِلْمًا سَهَّلَ اللَّهُ لَهُ بِهِ طَرِيقًا إِلَى الْجَنَّةِ»',
    kurdishExplanation:
        'هەركەسێك بە ڕێگەیەکدا بڕوات بۆ بەدەستهێنانی زانستی شەرعی، خوای گەورە ڕێگەیەکی بەرەو بەهەشت بۆ ئاسان دەکات.',
    source: '(صحيح مسلم)',
  ),
  DailyLearningEntry(
    id: 'daily_2',
    badge: 'پێناسەی زانستە یارمەتیدەرەکان • علوم الآلة',
    title: 'فێربوونی ڕۆژانە: علوم الآلة',
    arabicQuote:
        'علوم الآلة (العلوم المساعدة): علوم اللغة العربية؛ النحو والصرف والبلاغة لفهم النصوص، أصول الفقه ومقاصد الشريعة؛ قواعد استنباط الأحكام، مصطلح الحديث وأصول التفسير؛ قواعد تلقي وقبول الروايات والتفسيرات، وعلوم الحكمة والمنطق.',
    kurdishExplanation:
        'ئەو زانستانەی کە کلیل و ئامرازی تێگەیشتنی دروستن بۆ دەقەکانی قورئان و سوننەت و دەرهێنانی حوکمە شەرعییەکان.',
    source: 'مەنهەجی فێرگەی ڕێبوون',
  ),
  DailyLearningEntry(
    id: 'daily_3',
    badge: 'وتەی زێڕین بۆ فێرخواز • أصول العلم',
    title: 'ئادابی زانستخوازی',
    arabicQuote:
        '«العِلْمُ ثَلَاثَةُ أَشْبَارٍ؛ مَنْ دَخَلَ فِي الشِّبْرِ الأَوَّلِ تَكَبَّرَ، وَمَنْ دَخَلَ فِي الشِّبْرِ الثَّانِي تَوَاضَعَ، وَمَنْ دَخَلَ فِي الشِّبْرِ الثَّالِثِ عَلِمَ أَنَّهُ مَا يَعْلَمُ»',
    kurdishExplanation:
        'زانست سێ بستە: هەرکەس لە بستی یەکەمدا بێت خۆبەزلزان دەبێت، لە بستی دووەمدا خاکەڕا دەبێت، و لە بستی سێیەمدا دەزانێت کە هێشتا نازانێت.',
    source: 'الشعبي رحمه الله',
  ),
];

final List<VideoContentItem> reelsContentList = [
  const VideoContentItem(
    id: 'reel_1',
    title: 'چۆن لە زانستخوازییەوە دەستپێبکەم؟',
    duration: '٠٣:١٥ خولەک',
    speaker: 'م. زمکان حمید',
    desc: 'ڕێنمایی هەنگاو بە هەنگاو بۆ ڕێکخستنی کات و دوورکەوتنەوە لە سەرگەردانی.',
    categoryLabel: 'کورتە ڤیدیۆ',
    isVerticalReel: true,
    colorStart: AppColors.teal800,
    colorEnd: Color(0xFF042F2E),
  ),
  const VideoContentItem(
    id: 'reel_2',
    title: 'نەهێشتنی گومان و دوودڵی لە باوەڕدا',
    duration: '٠٤:٤٠ خولەک',
    speaker: 'د. کمال حسن',
    desc: 'تیشکخستنە سەر گرنگیی خوێندنی عەقیدەی دروست بۆ نەهێشتنی دوودڵی و پاراستن لە شوبهەکان.',
    categoryLabel: 'کورتە ڤیدیۆ',
    isVerticalReel: true,
    colorStart: Color(0xFF92400E),
    colorEnd: Color(0xFF451A03),
  ),
  const VideoContentItem(
    id: 'reel_3',
    title: 'بەرەکەتی کات بۆ فێربوونی زانست',
    duration: '٠٢:٥٠ خولەک',
    speaker: 'م. نافع گرتکی',
    desc: 'چۆن لە ناو سەرقاڵیی ڕۆژانەدا کات بۆ خوێندنی زانست تەرخان بکەین؟',
    categoryLabel: 'کورتە ڤیدیۆ',
    isVerticalReel: true,
    colorStart: Color(0xFF6B21A8),
    colorEnd: Color(0xFF3B0764),
  ),
  const VideoContentItem(
    id: 'reel_4',
    title: 'چۆنێتی وەرگرتنی ئیجازەی سەنەدی متصل',
    duration: '٠٥:١٠ خولەک',
    speaker: 'ئەکادیمیای ڕێبوون',
    desc: 'ناساندنی پرۆسەی عەرزی دەنگی و وەرگرتنی ئیجازەی فەرمی لە فێرگەی ڕێبوون.',
    categoryLabel: 'کورتە ڤیدیۆ',
    isVerticalReel: true,
    colorStart: Color(0xFF1E40AF),
    colorEnd: Color(0xFF172554),
  ),
];

final List<VideoContentItem> webinarsContentList = [
  const VideoContentItem(
    id: 'web_1',
    title: 'کارامەییەکانی قوتابی شەرعی',
    duration: '٢٥:٠٠ خولەک',
    speaker: 'د. کمال حسن',
    desc: 'لێهاتوویی و کارامەییە بنەڕەتییەکان کە هەر فێرخوازێکی زانستی شەرعی پێویستی پێیەتی بۆ سەرکەوتن.',
    categoryLabel: 'وێبینار',
    isVerticalReel: false,
    colorStart: AppColors.amber600,
    colorEnd: AppColors.teal800,
  ),
  const VideoContentItem(
    id: 'web_2',
    title: 'نەخشەی ڕێگای فێربوونی زانستە شەرعییەکان لە سەردەمی دیجیتالدا',
    duration: '٤٥:٠٠ خولەک',
    speaker: 'م. زمکان حمید',
    desc: 'کۆڕی تێروتەسەل بۆ بەکارهێنانی تەکنەلۆژیا لە خزمەت فێربوون، پۆلێنکردنی زانستەکان و ڕێکخستنی کاتەکان.',
    categoryLabel: 'وێبینار',
    isVerticalReel: false,
    colorStart: AppColors.indigo600,
    colorEnd: Color(0xFF1E1B4B),
  ),
  const VideoContentItem(
    id: 'web_3',
    title: 'کاتژمێرێک لەگەڵ عەقیدەی سەلەف و بەرپەرچدانەوەی شوبهە هاوچەرخەکان',
    duration: '٥٢:٣٠ خولەک',
    speaker: 'د. کمال حسن',
    desc: 'وێبیناری شیکاری زانستی بۆ دەستنیشانکردنی بنەماکانی باوەڕ و پاراستنی فێرخوازان لە دەمارگیری.',
    categoryLabel: 'وێبینار',
    isVerticalReel: false,
    colorStart: AppColors.teal700,
    colorEnd: Color(0xFF042F2E),
  ),
  const VideoContentItem(
    id: 'web_4',
    title: 'گرنگی بوونی شێخ و مامۆستا بۆ فێربوونی زانستی شەرعی',
    duration: '٣٢:١٥ خولەک',
    speaker: 'م. نافع گرتکی',
    desc: 'بۆچی وەرگرتنی زانست لە دەمی مامۆستاوە مرۆڤ دەپارێزێت لە هەڵەتێگەیشتن و تێکەڵبوونی مەنهەج؟',
    categoryLabel: 'وێبینار',
    isVerticalReel: false,
    colorStart: AppColors.emerald600,
    colorEnd: Color(0xFF022C22),
  ),
];

final List<GuidanceVideoItem> guidanceVideosList = [
  const GuidanceVideoItem(
    id: 'guid_1',
    title: 'پاراستنی تەندروستی چاو بۆ فێرخوازانی کتێب و مۆبایل',
    specialist: 'دکتۆری پسپۆڕی چاو',
    duration: '١٢:٢٠ خولەک',
    summary:
        'ڕێنمایی پزیشکی تایبەت بە قوتابی زانست بۆ پاراستنی بینایی لە کاتی خوێندنەوەی درێژخایەنی کتێب و شاشەی مۆبایلدا.',
    keyTips: [
      'یاسای ٢٠-٢٠-٢٠: هەر ٢٠ خولەک جارێک بۆ ٢٠ چرکە سەیری دووری بکە.',
      'ڕووناکی ژوورەکە بە شێوەیەکی هاوسەنگ دابنێ و لە تاریکیدا مەخوێنەرەوە.',
      'دووری گونجاوی نێوان چاو و کتێب یان شاشە لانیکەم ٤٠ سانتیمەتر بێت.',
    ],
    icon: Icons.visibility_rounded,
    color: AppColors.sky600,
  ),
  const GuidanceVideoItem(
    id: 'guid_2',
    title: 'پاراستنی بڕبڕەی پشت، مل و شان لە کاتی دانیشتندا',
    specialist: 'دکتۆری پسپۆڕی ئێسک و فەقەرات',
    duration: '١٥:٤٥ خولەک',
    summary:
        'چۆن قوتابی شەرعی لە کاتی وانەخوێندن و سەیرکردنی محازەرەکاندا تووشی ئازاری مل و فەقەرات نەبێت؟',
    keyTips: [
      'بەکارهێنانی ڕەحلە (حامل) یان مێزی گونجاو تا مل بەرزبێت و نەچەمێتەوە.',
      'هەر ٤٥ خولەک جارێک بۆ ٣ خولەک هەستە و جووڵەی سادەی مل و شان بکە.',
      'پشتی کورسی پاڵپشتی کەلەکە و بڕبڕەی خوارەوەی پشت بکات.',
    ],
    icon: Icons.accessibility_new_rounded,
    color: AppColors.emerald600,
  ),
  const GuidanceVideoItem(
    id: 'guid_3',
    title: 'چۆن قوتابی شەرعی پلانێکی زانستی و ڕۆژانە دابنێت؟',
    specialist: 'پسپۆڕی پلاندانان و بەڕێوەبردنی کات',
    duration: '١٨:١٠ خولەک',
    summary:
        'شێوازی دانانی خشتەی هاوسەنگ بۆ خوێندنی مەتنەکان، پێداچوونەوە، و بەردەوامبوون بەبێ پچڕان.',
    keyTips: [
      'باشترین کات بۆ لەبەرکردن و خوێندنی ورد کاتی دوای نوێژی بەیانییە.',
      'لە ڕۆژێکدا بە بڕێکی کەم بەڵام جێگیر (٣٠ خولەک) دەست پێبکە.',
      'هەفتەی یەک ڕۆژ تەنها بۆ پێداچوونەوەی وانەکانی پێشوو تەرخان بکە.',
    ],
    icon: Icons.event_note_rounded,
    color: AppColors.amber600,
  ),
  const GuidanceVideoItem(
    id: 'guid_4',
    title: 'مامەڵەکردن لەگەڵ فشاری دەروونی و بێزارنەبوون لە خوێندن',
    specialist: 'دکتۆری دەروونی و پەروەردەیی',
    duration: '١٤:٣٠ خولەک',
    summary:
        'ڕێکارە دەروونییەکان بۆ فێرخوازان تا چێژ لە فێربوون وەربگرن و تووشی دڵەڕاوکێ و وازهێنان نەبن.',
    keyTips: [
      'بەراوردکردنی خۆت بە پلەی گەورەی زانایان لە سەرەتادا تووشی بێئومێدیت نەکات.',
      'هەر دەستکەوتێکی بچووک لە تەواوکردنی کتێبێک یان ئەڵقەیەک بەرز بنرخێنە.',
      'نوێکردنەوەی نیەت و داوای یارمەتی لە خوای گەورە فشارە دەروونییەکان کەم دەکاتەوە.',
    ],
    icon: Icons.favorite_rounded,
    color: AppColors.rose600,
  ),
];

final List<ArticleContentItem> articlesContentList = [
  const ArticleContentItem(
    id: 'art_daily',
    title: 'بابەتی ڕۆژ: گرنگی و گەورەیی فێربوونی زانستە شەرعییەکان',
    author: 'فێرگەی ڕێبوون',
    badge: '📌 بابەتی ڕۆژ',
    excerpt:
        'زانستی شەرعی تەنها کۆمەڵێک زانیاری زوهدیی نییە، بەڵکو ڕێگەیەکی ڕوون و بەدیارخراوە بۆ ڕێکخستنی ژیانی مرۆڤ و دۆزینەوەی ئارامی دەروونی...',
    fullContent:
        'زانستی شەرعی تەنها کۆمەڵێک زانیاری نییە، بەڵکو ڕێگەیەکی ڕوون و بەدیارخراوە بۆ ڕێکخستنی ژیانی مرۆڤ، دۆزینەوەی ئارامی دەروونی، و گەیاندنی بە ڕەزامەندی پەروەردگار.\n\nخوێندن لێرە پرۆسەیەکی کارلێکەرە کە تێیدا فێرخواز دەبێتە خاوەنی عەقڵێکی شیکاری و دەتوانێت ڕاستی لە باطل جودا بکاتەوە و بەڵگەی صەحیح بناسێت.\n\nسیستەمی "پێشکەوتنی پلەبەپلە" یارمەتی فێرخواز دەدات کە لە بناغەوە دەست پێبکات، ئەمەش ڕێگری دەکات لە دروستبوونی گومان یان لێتێکچوونی بابەتەکان. لە فێرگەی ڕێبوون، ئێمە جەخت لەسەر ئەوە دەکەینەوە کە زانست دەبێت ببێتە هۆی گۆڕینی ڕەوشت، ڕۆحیەت، و ئاوەدانکردنەوەی ژیانی فێرخوازان.',
    color: AppColors.teal700,
  ),
  const ArticleContentItem(
    id: 'art_1',
    title: '١. ئادابی زانستخواز: ئیخلاس و پاکیی نیەت لە دەستپێکدا',
    author: 'م. زمکان حمید',
    badge: 'ئادابی زانست',
    excerpt:
        'زانستی شەرعی پەرستشێکی گەورەیە کە تەنها بە پاکیی نیەت و ئیخلاس بەرەکەتدار دەبێت. فێرخوازی سەرکەوتوو ئەوەیە کە تەنها بۆ ڕەزامەندی پەروەردگار دەخوێنێت...',
    fullContent:
        'زانستی شەرعی پەرستشێکی گەورەیە کە تەنها بە پاکیی نیەت و ئیخلاس بەرەکەتدار دەبێت. فێرخوازی سەرکەوتوو ئەوەیە کە تەنها بۆ ڕەزامەندی پەروەردگار و نەهێشتنی نەزانین لەسەر خۆی دەخوێنێت، نهێنی بەردەوامی لێرەوە دەست پێدەکات.\n\nئیمامی ئەحمەد دەفەرموێت: «العلم لا يعدله شيء لمن صحت نيته»، واتە هیچ شتێک هاوتای زانست نییە بۆ کەسێک کە نیەتەکەی پاک بێت.',
    color: AppColors.teal600,
  ),
  const ArticleContentItem(
    id: 'art_2',
    title: '٢. یاسای بەردەوامی: (قليل دائم خير من كثير منقطع)',
    author: 'د. کمال حسن',
    badge: 'یاسای سەرکەوتن',
    excerpt:
        'گەورەترین نهێنی گەیشتن بە پلەی بەرز لە زانستدا، بەردەوامیی ڕۆژانەیە ئەگەر بە بڕێکی کەمیش بێت. ڕۆژانە ١٥ خولەک گوێگرتن دەبێتە دەیان کتێب...',
    fullContent:
        'گەورەترین نهێنی گەیشتن بە پلەی بەرز لە زانستدا، بەردەوامیی ڕۆژانەیە ئەگەر بە بڕێکی کەمیش بێت. ڕۆژانە ١٥ خولەک گوێگرتن لە وانەیەکی شەرعی لە ماوەی یەک ساڵدا دەکاتە دەیان کتێبی تەواوکراو.\n\nخەڵکانێکی زۆر بە حەماسێکی گەورەوە دەست پێدەکەن و دوای چەند ڕۆژێک دەوەستن؛ بەڵام زانستخوازی هۆشیار هەنگاو بە هەنگاو و ڕۆژانە بەبێ دابڕان بەرەو ئامانجەکەی دەڕوات.',
    color: AppColors.amber600,
  ),
  const ArticleContentItem(
    id: 'art_3',
    title: '٣. بەها و ڕەسەنایەتی سەنەد: بۆچی ئیجازە لە ڕێبوون گرنگە؟',
    author: 'م. نافع گرتکی',
    badge: 'گرنگی سەنەد',
    excerpt:
        'سەنەد پارێزەری ڕەسەنایەتی دینی ئیسلامە. وەرگرتنی زانست لە مامۆستایانی سەنەدداری ئیجازەدار فێرخواز لە شێواندن و لێکدانەوەی هەڵە دەپارێزێت...',
    fullContent:
        'سەنەد پارێزەری ڕەسەنایەتی دینی ئیسلامە. وەرگرتنی زانست لە مامۆستایانی سەنەدداری ئیجازەدار فێرخواز لە شێواندن و لێکدانەوەی هەڵە دەپارێزێت و دەیبەستێتەوە بە زنجیرەی زانایانی پێشین تا پێغەمبەری خوا صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ.\n\nهەروەک عەبدوڵڵای کوڕی موبارەک دەفەرموێت: «الإسناد من الدين، ولولا الإسناد لقال من شاء ما شاء».',
    color: AppColors.purple600,
  ),
  const ArticleContentItem(
    id: 'art_4',
    title: '٤. ئامۆژگاری ئیمامی شافعی بۆ فێرخوازانی زانست',
    author: 'ئەکادیمیای ڕێبوون',
    badge: 'ئامۆژگاری پێشینان',
    excerpt:
        'ئیمامی شافعی دەفەرموێت: (أخي لن تنال العلم إلا بستة... ذكاءٌ وحرصٌ واجتهادٌ وبلغةٌ وصحبةُ أستاذٍ وطولُ زمانٍ). شەش هۆکاری مێژوویی سەرکەوتن...',
    fullContent:
        'ئیمامی شافعی دەفەرموێت:\n«أخي لن تنال العلم إلا بستةٍ — سأنبيك عن تفصيلها ببَيانِ:\nذكاءٌ وحرصٌ واجتهادٌ وبلغةٌ — وصحبةُ أستاذٍ وطولُ زمانِ»\n\nشەش هۆکار هەن بۆ وەرگرتنی زانست: ژیری و تێگەیشتن، پەرۆشی و تامەزرۆیی، تێکۆشان و هەوڵدان، ئامراز و بژێوی گونجاو، هاوڕێیەتی مامۆستای سەنەددار، و درێژخایەنی کات و ئارامگرتن.',
    color: AppColors.blue600,
  ),
];

class OrganizationInfo {
  static const String pageTitle = 'دەربارەی ئێمە';
  static const String orgNameKu = 'ڕێکخراوی ڕێبوون';
  static const String orgSubtitleKu = 'بۆ پەروەردە و ڕاهێنان';
  static const String orgNameAr = 'منظمة ريبوون للتعليم والتدريب';
  static const String orgNameEn = 'Reboon Organization For Education and Training';
  static const String slogan = 'هۆشیاری - نوێگەری - پێگەیاندن - خزمەت';
  static const String definition =
      'دامەزراوەیەکی پەروەردەیی ڕێنموونی کاری چاکسازی سەربەخۆی قازانج نەویستە هەوڵدەدات لەپێناو دروستکردنی کۆمەڵگەیەکی بەختەوەر و هاوچەرخ، بەتایبەت پەرەپێدان بەتوانای گەنجان تا بتوانن ڕۆڵی کارا و کاریگەریان هەبێت لە پێشخستنی کۆمەڵگەکیاندا.';
  static const List<String> workAreas = [
    'گرنگیدان بە پێگەیاندنی گەنجان بەهەردوو ڕەگەزەوە.',
    'بڵاوکردنەوەی هۆشیاری لە بوارە جیاوازەکان.',
    'بەرەوپێشبردنی ئاستی زانستی و ڕۆشنبیری لە ڕێگەی فێرگەی ڕێبوون و خولە ئەکادیمییەکان.',
    'پێگەیاندنی کادری زانستی و پەروەردەیی بە سەنەدی ڕەسەن و مێتۆدی هاوچەرخ.',
  ];
}

class AcademyGoalItem {
  final String title;
  final String desc;
  final IconData icon;
  final Color color;

  const AcademyGoalItem({
    required this.title,
    required this.desc,
    required this.icon,
    required this.color,
  });
}

const List<AcademyGoalItem> academyGoalsList = [
  AcademyGoalItem(
    title: 'خوێندنی سەنەددار',
    desc: 'پشتبەستن بە بەڵگەی صەحیح و سەنەدی بەردەوام تا پێغەمبەری خوا صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ.',
    icon: Icons.school_rounded,
    color: AppColors.teal600,
  ),
  AcademyGoalItem(
    title: 'تێگەیشتنی قووڵ',
    desc: 'دوور لە دەمارگیری و پەرگیری؛ تێگەیشتنی دروست لە دەقە شەرعییەکان بە شێوازی هاوچەرخ.',
    icon: Icons.lightbulb_rounded,
    color: AppColors.amber600,
  ),
  AcademyGoalItem(
    title: 'ئیجازەی فەرمی',
    desc: 'بەخشینی سەنەد و ئیجازەی زانستی بە فێرخوازانی بەتوانا لە ژێر چاودێری مامۆستایان.',
    icon: Icons.verified_rounded,
    color: AppColors.emerald600,
  ),
  AcademyGoalItem(
    title: 'سیستەمی مۆدێرن',
    desc: 'ئاسانکاری تەواو بۆ خوێندن و داگرتنی وانەکان بە شێوازی دەنگی و ڤیدیۆیی ڕاستەوخۆ.',
    icon: Icons.bolt_rounded,
    color: AppColors.sky600,
  ),
];

