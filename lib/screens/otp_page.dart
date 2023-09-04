import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:video_recorder/screens/home_page.dart';
import 'package:video_recorder/screens/login_page.dart';

class OtpPage extends StatefulWidget {
  String? verificationID;
  OtpPage(this.verificationID);
  static const String id = 'otp_page';
  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String? otpCode;
  // final String verificationId = Get.arguments[0];

  FirebaseAuth auth = FirebaseAuth.instance;
  // verify otp
  void verifyOtp(
    String verificationId,
    String userOtp,
  ) async {
    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      User? user = (await auth.signInWithCredential(creds)).user;
      if (user != null) {
        Get.to(HomePage());
      } else {
        Get.snackbar(
          "Failed to verify OTP",
          "Failed",
          colorText: Colors.white,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        Get.snackbar(
          "Invalid OTP",
          "Failed",
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          e.message.toString(),
          "Failed",
          colorText: Colors.white,
        );
      }
    }
  }

  void _login() {
    if (otpCode != null) {
      verifyOtp(widget.verificationID.toString(), otpCode!);
    } else {
      Get.snackbar(
        "Enter 6-Digit code",
        "Failed",
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: SizedBox(
        height: 50,
        width: 100,
        child: FloatingActionButton(
          child: Text(
            'Back',
            style: TextStyle(fontSize: 20),
          ), //child widget inside this button
          shape: StadiumBorder(),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 60),
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              children: [
                Image.asset('images/flutterLogo.jpeg'),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Enter otp',
                    style: TextStyle(fontSize: 22, color: Colors.blue),
                  ),
                ),
                Pinput(
                  length: 6,
                  defaultPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    textStyle: const TextStyle(
                      fontSize: 22,
                      color: Colors.blue,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(color: Colors.blue),
                    ),
                  ),
                  onCompleted: (value) {
                    setState(() {
                      otpCode = value;
                    });
                  },
                ),
                SizedBox(
                  height: 80,
                ),
                SizedBox(
                  height: 40,
                  width: 140,
                  child: ElevatedButton(
                    onPressed: _login,
                    child: Text(
                      'Get Started',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
