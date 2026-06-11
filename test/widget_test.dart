import 'package:aurae_app/app/app_controller.dart';
import 'package:aurae_app/app/aurae_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows Aurae welcome experience', (tester) async {
    final controller = AppController();
    controller.authenticationReady = true;
    await tester.pumpWidget(AuraeApp(controller: controller));
    await tester.pump();

    expect(find.text('AURAE'), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
  });
}
