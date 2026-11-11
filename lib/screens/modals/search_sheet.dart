import 'package:flutter/material.dart';
import '../../data/courses_data.dart';
import '../../data/home_content_data.dart';
import '../../data/library_teachers_data.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import 'lesson_study_sheet.dart';
import 'media_player_sheet.dart';
import 'pdf_library_sheet.dart';
import 'teachers_sheet.dart';

void openGlobalSearchSheet(
  BuildContext context,
  AppState appState, {
  required VoidCallback onOpenAccountTab,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _GlobalSearchSheet(
      appState: appState,
      onOpenAccountTab: onOpenAccountTab,
    ),
  );
}

class _GlobalSearchSheet extends StatefulWidget {
  final AppState appState;
  final VoidCallback onOpenAccountTab;

  const _GlobalSearchSheet({
    required this.appState,
    required this.onOpenAccountTab,
  });

  @override
  State<_GlobalSearchSheet> createState() => _GlobalSearchSheetState();
}

class _GlobalSearchSheetState extends State<_GlobalSearchSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();

    final courses = courseCatalog.values
        .where((c) =>
            q.isEmpty ||
            c.title.toLowerCase().contains(q) ||
            c.instructor.toLowerCase().contains(q) ||
            c.category.toLowerCase().contains(q))
        .take(6)
        .toList();

    final books = pdfBooksDatabase
        .where((b) =>
            q.isEmpty ||
            b.title.toLowerCase().contains(q) ||
            b.author.toLowerCase().contains(q))
        .take(5)
        .toList();

    final teachers = academyTeachersDatabase
        .where((t) =>
            q.isEmpty ||
            t.name.toLowerCase().contains(q) ||
            t.specialty.toLowerCase().contains(q))
        .take(4)
        .toList();

    final webinars = [...webinarsContentList, ...reelsContentList]
        .where((v) =>
            q.isEmpty ||
            v.title.toLowerCase().contains(q) ||
            v.speaker.toLowerCase().contains(q))
        .take(4)
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.88,
      maxChildSize: 0.96,
      builder: (_, controller) => Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    onChanged: (v) => setState(() => _query = v),
                    decoration: const InputDecoration(
                      hintText: 'گەڕان لە وانە، کتێبی PDF، مامۆستا یان وێبینار...',
                      prefixIcon: Icon(Icons.search_rounded),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.all(16),
              children: [
                if (courses.isNotEmpty) ...[
                  const _SearchHeader('📖 ڕاڤەی پەرتووکە شەرعییەکان'),
                  ...courses.map(
                    (c) => ListTile(
                      leading: const Icon(Icons.menu_book_rounded, color: AppColors.teal700),
                      title: Text(c.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text('${c.instructor} • ${toKurdishDigits(c.episodesCount)} ئەڵقە'),
                      onTap: () {
                        Navigator.pop(context);
                        openLessonStudySheet(
                          context,
                          widget.appState,
                          c.key,
                          onOpenAccountTab: widget.onOpenAccountTab,
                        );
                      },
                    ),
                  ),
                  const Divider(),
                ],
                if (books.isNotEmpty) ...[
                  const _SearchHeader('📚 کتێبخانەی PDF'),
                  ...books.map(
                    (b) => ListTile(
                      leading: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.amber600),
                      title: Text(b.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(b.author),
                      onTap: () {
                        Navigator.pop(context);
                        openPdfBookDetailSheet(context, widget.appState, b);
                      },
                    ),
                  ),
                  const Divider(),
                ],
                if (teachers.isNotEmpty) ...[
                  const _SearchHeader('🎓 مامۆستایانی فێرگە'),
                  ...teachers.map(
                    (t) => ListTile(
                      leading: const Icon(Icons.person_rounded, color: AppColors.emerald600),
                      title: Text(t.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(t.specialty),
                      onTap: () {
                        Navigator.pop(context);
                        openTeacherChatSheet(context, widget.appState, t);
                      },
                    ),
                  ),
                  const Divider(),
                ],
                if (webinars.isNotEmpty) ...[
                  const _SearchHeader('📹 وێبینار و کورتە ڤیدیۆ'),
                  ...webinars.map(
                    (v) => ListTile(
                      leading: const Icon(Icons.play_circle_fill_rounded, color: AppColors.indigo600),
                      title: Text(v.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text('${v.speaker} • ${v.duration}'),
                      onTap: () {
                        Navigator.pop(context);
                        openVideoPlayerSheet(context, widget.appState, v);
                      },
                    ),
                  ),
                ],
                if (courses.isEmpty &&
                    books.isEmpty &&
                    teachers.isEmpty &&
                    webinars.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: Text('هیچ ئەنجامێک نەدۆزرایەوە.')),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchHeader extends StatelessWidget {
  final String text;
  const _SearchHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 4),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.teal700,
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
    );
  }
}

