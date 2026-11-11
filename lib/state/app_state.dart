import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/academy_models.dart';
import '../data/courses_data.dart';
import '../data/library_teachers_data.dart';
import '../data/home_content_data.dart';

class AppState extends ChangeNotifier {
  // Bottom Nav: 0=Sanad, 1=Academy, 2=Home(Center), 3=Favorites, 4=Account
  int currentTabIndex = 2;
  // Academy track: 'general' or 'specific'
  String academyTrack = 'general';

  // Appearance & Settings
  bool isDarkMode = false;
  double fontSize = 16.0;
  String fontFamily = 'NotoSansArabic';

  // Notifications Settings
  bool pushNotifications = true;
  bool emailNotifications = false;
  bool dailyReminder = true;

  // Learning Settings
  int dailyGoalMinutes = 30;
  bool offlineDownloadsEnabled = false;
  final List<OfflineLesson> offlineLessons = [
    const OfflineLesson(id: 1, name: 'عەقیدە - وانەی ١', size: '12 MB', icon: '📖'),
    const OfflineLesson(id: 2, name: 'فیقهـ - مەرجەکانی نوێژ', size: '18 MB', icon: '📗'),
    const OfflineLesson(id: 3, name: 'نەحو - ئاجوڕومییە', size: '15 MB', icon: '📘'),
  ];

  // Auth & User Profile
  bool isLoggedIn = false;
  String firstName = 'محەمەد';
  String middleName = '';
  String lastName = 'ڕێبوونی';
  String username = 'm.reboon';
  String email = 'm.reboon@example.com';
  String password = '123456';

  // Lesson Progress & Level Locks
  final Map<String, Set<int>> lessonProgress = {};
  final Map<int, bool> completedLevels = {
    1: false,
    2: false,
    3: false,
    4: false,
    5: false,
  };

  // Sanad Listening Progress
  final Map<String, Set<int>> sanadListenedLessons = {};

  // Favorites (Voice 2: وانە دڵخوازەکان)
  final Set<String> favoriteKeys = {
    'course:اصول الثالثة',
    'video:reel_1',
  };

  // Notifications List
  final List<AppNotification> notifications = [
    AppNotification(
      id: 1,
      title: 'وانەی نوێ دانرا',
      text: 'وانەی (مەرجەکانی نوێژ) لە بەشی فیقهـ بەردەستە بۆ سەیرکردن.',
      time: '٢ کاتژمێر لەمەوپێش',
      read: false,
      icon: '▶️',
    ),
    AppNotification(
      id: 2,
      title: 'تاقیکردنەوەی مانگانە',
      text: 'ئاگاداربە، تاقیکردنەوەی عەقیدە سبەینێ کاتژمێر ٩ی شەو دەست پێدەکات.',
      time: 'دوێنێ',
      read: true,
      icon: '📝',
    ),
    AppNotification(
      id: 3,
      title: 'ئیجازەی زانستی',
      text: 'پیرۆزە! ئیجازەی (الآجرومية) پەسەند کرا لەلایەن مامۆستاوە.',
      time: '٣ ڕۆژ لەمەوپێش',
      read: true,
      icon: '📜',
    ),
  ];

  // Teacher Chat Histories
  final Map<int, List<TeacherChatMessage>> teacherChats = {};

  // Live Stream Messages
  final List<Map<String, String>> liveChatMessages = [
    {'name': 'ئەحمەد عەلی', 'msg': 'سڵاو لە مامۆستای بەڕێز، جزاکم الله خیراً'},
    {'name': 'سۆران هەولێری', 'msg': 'دەنگی لایڤەکە زۆر ڕوونە و دەستتان خۆش بێت'},
  ];

  Timer? _simTimer;
  SharedPreferences? _prefs;

