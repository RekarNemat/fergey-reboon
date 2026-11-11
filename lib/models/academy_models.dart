import 'package:flutter/material.dart';

class Episode {
  final int id;
  final String title;
  final String duration;

  const Episode({
    required this.id,
    required this.title,
    this.duration = '٢٥ خولەک',
  });
}

class CourseDetail {
  final String key;
  final String title;
  final String instructor;
  final int episodesCount;
  final String category;
  final String summary;
  final Color accentColor;
  final List<Episode> episodes;

  const CourseDetail({
    required this.key,
    required this.title,
    required this.instructor,
    required this.episodesCount,
    required this.category,
    required this.summary,
    required this.accentColor,
    required this.episodes,
  });
}

class GeneralCourseCardData {
  final String courseKey;
  final String scienceBadge;
  final String title;
  final String mainBook;
  final String supportBook;
  final String instructorShort;
  final String instructorFull;
  final Color color;

  const GeneralCourseCardData({
    required this.courseKey,
    required this.scienceBadge,
    required this.title,
    required this.mainBook,
    required this.supportBook,
    required this.instructorShort,
    required this.instructorFull,
    required this.color,
  });
}

class GeneralLevelData {
  final int levelNumber;
  final String badgeText;
  final String title;
  final Color badgeColor;
  final List<GeneralCourseCardData> courses;

  const GeneralLevelData({
    required this.levelNumber,
    required this.badgeText,
    required this.title,
    required this.badgeColor,
    required this.courses,
  });
}

class SpecializedStageData {
  final String courseKey;
  final String stageLabel;
  final String title;
  final String mainBook;
  final String supportBook;
  final String instructorFull;

  const SpecializedStageData({
    required this.courseKey,
    required this.stageLabel,
    required this.title,
    required this.mainBook,
    required this.supportBook,
    required this.instructorFull,
  });
}

class SpecializedScienceData {
  final String id;
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final List<SpecializedStageData> stages;

  const SpecializedScienceData({
    required this.id,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.stages,
  });
}

class SanadChainNode {
  final String name;
  final String title;

  const SanadChainNode({required this.name, required this.title});
}

class SanadItemData {
  final String key;
  final String shortTitle;
  final String title;
  final String science;
  final String book;
  final String description;
  final String teacherName;
  final String reqTitle;
  final String reqText;
  final String iconEmoji;
  final Color color;
  final List<SanadChainNode> chain;

  const SanadItemData({
    required this.key,
    required this.shortTitle,
    required this.title,
    required this.science,
    required this.book,
    required this.description,
    required this.teacherName,
    required this.reqTitle,
    required this.reqText,
    required this.iconEmoji,
    required this.color,
    required this.chain,
  });
}

class PdfBookData {
  final int id;
  final String title;
  final String author;
  final String category;
  final int pages;
  final String size;
  final String icon;
  final String desc;
  final Color coverColor;

  const PdfBookData({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.pages,
    required this.size,
    required this.icon,
    required this.desc,
    this.coverColor = const Color(0xFF0F766E),
  });
}

class TeacherData {
  final int id;
  final String name;
  final String title;
  final Color colorStart;
  final Color colorEnd;
  final String booksCount;
  final String lessonsCount;
  final String studentsCount;
  final String specialty;
  final String bio;
  final List<String> books;

  const TeacherData({
    required this.id,
    required this.name,
    required this.title,
    required this.colorStart,
    required this.colorEnd,
    required this.booksCount,
    required this.lessonsCount,
    required this.studentsCount,
    required this.specialty,
    required this.bio,
    required this.books,
  });
}

class ResourceItemData {
  final int id;
  final String title;
  final String url;
  final String category;
  final String desc;
  final String icon;
  final String badge;

  const ResourceItemData({
    required this.id,
    required this.title,
    required this.url,
    required this.category,
    required this.desc,
    required this.icon,
    required this.badge,
  });
}

class VideoContentItem {
  final String id;
  final String title;
  final String duration;
  final String speaker;
  final String desc;
  final String categoryLabel;
  final bool isVerticalReel;
  final Color colorStart;
  final Color colorEnd;

  const VideoContentItem({
    required this.id,
    required this.title,
    required this.duration,
    required this.speaker,
    required this.desc,
    required this.categoryLabel,
    required this.isVerticalReel,
    required this.colorStart,
    required this.colorEnd,
  });
}

class ArticleContentItem {
  final String id;
  final String title;
  final String author;
  final String badge;
  final String excerpt;
  final String fullContent;
  final Color color;

  const ArticleContentItem({
    required this.id,
    required this.title,
    required this.author,
    required this.badge,
    required this.excerpt,
    required this.fullContent,
    required this.color,
  });
}

class GuidanceVideoItem {
  final String id;
  final String title;
  final String specialist;
  final String duration;
  final String summary;
  final List<String> keyTips;
  final IconData icon;
  final Color color;

  const GuidanceVideoItem({
    required this.id,
    required this.title,
    required this.specialist,
    required this.duration,
    required this.summary,
    required this.keyTips,
    required this.icon,
    required this.color,
  });
}

class ScienceCategoryItem {
  final String id;
  final String arabicName;
  final String kurdishName;
  final IconData icon;
  final Color color;

  const ScienceCategoryItem({
    required this.id,
    required this.arabicName,
    required this.kurdishName,
    required this.icon,
    required this.color,
  });
}

class ReboonProjectItem {
  final String id;
  final String title;
  final String subtitle;
  final String badge;
  final String icon;
  final String linkText;
  final String url;
  final String desc;
  final bool isFeatured;
  final Color accentColor;

  const ReboonProjectItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.icon,
    required this.linkText,
    required this.url,
    required this.desc,
    this.isFeatured = false,
    this.accentColor = const Color(0xFF0F766E),
  });
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation = '',
  });
}

class IndependentScienceMeta {
  final String id;
  final String name;
  final String icon;
  final Color colorStart;
  final Color colorEnd;
  final String desc;

  const IndependentScienceMeta({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorStart,
    required this.colorEnd,
    required this.desc,
  });
}

class AssessmentTopicData {
  final int id;
  final String title;
  final String category;
  final int questionCount;
  final String level;
  final List<QuizQuestion> sampleQuestions;

  const AssessmentTopicData({
    required this.id,
    required this.title,
    required this.category,
    required this.questionCount,
    required this.level,
    required this.sampleQuestions,
  });
}

class AppNotification {
  final int id;
  final String title;
  final String text;
  final String time;
  bool read;
  final String icon;

  AppNotification({
    required this.id,
    required this.title,
    required this.text,
    required this.time,
    required this.read,
    required this.icon,
  });
}

class OfflineLesson {
  final int id;
  final String name;
  final String size;
  final String icon;

  const OfflineLesson({
    required this.id,
    required this.name,
    required this.size,
    required this.icon,
  });
}

class FavoriteEntry {
  final String key;
  final String type; // 'course', 'video', 'article', 'pdf', 'guidance'
  final String title;
  final String subtitle;
  final String badge;
  final Color color;

  const FavoriteEntry({
    required this.key,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.color,
  });
}

class TeacherChatMessage {
  final bool isTeacher;
  final String text;
  final String time;

  const TeacherChatMessage({
    required this.isTeacher,
    required this.text,
    required this.time,
  });
}

