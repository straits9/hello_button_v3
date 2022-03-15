import 'package:get/get.dart';
import 'package:hello_button_v3/models/button.dart';
import 'package:hello_button_v3/models/site.dart';
import 'package:hello_button_v3/services/remote_services.dart';

// https://github.com/afzalali15/shopx/tree/master/lib/controllers 참고중..

class HelloButtonController extends GetxController {
  final isLoading = false.obs;
  final site = Site().obs;
  final buttons = ButtonBase().obs;

  @override
  void onInit() {
    fetchStoreButton();
    super.onInit();
  }

  void fetchStoreButton() async {
    try {
      isLoading(true);
      var resp = await RemoteServices.fetchButtons();
      if (resp != null) {
        buttons.value = resp;
      }
    } finally {
      isLoading(false);
    }
  }
}
