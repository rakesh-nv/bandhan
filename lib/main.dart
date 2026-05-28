import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme.dart';
import 'routes/routes.dart';
import 'routes/pages.dart';
import 'services/supabase_service.dart';
import 'services/auth_service.dart';
import 'services/storage_service.dart';
import 'services/realtime_service.dart';
import 'services/notification_service.dart';
import 'bindings/initial_binding.dart';

void main() async {
  // Ensure Flutter engine bindings are initialized for async hooks
  WidgetsFlutterBinding.ensureInitialized();
  
  // Register Supabase Service asynchronously in GetX dependency injection container
  final supabase = await Get.putAsync(() => SupabaseService().init());
  
  // Register and initialize other critical services asynchronously
  await Get.putAsync(() => AuthService().init(), permanent: true);
  await Get.putAsync(() => StorageService().init(), permanent: true);
  await Get.putAsync(() => RealtimeService().init(), permanent: true);
  await Get.putAsync(() => NotificationService().init(), permanent: true);

  runApp(const BandhanApp());
}

class BandhanApp extends StatelessWidget {
  const BandhanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bandhan Matrimony',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      
      // Theme parameters
      theme: AppTheme.lightTheme,
      
      // Routes parameters
      initialRoute: AppPages.initial,
      getPages: AppPages.pages,
      
      // Default configurations
      defaultTransition: Transition.fade,
    );
  }
}
