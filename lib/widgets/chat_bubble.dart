import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/constants.dart';
import '../models/models.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
      bottomRight: isMe ? Radius.zero : const Radius.circular(16),
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryMaroon : AppColors.surfaceWhite,
          borderRadius: borderRadius,
          border: isMe
              ? null
              : Border.all(color: AppColors.surfaceCreamDim.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryMaroon.withOpacity(0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Media sharing mock UI
            if (message.mediaUrl != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  message.mediaUrl!,
                  fit: .cover,
                  width: double.infinity,
                  height: 160,
                ),
              ),
              const SizedBox(height: 8),
            ],
            
            // Audio attachment mock UI
            if (message.isAudio) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.play_arrow,
                    color: isMe ? Colors.white : AppColors.primaryMaroon,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 120,
                    height: 4,
                    decoration: BoxDecoration(
                      color: (isMe ? Colors.white : AppColors.primaryMaroon).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '0:12',
                    style: TextStyle(
                      color: isMe ? Colors.white70 : AppColors.textDarkMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],

            if (message.content.isNotEmpty)
              Text(
                message.content,
                style: TextStyle(
                  color: isMe ? Colors.white : AppColors.textDark,
                  fontSize: 15,
                  height: 1.3,
                ),
              ),
              
            const SizedBox(height: 4),
            
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  DateFormat('h:mm a').format(message.sentAt),
                  style: TextStyle(
                    color: isMe ? Colors.white70 : AppColors.textDarkMuted,
                    fontSize: 10,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isRead ? Icons.done_all : Icons.done,
                    color: Colors.white70,
                    size: 14,
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
