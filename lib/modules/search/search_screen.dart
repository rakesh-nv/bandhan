import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants.dart';
import '../../widgets/match_card.dart';
import '../../widgets/profile_card.dart';
import '../../widgets/loading_skeleton.dart';
import '../../routes/routes.dart';
import 'search_controller.dart' as app_search;

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(app_search.SearchController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Matches'),
        actions: [
          // View Grid/List toggle
          Obx(() => IconButton(
                icon: Icon(
                  controller.isGridView.value ? Icons.view_list : Icons.grid_view,
                  color: AppColors.primaryMaroon,
                ),
                onPressed: controller.toggleView,
              )),
          // Sorting popup menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: AppColors.primaryMaroon),
            onSelected: controller.updateSort,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'compatibility', child: Text('Sort by Compatibility')),
              const PopupMenuItem(value: 'age', child: Text('Sort by Age')),
              const PopupMenuItem(value: 'recentlyJoined', child: Text('Sort by Recently Joined')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter summary bar containing chips and Filters toggle
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.surfaceCreamDim.withOpacity(0.2),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Obx(() => Row(
                            children: [
                              _buildFilterChip('Age: ${controller.minAge.value.toInt()}-${controller.maxAge.value.toInt()}'),
                              _buildFilterChip('Rel: ${controller.religion.value}'),
                              _buildFilterChip('Comm: ${controller.community.value}'),
                              if (controller.minSalary.value > 0)
                                _buildFilterChip('Salary: ₹${controller.minSalary.value.toInt()}L+'),
                            ],
                          )),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    style: TextButton.styleFrom(foregroundColor: AppColors.primaryMaroon),
                    icon: const Icon(Icons.tune, size: 18),
                    label: const Text('Filters', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () => _showFilterBottomSheet(context, controller),
                  ),
                ],
              ),
            ),

            // Matches Results Grid/List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: MatchCardSkeleton(),
                  );
                }

                if (controller.searchResults.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_outlined, size: 64, color: AppColors.surfaceCreamDim),
                        const SizedBox(height: 16),
                        const Text(
                          'No matches found',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Try broadening your filter preferences',
                          style: TextStyle(color: AppColors.textDarkMuted),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: controller.resetFilters,
                          child: const Text('Reset All Filters'),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.isGridView.value) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: controller.searchResults.length,
                    itemBuilder: (context, index) {
                      final profile = controller.searchResults[index];
                      return MatchCard(
                        profile: profile,
                        onTap: () => Get.toNamed(AppRoutes.profileDetails, arguments: profile),
                      );
                    },
                  );
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.searchResults.length,
                    itemBuilder: (context, index) {
                      final profile = controller.searchResults[index];
                      return ProfileCard(
                        profile: profile,
                        initialSent: false,
                        onTap: () => Get.toNamed(AppRoutes.profileDetails, arguments: profile),
                        onSendInterest: () => ctrlSendInterest(profile.id),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Stub function to trigger interest from controller
  Future<void> ctrlSendInterest(String id) async {
    final searchCtrl = Get.find<app_search.SearchController>();
    // Call interest api
    await searchCtrl.dbService.sendInterest(id);
  }

  Widget _buildFilterChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        border: Border.all(color: AppColors.surfaceCreamDim),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, color: AppColors.textDarkMuted, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Bottom sheet modal for advanced filter settings
  void _showFilterBottomSheet(BuildContext context, app_search.SearchController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(AppSpacing.padding),
        decoration: const BoxDecoration(
          color: AppColors.surfaceCream,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.container)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Search Filters',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryMaroon,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.resetFilters();
                      Get.back();
                    },
                    child: const Text('Reset All', style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),

              // Age Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Age Range', style: TextStyle(fontWeight: FontWeight.bold)),
                  Obx(() => Text(
                        '${controller.minAge.value.toInt()} - ${controller.maxAge.value.toInt()} yrs',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryMaroon),
                      )),
                ],
              ),
              Obx(() => RangeSlider(
                    values: RangeValues(controller.minAge.value, controller.maxAge.value),
                    min: 18,
                    max: 60,
                    activeColor: AppColors.primaryMaroon,
                    inactiveColor: AppColors.surfaceCreamDim,
                    onChanged: (values) {
                      controller.minAge.value = values.start;
                      controller.maxAge.value = values.end;
                    },
                  )),
              const SizedBox(height: 16),

              // Height Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Height (cm)', style: TextStyle(fontWeight: FontWeight.bold)),
                  Obx(() => Text(
                        '${controller.minHeight.value.toInt()} - ${controller.maxHeight.value.toInt()} cm',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryMaroon),
                      )),
                ],
              ),
              Obx(() => RangeSlider(
                    values: RangeValues(controller.minHeight.value, controller.maxHeight.value),
                    min: 130,
                    max: 220,
                    activeColor: AppColors.primaryMaroon,
                    inactiveColor: AppColors.surfaceCreamDim,
                    onChanged: (values) {
                      controller.minHeight.value = values.start;
                      controller.maxHeight.value = values.end;
                    },
                  )),
              const SizedBox(height: 16),

              // Religion dropdown
              const Text('Religion', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.religion.value,
                    items: controller.religions.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                    onChanged: (val) {
                      if (val != null) controller.religion.value = val;
                    },
                  )),
              const SizedBox(height: 16),

              // Community dropdown
              const Text('Community / Caste', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.community.value,
                    items: controller.communities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) {
                      if (val != null) controller.community.value = val;
                    },
                  )),
              const SizedBox(height: 16),

              // Marital Status dropdown
              const Text('Marital Status', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.maritalStatus.value,
                    items: controller.maritalStatuses.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                    onChanged: (val) {
                      if (val != null) controller.maritalStatus.value = val;
                    },
                  )),
              const SizedBox(height: 24),

              // Apply Filters Action button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.applyFilters();
                    Get.back();
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
