import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme.dart';
import 'routes/routes.dart';
import 'routes/pages.dart';
import 'services/supabase_service.dart';

void main() async {
  // Ensure Flutter engine bindings are initialized for async hooks
  WidgetsFlutterBinding.ensureInitialized();
  
  // Register Supabase Service asynchronously in GetX dependency injection container
  await Get.putAsync(() => SupabaseService().init());

  runApp(const BandhanApp());
}

class BandhanApp extends StatelessWidget {
  const BandhanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bandhan Matrimony',
      debugShowCheckedModeBanner: false,
      
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
