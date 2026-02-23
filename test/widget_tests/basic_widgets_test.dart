import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:azkar/core/manager/app_cubit.dart';
import 'package:azkar/core/manager/app_state.dart';
import 'package:azkar/core/localization/app_localizations.dart';
import 'package:azkar/core/theme/app_themes.dart';

void main() {
  group('Widget Tests - Basic UI Components', () {
    testWidgets('AppBar renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Test App')),
            body: const Center(child: Text('Test Body')),
          ),
        ),
      );

      expect(find.text('Test App'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Text widget displays correctly', (WidgetTester tester) async {
      const testText = 'Hello, World!';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: Text(testText))),
        ),
      );

      expect(find.text(testText), findsOneWidget);
    });

    testWidgets('Button tap is detected', (WidgetTester tester) async {
      int tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => tapCount++,
                child: const Text('Tap Me'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(tapCount, equals(1));
    });

    testWidgets('ListView renders items correctly', (
      WidgetTester tester,
    ) async {
      const items = ['Item 1', 'Item 2', 'Item 3'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(items[index]));
              },
            ),
          ),
        ),
      );

      for (final item in items) {
        expect(find.text(item), findsOneWidget);
      }
    });
  });

  group('Widget Tests - Dialog & Bottom Sheets', () {
    testWidgets('AlertDialog displays and closes correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: tester.element(find.byType(ElevatedButton)),
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Test Dialog'),
                        content: const Text('Dialog Content'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Test Dialog'), findsOneWidget);
      expect(find.text('Dialog Content'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.text('Test Dialog'), findsNothing);
    });

    testWidgets('Dialog shows correct content', (WidgetTester tester) async {
      const dialogTitle = 'Confirmation';
      const dialogContent = 'Are you sure?';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: AlertDialog(
                title: const Text(dialogTitle),
                content: const Text(dialogContent),
                actions: [
                  TextButton(onPressed: () {}, child: const Text('Yes')),
                  TextButton(onPressed: () {}, child: const Text('No')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text(dialogTitle), findsOneWidget);
      expect(find.text(dialogContent), findsOneWidget);
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);
    });
  });

  group('Widget Tests - Form Inputs', () {
    testWidgets('TextField accepts input correctly', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'Enter text'),
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Test Input');
      expect(controller.text, equals('Test Input'));
    });

    testWidgets('Checkbox toggles correctly', (WidgetTester tester) async {
      bool isChecked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Center(
                  child: Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() => isChecked = value ?? false);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(isChecked, equals(false));

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(isChecked, equals(true));
    });
  });

  group('Widget Tests - Responsive Layout', () {
    testWidgets('Column layouts stack widgets vertically', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Container(height: 100, color: Colors.red),
                Container(height: 100, color: Colors.blue),
                Container(height: 100, color: Colors.green),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('Row layouts widgets horizontally', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                Expanded(child: Container(color: Colors.red)),
                Expanded(child: Container(color: Colors.blue)),
                Expanded(child: Container(color: Colors.green)),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Expanded), findsWidgets);
    });
  });

  group('Widget Tests - State Management', () {
    testWidgets('StatefulWidget state updates correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: CounterWidget()));

      expect(find.text('Count: 0'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('Count: 1'), findsOneWidget);
    });

    testWidgets('Multiple state updates work correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: CounterWidget()));

      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();
      }

      expect(find.text('Count: 5'), findsOneWidget);
    });
  });
}

// Test Widget - Simple Counter
class CounterWidget extends StatefulWidget {
  const CounterWidget({Key? key}) : super(key: key);

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(child: Text('Count: $count')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => count++);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
