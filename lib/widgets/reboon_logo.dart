import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Calligraphic vertical pill emblem of "ڕێبوون" matching the attached brand mark
/// in Image 2 (gold on dark teal) and Image 4 (dark teal on white circle).
class ReboonEmblem extends StatelessWidget {
  final double height;
  final Color backgroundColor;
  final Color strokeColor;

  const ReboonEmblem({
    super.key,
    this.height = 36,
    this.backgroundColor = AppColors.gold,
    this.strokeColor = AppColors.teal800,
  });

  @override
  Widget build(BuildContext context) {
    final double width = height * 0.44;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(width * 0.48),
      ),
      child: CustomPaint(
        painter: _ReboonCalligraphyPainter(strokeColor: strokeColor),
      ),
    );
  }
}

class _ReboonCalligraphyPainter extends CustomPainter {
  final Color strokeColor;

  const _ReboonCalligraphyPainter({required this.strokeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.13
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.fill;

    // Top calligraphic "ن" / crescent bowl
    final topBowl = Path()
      ..moveTo(w * 0.20, h * 0.14)
      ..quadraticBezierTo(w * 0.18, h * 0.30, w * 0.52, h * 0.31)
      ..quadraticBezierTo(w * 0.84, h * 0.30, w * 0.82, h * 0.15);
    canvas.drawPath(topBowl, paint);
    // Dot inside top bowl
    canvas.drawCircle(Offset(w * 0.50, h * 0.18), w * 0.08, fillPaint);

    // Middle interlocking "بوو" loops
    final midWave = Path()
      ..moveTo(w * 0.78, h * 0.43)
      ..quadraticBezierTo(w * 0.54, h * 0.36, w * 0.32, h * 0.48)
      ..quadraticBezierTo(w * 0.18, h * 0.56, w * 0.48, h * 0.60)
      ..quadraticBezierTo(w * 0.82, h * 0.64, w * 0.66, h * 0.75)
      ..quadraticBezierTo(w * 0.48, h * 0.84, w * 0.22, h * 0.76);
    canvas.drawPath(midWave, paint);

    // Secondary loop accent ("و" circle)
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.36, h * 0.65),
        width: w * 0.26,
        height: h * 0.13,
      ),
      paint,
    );

    // Bottom "ڕ" tail + inverted caret ("v")
    final bottomTail = Path()
      ..moveTo(w * 0.78, h * 0.77)
      ..quadraticBezierTo(w * 0.68, h * 0.90, w * 0.35, h * 0.91);
    canvas.drawPath(bottomTail, paint);

    final caret = Path()
      ..moveTo(w * 0.44, h * 0.93)
      ..lineTo(w * 0.53, h * 0.96)
      ..lineTo(w * 0.62, h * 0.93);
    canvas.drawPath(
      caret,
      paint..strokeWidth = w * 0.09,
    );
  }

  @override
  bool shouldRepaint(covariant _ReboonCalligraphyPainter oldDelegate) =>
      oldDelegate.strokeColor != strokeColor;
}

class TeacherAvatarBubble extends StatelessWidget {
  final String name;
  final double size;
  final Color colorStart;
  final Color colorEnd;
  final bool showOnlineDot;

  const TeacherAvatarBubble({
    super.key,
    required this.name,
    this.size = 32,
    this.colorStart = AppColors.teal600,
    this.colorEnd = AppColors.teal800,
    this.showOnlineDot = true,
  });

  String _initials(String raw) {
    final clean = raw
        .replaceFirst(RegExp(r'^(د\.|م\.|الشيخ|الأستاذ)\s*'), '')
        .trim();
    final parts = clean.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}.${parts[1][0]}';
    }
    return clean.isNotEmpty ? clean.characters.take(2).toString() : 'ڕ';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colorStart, colorEnd],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.9),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              _initials(name),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: size * 0.34,
                height: 1.0,
              ),
            ),
          ),
          if (showOnlineDot)
            Positioned(
              bottom: -1,
              left: -1,
              child: Container(
                width: size * 0.32,
                height: size * 0.32,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Decorative classical Islamic book cover with spine & ornament
class StylizedBookCover extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final double width;
  final double height;
  final String? badge;

  const StylizedBookCover({
    super.key,
    required this.title,
    this.subtitle = '',
    required this.color,
    this.width = 110,
    this.height = 148,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final darker = Color.lerp(color, Colors.black, 0.35) ?? color;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [color, darker],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.28),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Spine line on the right (RTL book spine)
          Positioned(
            top: 0,
            bottom: 0,
            right: 8,
            child: Container(
              width: 2,
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          // Inner ornamental frame
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.amber400.withValues(alpha: 0.55),
                  width: 1.2,
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 14, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.amber400.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badge!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.amber400,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                else
                  const Icon(
                    Icons.auto_stories_rounded,
                    color: AppColors.amber400,
                    size: 18,
                  ),
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: width * 0.115,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

