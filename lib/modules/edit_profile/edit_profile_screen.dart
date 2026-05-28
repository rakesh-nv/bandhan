import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants.dart';
import 'edit_profile_controller.dart';
import '../../widgets/profile_image_picker.dart';
import '../../widgets/gallery_image_grid.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());

    return Scaffold(
      backgroundColor: AppColors.surfaceCream,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
        actions: [
          Obx(() => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton(
                  onPressed: controller.isSaving.value ? null : controller.saveProfile,
                  child: controller.isSaving.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primaryMaroon,
                          ),
                        )
                      : Text(
                          'Save',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.primaryMaroon,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                ),
              )),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // ── Profile Photo Section ──
            ProfileImagePicker(controller: controller.profileCtrl),
            const SizedBox(height: 24),

            // ── Gallery Images Section ──
            GalleryImageGrid(controller: controller.profileCtrl),
            const SizedBox(height: 24),

            // ── Personal Details ──
            _buildSectionCard(
              context,
              title: 'Personal Details',
              icon: Icons.person_outline,
              children: [
                _buildTextField(
                  controller: controller.fullNameController,
                  label: 'Full Name',
                  icon: Icons.badge_outlined,
                ),
                const SizedBox(height: 16),
                _buildGenderSelector(controller),
                const SizedBox(height: 16),
                _buildDateOfBirthPicker(context, controller),
              ],
            ),

            // ── Cultural & Location ──
            _buildSectionCard(
              context,
              title: 'Cultural & Location',
              icon: Icons.temple_hindu_outlined,
              children: [
                _buildDropdown<String>(
                  label: 'Religion',
                  value: controller.selectedReligion,
                  items: controller.religionsList,
                  icon: Icons.auto_awesome_outlined,
                ),
                const SizedBox(height: 16),
                _buildDropdown<String>(
                  label: 'Community',
                  value: controller.selectedCommunity,
                  items: controller.communitiesList,
                  icon: Icons.groups_outlined,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: controller.cityController,
                  label: 'City / Location',
                  icon: Icons.location_on_outlined,
                ),
              ],
            ),

            // ── Education & Career ──
            _buildSectionCard(
              context,
              title: 'Education & Career',
              icon: Icons.school_outlined,
              children: [
                _buildTextField(
                  controller: controller.educationController,
                  label: 'Education / Degree',
                  icon: Icons.menu_book_outlined,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: controller.professionController,
                  label: 'Profession',
                  icon: Icons.work_outline,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: controller.companyNameController,
                  label: 'Company Name',
                  icon: Icons.business_outlined,
                ),
              ],
            ),

            // ── About Me ──
            _buildSectionCard(
              context,
              title: 'About Me',
              icon: Icons.edit_note,
              children: [
                _buildTextField(
                  controller: controller.bioController,
                  label: 'Bio',
                  icon: Icons.short_text,
                  maxLines: 4,
                  hintText:
                      'Write about your personality, values, hobbies and what you look for in a partner...',
                ),
              ],
            ),

            // ── Save Button at bottom ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Obx(() => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: controller.isSaving.value ? null : controller.saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryMaroon,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.button),
                        ),
                        elevation: 2,
                      ),
                      child: controller.isSaving.value
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              'Save Changes',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  )),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }



  // ═══════════════════════════════════════════════════════════
  //  Section Card
  // ═══════════════════════════════════════════════════════════
  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryMaroon.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primaryMaroon, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  Text Field
  // ═══════════════════════════════════════════════════════════
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? hintText,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.inter(fontSize: 15, color: AppColors.textDark),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        labelStyle: GoogleFonts.inter(color: AppColors.textDarkMuted, fontSize: 14),
        hintStyle: GoogleFonts.inter(color: AppColors.textDarkMuted.withOpacity(0.5), fontSize: 13),
        prefixIcon: Icon(icon, color: AppColors.primaryMaroon, size: 20),
        filled: true,
        fillColor: AppColors.surfaceCream,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: AppColors.surfaceCreamDim),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: AppColors.surfaceCreamDim),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.primaryMaroon, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  Gender Selector
  // ═══════════════════════════════════════════════════════════
  Widget _buildGenderSelector(EditProfileController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _genderOption(controller, 'male', Icons.male, 'Male')),
            const SizedBox(width: 12),
            Expanded(child: _genderOption(controller, 'female', Icons.female, 'Female')),
          ],
        ),
      ],
    );
  }

  Widget _genderOption(
    EditProfileController controller,
    String value,
    IconData icon,
    String label,
  ) {
    return Obx(() {
      final isSelected = controller.selectedGender.value == value;
      return InkWell(
        onTap: () => controller.selectedGender.value = value,
        borderRadius: BorderRadius.circular(AppRadius.input),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryMaroon.withOpacity(0.06)
                : AppColors.surfaceCream,
            border: Border.all(
              color: isSelected ? AppColors.primaryMaroon : AppColors.surfaceCreamDim,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(AppRadius.input),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: isSelected ? AppColors.primaryMaroon : Colors.grey, size: 26),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: isSelected ? AppColors.primaryMaroon : AppColors.textDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ═══════════════════════════════════════════════════════════
  //  Date of Birth Picker
  // ═══════════════════════════════════════════════════════════
  Widget _buildDateOfBirthPicker(
    BuildContext context,
    EditProfileController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date of Birth',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: controller.dob.value ??
                  DateTime.now().subtract(const Duration(days: 365 * 25)),
              firstDate: DateTime(1950),
              lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: AppColors.primaryMaroon,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              controller.dob.value = picked;
            }
          },
          borderRadius: BorderRadius.circular(AppRadius.input),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceCream,
              border: Border.all(color: AppColors.surfaceCreamDim),
              borderRadius: BorderRadius.circular(AppRadius.input),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month, color: AppColors.primaryMaroon, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() => Text(
                        controller.dob.value != null
                            ? DateFormat('dd MMMM yyyy').format(controller.dob.value!)
                            : 'Select Date of Birth',
                        style: GoogleFonts.inter(
                          color: controller.dob.value != null
                              ? AppColors.textDark
                              : AppColors.textDarkMuted.withOpacity(0.5),
                          fontSize: 15,
                        ),
                      )),
                ),
                const Icon(Icons.arrow_drop_down, color: AppColors.textDarkMuted),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  Dropdown
  // ═══════════════════════════════════════════════════════════
  Widget _buildDropdown<T>({
    required String label,
    required Rx<String?> value,
    required List<String> items,
    required IconData icon,
  }) {
    return Obx(() => DropdownButtonFormField<String>(
          value: items.contains(value.value) ? value.value : null,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.inter(color: AppColors.textDarkMuted, fontSize: 14),
            prefixIcon: Icon(icon, color: AppColors.primaryMaroon, size: 20),
            filled: true,
            fillColor: AppColors.surfaceCream,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.input),
              borderSide: BorderSide(color: AppColors.surfaceCreamDim),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.input),
              borderSide: BorderSide(color: AppColors.surfaceCreamDim),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.input),
              borderSide: const BorderSide(color: AppColors.primaryMaroon, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          style: GoogleFonts.inter(fontSize: 15, color: AppColors.textDark),
          dropdownColor: Colors.white,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) value.value = val;
          },
        ));
  }
}
