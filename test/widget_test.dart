import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:student_profile_form/main.dart';

void main() {
  // Use a tall screen so every field and both buttons are visible.
  void useTallScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> fillForm(WidgetTester tester) async {
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Full name'), 'Juan Dela Cruz');
    await tester.enterText(find.widgetWithText(TextFormField, 'Age'), '20');
    await tester.tap(find.text('Male'));
    await tester.pump();
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Address'), 'Naga City');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Contact number'), '09171234567');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'juan@school.edu');
  }

  testWidgets('empty form shows required-field errors', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(const StudentProfileApp());

    await tester.tap(find.text('Submit'));
    await tester.pump();

    expect(find.text('Full name is required'), findsOneWidget);
    expect(find.text('Age is required'), findsOneWidget);
    expect(find.text('Please select a gender'), findsOneWidget);
    expect(find.text('Address is required'), findsOneWidget);
    expect(find.text('Contact number is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Submitted profile'), findsNothing);
  });

  testWidgets('invalid email is rejected', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(const StudentProfileApp());

    await fillForm(tester);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'juan@');
    await tester.tap(find.text('Submit'));
    await tester.pump();

    expect(find.text('Enter a valid email, e.g. name@school.edu'),
        findsOneWidget);
    expect(find.text('Submitted profile'), findsNothing);
  });

  testWidgets('valid form displays the submitted profile', (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(const StudentProfileApp());

    await fillForm(tester);
    await tester.tap(find.text('Submit'));
    await tester.pump();

    expect(find.text('Submitted profile'), findsOneWidget);
  });

  testWidgets('Clear removes the entered data and the summary',
      (tester) async {
    useTallScreen(tester);
    await tester.pumpWidget(const StudentProfileApp());

    await fillForm(tester);
    await tester.tap(find.text('Submit'));
    await tester.pump();
    expect(find.text('Submitted profile'), findsOneWidget);

    await tester.tap(find.text('Clear'));
    await tester.pump();

    expect(find.text('Submitted profile'), findsNothing);
    expect(find.text('Juan Dela Cruz'), findsNothing);
  });
}