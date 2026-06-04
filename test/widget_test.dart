import 'package:flutter_test/flutter_test.dart';
import 'package:mahsool/main.dart';

void main() {
  testWidgets('App starts and shows login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MahsoolApp());
    expect(find.text('ورود به محصول'), findsOneWidget);
  });
}
