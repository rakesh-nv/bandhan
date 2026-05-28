import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bandhan/core/supabase/supabase_config.dart';

class SupabaseService extends GetxService {
  late final SupabaseClient client;

  Future<SupabaseService> init() async {
    await SupabaseConfig.initialize();
    client = SupabaseConfig.client;
    return this;
  }
}