  Future<void> init({bool startSimulationTimer = true}) async {
    _prefs = await SharedPreferences.getInstance();
    isDarkMode = _prefs?.getBool('isDarkMode') ?? false;
    fontSize = _prefs?.getDouble('fontSize') ?? 16.0;
    fontFamily = _prefs?.getString('fontFamily') ?? 'NotoSansArabic';
    pushNotifications = _prefs?.getBool('pushNotif') ?? true;
    emailNotifications = _prefs?.getBool('emailNotif') ?? false;
    dailyReminder = _prefs?.getBool('dailyReminder') ?? true;
    dailyGoalMinutes = _prefs?.getInt('dailyGoalMinutes') ?? 30;
    offlineDownloadsEnabled = _prefs?.getBool('offlineEnabled') ?? false;
    isLoggedIn = _prefs?.getBool('isLoggedIn') ?? false;
    firstName = _prefs?.getString('firstName') ?? 'محەمەد';
    middleName = _prefs?.getString('middleName') ?? '';
    lastName = _prefs?.getString('lastName') ?? 'ڕێبوونی';
    username = _prefs?.getString('username') ?? 'm.reboon';
    email = _prefs?.getString('email') ?? 'm.reboon@example.com';

    final savedFavs = _prefs?.getStringList('favoriteKeys');
    if (savedFavs != null) {
      favoriteKeys
        ..clear()
        ..addAll(savedFavs);
    }

    for (int i = 1; i <= 5; i++) {
      completedLevels[i] = _prefs?.getBool('levelDone_$i') ?? false;
    }

    notifyListeners();

    // Simulate incoming live notification once after 6 seconds (like HTML)
    if (startSimulationTimer) {
      _simTimer = Timer(const Duration(seconds: 6), () {
        if (!notifications.any((n) => n.id == 999)) {
          notifications.insert(
            0,
            AppNotification(
              id: 999,
              title: 'وانەی نوێ دابەزی!',
              text: 'وانەی ٤: حوکمەکانی دەستنوێژ بەردەستە ئێستا. سەردانی ئەکادیمیا بکە.',
              time: 'هەر ئێستا',
              read: false,
              icon: '🆕',
            ),
          );
          notifyListeners();
        }
      });
    }
  }

  @override
  void dispose() {
    _simTimer?.cancel();
    super.dispose();
  }

  void setTabIndex(int index) {
    currentTabIndex = index;
    notifyListeners();
  }

