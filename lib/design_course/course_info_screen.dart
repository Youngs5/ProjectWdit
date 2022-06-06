import 'dart:math';

// import 'package:wdit/design_course/action_button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wdit/design_course/create_appointment_screen.dart';
import 'package:wdit/design_course/create_group_screen.dart';
import 'package:wdit/design_course/create_post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wdit/design_course/new_message.dart';
import 'package:wdit/design_course/read_from_firebase.dart';
import 'package:wdit/design_course/models/model_club.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'design_course_app_theme.dart';

var _groupName;
var _groupCategory;
var _groupExplanation;
var _groupNum;
var postLen;

class CourseInfoScreen extends StatefulWidget {
  const CourseInfoScreen({ Key? key, required this.groupData }) : super(key: key);
  final GroupData groupData;
  @override
  _CourseInfoScreenState createState() => _CourseInfoScreenState();
}

class _CourseInfoScreenState extends State<CourseInfoScreen>
    with TickerProviderStateMixin {
  final double infoHeight = 700.0;
  AnimationController? animationController;
  Animation<double>? animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  bool isChating = false;
  bool isJoined = false;
  bool isLoading = true;
  
  String? userName = '';
  String? userEmail = '';
  String? userImage = '';
  String? userId = '';
  List<QueryDocumentSnapshot> users = [];

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    getCurrentUser();
    super.initState();
  }
  
  void getCurrentUser() async{
    try{
      final user = FirebaseAuth.instance.currentUser;

      if(user != null){
        userName = user.displayName;
        userEmail = user.email;
        userImage = user.photoURL;
        userId = user.uid;

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupData.name)
          .collection('users')
          .get();
        users = querySnapshot.docs;

        users.forEach((document) => {
          if(document['id'] == userId) isJoined = true
        });
        isLoading = false;
      } 
    }catch(e){
      print(e);
    }
  }    

