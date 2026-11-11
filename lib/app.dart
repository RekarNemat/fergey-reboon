import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';
import 'widgets/responsive_scaffold.dart';

class ReboonAcademyApp extends StatelessWidget {
  final AppState appState;

  const ReboonAcademyApp({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'فێرگەی ڕێبوون',
          locale: const Locale('ar'),
          supportedLocales: const [
            Locale('ar'),
            Locale('en'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: AppTheme.buildTheme(
            brightness: Brightness.light,
            fontFamily: appState.fontFamily,
            baseFontSize: appState.fontSize,
          ),
          darkTheme: AppTheme.buildTheme(
            brightness: Brightness.dark,
            fontFamily: appState.fontFamily,
            baseFontSize: appState.fontSize,
          ),
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: ResponsiveMainShell(appState: appState),
        );
      },
    );
  }
}
