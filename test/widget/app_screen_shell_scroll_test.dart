import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nine_tas/shared/ui/app_screen_shell.dart';

void main() {
  testWidgets('shared scroll shell reaches deep content on a small screen', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: AppScreenShell(
          scrollable: true,
          body: Column(
            children: [
              for (var i = 0; i < 80; i++)
                SizedBox(
                  height: 44,
                  child: Text('row-$i', key: ValueKey('row-$i')),
                ),
            ],
          ),
        ),
      ),
    );

    final target = find.byKey(const ValueKey('row-79'));
    await tester.scrollUntilVisible(
      target,
      420,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(target, findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shared scroll shell survives RTL and large text', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: AppScreenShell(
              scrollable: true,
              body: Column(
                children: [
                  for (var i = 0; i < 45; i++)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('اختبار واجهة طويل'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await tester.drag(find.byType(Scrollable).first, const Offset(0, -1200));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
