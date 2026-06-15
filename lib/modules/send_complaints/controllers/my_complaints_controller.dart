import 'package:get/get.dart';
import '../../../data/models/complaint_model.dart';
import '../../../data/repositories/complaint_repository.dart';


class MyComplaintsController extends GetxController {
  final ComplaintsRepository _repo = ComplaintsRepository();

  var complaints = <ComplaintModel>[].obs;
  var isLoading = false.obs;
  var hasError = false.obs;

  @override
  void onInit() {
    fetchComplaints();
    super.onInit();
  }

  Future<void> fetchComplaints() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final result = await _repo.getComplaints();
      complaints.assignAll(result);
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
