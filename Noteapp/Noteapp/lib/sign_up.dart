import 'dart:convert';
import 'dart:ui';

import 'package:cs/helper/app_shared.dart';
import 'package:flutter/material.dart';

import 'helper/spref.dart';
import 'server/service.dart';

class SignUpPage extends StatefulWidget {
  static var routeName = "/sign-up";

  SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  String userName = "";
  String pass = "";
  String rePass = "";
  String email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/images/gold_silver.jpg'),
                    fit: BoxFit.cover)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: ListView(
                  children: [
                    Text(
                      'Welcome!',
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Sign up your account',
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 46,
                    ),
                    TextField(
                      style: TextStyle(color: Colors.white, fontSize: 22),
                      decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          filled: true,
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 18),
                          hintText: 'Username/Email'),
                      onChanged: (text) {
                        userName = text;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    TextField(
                      style: TextStyle(color: Colors.white, fontSize: 22),
                      decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          filled: true,
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 18),
                          hintText: 'Email'),
                      onChanged: (text) {
                        email = text;
                      },
                    ),
                    SizedBox(height: 12),
                    TextField(
                      style: TextStyle(color: Colors.white, fontSize: 22),
                      obscureText: true,
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        filled: true,
                        hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                        hintText: 'Password',
                      ),
                      onChanged: (text) {
                        pass = text;
                      },
                    ),
                    SizedBox(height: 12),
                    TextField(
                      style: TextStyle(color: Colors.white, fontSize: 22),
                      obscureText: true,
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        filled: true,
                        hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                        hintText: 'Re-Password',
                      ),
                      onChanged: (text) {
                        rePass = text;
                      },
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 52,
                      child: MaterialButton(
                        elevation: 26,
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28)),
                        onPressed: () {
                          var regExp = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                          if (userName.isEmpty) {
                            AppShared.showMessage("Please input your user name",
                                isRed: true);
                          } else if (pass.isEmpty) {
                            AppShared.showMessage("Please input your password",
                                isRed: true);
                          } else if (pass != rePass) {
                            AppShared.showMessage("Password don't match",
                                isRed: true);
                          } else if (!regExp.hasMatch(email) || email.isEmpty) {
                            AppShared.showMessage("Mail is wrong format",
                                isRed: true);
                          } else {
                            _signUp();
                          }
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _signUp() async {
    AppShared.showLoading(context);
    var res = await Service().call?.post("api/auth/signup", data: {
      "username": userName,
      "password": pass,
      "email": email
    }).catchError((onError) {
      AppShared.hideLoading(context);
      AppShared.showMessage(onError.response.data["message"], isRed: true);
    });
    AppShared.hideLoading(context);
    if (res?.statusCode == 200) {
      AppShared.showMessage(jsonDecode(res?.data)["message"]);
      Navigator.pop(context);
    } else {
      AppShared.showMessage(jsonDecode(res?.data)["message"], isRed: true);
    }
  }
}
