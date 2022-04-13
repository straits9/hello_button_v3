import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hello_button_v3/controllers/auth_controller.dart';
import 'package:hello_button_v3/widgets/background.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final AuthController _auth = Get.find();
  late String error;

  TextEditingController useridCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  @override
  void initState() {
    error = '';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // keep to change custom app bar
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.orange),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          height: size.height,
          // background design위에 login form을 만든다.
          child: Background(
            child: loginForm(size),
          ),
        ),
      ),
    );
  }

  // login 전담 처리 form
  Form loginForm(Size size) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 페이지 제목
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            child: const Text(
              "LOGIN",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C8CCA),
                  fontSize: 24),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: size.height * 0.035),

          // username input
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: TextFormField(
              controller: useridCtrl,
              validator: (String? val) =>
                  val!.isEmpty ? 'Please enter username' : null,
              decoration: inputDecoration('Username', Icons.person),
            ),
          ),
          SizedBox(height: size.height * 0.03),

          // password input
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: TextFormField(
              validator: (String? val) =>
                  val!.isEmpty ? 'Please enter password' : null,
              controller: passwordCtrl,
              decoration: inputDecoration('Password', Icons.lock),
            ),
          ),

          // forget password link
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: const Text(
              "Forgot your password?",
              style: TextStyle(fontSize: 12, color: Color(0XFF2661FA)),
            ),
          ),

          // error 발생시 표시하는 부분
          Center(
            child: Text(
              error,
              style: const TextStyle(
                color: Color.fromRGBO(216, 181, 58, 1.0),
                fontSize: 14.0,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.035),

          // login button
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF82C035),
                minimumSize: const Size.fromHeight(50),
                //side: const BorderSide(width: 1, color: Colors.brown),
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                //padding:
                //    const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
              ),
              onPressed: () async {
                // if (formKey.currentState?.validate() ?? false) {
                if (formKey.currentState!.validate()) {
                  // await _viewModel.loginUser(emailCtr.text, passwordCtr.text);
                  _auth.login('token');
                }
              },
              child: const Text(
                'Login',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//
// input 부분에 대한 decoration
//
InputDecoration inputDecoration(String labelText, IconData iconData,
    {String? prefix, String? helperText}) {
  return InputDecoration(
    labelText: labelText,
    // contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    // helperText: helperText,
    // labelStyle: const TextStyle(color: Colors.grey),
    // fillColor: Colors.grey.shade200,
    // filled: true,
    // prefixText: prefix,
    // prefixIcon: Icon(
    //   iconData,
    //   size: 20,
    // ),
    // prefixIconConstraints: const BoxConstraints(minWidth: 60),
    // enabledBorder: OutlineInputBorder(
    //   borderRadius: BorderRadius.circular(30),
    //   borderSide: const BorderSide(color: Colors.black),
    // ),
    // focusedBorder: OutlineInputBorder(
    //   borderRadius: BorderRadius.circular(30),
    //   borderSide: const BorderSide(color: Colors.black),
    // ),
    // errorBorder: OutlineInputBorder(
    //   borderRadius: BorderRadius.circular(30),
    //   borderSide: const BorderSide(color: Colors.black),
    // ),
    // border: OutlineInputBorder(
    //   borderRadius: BorderRadius.circular(30),
    //   borderSide: const BorderSide(color: Colors.black),
    // ),
  );
}
