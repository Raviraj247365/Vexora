import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vexora_mobile_app/src/app.dart';

void main() {
  testWidgets('Vexora app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: VexoraApp()));
    await tester.pump();

    expect(find.text('VEXORA'), findsOneWidget);
  });
}
