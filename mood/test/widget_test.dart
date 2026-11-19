import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood/core/database/app_database.dart';
import 'package:mood/features/capture/presentation/providers/entry_repository_provider.dart';
import 'package:mood/main.dart';

void main() {
  testWidgets('MoodCanvas full daily capture flow smoke test',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;

    // Use fast in-memory Drift database for test environment
    final inMemoryDb = AppDatabase(NativeDatabase.memory());

    addTearDown(() async {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      await inMemoryDb.close();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(inMemoryDb),
        ],
        child: const MoodCanvasApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // 0. Splash Screen -> auto-transitions to Walkthrough after 1.8s
    expect(find.text('MoodCanvas'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1900));
    await tester.pump(const Duration(milliseconds: 400));

    // 1. Onboarding Walkthrough
    expect(find.text('Welcome to MoodCanvas -\nTrack Your Daily Moods'), findsOneWidget);
    await tester.tap(find.text('Skip'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // 1b. Welcome Screen -> Sign up
    expect(find.text("Let's Get Started!"), findsOneWidget);
    await tester.tap(find.text('Sign up'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    // 1c. Sign Up Screen -> Loading -> Account Setup
    expect(find.text('Join MoodCanvas Today ✨'), findsOneWidget);
    await tester.tap(find.text('Sign up').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Sign up...'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pump(const Duration(milliseconds: 400));

    // 1d. 8-Step Account Setup Flow
    expect(find.text('What should we call you?'), findsOneWidget);
    for (int step = 0; step < 7; step++) {
      await tester.tap(find.text('Continue'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
    }
    expect(find.text('Finish'), findsOneWidget);
    await tester.tap(find.text('Finish'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // 1e. Setup Loading Screen -> auto-transitions to Home after 2.2s
    expect(find.text('Setting up your\npersonalized page...'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 2400));
    await tester.pump(const Duration(milliseconds: 600));

    // 2. Home Screen
    expect(find.text('How do you feel today?'), findsOneWidget);

    // Tap floating + FAB to open Today / Select Date action menu
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Today'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    // 3. Step 0: Mood Gauge Dial
    expect(find.text('I Feel Good!'), findsOneWidget);
    await tester.tap(find.text('I Feel Good!'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // 4. Step 1: What have you done? (Activities)
    expect(find.text('What have you done?'), findsOneWidget);
    await tester.tap(find.text('Happy').first);
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // 5. Step 2: Add more details
    expect(find.text('Add more details'), findsOneWidget);
    await tester.enterText(
      find.byType(TextField),
      'A quiet, deeply peaceful moment listening to acoustic music.',
    );
    await tester.pump();

    // Tap Save
    await tester.tap(find.text('Save'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pump(const Duration(milliseconds: 600));

    // Verify returned to Home and Home reflects the saved check-in note
    expect(find.text('How do you feel today?'), findsOneWidget);
    expect(
      find.text('A quiet, deeply peaceful moment listening to acoustic music.'),
      findsOneWidget,
    );

    // Unmount widget tree to dispose repeating animation controllers before tearDown checks
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
  });
}
