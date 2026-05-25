import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hub_controller.dart';
import 'recommendations_tab.dart';
import 'matches_tab.dart';
import '../chat/chats_tab.dart';
import 'notifications_tab.dart';
import '../settings/settings_tab.dart';
import '../../core/constants.dart';
import '../../routes/routes.dart';

class HubScreen extends StatelessWidget {
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HubController());

    final List<Widget> tabs = [
      const RecommendationsTab(),
      const MatchesTab(),
      const ChatsTab(),
      const NotificationsTab(),
      const SettingsTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, color: AppColors.primaryMaroon, size: 22),
            const SizedBox(width: 8),
            Text(
              'Bandhan',
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.primaryMaroon,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          // Admin Panel shortcut for convenience
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_outlined, color: AppColors.primaryMaroon),
            tooltip: 'Admin Portal',
            onPressed: () => Get.toNamed(AppRoutes.admin),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Obx(() => IndexedStack(
            index: controller.activeTabIndex.value,
            children: tabs,
          )),
      bottomNavigationBar: Obx(() => Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryMaroon.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: NavigationBar(
              selectedIndex: controller.activeTabIndex.value,
              onDestinationSelected: (index) => controller.activeTabIndex.value = index,
              backgroundColor: AppColors.surfaceWhite,
              indicatorColor: AppColors.tertiaryPink.withOpacity(0.4),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home, color: AppColors.primaryMaroon),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_border),
                  selectedIcon: Icon(Icons.favorite, color: AppColors.primaryMaroon),
                  label: 'Interests',
                ),
                NavigationDestination(
                  icon: Icon(Icons.chat_bubble_outline),
                  selectedIcon: Icon(Icons.chat_bubble, color: AppColors.primaryMaroon),
                  label: 'Chats',
                ),
                NavigationDestination(
                  icon: Icon(Icons.notifications_none),
                  selectedIcon: Icon(Icons.notifications, color: AppColors.primaryMaroon),
                  label: 'Alerts',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person, color: AppColors.primaryMaroon),
                  label: 'Profile',
                ),
              ],
            ),
          )),
    );
  }
}
