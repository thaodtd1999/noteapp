import 'dart:convert';
import 'dart:ui';

import 'package:cs/helper/app_shared.dart';
import 'package:cs/model/user_model.dart';
import 'package:cs/nutrition_app.dart';
import 'package:cs/sign_up.dart';
import 'package:flutter/material.dart';

import 'helper/spref.dart';
import 'server/service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  static var routeName = "/";

  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isChecked = false;
  String userName = "c123";
  String pass = "123123";


  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (SPref().id != 0) {
        Navigator.pushNamed(context, NutritionApp.routeName);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SPref().id != 0 ? Container() : Stack(
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
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Log into',
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'your account',
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
                    SizedBox(height: 12),
                    TextField(
                      style: TextStyle(color: Colors.white, fontSize: 22),
                      obscureText: true,
                      decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          filled: true,
                          hintStyle:
                          TextStyle(color: Colors.white, fontSize: 18),
                          hintText: 'Password',
                          suffix: Text(
                            'Forget?',
                            style: TextStyle(color: Colors.white),
                          )),
                      onChanged: (text) {
                        pass = text;
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          fillColor: MaterialStateProperty.all(Colors.white),
                          checkColor: Colors.black,
                          activeColor: Colors.white,
                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        Text(
                          'Remember me',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 52,
                      child: MaterialButton(
                        elevation: 26,
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28)),
                        onPressed: () {
                          if (userName.isEmpty) {
                            AppShared.showMessage("Please input your user name",
                                isRed: true);
                          } else if (pass.isEmpty) {
                            AppShared.showMessage("Please input your password",
                                isRed: true);
                          } else {
                            AppShared.showLoading(context);
                            _onLogin();
                            //Navigator.of(context).pushNamed(NutritionApp.routeName);
                          }
                        },
                        child: Text(
                          'Log in',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 52,
                      child: MaterialButton(
                        elevation: 26,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28)),
                        onPressed: () {
                          _onLoginGoogle();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'G  ',
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Log in with Google',
                              style:
                              TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 60, horizontal: 10),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, SignUpPage.routeName);
                },
                child: Row(
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    Text(
                      " Sign up",
                      style: TextStyle(fontSize: 14, color: Colors.yellow),
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

  _onLogin() async {
    var res = await Service().call?.post("api/auth/signin",
        data: {"username": userName, "password": pass}).catchError((onError) {
      AppShared.hideLoading(context);
      print(onError.toString());
      AppShared.showMessage(onError.response.data["message"], isRed: true);
    });
    AppShared.hideLoading(context);
    if (res?.statusCode == 200) {
      var spRef = SPref();
      spRef.token = "${res?.data["tokenType"]} ${res?.data["accessToken"]}";
      spRef.userName = userName;
      _getInfo();
    } else {
      AppShared.showMessage("Wrong user name or password", isRed: true);
    }
  }

  _getInfo() async {
    var res = await Service().call?.get("api/auth/details/${SPref().userName}");
    AppShared.hideLoading(context);
    var spRef = SPref();
    var userModel = UserModel.fromJson(res?.data["usersTracking"]);
    spRef.id = int.parse(userModel.id ?? "0");
    Navigator.of(context).pushNamed(NutritionApp.routeName);
    if (res?.statusCode == 200) {
    } else {
      AppShared.showMessage("Have a error \n Please try again", isRed: true);
    }
  }

  _onLoginGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      userName = account?.email ?? "";
      pass = account?.email ?? "";
      _onLogin();
    } catch (error) {
      print(error);
    }
  }
}
