import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:bandhan/main.dart';
import 'package:bandhan/services/supabase_service.dart';

void main() {
  testWidgets('Bandhan app smoke test', (WidgetTester tester) async {
    // Register mock/real service before pumping the widget
    Get.put(SupabaseService());

    // Build our app and trigger a frame.
    await tester.pumpWidget(const BandhanApp());

    // Expecting to find the GetMaterialApp/BandhanApp widget structure
    expect(find.byType(BandhanApp), findsOneWidget);
  });
}
