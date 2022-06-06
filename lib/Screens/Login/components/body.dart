// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wdit/Screens/Login/components/background.dart';
import 'package:wdit/design_course/home_design_course.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wdit/design_course/design_course_app_theme.dart';

class Body extends StatefulWidget {
  const Body({  Key? key, }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // final _authentication = FirebaseAuth.instance;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
 
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
 
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

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
            // SizedBox(height: size.height * 0.03),
            Image.asset(
              "assets/images/wdit4.png",
              // height: size.height * 0.35,
              width: 300,
            ),
            Image.asset(
              "assets/images/logo_text2.png",
              // height: size.height * 0.35,
              width: 130,
            ),
            SizedBox(height: size.height * 0.2),
            // TextFieldContainer(
            //   child: TextFormField(
            //     onSaved: (value){
            //       userStudentID = value!;
            //     },
            //     onChanged: (value){
            //       userStudentID = value;
            //       debugPrint(value);
            //     },
            //     cursorColor: kPrimaryColor,
            //     decoration: InputDecoration(
            //       icon: Icon(
            //         Icons.person,
            //         color: kPrimaryColor,
            //       ),
            //       hintText: "Student ID",
            //       border: InputBorder.none,
            //     ),
            //   ),
            // ),
            // TextFieldContainer(
            //   child: TextFormField(
            //     obscureText: true,
            //     onSaved: (value){
            //       userPassword = value!;
            //     },
            //     onChanged: (value){
            //       userPassword = value;
            //       debugPrint(value);
            //     },
            //     cursorColor: kPrimaryColor,
            //     decoration: InputDecoration(
            //       icon: Icon(
            //         Icons.lock,
            //         color: kPrimaryColor,
            //       ),
            //       hintText: "Password",
            //       border: InputBorder.none,
            //     ),
            //   ),
            // ),      
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              width: size.width * 0.8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/glogo.png', width: 25,),
                      SizedBox(width: 20,),
                      Text(
                        'GOOGLE LOGIN',
                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                      ),                      
                    ],
                  ),
                  onPressed: () async{
                    try{
                      final newUser = await signInWithGoogle();

                      if(newUser.user != null){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              // return DesignCourseHomeScreen();
                              return DesignCourseHomeScreen();
                            },
                          ),
                        );                                      
                      }
                    }catch(e){
                      print(e);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: DesignCourseAppTheme.nearlyBlue.withOpacity(0.9),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      textStyle: TextStyle(
                          color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                ),         
              ),
            ),
            
            // RoundedButton(
            //   text: "GOOGLE LOGIN",
            //   color: DesignCourseAppTheme.nearlyBlue.withOpacity(0.9),
            //   press: () async{
            //     try{
            //       final newUser = await signInWithGoogle();

            //       if(newUser.user != null){
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) {
            //               // return DesignCourseHomeScreen();
            //               return DesignCourseHomeScreen();
            //             },
            //           ),
            //         );                                      
            //       }
            //     }catch(e){
            //       print(e);
            //     }
            //   },
            // ),
            SizedBox(height: size.height * 0.1),
          ],
        ),
      ),
    );
  }
}
