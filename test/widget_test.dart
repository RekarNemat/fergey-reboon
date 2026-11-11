import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reboon_academy/app.dart';
import 'package:reboon_academy/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<AppState> pumpApp(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final state = AppState();
    await state.init(startSimulationTimer: false);
    addTearDown(state.dispose);

    await tester.pumpWidget(ReboonAcademyApp(appState: state));
    await tester.pumpAndSettle();
    return state;
  }

  testWidgets('Responsive renders cleanly at 320px, 390px, and 800px widths',
      (tester) async {
    for (final size in [
      const Size(320, 680),
      const Size(390, 844),
      const Size(800, 1280),
    ]) {
      await pumpApp(tester, size);
      expect(find.text('فێرگەی ڕێبوون'), findsWidgets);
      expect(find.text('سەنەدەکان'), findsWidgets);
      expect(find.text('ئەکادیمیا'), findsWidgets);
      expect(find.text('وانە دڵخوازەکان'), findsOneWidget);
      expect(find.text('هەژمار'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Bottom navigation switches across all 5 tabs and Academy tracks',
      (tester) async {
    await pumpApp(tester, const Size(390, 844));

    // Switch to Academy tab (disambiguate bottom bar item vs drawer/card label)
    await tester.tap(find.text('ئەکادیمیا').last);
    await tester.pumpAndSettle();
    expect(find.text('مەنهەجی گشتی هاوتەریب'), findsWidgets);

    // Switch to Specialized track
    await tester.tap(find.text('مەنهەجی پسپۆڕی (جیاواز)'));
    await tester.pumpAndSettle();
    expect(find.text('١. زانستی بیروباوەڕ (العقيدة)'), findsOneWidget);

    // Switch to Sanad tab
    await tester.tap(find.text('سەنەدەکان'));
    await tester.pumpAndSettle();
    expect(find.text('١. سەنەدی تەجوید و قیرائات'), findsOneWidget);

    // Switch to Favorites tab
    await tester.tap(find.text('وانە دڵخوازەکان'));
    await tester.pumpAndSettle();
    expect(find.textContaining('وانە دڵخوازەکان'), findsWidgets);

    // Switch to Account tab
    await tester.tap(find.text('هەژمار'));
    await tester.pumpAndSettle();
    expect(find.text('هەژماری فێرخواز لە فێرگەی ڕێبوون'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Drawer opens Organization & Academy intro pages and Settings works',
      (tester) async {
    await pumpApp(tester, const Size(390, 844));

    // Open hamburger drawer
    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();
    expect(find.text('ناساندنی ڕێکخراو'), findsOneWidget);
    expect(find.text('ناساندنی فێرگە'), findsOneWidget);

    // Open Organization Intro (دەربارەی ئێمە)
    await tester.tap(find.text('ناساندنی ڕێکخراو'));
    await tester.pumpAndSettle();
    expect(find.text('دەربارەی ئێمە'), findsOneWidget);
    expect(find.text('ڕێکخراوی ڕێبوون'), findsOneWidget);
    expect(find.text('دروشم'), findsOneWidget);

    // Back to Home
    final backBtn = find.byWidgetPredicate(
      (w) => w is Icon && (w.icon == Icons.arrow_back || w.icon == Icons.arrow_back_ios_new_rounded || w.icon == Icons.arrow_back_ios),
    );
    await tester.tap(backBtn.first);
    await tester.pumpAndSettle();

    // Open Settings via top Settings gear icon
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('ڕێکخستنەکان'), findsOneWidget);
    expect(find.text('ئاگادارکردنەوە (Notification)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
