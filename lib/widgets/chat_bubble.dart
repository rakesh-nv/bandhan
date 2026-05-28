import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/constants.dart';
import '../models/message_model.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
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
            if (message.message.isNotEmpty)
              Text(
                message.message,
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
                  DateFormat('h:mm a').format(message.createdAt ?? DateTime.now()),
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
