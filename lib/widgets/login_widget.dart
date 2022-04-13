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

  TextEditingController useridCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
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
          child: Background(child: loginForm(size)),
        ),
      ),
    );
  }

  Form loginForm(Size size) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            child: const Text(
              "",
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2661FA), fontSize: 24),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: size.height * 0.035),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: TextFormField(
              controller: useridCtrl,
              validator: (String? val) => val!.isEmpty ? 'Please enter username' : null,
              decoration: inputDecoration('Username', Icons.person),
            ),
          ),
          SizedBox(height: size.height * 0.03),
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
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: const Text(
              "Forgot your password?",
              style: TextStyle(fontSize: 12, color: Color(0XFF2661FA)),
            ),
          ),
          Center(
            child: Text(
              "",
              style: TextStyle(
                  color: Color.fromRGBO(216, 181, 58, 1.0), fontSize: 14.0),
            ),
          ),
          SizedBox(height: size.height * 0.035),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
                side: BorderSide(width: 3, color: Colors.brown),
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                padding: const EdgeInsets.all(0),
              ),
              onPressed: () async {
                // if (formKey.currentState?.validate() ?? false) {
                if (formKey.currentState!.validate()) {
                  // await _viewModel.loginUser(emailCtr.text, passwordCtr.text);
                  _auth.login('token');
                }
              },
              child: const Text('Login', textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration inputDecoration(String labelText, IconData iconData,
    {String? prefix, String? helperText}) {
  return InputDecoration(
    // contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    // helperText: helperText,
    labelText: labelText,
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
