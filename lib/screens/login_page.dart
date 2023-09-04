import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_recorder/constants.dart';
import 'otp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String id = 'login_page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // another functions variable
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationID = "";
  String verificationIdReceived = "";

  TextEditingController phoneController = TextEditingController();
  bool showClearIcon = false;
  // Function 1
  String phone = '';
  void _userLogin() async {
    String mobile = phone;
    if (mobile == "") {
      Get.snackbar(
        "Please enter the mobile number!",
        "Failed",
        colorText: Colors.white,
      );
    } else {
      print('This is the entered mobile num : $mobile');
      signInWithPhoneNumber("+91$mobile");
    }
  }

  // Function 2
  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        // authentication successful, do something
      },
      verificationFailed: (FirebaseAuthException e) {
        // authentication failed, do something
      },
      codeSent: (String verificationId, int? resendToken) async {
        verificationIdReceived = verificationId;
        setState(() {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => OtpPage(verificationId)));
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 60),
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            children: [
              Image.asset('images/flutterLogo.jpeg'),
              SizedBox(
                height: 20,
              ),
              TextField(
                textAlign: TextAlign.center,
                enableInteractiveSelection: true,
                keyboardType: TextInputType.number,
                controller: phoneController,
                onChanged: (value) {
                  setState(() {
                    phone = value;
                  });
                  if (phoneController.text.length == 10) {
                    showClearIcon = true;
                  }
                },
                decoration: textFieldDecor.copyWith(
                  hintText: 'Enter Mobile number',
                  suffixIcon: showClearIcon
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              phoneController.clear();
                              showClearIcon = false;
                            });
                          },
                        )
                      : null,
                ),
              ),
              SizedBox(
                height: 80,
              ),
              SizedBox(
                height: 40,
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    _userLogin();
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
