import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/shared/custom_snackbar.dart';
import '../../../data/models/complaint_category_model.dart';
import '../../../data/repositories/complaint_repository.dart';
import 'package:file_picker/file_picker.dart';

import '../views/screen/my_complaints_screen.dart';


class ComplaintsController extends GetxController {
  final ComplaintsRepository _repo = ComplaintsRepository();
  final formKey = GlobalKey<FormState>();
  late TextEditingController descriptionController;

  late int tripId;
  late int bookingId;

  var isLoading = false.obs;
  var isCategoriesLoading = false.obs;
  var categories = <ComplaintCategoryModel>[].obs;
  var selectedCategory = Rxn<ComplaintCategoryModel>();
  var selectedFiles = <PlatformFile>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args.containsKey('tripId') && args.containsKey('bookingId')) {
      tripId = args['tripId'];
      bookingId = args['bookingId'];
    } else {
      Get.back();
      CustomSnackBar.showError('Missing trip or booking information');
      return;
    }
    descriptionController = TextEditingController();
    _loadCategories();
  }


  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4'],
    );

    if (result != null) {
      for (var file in result.files) {
        if (!['jpg', 'jpeg', 'png', 'mp4'].contains(file.extension?.toLowerCase())) {
          CustomSnackBar.showError("invalid_file_type".tr);
          continue;
        }

        if (file.size > 5 * 1024 * 1024) {
          CustomSnackBar.showError("file_too_large".trParams({'name': file.name}));
          continue;
        }

        selectedFiles.add(file);
      }
    }
  }

  Future<void> sendComplaint() async {
    if (selectedCategory.value == null) {
      CustomSnackBar.showError("select_category_error".tr);      return;
    }
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final success = await _repo.sendComplaint(
        tripId: tripId,
        bookingId: bookingId,
        categoryId: selectedCategory.value!.id!,
        description: descriptionController.text.trim(),
        files: selectedFiles,
      );

      if (success) {
        // Get.back();
        Get.off(() => const MyComplaintsScreen(),
            arguments: {'refresh': true}
        );
        CustomSnackBar.showSuccess('complaintSentSuccess'.tr);      }
    } catch (e) {
      if (e.toString().contains('SocketException') || e.toString().contains('No internet')) {
        CustomSnackBar.showError('noInternetError'.tr);      } else {
        CustomSnackBar.showError('sendComplaintError'.tr);      }
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> _loadCategories() async {
    isCategoriesLoading.value = true;
    categories.value = await _repo.getCategories();
    isCategoriesLoading.value = false;
  }

  void selectCategory(ComplaintCategoryModel cat) {
    selectedCategory.value = cat;
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
}