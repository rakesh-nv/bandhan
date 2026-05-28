# UI Integration Guide for Bandhan Matrimony

This guide provides examples on how to integrate your existing hardcoded Flutter UI with the GetX controllers generated for the backend.

## 1. Authentication (Login/Signup)

In your existing `LoginScreen`, bind the UI to the `AuthController`.

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bandhan/controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (authController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            TextField(controller: emailCtrl, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passCtrl, decoration: InputDecoration(labelText: 'Password')),
            ElevatedButton(
              onPressed: () async {
                bool success = await authController.login(emailCtrl.text, passCtrl.text);
                if (success) {
                  Get.offAllNamed('/home');
                }
              },
              child: Text('Login'),
            )
          ],
        );
      }),
    );
  }
}
```

## 2. Discover Profiles (Pagination & Filters)

In your `DiscoverScreen`, use `DiscoverController` to show the list of matching profiles instead of mock data.

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bandhan/controllers/discover_controller.dart';

class DiscoverScreen extends StatelessWidget {
  final DiscoverController discoverController = Get.find<DiscoverController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Discover Matches')),
      body: Obx(() {
        if (discoverController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (discoverController.discoverProfiles.isEmpty) {
          return Center(child: Text('No profiles found'));
        }
        
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!discoverController.isFetchingMore.value && 
                scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
              discoverController.fetchMore();
            }
            return false;
          },
          child: ListView.builder(
            itemCount: discoverController.discoverProfiles.length + 1,
            itemBuilder: (context, index) {
              if (index == discoverController.discoverProfiles.length) {
                 return discoverController.isFetchingMore.value 
                     ? Center(child: CircularProgressIndicator()) 
                     : SizedBox.shrink();
              }
              final profile = discoverController.discoverProfiles[index];
              return ListTile(
                title: Text(profile.fullName ?? 'Unknown'),
                subtitle: Text('\${profile.age} yrs • \${profile.profession}'),
                onTap: () => Get.toNamed('/profile_detail', arguments: profile),
              );
            },
          ),
        );
      }),
    );
  }
}
```

## 3. Sending an Interest

In the `ProfileDetailScreen` where you have a "Send Interest" button.

```dart
import 'package:get/get.dart';
import 'package:bandhan/controllers/interest_controller.dart';

// Inside your build method:
final InterestController interestCtrl = Get.find<InterestController>();
final profile = Get.arguments; // Assuming you passed ProfileModel

ElevatedButton(
  onPressed: interestCtrl.isLoading.value ? null : () {
    interestCtrl.sendInterest(profile.id);
  },
  child: Obx(() => interestCtrl.isLoading.value 
      ? CircularProgressIndicator() 
      : Text('Send Interest')
  ),
)
```

## 4. Realtime Chat

In your `ChatRoomScreen`.

```dart
import 'package:get/get.dart';
import 'package:bandhan/controllers/chat_controller.dart';

class ChatRoomScreen extends StatefulWidget {
  final String matchId;
  final String otherUserId;
  
  ChatRoomScreen({required this.matchId, required this.otherUserId});
  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final ChatController chatCtrl = Get.find<ChatController>();
  final TextEditingController msgCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch old messages and mark as read
    chatCtrl.openChatRoom(widget.matchId, widget.otherUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (chatCtrl.isLoading.value) return Center(child: CircularProgressIndicator());
              
              return ListView.builder(
                reverse: true, // newest messages at the bottom
                itemCount: chatCtrl.messages.length,
                itemBuilder: (context, index) {
                  final msg = chatCtrl.messages[index];
                  bool isMe = msg.senderId == Get.find<AuthService>().currentUserId;
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(12),
                      color: isMe ? Colors.blue[100] : Colors.grey[200],
                      child: Text(msg.message),
                    ),
                  );
                },
              );
            }),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: msgCtrl,
                  decoration: InputDecoration(hintText: 'Type a message...'),
                )
              ),
              IconButton(
                icon: Icon(Icons.send),
                onAction: () {
                  chatCtrl.sendMessage(msgCtrl.text);
                  msgCtrl.clear();
                },
              )
            ],
          )
        ],
      )
    );
  }
}
```
