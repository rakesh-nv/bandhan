import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'hub_controller.dart';
import '../../core/constants.dart';
import '../../models/interest_model.dart';
import '../../routes/routes.dart';

class MatchesTab extends StatelessWidget {
  const MatchesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          // Inner Tab Bar
          TabBar(
            labelColor: AppColors.primaryMaroon,
            unselectedLabelColor: AppColors.textDarkMuted,
            indicatorColor: AppColors.primaryMaroon,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: const [
              Tab(text: 'Received'),
              Tab(text: 'Sent'),
              Tab(text: 'Accepted'),
            ],
          ),
          
          // Tab views
          Expanded(
            child: GetBuilder<HubController>(
              builder: (ctrl) {
                return TabBarView(
                  children: [
                    _buildReceivedList(context, ctrl),
                    _buildSentList(context, ctrl),
                    _buildAcceptedList(context, ctrl),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceivedList(BuildContext context, HubController ctrl) {
    final list = ctrl.receivedInterests;
    if (list.isEmpty) {
      return const Center(
        child: Text('No interests received yet.', style: TextStyle(color: AppColors.textDarkMuted)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final interest = list[index];
        final profile = interest.otherProfile;

        if (profile == null) return const SizedBox.shrink();

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(profile.profilePhoto ?? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&fit=crop&q=80'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.fullName ?? 'User',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${profile.age ?? 25} yrs • ${profile.profession ?? "Not specified"}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textDarkMuted),
                      ),
                    ],
                  ),
                ),
                // Accept/Reject Actions
                IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green, size: 28),
                  onPressed: () => ctrl.acceptInterest(interest),
                ),
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.redAccent, size: 28),
                  onPressed: () => ctrl.rejectInterest(interest.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSentList(BuildContext context, HubController ctrl) {
    final list = ctrl.sentInterests;
    if (list.isEmpty) {
      return const Center(
        child: Text('You haven\'t sent any interests yet.', style: TextStyle(color: AppColors.textDarkMuted)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final interest = list[index];
        final profile = interest.otherProfile;

        if (profile == null) return const SizedBox.shrink();

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(profile.profilePhoto ?? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&fit=crop&q=80'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.fullName ?? 'User',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Status: ${interest.status.toUpperCase()}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: interest.status == 'accepted'
                              ? Colors.green
                              : interest.status == 'pending'
                                  ? AppColors.secondaryGold
                                  : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  interest.status == 'accepted'
                      ? Icons.check_circle_outline
                      : Icons.hourglass_top_outlined,
                  color: interest.status == 'accepted' ? Colors.green : AppColors.secondaryGold,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAcceptedList(BuildContext context, HubController ctrl) {
    final list = ctrl.acceptedInterests;
    if (list.isEmpty) {
      return const Center(
        child: Text('No accepted matches yet. Keep exploring!', style: TextStyle(color: AppColors.textDarkMuted)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final interest = list[index];
        final profile = interest.otherProfile;

        if (profile == null) return const SizedBox.shrink();

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(profile.profilePhoto ?? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&fit=crop&q=80'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.fullName ?? 'User',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Connected! Click to message.',
                        style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble, color: AppColors.primaryMaroon),
                  onPressed: () {
                    // Navigate to conversation
                    Get.toNamed(AppRoutes.chat, arguments: profile);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
