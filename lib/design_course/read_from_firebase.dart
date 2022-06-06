import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wdit/design_course/chat_bubble.dart';
import 'package:wdit/design_course/design_course_app_theme.dart';
import 'package:wdit/design_course/models/model_club.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:wdit/fcm_set.dart/fcm_service.dart';

var _groupName = List.empty(growable: true);
var _groupCategory = List.empty(growable: true);
var _groupExplantion = List.empty(growable: true);
var _groupNum = List.empty(growable: true);
int? postLen;
late List<bool> isChecked = List<bool>.filled(postLen!, false, growable: true);

Future<List<QueryDocumentSnapshot>> fetchGroupData() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('groups').get();
  List<QueryDocumentSnapshot> groupData = querySnapshot.docs;
  postLen = groupData.length;
  for (var i = 0; i < postLen!; i++) {
    _groupName.add(groupData[i].get("group_name"));
    _groupCategory.add(groupData[i].get("group_category"));
    _groupExplantion.add(groupData[i].get("group_explanation"));
    _groupNum.add(groupData[i].get("group_number"));
  }
  return groupData;
}

var _title = List.empty(growable: true);
var _content = List.empty(growable: true);
var _postNum = List.empty(growable: true);

Future<List<QueryDocumentSnapshot>> fetchNoticeData(String groupName) async {
  _title = [];
  _content = [];
  _postNum = [];

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('groups')
      .doc(groupName)
      .collection('notice')
      .get();
  List<QueryDocumentSnapshot> postData = querySnapshot.docs;
  postLen = postData.length;
  for (var i = 0; i < postLen!; i++) {
    _title.add(postData[i].get("title"));
    _content.add(postData[i].get("content"));
    _postNum.add(postData[i].get('number'));
  }
  return postData;
}



Future<List<QueryDocumentSnapshot>> fetchAppointmentData(String groupName) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('groups')
      .doc(groupName)
      .collection('appointment')
      .get();
  List<QueryDocumentSnapshot> postData = querySnapshot.docs;

  return postData;
}

class DrawPost extends StatefulWidget {
  const DrawPost({Key? key, required this.groupName}) : super(key: key);
  final String groupName;
  @override
  State<DrawPost> createState() => _DrawPostState();
}

class _DrawPostState extends State<DrawPost> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupName)
          .collection('chat')
          .orderBy('time', descending: true)
          .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs =  snapshot.data!.docs;
          return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (context, index){
            return ChatBubbles(
              chatDocs[index]['text'],
              chatDocs[index]['userName'],
              chatDocs[index]['userId'].toString() == user!.uid
            );
          },
        );          
          // return _noticeList(context, groupDocs);
        },
      );
  }
}

Widget _noticeList(BuildContext context, List<QueryDocumentSnapshot<Map<String, dynamic>>> groupDocs) {

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: groupDocs.length,
      itemBuilder: (context, i) {
        return TextButton(
          onPressed: () {},
          child: Text(
            groupDocs[i]['title'].toString()
            + "(생성번호: "
            + groupDocs[i]['number'].toString()
            + ")",
            textAlign: TextAlign.start,
          ),
        );
      },
    );
  }

class DrawAppointment extends StatefulWidget {
  const DrawAppointment({Key? key,required this.groupName}) : super(key: key);

  final String groupName;

  @override
  State<DrawAppointment> createState() => _DrawAppointmentState();
}

class _DrawAppointmentState extends State<DrawAppointment> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  
  void parentState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => {
        setState(() {})
      },
        child: FutureBuilder<void>(
            future: fetchAppointmentData(widget.groupName),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, index) {
                    return Container(
                      key: GlobalKey(debugLabel: snapshot.data[index]['name']),
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            Color.fromARGB(255, 254, 254, 254),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(16.0),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Color.fromARGB(255, 100, 100, 120)
                                  .withOpacity(0.5),
                              offset: const Offset(0.7, 0.7),
                              blurRadius: 2.0),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data[index]['name'],
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2,),
                              Row(
                                children: [
                                  Icon(CupertinoIcons.calendar, size: 14,),
                                  SizedBox(width: 3,),
                                  Text(
                                    snapshot.data[index]['start_date'].toString().substring(5,10)
                                    + ' / ' +
                                    snapshot.data[index]['start_time']
                                    + ' ~ ' +
                                    snapshot.data[index]['end_time'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade700
                                    ),
                                  ),
                                ],
                              ),
                              // SizedBox(height: 3,),
                              // Row(
                              //   children: [
                              //     Icon(CupertinoIcons.time, size: 14,),
                              //     SizedBox(width: 3,),
                              //     Text(
                              //       snapshot.data[index]['start_time']
                              //       + ' ~ ' +
                              //       snapshot.data[index]['end_time'],
                              //       style: TextStyle(
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w500,
                              //         color: Colors.orange.shade800
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              SizedBox(height: 3,),
                              Row(
                                children: [
                                  Icon(CupertinoIcons.location, size: 14,),
                                  Text(
                                    snapshot.data[index]['locale'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade700
                                    ),
                                  ),
                                ],
                              ),
                              // SizedBox(height: 5,),
                              // Container(
                              //   width: 65,
                              //   child: Stack(
                              //     children: [
                              //       Positioned(
                              //         left: 30,
                              //         child: ClipRRect(
                              //           borderRadius: BorderRadius.circular(50.0),
                              //           child: Image.asset(
                              //               'assets/images/userImage.png',
                              //               height: 25,
                              //               width: 25,
                              //           ),
                              //         ),
                              //       ),
                              //       Positioned(
                              //         left: 15,
                              //         child: ClipRRect(
                              //           borderRadius: BorderRadius.circular(50.0),
                              //           child: Image.asset(
                              //               'assets/images/userImage.png',
                              //               height: 25,
                              //               width: 25,
                              //           ),
                              //         ),
                              //       ),
                              //       Positioned(
                              //         child: ClipRRect(
                              //           borderRadius: BorderRadius.circular(50.0),
                              //           child: Image.asset(
                              //               'assets/images/userImage.png',
                              //               height: 25,
                              //               width: 25,
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                          JoinAppointmentButton(
                            apptName: snapshot.data[index]['name'].toString(),
                            apptLimit: snapshot.data[index]['user_limit'],
                            groupName: widget.groupName,
                            parentState: parentState,
                          )
                        ],
                      )
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}

