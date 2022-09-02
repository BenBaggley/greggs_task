import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greggs/l10n/l10n.dart';

import 'mock_router.dart';

extension TestApp on WidgetTester {
  Future<void> pumpRouterApp({
    required Widget child,
    required MockRouter router,
  }) async {
    await pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MockRouterProvider(goRouter: router, child: child),
      ),
    );
  }

  Future<void> pumpApp({
    required Widget child,
  }) async {
    await pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );
  }
}
