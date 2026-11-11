import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

void showReboonToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.teal800,
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      duration: const Duration(seconds: 3),
      content: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.teal400, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class SectionTitleHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final Color? dotColor;

  const SectionTitleHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
    this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Flexible(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.teal900,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: dotColor ?? AppColors.gold,
              shape: BoxShape.circle,
            ),
          ),
          const Spacer(),
          if (actionLabel != null && onActionTap != null)
            InkWell(
              onTap: onActionTap,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      actionLabel!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: theme.brightness == Brightness.dark
                            ? AppColors.teal400
                            : AppColors.teal700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: theme.brightness == Brightness.dark
                          ? AppColors.teal400
                          : AppColors.teal700,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class FavoriteHeartButton extends StatelessWidget {
  final AppState appState;
  final String favoriteKey;
  final Color? inactiveColor;
  final double size;

  const FavoriteHeartButton({
    super.key,
    required this.appState,
    required this.favoriteKey,
    this.inactiveColor,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    final isFav = appState.isFavorite(favoriteKey);
    return InkWell(
      onTap: () {
        appState.toggleFavorite(favoriteKey);
        showReboonToast(
          context,
          isFav
              ? 'لە وانە دڵخوازەکان لابرا'
              : 'زیادکرا بۆ وانە دڵخوازەکان ❤️',
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isFav
              ? AppColors.rose600.withValues(alpha: 0.14)
              : Colors.black.withValues(alpha: 0.06),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          size: size,
          color: isFav
              ? AppColors.rose600
              : (inactiveColor ?? Colors.grey.shade500),
        ),
      ),
    );
  }
}

Future<bool> ensureAuthenticated(
  BuildContext context,
  AppState appState, {
  required String actionLabel,
  required VoidCallback onOpenAccountTab,
}) async {
  if (appState.isLoggedIn) return true;

  final result = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.teal50,
            child: Text('🔐', style: TextStyle(fontSize: 30)),
          ),
          SizedBox(height: 12),
          Text(
            'داغڵبوون پێویستە',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'بۆ خوێندنی وانەکان و پاشەکەوتکردنی پێشکەوتن پێویستە بە هەژمار داغڵ ببیت.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.teal50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '📚 $actionLabel',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.teal800,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: () => Navigator.pop(ctx, 'account'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.teal700,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('چوونەژوورەوە / دروستکردنی هەژمار'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.pop(ctx, 'quick'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('چوونەژوورەوەی خێرا وەک فێرخواز'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, 'guest'),
              child: const Text('بەردەوامبوون وەک میوان'),
            ),
          ],
        ),
      ],
    ),
  );

  if (result == 'quick') {
    appState.signIn(emailInput: appState.email);
    if (context.mounted) {
      showReboonToast(context, 'بەخێربێیت! بە سەرکەوتوویی چوویتەژوورەوە');
    }
    return true;
  } else if (result == 'account') {
    onOpenAccountTab();
    return false;
  }
  return false;
}

