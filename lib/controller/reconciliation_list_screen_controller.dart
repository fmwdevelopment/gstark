import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../constants/shared_preference_string.dart';
import '../helper/network/api_end_point.dart';
import '../helper/network/network_helper.dart';
import '../utils/internet_utils.dart';
import '../utils/shared_preference/custom_shared_preference.dart';

class ReconciliationListScreenController extends GetxController {
  ApiService apiService = ApiService();

  final RxBool _isBusy = RxBool(false);

  bool get isBusy => _isBusy.value;

  setBusy(bool value) {
    _isBusy.value = value;
  }

  final RxString _fileContent = RxString('');

  String get fileContent => _fileContent.value;

  setFileContent(String value) {
    _fileContent.value = value;
  }

  initCall(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getReconciliationList(context);
    });
  }

  getReconciliationList(BuildContext context) async {
    setBusy(true);
    bool isConnectedToInternet = await checkIsConnectedToInternet();
    if (isConnectedToInternet) {
      try {
        String authToken =
            await CustomSharedPref.getPref(SharedPreferenceString.authToken);
        String email =
            await CustomSharedPref.getPref(SharedPreferenceString.email);
        String userId = await CustomSharedPref.getPref<String>(
            SharedPreferenceString.clientId);

        String token = 'Bearer $authToken';

        var value = await apiService.post(
            "${ApiEndPoint.reconciliationListApi}/265f7f98-79f6-4358-bcfd-bce848213aca/preview?clientId=$userId",
            Get.overlayContext ?? context,
            headers: {
              'x-header-token': email,
              'authorization': token,
              'Content-Type': "application/json",
            },
            body: {});

        if (value.statusCode == 200 || value.statusCode == 201) {
          setBusy(false);
          setFileContent(value.response.toString());
        } else {
          setBusy(false);
        }
      } catch (e) {
        debugPrint(e.toString());
        setBusy(false);
        rethrow;
      }
    }
  }
}
