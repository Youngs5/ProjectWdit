import 'package:flutter/material.dart';
import 'package:wdit/Screens/Login/login_screen.dart';
import 'package:wdit/Screens/Signup/components/background.dart';
import 'package:wdit/Screens/Signup/components/or_divider.dart';
import 'package:wdit/Screens/Signup/components/social_icon.dart';
import 'package:wdit/components/already_have_an_account_acheck.dart';
import 'package:wdit/components/rounded_button.dart';
import 'package:wdit/components/text_field_container.dart';
import 'package:wdit/design_course/home_design_course.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wdit/constants.dart';
// import 'package:wdit/components/rounded_input_field.dart';
// import 'package:wdit/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _authentication = FirebaseAuth.instance;

  bool showSpinner = false;
  // final _formKey = GlobalKey<FormState>();

  String userStudentID = '';
  String userPassword = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            TextFieldContainer(
              child: TextFormField(
                onSaved: (value){
                  userStudentID = value!;
                },
                onChanged: (value){
                  userStudentID = value;
                  debugPrint(value);
                },
                cursorColor: kPrimaryColor,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.person,
                    color: kPrimaryColor,
                  ),
                  hintText: "Student ID",
                  border: InputBorder.none,
                ),
              ),
            ),
            TextFieldContainer(
              child: TextFormField(
                obscureText: true,
                onSaved: (value){
                  userPassword = value!;
                },
                onChanged: (value){
                  userPassword = value;
                  debugPrint(value);
                },
                cursorColor: kPrimaryColor,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.lock,
                    color: kPrimaryColor,
                  ),
                  hintText: "Password",
                  border: InputBorder.none,
                ),
              ),
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () async{
                try{
                  final newUser = await _authentication.createUserWithEmailAndPassword(
                    email: userStudentID,
                    password: userPassword
                  );

                  // await FirebaseFirestore.instance.collection('user').doc(newUser.user!.uid)
                  // .set({
                  //   'userName' : userName,
                  //   'email' : userStudentID
                  // });

                  if(newUser.user != null){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context){
                        return DesignCourseHomeScreen();
                      }),
                    );
                  }
                }catch(e){
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please check your email and password"),
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/icons/facebook.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/twitter.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