class JoinAppointmentButton extends StatefulWidget {
  const JoinAppointmentButton({ Key? key , required this.apptName, required this.groupName, required this.parentState, required this.apptLimit}) : super(key: key);
  final String apptName;
  final int apptLimit;
  final String groupName;
  final Function parentState;

  @override
  State<JoinAppointmentButton> createState() => _JoinAppointmentButtonState();
}

class _JoinAppointmentButtonState extends State<JoinAppointmentButton> {
  bool isJoined = false;
  bool isLoading = true;
  late final users;

  final FCMNotificationService _fcmNotificationService =
      FCMNotificationService();

  @override
  void initState() {
    checkJoined();
    // TODO: implement initState
    super.initState();
  }

  void checkJoined() async{
      final user = FirebaseAuth.instance.currentUser;
    
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupName)
        .collection('appointment')
        .doc(widget.apptName)
        .collection('users')
        .get();
      users = querySnapshot.docs;

      users.forEach((document) => {
        if(document['id'] == user!.uid) isJoined = true
      });

      if (this.mounted) {
        setState(() {
          isLoading = false;
        });
      }
  }

  void joinAppointment(String name) async{
    final user = FirebaseAuth.instance.currentUser;
    var t = await FirebaseMessaging.instance.getToken();
    
    await FirebaseFirestore.instance
      .collection('groups')
      .doc(widget.groupName)
      .collection('appointment')
      .doc(name)
      .collection('users')
      .add({
        'name': user!.displayName,
        'email': user.email,
        'image': user.photoURL,
        'id': user.uid,
        'token' : t.toString()
      });
    
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupName)
        .collection('appointment')
        .doc(name)
        .collection('users')
        .get();

      final users = querySnapshot.docs;

      users.forEach((document) => {
        // print(document['token'])
        _fcmNotificationService.sendNotificationToUser(
          fcmToken: document['token'],
          title: 'WDIT 약속 참여',
          body: '${user.displayName}님이 $name 약속에 참여하였습니다.',
        )
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
    ? Center(
      child: CircularProgressIndicator(),
    )
    : ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(DesignCourseAppTheme.nearlyBlue),
        elevation: MaterialStateProperty.all<double>(0.0),
        padding: MaterialStateProperty.all(EdgeInsets.all(8)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15))
        )
      ),
      child: isJoined
      ? Text(
        '참여중\n${users.length}/${widget.apptLimit}',
        textAlign: TextAlign.center,
      )
      : Text(
        '참여\n${users.length}/${widget.apptLimit}',
        textAlign: TextAlign.center,
      ),
      onPressed: isJoined
      ? (){}
      : (){
        if (users.length == widget.apptLimit) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              margin: EdgeInsets.fromLTRB(100, 0, 100,
                MediaQuery.of(context).size.height * 0.45
              ),
              padding: EdgeInsets.all(18),
              content: Text('정원이 꽉찬 약속입니다.'),
              backgroundColor: Colors.red.shade200,
              duration: Duration(milliseconds: 1400),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Colors.red.shade200,
                  width: 2,
                ),
              ),
            )
          );
        } else {
        joinAppointment(widget.apptName);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              margin: EdgeInsets.fromLTRB(100, 0, 100,
                MediaQuery.of(context).size.height * 0.45
              ),
              padding: EdgeInsets.all(18),
              content: Text('약속에 참여되었습니다.'),
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
        }
        widget.parentState();
      },
    );
  }
}