  void setAcademyTrack(String track) {
    academyTrack = track;
    notifyListeners();
  }

  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
    _prefs?.setBool('isDarkMode', isDarkMode);
    notifyListeners();
  }

  void setFontSize(double size) {
    fontSize = size.clamp(14.0, 24.0);
    _prefs?.setDouble('fontSize', fontSize);
    notifyListeners();
  }

  void setFontFamily(String family) {
    fontFamily = family;
    _prefs?.setString('fontFamily', family);
    notifyListeners();
  }

  void setPushNotifications(bool val) {
    pushNotifications = val;
    _prefs?.setBool('pushNotif', val);
    notifyListeners();
  }

  void setEmailNotifications(bool val) {
    emailNotifications = val;
    _prefs?.setBool('emailNotif', val);
    notifyListeners();
  }

  void setDailyReminder(bool val) {
    dailyReminder = val;
    _prefs?.setBool('dailyReminder', val);
    notifyListeners();
  }

  void setDailyGoalMinutes(int mins) {
    dailyGoalMinutes = mins;
    _prefs?.setInt('dailyGoalMinutes', mins);
    notifyListeners();
  }

  void setOfflineEnabled(bool val) {
    offlineDownloadsEnabled = val;
    _prefs?.setBool('offlineEnabled', val);
    notifyListeners();
  }

  void removeOfflineLesson(int id) {
    offlineLessons.removeWhere((l) => l.id == id);
    notifyListeners();
  }

  // Auth helpers
  String get fullName {
    return [firstName, middleName, lastName]
        .where((e) => e.trim().isNotEmpty)
        .join(' ');
  }

  String get initials {
    final f = firstName.trim().isNotEmpty ? firstName.trim()[0] : 'ف';
    final l = lastName.trim().isNotEmpty ? lastName.trim()[0] : 'ڕ';
    return '$f.$l';
  }

  void signIn({required String emailInput, String? nameOverride}) {
    isLoggedIn = true;
    if (emailInput.isNotEmpty) email = emailInput;
    if (nameOverride != null && nameOverride.trim().isNotEmpty) {
      final parts = nameOverride.trim().split(RegExp(r'\s+'));
      firstName = parts.first;
      middleName = parts.length > 2 ? parts[1] : '';
      lastName = parts.length > 1 ? parts.last : '';
    } else if (firstName.isEmpty) {
      firstName = 'محەمەد';
      lastName = 'ڕێبوونی';
    }
    _saveProfileToPrefs();
    notifyListeners();
  }

  void signUp({
    required String nameInput,
    required String usernameInput,
    required String emailInput,
    required String passwordInput,
  }) {
    final parts = nameInput.trim().split(RegExp(r'\s+'));
    firstName = parts.isNotEmpty ? parts[0] : 'فێرخواز';
    middleName = parts.length > 2 ? parts[1] : '';
    lastName = parts.length > 1 ? parts.last : '';
    username = usernameInput;
    email = emailInput;
    password = passwordInput;
    isLoggedIn = true;
    _saveProfileToPrefs();
    notifyListeners();
  }

  void updateProfile({
    required String first,
    required String middle,
    required String last,
    required String user,
  }) {
    firstName = first;
    middleName = middle;
    lastName = last;
    if (user.isNotEmpty) username = user;
    _saveProfileToPrefs();
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    email = newEmail;
    _saveProfileToPrefs();
    notifyListeners();
  }

  void updatePassword(String newPassword) {
    password = newPassword;
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    _prefs?.setBool('isLoggedIn', false);
    notifyListeners();
  }

  void deleteAccount() {
    firstName = '';
    middleName = '';
    lastName = '';
    username = '';
    email = '';
    password = '';
    isLoggedIn = false;
    _saveProfileToPrefs();
    notifyListeners();
  }

  void _saveProfileToPrefs() {
    _prefs?.setBool('isLoggedIn', isLoggedIn);
    _prefs?.setString('firstName', firstName);
    _prefs?.setString('middleName', middleName);
    _prefs?.setString('lastName', lastName);
    _prefs?.setString('username', username);
    _prefs?.setString('email', email);
  }

  // Notifications
  int get unreadNotificationsCount =>
      notifications.where((n) => !n.read).length;

  void markNotificationRead(int id) {
    for (final n in notifications) {
      if (n.id == id) n.read = true;
    }
    notifyListeners();
  }

  void markAllNotificationsRead() {
    for (final n in notifications) {
      n.read = true;
    }
    notifyListeners();
  }

  // Course Episode Progress & Level Unlocking
  Set<int> getCompletedEpisodes(String courseKey) {
    return lessonProgress[courseKey] ?? const {};
  }

  void toggleEpisodeDone(String courseKey, int episodeId) {
    final set = lessonProgress.putIfAbsent(courseKey, () => <int>{});
    if (set.contains(episodeId)) {
      set.remove(episodeId);
    } else {
      set.add(episodeId);
    }
    _recheckLevelCompletion();
    notifyListeners();
  }

  void _recheckLevelCompletion() {
    for (final level in generalLevelsData) {
      final allDone = level.courses.every((c) {
        final set = lessonProgress[c.courseKey];
        return set != null && set.length >= 3;
      });
      if (allDone) {
        completedLevels[level.levelNumber] = true;
        _prefs?.setBool('levelDone_${level.levelNumber}', true);
      }
    }
  }

  void markLevelQuizPassed(int levelNum) {
    completedLevels[levelNum] = true;
    _prefs?.setBool('levelDone_$levelNum', true);
    notifyListeners();
  }

  bool isLevelUnlocked(int levelNum) {
    if (levelNum <= 1) return true;
    return completedLevels[levelNum - 1] ?? false;
  }

  int get completedLessonsTotalCount {
    int count = 12; // baseline from HTML quick stats
    for (final set in lessonProgress.values) {
      count += set.length;
    }
    return count;
  }

  // Sanad Listening
  Set<int> getSanadListened(String sanadKey) {
    return sanadListenedLessons[sanadKey] ?? const {};
  }

  void toggleSanadLesson(String sanadKey, int id) {
    final set = sanadListenedLessons.putIfAbsent(sanadKey, () => <int>{});
    if (set.contains(id)) {
      set.remove(id);
    } else {
      set.add(id);
    }
    notifyListeners();
  }

  // Favorites
  bool isFavorite(String key) => favoriteKeys.contains(key);

  void toggleFavorite(String key) {
    if (favoriteKeys.contains(key)) {
      favoriteKeys.remove(key);
    } else {
      favoriteKeys.add(key);
    }
    _prefs?.setStringList('favoriteKeys', favoriteKeys.toList());
    notifyListeners();
  }

  List<FavoriteEntry> get resolvedFavorites {
    final List<FavoriteEntry> result = [];
    for (final key in favoriteKeys) {
      if (key.startsWith('course:')) {
        final cKey = key.substring(7);
        final c = getCourseDetail(cKey);
        result.add(FavoriteEntry(
          key: key,
          type: 'course',
          title: c.title,
          subtitle: c.instructor,
          badge: '${toKurdishDigits(c.episodesCount)} ئەڵقە • ${c.category}',
          color: c.accentColor,
        ));
      } else if (key.startsWith('video:')) {
        final vId = key.substring(6);
        final allVideos = [...reelsContentList, ...webinarsContentList];
        final match = allVideos.where((v) => v.id == vId).firstOrNull;
        if (match != null) {
          result.add(FavoriteEntry(
            key: key,
            type: 'video',
            title: match.title,
            subtitle: match.speaker,
            badge: '${match.categoryLabel} • ${match.duration}',
            color: match.colorStart,
          ));
        }
      } else if (key.startsWith('article:')) {
        final aId = key.substring(8);
        final match = articlesContentList.where((a) => a.id == aId).firstOrNull;
        if (match != null) {
          result.add(FavoriteEntry(
            key: key,
            type: 'article',
            title: match.title,
            subtitle: match.author,
            badge: match.badge,
            color: match.color,
          ));
        }
      } else if (key.startsWith('guidance:')) {
        final gId = key.substring(9);
        final match = guidanceVideosList.where((g) => g.id == gId).firstOrNull;
        if (match != null) {
          result.add(FavoriteEntry(
            key: key,
            type: 'guidance',
            title: match.title,
            subtitle: match.specialist,
            badge: 'ڕێنمایی • ${match.duration}',
            color: match.color,
          ));
        }
      } else if (key.startsWith('pdf:')) {
        final idInt = int.tryParse(key.substring(4));
        final match = pdfBooksDatabase.where((b) => b.id == idInt).firstOrNull;
        if (match != null) {
          result.add(FavoriteEntry(
            key: key,
            type: 'pdf',
            title: match.title,
            subtitle: match.author,
            badge: '${toKurdishDigits(match.pages)} لاپەڕە • ${match.size}',
            color: match.coverColor,
          ));
        }
      }
    }
    return result;
  }

  // Teacher chat
  List<TeacherChatMessage> getTeacherChat(TeacherData teacher) {
    return teacherChats.putIfAbsent(
      teacher.id,
      () => [
        TeacherChatMessage(
          isTeacher: true,
          text:
              'سڵاو و ڕێز فێرخوازی بەڕێز، بەخێربێیت بۆ چاتی ڕاستەوخۆ لەگەڵ ${teacher.name}. فەرموو پرسیار یان تێبینییەکەت بنووسە.',
          time: 'هەر ئێستا',
        ),
      ],
    );
  }

  void sendTeacherMessage(TeacherData teacher, String text) {
    final list = getTeacherChat(teacher);
    final now = TimeOfDay.now();
    final timeStr =
        '${toKurdishDigits(now.hour.toString().padLeft(2, '0'))}:${toKurdishDigits(now.minute.toString().padLeft(2, '0'))}';
    list.add(TeacherChatMessage(isTeacher: false, text: text, time: timeStr));
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 900), () {
      list.add(TeacherChatMessage(
        isTeacher: true,
        text:
            'پەیامەکەت گەیشت فێرخوازی بەڕێز. خوای گەورە پاداشتت بداتەوە، وەڵامی تێروتەسەل بۆ ئەم پرسیارە لە وانەکانی داهاتوودا ڕووندەکەینەوە.',
        time: timeStr,
      ));
      notifyListeners();
    });
  }

  void sendLiveMessage(String text) {
    liveChatMessages.add({
      'name': isLoggedIn ? fullName : 'میوان',
      'msg': text,
    });
    notifyListeners();
  }
}

String toKurdishDigits(dynamic input) {
  const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  return input.toString().replaceAllMapped(
        RegExp(r'[0-9]'),
        (m) => digits[int.parse(m.group(0)!)],
      );
}

