import 'package:get/get.dart';
import 'package:hello_button_v3/models/button.dart';
import 'package:hello_button_v3/models/site.dart';
import 'package:hello_button_v3/services/remote_services.dart';

class TransactionController extends GetxController {
  var _site;
  var _buttonenv;
  var _buttons = [] as List<Button>;
  var _dataAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  bool get dataAvailable => _dataAvailable.value;
  Site get site => _site;
  ButtonBase get env => _buttonenv;
  List<Button> get buttons => _buttons;

  Future<void> fetchButtons(String mac) {
    return NetService.fetchPostJsonData('/dev/api/buttons', {'mac': mac})
        .then((response) {
          if (response != null) {
            _site = Site.fromJson(response['store']);
            if (_site.useButton) {
              _buttonenv = ButtonBase.fromJson(response['store']);
              (response['buttons'] as List)
                  .forEach((e) => _buttons.add(Button.fromJson(e)));
            }
          }
        })
        .catchError((err) => print('fetchButtons error: $err'))
        .whenComplete(() => _dataAvailable.value = _site != null);
  }
}
