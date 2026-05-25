import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants.dart';
import '../../models/models.dart';
import '../../widgets/chat_bubble.dart';
import '../../routes/routes.dart';
import 'chat_controller.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController controller = Get.find<ChatController>();
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  late UserProfile otherUser;

  @override
  void initState() {
    super.initState();
    otherUser = Get.arguments as UserProfile;
    controller.loadChatMessages(otherUser.id);
    
    // Scroll to bottom after frame rendering
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Auto scroll on new messages
    ever(controller.currentChatMessages, (_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollToBottom();
      });
    });
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserPremium = controller.dbService.currentUser.value?.isPremium ?? false;
    final blurImage = otherUser.photosLocked && !currentUserPremium;

    return Scaffold(
      backgroundColor: AppColors.surfaceCream,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.surfaceWhite,
        iconTheme: const IconThemeData(color: AppColors.primaryMaroon),
        elevation: 0.5,
        title: InkWell(
          onTap: () => Get.toNamed(AppRoutes.profileDetails, arguments: otherUser),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: otherUser.isPremium ? AppColors.secondaryGold : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(19),
                  child: CachedNetworkImage(
                    imageUrl: otherUser.photoUrls.isNotEmpty
                        ? otherUser.photoUrls.first
                        : AppPlaceholderImages.avatarFemale1,
                    fit: BoxFit.cover,
                    width: 38,
                    height: 38,
                    imageBuilder: (context, imageProvider) {
                      if (blurImage) {
                        return ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                          child: Image(image: imageProvider, fit: BoxFit.cover),
                        );
                      }
                      return Image(image: imageProvider, fit: BoxFit.cover);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            otherUser.name,
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (otherUser.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, color: Colors.blue, size: 14),
                        ],
                      ],
                    ),
                    Obx(() {
                      if (controller.isTyping.value) {
                        return Text(
                          'typing...',
                          style: GoogleFonts.inter(
                            color: AppColors.primaryMaroon,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }
                      return Text(
                        otherUser.id == 'usr_2' ? 'Online' : 'Active 2h ago',
                        style: GoogleFonts.inter(
                          color: otherUser.id == 'usr_2' ? AppColors.activeGreen : AppColors.textDarkMuted,
                          fontSize: 11,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'kundali') {
                _showKundaliDialog();
              } else if (value == 'block') {
                Get.back();
                Get.snackbar('Blocked', '${otherUser.name} has been blocked.',
                    backgroundColor: AppColors.textDark, colorText: Colors.white);
              } else if (value == 'report') {
                _showReportDialog();
              }
            },
            icon: const Icon(Icons.more_vert, color: AppColors.primaryMaroon),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'kundali',
                child: Row(
                  children: [
                    const Icon(Icons.star_half, color: AppColors.secondaryGold, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'View Kundali Match',
                      style: GoogleFonts.plusJakartaSans(color: AppColors.textDark),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'block',
                child: Row(
                  children: const [
                    Icon(Icons.block, color: AppColors.errorRed, size: 18),
                    SizedBox(width: 8),
                    Text('Block Member'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'report',
                child: Row(
                  children: const [
                    Icon(Icons.flag_outlined, color: AppColors.errorRed, size: 18),
                    SizedBox(width: 8),
                    Text('Report Profile'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Match compatibility notice
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            color: AppColors.tertiaryPink.withOpacity(0.2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite, color: AppColors.primaryMaroon, size: 14),
                const SizedBox(width: 6),
                Text(
                  'Community Compatibility: 96% Match (${otherUser.religion} - ${otherUser.community})',
                  style: GoogleFonts.inter(
                    color: AppColors.primaryMaroon,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Obx(() {
              if (controller.currentChatMessages.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryMaroon.withOpacity(0.05),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.lock_outline, color: AppColors.primaryMaroon, size: 28),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Matches Are End-to-End Encrypted',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Text(
                          'Your safety is our priority. Direct contact sharing is disabled for basic users.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: AppColors.textDarkMuted,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: controller.currentChatMessages.length,
                itemBuilder: (context, index) {
                  final msg = controller.currentChatMessages[index];
                  final isMe = msg.senderId == 'usr_curr';
                  return ChatBubble(message: msg, isMe: isMe);
                },
              );
            }),
          ),

          // Typing status indicator bubble row
          Obx(() {
            if (!controller.isTyping.value) return const SizedBox.shrink();
            return Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                child: Row(
                  children: [
                    Text(
                      '${otherUser.name} is typing',
                      style: GoogleFonts.inter(
                        color: AppColors.textDarkMuted,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 1.5, color: AppColors.primaryMaroon),
                    ),
                  ],
                ),
              ),
            );
          }),

          // Input Bar
          Container(
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              bottom: MediaQuery.of(context).padding.bottom + 8,
              top: 8,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Attachments button
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryMaroon),
                  onPressed: _showAttachmentSheet,
                ),
                
                // Text Input
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCream,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.surfaceCreamDim, width: 0.8),
                    ),
                    child: TextField(
                      controller: textEditingController,
                      style: GoogleFonts.inter(color: AppColors.textDark, fontSize: 15),
                      maxLines: 4,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: GoogleFonts.inter(color: AppColors.textDarkMuted, fontSize: 14),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Voice Message Button
                IconButton(
                  icon: const Icon(Icons.mic, color: AppColors.primaryMaroon),
                  onPressed: () {
                    controller.sendAudioMessage();
                    Get.snackbar('Voice Shared', 'Sent voice message mock.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.primaryMaroon,
                        colorText: Colors.white);
                  },
                ),
                
                // Send Button
                GestureDetector(
                  onTap: () {
                    if (textEditingController.text.trim().isNotEmpty) {
                      controller.sendTextMessage(textEditingController.text);
                      textEditingController.clear();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryMaroon,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAttachmentSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Share with Match',
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textDark,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAttachmentOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  color: Colors.orange,
                  onTap: () {
                    Get.back();
                    // Mock send venue image
                    controller.sendMediaMessage('https://images.unsplash.com/photo-1519741497674-611481863552?w=500&fit=crop&q=80');
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  color: Colors.blue,
                  onTap: () {
                    Get.back();
                    // Mock send ring image
                    controller.sendMediaMessage('https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=500&fit=crop&q=80');
                  },
                ),
                _buildAttachmentOption(
                  icon: Icons.star_border,
                  label: 'Kundali PDF',
                  color: AppColors.secondaryGold,
                  onTap: () {
                    Get.back();
                    controller.sendTextMessage("Shared Kundali PDF. Ready for matchup analysis.");
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppColors.textDark,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showKundaliDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_half, color: AppColors.secondaryGold, size: 48),
              const SizedBox(height: 16),
              Text(
                'Kundali Match Analysis',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Calculated Gun Milan: 32 / 36 Gunas match!\n\nThis is an exceptionally compatible match according to Vedic astrology. Ganas, Bhakoot and Nadi points show excellent alignment.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: AppColors.textDarkMuted, fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryMaroon,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                ),
                child: Text('Close', style: GoogleFonts.plusJakartaSans(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReportDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Report Member',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select a reason to flag this account. Our support administrators will review and take immediate action.',
              style: GoogleFonts.inter(color: AppColors.textDarkMuted, fontSize: 13),
            ),
            const SizedBox(height: 8),
            _buildReportReasonItem('Fake Profile / Incorrect Details'),
            _buildReportReasonItem('Abusive Language or Behavior'),
            _buildReportReasonItem('Commercial Advertisement / Spam'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: GoogleFonts.plusJakartaSans(color: AppColors.textDarkMuted)),
          ),
        ],
      ),
    );
  }

  Widget _buildReportReasonItem(String reason) {
    return ListTile(
      title: Text(reason, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textDark)),
      trailing: const Icon(Icons.chevron_right, size: 16),
      dense: true,
      onTap: () {
        Get.back();
        Get.snackbar('Report Submitted', 'Thank you for reporting. We will investigate this.',
            backgroundColor: AppColors.primaryMaroon, colorText: Colors.white);
      },
    );
  }
}
