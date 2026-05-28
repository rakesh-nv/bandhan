import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../core/constants.dart';
import '../../widgets/empty_state.dart';
import '../../routes/routes.dart';
import '../../models/message_model.dart';
import '../../controllers/profile_controller.dart';
import 'chat_controller.dart';

class ChatsTab extends StatelessWidget {
  const ChatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());
    final ProfileController profileCtrl = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: AppColors.surfaceCream,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner for Premium chat upgrade
          Obx(() {
            final isPremium = profileCtrl.currentProfile.value?.isPremium ?? false;
            if (isPremium) return const SizedBox.shrink();
            
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondaryGold.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Direct Messages Unlocked',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Get Premium to chat directly with matches.',
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Get.toNamed(AppRoutes.subscription),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryMaroon,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Upgrade',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Your Connections',
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.activeChats.isEmpty) {
                return const EmptyState(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'No Chats Yet',
                  description: 'Interests must be sent and accepted before you can start messaging your potential matches.',
                );
              }

              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: controller.activeChats.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  indent: 76,
                  endIndent: 16,
                  color: Color(0xFFF1E6D9),
                ),
                itemBuilder: (context, index) {
                  final item = controller.activeChats[index];
                  final profile = item.profile;
                  final lastMessage = item.lastMessage;
                  final unreadCount = item.unreadCount;
                  
                  final blurImage = false; // Photos are never locked in ProfileModel

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    onTap: () {
                      Get.toNamed(AppRoutes.chat, arguments: profile);
                    },
                    leading: Stack(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: profile.isPremium ? AppColors.secondaryGold : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(26),
                            child: CachedNetworkImage(
                              imageUrl: profile.profilePhoto ?? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&fit=crop&q=80',
                              fit: BoxFit.cover,
                              width: 52,
                              height: 52,
                              placeholder: (context, url) => Container(
                                color: AppColors.surfaceCreamHigh,
                                child: const Center(
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.person),
                              imageBuilder: (context, imageProvider) {
                                if (blurImage) {
                                  return ImageFiltered(
                                    imageFilter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                                    child: Image(image: imageProvider, fit: BoxFit.cover),
                                  );
                                }
                                return Image(image: imageProvider, fit: BoxFit.cover);
                              },
                            ),
                          ),
                        ),
                        if (item.isOnline)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: AppColors.activeGreen,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                    onLongPress: () {
                      // Option to clear chat thread
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                  child: Text(
                                    profile.fullName ?? 'User',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textDark,
                                      fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              if (profile.isVerified) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.verified, color: Colors.blue, size: 16),
                              ],
                              if (profile.isPremium) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.star, color: AppColors.secondaryGold, size: 16),
                              ],
                            ],
                          ),
                        ),
                        if (lastMessage != null)
                          Text(
                            _formatMessageTime(lastMessage.createdAt ?? DateTime.now()),
                            style: GoogleFonts.inter(
                              color: unreadCount > 0 ? AppColors.primaryMaroon : AppColors.textDarkMuted,
                              fontSize: 11,
                              fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _getMessagePreview(lastMessage),
                              style: GoogleFonts.inter(
                                color: unreadCount > 0 ? AppColors.textDark : AppColors.textDarkMuted,
                                fontSize: 13,
                                fontWeight: unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (unreadCount > 0)
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.primaryMaroon,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$unreadCount',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  String _getMessagePreview(MessageModel? message) {
    if (message == null) return "Connected! Start a conversation.";
    return message.message;
  }

  String _formatMessageTime(DateTime time) {
    final now = DateTime.now();
    if (time.year == now.year && time.month == now.month && time.day == now.day) {
      return DateFormat('h:mm a').format(time);
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (time.year == yesterday.year && time.month == yesterday.month && time.day == yesterday.day) {
      return "Yesterday";
    }
    return DateFormat('dd/MM/yyyy').format(time);
  }
}
