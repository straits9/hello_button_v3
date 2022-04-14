import 'package:get/get.dart';
import 'package:equatable/equatable.dart';
import 'package:hello_button_v3/controllers/auth_controller.dart';

class LoginController extends GetxController {
  final AuthController _authController = Get.find();

  final _loginStateStream = LoginState().obs;

  LoginState get state => _loginStateStream.value;

  void login(String username, String password) async {
    _loginStateStream.value = LoginLoading();

    try {
      await _authController.login(username, password);
      _loginStateStream.value = LoginState();
    } on AuthenticationException catch (e) {
      _loginStateStream.value = LoginFailure(error: e.message);
    }
  }
}

class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure({required this.error});

  @override
  List<Object> get props => [error];
}
