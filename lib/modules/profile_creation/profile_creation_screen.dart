import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants.dart';
import '../../models/models.dart';
import 'profile_creation_controller.dart';

class ProfileCreationScreen extends StatelessWidget {
  const ProfileCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileCreationController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Progress bar
            Obx(() {
              final step = controller.currentStep.value;
              final percent = (step + 1) / controller.totalSteps;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.margin, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Step ${step + 1} of ${controller.totalSteps}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryMaroon),
                        ),
                        Text(
                          '${(percent * 100).toInt()}% Done',
                          style: const TextStyle(color: AppColors.textDarkMuted, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 4,
                    width: double.infinity,
                    color: AppColors.surfaceCreamDim.withOpacity(0.5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: percent,
                        child: Container(
                          color: AppColors.primaryMaroon,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),

            // Steps views container
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.padding),
                child: Obx(() {
                  switch (controller.currentStep.value) {
                    case 0:
                      return _buildStep1(context, controller);
                    case 1:
                      return _buildStep2(context, controller);
                    case 2:
                      return _buildStep3(context, controller);
                    case 3:
                      return _buildStep4(context, controller);
                    default:
                      return const SizedBox.shrink();
                  }
                }),
              ),
            ),

            // Bottom Navigation buttons
            Container(
              padding: const EdgeInsets.all(AppSpacing.padding),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Back button
                  Obx(() {
                    final step = controller.currentStep.value;
                    if (step == 0) return const SizedBox.shrink();
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: OutlinedButton(
                          onPressed: controller.previousStep,
                          child: const Text('Back'),
                        ),
                      ),
                    );
                  }),

                  // Next / Save button
                  Expanded(
                    child: Obx(() {
                      final isLast = controller.currentStep.value == controller.totalSteps - 1;
                      return ElevatedButton(
                        onPressed: controller.isSubmitting.value ? null : controller.nextStep,
                        child: controller.isSubmitting.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Text(isLast ? 'Submit Profile' : 'Next Step'),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 1: Personal Details View
  Widget _buildStep1(BuildContext context, ProfileCreationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Details',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryMaroon,
              ),
        ),
        const SizedBox(height: 8),
        const Text('Provide your basic physical and profile identifiers.', style: TextStyle(color: AppColors.textDarkMuted)),
        const SizedBox(height: 32),

        // Gender Selector
        const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Obx(() {
                final isMale = controller.selectedGender.value == Gender.male;
                return InkWell(
                  onTap: () => controller.selectedGender.value = Gender.male,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isMale ? AppColors.primaryMaroon.withOpacity(0.05) : AppColors.surfaceWhite,
                      border: Border.all(
                        color: isMale ? AppColors.primaryMaroon : AppColors.surfaceCreamDim,
                        width: isMale ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.input),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.male, color: isMale ? AppColors.primaryMaroon : Colors.grey, size: 28),
                        const SizedBox(height: 8),
                        Text('Male', style: TextStyle(color: isMale ? AppColors.primaryMaroon : AppColors.textDark, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Obx(() {
                final isFemale = controller.selectedGender.value == Gender.female;
                return InkWell(
                  onTap: () => controller.selectedGender.value = Gender.female,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isFemale ? AppColors.primaryMaroon.withOpacity(0.05) : AppColors.surfaceWhite,
                      border: Border.all(
                        color: isFemale ? AppColors.primaryMaroon : AppColors.surfaceCreamDim,
                        width: isFemale ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.input),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.female, color: isFemale ? AppColors.primaryMaroon : Colors.grey, size: 28),
                        const SizedBox(height: 8),
                        Text('Female', style: TextStyle(color: isFemale ? AppColors.primaryMaroon : AppColors.textDark, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Date of Birth DatePicker
        const Text('Date of Birth', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
              firstDate: DateTime(1950),
              lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
            );
            if (picked != null) {
              controller.dob.value = picked;
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              border: Border.all(color: AppColors.surfaceCreamDim),
              borderRadius: BorderRadius.circular(AppRadius.input),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                      controller.dob.value != null
                          ? DateFormat('dd MMMM yyyy').format(controller.dob.value!)
                          : 'Select Date of Birth',
                      style: TextStyle(
                        color: controller.dob.value != null ? AppColors.textDark : Colors.grey,
                        fontSize: 16,
                      ),
                    )),
                const Icon(Icons.calendar_month, color: AppColors.primaryMaroon),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Height & Weight
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Height (cm)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.heightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'e.g. 172'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Weight (kg)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'e.g. 64'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Marital Status
        const Text('Marital Status', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<MaritalStatus>(
          value: controller.selectedMaritalStatus.value,
          decoration: const InputDecoration(),
          items: MaritalStatus.values.map((status) {
            String label = 'Never Married';
            if (status == MaritalStatus.divorced) label = 'Divorced';
            if (status == MaritalStatus.widowed) label = 'Widowed';
            if (status == MaritalStatus.awaitingDivorce) label = 'Awaiting Divorce';
            return DropdownMenuItem(
              value: status,
              child: Text(label),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              controller.selectedMaritalStatus.value = val;
            }
          },
        ),
      ],
    );
  }

  // Step 2: Cultural / Background
  Widget _buildStep2(BuildContext context, ProfileCreationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cultural & Region',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryMaroon,
              ),
        ),
        const SizedBox(height: 8),
        const Text('Help matches discover you within community guidelines.', style: TextStyle(color: AppColors.textDarkMuted)),
        const SizedBox(height: 32),

        // Religion selection dropdown
        const Text('Religion', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: controller.selectedReligion.value,
          items: controller.religionsList.map((religion) {
            return DropdownMenuItem(value: religion, child: Text(religion));
          }).toList(),
          onChanged: (val) {
            if (val != null) controller.selectedReligion.value = val;
          },
        ),
        const SizedBox(height: 24),

        // Caste / Community selection dropdown
        const Text('Community / Caste', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: controller.selectedCommunity.value,
          items: controller.communitiesList.map((community) {
            return DropdownMenuItem(value: community, child: Text(community));
          }).toList(),
          onChanged: (val) {
            if (val != null) controller.selectedCommunity.value = val;
          },
        ),
        const SizedBox(height: 24),

        // Mother tongue
        const Text('Mother Tongue', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.motherTongueController,
          decoration: const InputDecoration(
            hintText: 'e.g. Hindi, Tamil, Bengali',
          ),
        ),
        const SizedBox(height: 24),

        // Location
        const Text('Current Location (City, State)', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.locationController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.location_on_outlined),
            hintText: 'e.g. Pune, Maharashtra',
          ),
        ),
      ],
    );
  }

  // Step 3: Professional Details
  Widget _buildStep3(BuildContext context, ProfileCreationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Education & Profession',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryMaroon,
              ),
        ),
        const SizedBox(height: 8),
        const Text('Let candidates know about your academic and career achievements.', style: TextStyle(color: AppColors.textDarkMuted)),
        const SizedBox(height: 32),

        // Education
        const Text('Education / Degree', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.educationController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.school_outlined),
            hintText: 'e.g. B.Tech, MBA, MD',
          ),
        ),
        const SizedBox(height: 24),

        // Profession
        const Text('Profession', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.professionController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.work_outline),
            hintText: 'e.g. Software Engineer, Doctor, CA',
          ),
        ),
        const SizedBox(height: 24),

        // Salary
        const Text('Annual Salary (LPA in ₹)', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.salaryController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.currency_rupee),
            hintText: 'e.g. 15.5',
          ),
        ),
        const SizedBox(height: 24),

        // Bio/About Me
        const Text('About Me (Bio)', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.bioController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Write a few lines describing your personality, values, and what you are looking for in a partner...',
          ),
        ),
      ],
    );
  }

  // Step 4: Family Details & Preferences
  Widget _buildStep4(BuildContext context, ProfileCreationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Family & Preferences',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryMaroon,
              ),
        ),
        const SizedBox(height: 8),
        const Text('Optional details to clarify partner search guidelines.', style: TextStyle(color: AppColors.textDarkMuted)),
        const SizedBox(height: 32),

        // Family Details
        const Text('Family Details', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.familyController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Briefly mention family background (e.g. Parents occupations, siblings details)',
          ),
        ),
        const SizedBox(height: 32),

        // Partner Preferences Header
        Text(
          'Partner Preferences',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryMaroon,
          ),
        ),
        const Divider(),
        const SizedBox(height: 16),

        // Partner Age range slider
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Preferred Age Range', style: TextStyle(fontWeight: FontWeight.w600)),
            Obx(() => Text(
                  '${controller.minPartnerAge.value.toInt()} - ${controller.maxPartnerAge.value.toInt()} yrs',
                  style: const TextStyle(color: AppColors.primaryMaroon, fontWeight: FontWeight.bold),
                )),
          ],
        ),
        Obx(() => RangeSlider(
              values: RangeValues(controller.minPartnerAge.value, controller.maxPartnerAge.value),
              min: 18,
              max: 60,
              activeColor: AppColors.primaryMaroon,
              inactiveColor: AppColors.surfaceCreamDim,
              onChanged: (values) {
                controller.minPartnerAge.value = values.start;
                controller.maxPartnerAge.value = values.end;
              },
            )),
        const SizedBox(height: 16),

        // Partner Min Salary
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Minimum Partner Salary', style: TextStyle(fontWeight: FontWeight.w600)),
            Obx(() => Text(
                  '₹${controller.minPartnerSalary.value.toInt()} LPA+',
                  style: const TextStyle(color: AppColors.primaryMaroon, fontWeight: FontWeight.bold),
                )),
          ],
        ),
        Obx(() => Slider(
              value: controller.minPartnerSalary.value,
              min: 0,
              max: 100,
              activeColor: AppColors.primaryMaroon,
              inactiveColor: AppColors.surfaceCreamDim,
              onChanged: (val) {
                controller.minPartnerSalary.value = val;
              },
            )),
      ],
    );
  }
}
