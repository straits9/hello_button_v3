import 'package:get/get.dart';
import 'package:hello_button_v3/models/button.dart';
import 'package:hello_button_v3/models/site.dart';
import 'package:hello_button_v3/services/remote_services.dart';

// https://github.com/afzalali15/shopx/tree/master/lib/controllers 참고중..

class HelloButtonController extends GetxController {
  final isLoading = true.obs;
  final site = Site().obs;

  @override
  void onInit() {
    super.onInit();
  }

  void fetchStoreButton(String mac) async {
    try {
      isLoading(true);
      var resp = await RemoteServices.fetchButtons(mac);
      if (resp != null) {
        site.value = resp;
      }
    } finally {
      isLoading(false);
    }
  }
}
