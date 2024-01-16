import 'package:black_coffer/otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class phoneIn extends StatefulWidget {
  const phoneIn({super.key});
  static String verify = "";
  @override
  State<phoneIn> createState() => _nameState();
}

class _nameState extends State<phoneIn> {
  TextEditingController countrycode = TextEditingController();
  TextEditingController phonenumber = TextEditingController();
  var buttonpressed = false;
  @override
  void initState() {
    countrycode.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', width: 160, height: 160),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Blackcoffer CloudClip",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 100,
              ),
              const Text(
                "Enter Mobile Number",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 17),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: countrycode,
                          style: const TextStyle(fontSize: 20.0),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              fillColor: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: phonenumber,
                        style: const TextStyle(fontSize: 15.0),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Phone Number",
                        ),
                      ),
                    ))
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      setState(() {buttonpressed = true;});
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: countrycode.text + phonenumber.text,
                        verificationCompleted:
                            (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {
                          setState(() {buttonpressed = false;});
                          Fluttertoast.showToast(
                            msg: 'Mobile Number Invalid',
                            backgroundColor: Colors.grey,
                          );
                        },
                        codeSent: (String verificationId, int? resendToken) {
                          phoneIn.verify = verificationId;
                          setState(() {buttonpressed = false;});
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  otp(value: phonenumber.text),
                            ),
                          );
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child:  Stack(
                      children: [
                        if(!buttonpressed)
                        const Text(
                          "Send OTP",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        if(buttonpressed)
                        const SpinKitFadingFour(
                          color: Colors.white,
                          size: 40.0,
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
