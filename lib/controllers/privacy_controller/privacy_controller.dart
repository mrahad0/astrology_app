import 'package:get/get.dart';
import '../../data/models/privacy_model/privacy_model.dart';
import '../../data/services/api_checker.dart';
import '../../data/services/api_client.dart';
import '../../data/services/api_constant.dart';

class PrivacypolicyController extends GetxController {
  var isLoading = false.obs;
  var policyList = <PrivacyModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPrivacyPolicy();
  }

  Future<void> fetchPrivacyPolicy() async {
    try {
      isLoading(true);

      final response = await ApiClient.getData(ApiConstant.privacypolicy);

      if (response.statusCode == 200 || response.statusCode == 201) {
        policyList.clear();
        final data = PrivacyModel.fromJson(response.body);
        policyList.add(data);
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }
}