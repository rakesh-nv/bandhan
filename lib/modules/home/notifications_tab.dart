import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants.dart';
import '../../routes/routes.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock notifications data list
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'New Interest Received',
        'body': 'Ananya Iyer has sent you an interest connection request.',
        'time': '2 hours ago',
        'icon': Icons.favorite,
        'color': AppColors.heartRed,
        'action': () => Get.toNamed(AppRoutes.hub), // Open interests tab
      },
      {
        'title': 'Connection Accepted 🎉',
        'body': 'Dr. Priyanka Patil accepted your interest request. Start a conversation now!',
        'time': '1 day ago',
        'icon': Icons.handshake,
        'color': Colors.green,
        'action': () => Get.toNamed(AppRoutes.hub),
      },
      {
        'title': 'Profile Viewed',
        'body': 'Someone from the Brahmin community viewed your profile.',
        'time': '2 days ago',
        'icon': Icons.remove_red_eye_outlined,
        'color': AppColors.secondaryGold,
        'action': () => Get.toNamed(AppRoutes.subscription), // Upsell contact/view details
      },
      {
        'title': 'Special Discount Active',
        'body': 'Get 30% off on Premium Plus plans to view contacts directly.',
        'time': '3 days ago',
        'icon': Icons.discount_outlined,
        'color': AppColors.primaryMaroon,
        'action': () => Get.toNamed(AppRoutes.subscription),
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => Divider(color: AppColors.surfaceCreamDim.withOpacity(0.5)),
      itemBuilder: (context, index) {
        final item = notifications[index];
        return InkWell(
          onTap: item['action'],
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: item['color'] as Color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['body'] as String,
                        style: TextStyle(color: AppColors.textDarkMuted, fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['time'] as String,
                        style: const TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
