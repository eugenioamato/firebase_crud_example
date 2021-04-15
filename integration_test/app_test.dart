/*
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:roomsgame/app.dart' as app;

import 'package:roomsgame/services/database_interface.dart'
    if (dart.library.html) 'package:firebase_crud_example/services/web_database_interface.dart';

/**
TO TEST ON ANDROID, WEAROS or IOS ,
  OPEN THE SIMULATOR AND RUN NEXT COMMAND
flutter drive --driver=test_driver/integration_driver.dart --target=integration_test/app_test.dart
*/


///TO TEST ON FLUTTER WEB (CHROME), INSTALL CHROMEDRIVER at:
///    https://chromedriver.chromium.org/downloads

///AND RUN NEXT 2 COMMANDS ON 2 DIFFERENT TERMINALS
///chromedriver --port=4444
///flutter drive --driver=test_driver/integration_driver.dart --target=integration_test/app_test.dart -d web-server


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final readButton =
      find.widgetWithText(ElevatedButton, 'Read', skipOffstage: false);
  final deleteButton =
      find.widgetWithText(ElevatedButton, 'Delete', skipOffstage: false);
  final updateButton =
      find.widgetWithText(ElevatedButton, 'Update', skipOffstage: false);
  final createButton =
      find.widgetWithText(ElevatedButton, 'Create', skipOffstage: false);

  setUpAll(() async {
    await DatabaseInterface()
        .init('users', () =>() async {});
  });

  testWidgets(
      'Pressing delete button '
      'gives error when no record is found', (WidgetTester tester) async {
    await tester.pumpWidget(app.FirebaseCrudExampleApp());

    expect(
      find.textContaining('Ready!'),
      findsOneWidget,
    );

    await tester.ensureVisible(deleteButton);
    expect(
      deleteButton,
      findsOneWidget,
    );

    await tester.pumpAndSettle(Duration(seconds: 2));
    await tester.tap(deleteButton);
    await tester.pumpAndSettle(Duration(seconds: 2));

    var formCaption = find.bySemanticsLabel('formCaption', skipOffstage: false);
    await tester.ensureVisible(formCaption);
    await tester.pumpAndSettle(Duration(seconds: 2));

    expect(
      find.textContaining('ERROR'),
      findsOneWidget,
    );
  });

  testWidgets(
      'Pressing update button '
      'gives error when no record is found', (WidgetTester tester) async {
    await tester.pumpWidget(app.FirebaseCrudExampleApp());

    expect(
      find.textContaining('Ready!'),
      findsOneWidget,
    );

    await tester.ensureVisible(updateButton);
    expect(
      updateButton,
      findsOneWidget,
    );

    await tester.pumpAndSettle(Duration(seconds: 2));
    await tester.tap(updateButton);
    await tester.pumpAndSettle(Duration(seconds: 2));

    var formCaption = find.bySemanticsLabel('formCaption', skipOffstage: false);
    await tester.ensureVisible(formCaption);

    expect(
      find.textContaining('ERROR'),
      findsOneWidget,
    );
  });

  testWidgets(
      'Pressing read button '
      'gives error when no record is found', (WidgetTester tester) async {
    await tester.pumpWidget(app.FirebaseCrudExampleApp());

    expect(
      find.textContaining('Ready!'),
      findsOneWidget,
    );

    await tester.ensureVisible(readButton);
    expect(
      readButton,
      findsOneWidget,
    );

    await tester.pumpAndSettle(Duration(seconds: 2));
    await tester.tap(readButton);
    await tester.pumpAndSettle(Duration(seconds: 2));

    var formCaption = find.bySemanticsLabel('formCaption', skipOffstage: false);
    await tester.ensureVisible(formCaption);

    expect(
      find.textContaining('ERROR'),
      findsOneWidget,
    );
  });

  testWidgets(
      'creating will show a success, '
      'then updating will show a success '
      'then the value will be Alessandro '
      'then deleting will show a success ', (WidgetTester tester) async {
    await tester.pumpWidget(app.FirebaseCrudExampleApp());

    expect(
      find.textContaining('Ready!'),
      findsOneWidget,
    );

    await tester.ensureVisible(createButton);
    await tester.pumpAndSettle(Duration(seconds: 2));
    await tester.tap(createButton);
    await tester.pumpAndSettle(Duration(seconds: 2));

    expect(
      find.textContaining('Success'),
      findsOneWidget,
    );

    await tester.ensureVisible(updateButton);
    await tester.pumpAndSettle(Duration(seconds: 2));

    await tester.tap(updateButton);
    await tester.pumpAndSettle(Duration(seconds: 2));

    var formCaption = find.bySemanticsLabel('formCaption', skipOffstage: false);
    await tester.ensureVisible(formCaption);

    expect(find.textContaining('Alessandro',skipOffstage: false), findsNWidgets(2));

    expect(
      find.textContaining('Success',skipOffstage: false),
      findsOneWidget,
    );

    await tester.ensureVisible(deleteButton);

    await tester.pumpAndSettle(Duration(seconds: 2));
    await tester.tap(deleteButton);

    await tester.pumpAndSettle(Duration(seconds: 2));

    expect(
      find.textContaining('Success'),
      findsOneWidget,
    );
  });
}
*/