void joinGroup() async{
  //카테고리 별로 컬렉션 저장.
  var t = await FirebaseMessaging.instance.getToken();

  await FirebaseFirestore.instance
    .collection('groups')
    .doc(widget.groupData.name)
    .collection('users')
    .add({
      'name': userName,
      'email': userEmail,
      'image': userImage,
      'id': userId,
      'token' : t.toString()
    });
}

  Future<void> setData() async {
    animationController?.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double tempHeight = MediaQuery.of(context).size.height -
      (MediaQuery.of(context).size.width / 1.2) +
      24.0;
    return Scaffold(
      backgroundColor: DesignCourseAppTheme.nearlyWhite,
      body: isLoading
      ? Center(child: CircularProgressIndicator())
      : isJoined
        ? Container(
          color: DesignCourseAppTheme.nearlyWhite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppBar(
                elevation: 0,
                title: Text(widget.groupData.name),
                toolbarHeight: 65,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                  )
                ),
                backgroundColor: DesignCourseAppTheme.nearlyBlue,
              ),
              SizedBox(height: 15,),
              // Padding(
              //   padding: const EdgeInsets.only(
              //       top: 32.0, left: 18, right: 16),
              //   child: Text(
              //     widget.groupData.name,
              //     textAlign: TextAlign.left,
              //     style: TextStyle(
              //       fontWeight: FontWeight.w600,
              //       fontSize: 22,
              //       letterSpacing: 0.27,
              //       color: DesignCourseAppTheme.darkerText,
              //     ),
              //   ),
              // ),
              DefaultTabController(
                length: 2,
                child: Expanded(
                  child: Column(
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: opacity1,
                        child: Container(
                          height: 38,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: DesignCourseAppTheme.nearlyBlue.withOpacity(0.2),
                          ),
                          child: TabBar(
                            unselectedLabelColor: DesignCourseAppTheme.nearlyBlue.withOpacity(0.8),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: DesignCourseAppTheme.nearlyBlue,
                            ),  
                            onTap: (index){
                              if(index == 1) {
                                setState(() {
                                  isChating = true;
                                });
                              } else {
                                setState(() {
                                  isChating = false;
                                });
                              }
                            },
                            tabs: <Widget>[
                              // tabBarTitleUI('정보'),
                              tabBarTitleUI('약속'),
                              tabBarTitleUI('채팅'),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: <Widget>[
                            // tabBarDescriptionUI(widget.groupData.explanation),
                            DrawAppointment(groupName: widget.groupData.name),
                            DrawPost(groupName: widget.groupData.name),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              isJoined
              ? isChating
                ? NewMessage(groupName: widget.groupData.name)
                : AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: opacity3,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16, bottom: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Container(
                        //   width: 48,
                        //   height: 48,
                        //   child: ExpandableFAB(distance: 50, children: [],),
                        // ),
                        // const SizedBox(
                        //   width: 16,
                        // ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) {
                                return Appointment(groupData: widget.groupData);
                              }));
                            },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color:
                                    DesignCourseAppTheme.nearlyBlue,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(16.0),
                                ),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: DesignCourseAppTheme
                                          .nearlyBlue
                                          .withOpacity(0.5),
                                      offset: const Offset(1.1, 1.1),
                                      blurRadius: 10.0),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '약속 생성',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    letterSpacing: 0.0,
                                    color: DesignCourseAppTheme
                                        .nearlyWhite,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      joinGroup();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          margin: EdgeInsets.fromLTRB(100, 0, 100,
                            MediaQuery.of(context).size.height * 0.45
                          ),
                          padding: EdgeInsets.all(18),
                          content: Text('환영합니다 ! \n${userName}님!'),
                          backgroundColor: DesignCourseAppTheme.nearlyBlue,
                          duration: Duration(milliseconds: 1400),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: DesignCourseAppTheme.nearlyBlue,
                              width: 2,
                            ),
                          ),
                        ),
                      );
                      setState(() {
                        isJoined = true;
                      });
                    },
                    child: Container(
                      height: 48,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color:
                            DesignCourseAppTheme.nearlyBlue,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(16.0),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: DesignCourseAppTheme
                                  .nearlyBlue
                                  .withOpacity(0.5),
                              offset: const Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '가입하기',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            letterSpacing: 0.0,
                            color: DesignCourseAppTheme
                                .nearlyWhite,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        )
        : Container(
          child: Stack(
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.58,
                      child: Image.asset(
                        'assets/design_course/webInterFace.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.groupData.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 22,
                                  letterSpacing: 0.27,
                                  color: DesignCourseAppTheme.darkerText,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                widget.groupData.explanation,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  letterSpacing: 0.27,
                                  color: DesignCourseAppTheme.darkerText,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 13,),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: DesignCourseAppTheme.nearlyBlue.withOpacity(0.9)
                                ),
                                padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                                child: Text(
                                  widget.groupData.category,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 13,),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.star,
                                  color:
                                      DesignCourseAppTheme
                                          .nearlyBlue,
                                  size: 17,
                                ),
                                Icon(
                                  Icons.star,
                                  color:
                                      DesignCourseAppTheme
                                          .nearlyBlue,
                                  size: 17,
                                ),
                                Icon(
                                  Icons.star,
                                  color:
                                      DesignCourseAppTheme
                                          .nearlyBlue,
                                  size: 17,
                                ),
                                Icon(
                                  Icons.star,
                                  color:
                                      DesignCourseAppTheme
                                          .nearlyBlue,
                                  size: 17,
                                ),
                                Icon(
                                  Icons.star_half,
                                  color:
                                      DesignCourseAppTheme
                                          .nearlyBlue,
                                  size: 17,
                                ),
                                Text(
                                  '4.5',
                                  textAlign:
                                      TextAlign.left,
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.w200,
                                    fontSize: 12,
                                    letterSpacing: 0.27,
                                    color:
                                        DesignCourseAppTheme
                                            .grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 13,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${users.length} Users'),
                              SizedBox(height: 5,),
                              Row(
                                children: [
                                  for(int i = 0; i < (users.length < 8 ? users.length : 8); i++)
                                    Container(
                                      margin: EdgeInsets.only(right: 5),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50.0),
                                        child: Image.network(
                                            users[i]['image'].toString(),
                                            height: 33,
                                            width: 33,
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 13,),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            joinGroup();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                margin: EdgeInsets.fromLTRB(100, 0, 100,
                                  MediaQuery.of(context).size.height * 0.45
                                ),
                                padding: EdgeInsets.all(18),
                                content: Text('환영합니다 ! \n${userName}님!'),
                                backgroundColor: DesignCourseAppTheme.nearlyBlue,
                                duration: Duration(milliseconds: 1400),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: DesignCourseAppTheme.nearlyBlue,
                                    width: 2,
                                  ),
                                ),
                              ),
                            );
                            setState(() {
                              isJoined = true;
                            });
                          },
                          child: Container(
                            height: 48,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 35),
                            width: MediaQuery.of(context).size.width * 0.85,
                            decoration: BoxDecoration(
                              color:
                                  DesignCourseAppTheme.nearlyBlue,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: DesignCourseAppTheme
                                        .nearlyBlue
                                        .withOpacity(0.5),
                                    offset: const Offset(1.1, 1.1),
                                    blurRadius: 5.0),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '가입하기',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  letterSpacing: 0.0,
                                  color: DesignCourseAppTheme
                                      .nearlyWhite,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                )
            ]
          ),
        ),
    );
  }

  Widget tabBarTitleUI(String text) {
    return Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          )
        ),
      ),
    );
  }

  // Widget tabBarTitleUI(String text) {
  //   return Container(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: <Widget>[
  //         Padding(
  //           padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
  //           child: Text(
  //             text,
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               fontWeight: FontWeight.w600,
  //               fontSize: 16,
  //               letterSpacing: 0.27,
  //               color: DesignCourseAppTheme.nearlyBlue,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget tabBarDescriptionUI(String text) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: opacity2,
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.w200,
                fontSize: 15,
                letterSpacing: 0.27,
                color: DesignCourseAppTheme.nearlyBlack),
          ),
        ],
      ),
    );
  }
}

class ExpandableFAB extends StatefulWidget {
  final double? distance;
  final List<Widget>? children;
  const ExpandableFAB(
      {Key? key, @required this.distance, @required this.children})
      : super(key: key);

  @override
  State<ExpandableFAB> createState() => _ExpandableFABState();
}

class _ExpandableFABState extends State<ExpandableFAB> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      transformAlignment: Alignment.center,
      duration: const Duration(milliseconds: 1000),
      transform: Matrix4.rotationZ(_open ? 0 : pi / 4),
      child: FloatingActionButton(
        onPressed: toggle,
        child: Icon(Icons.close),
      ),
    );
  }

  void toggle() {
    _open = !_open;
    setState(() {});
  }
}
