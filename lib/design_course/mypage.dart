import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wdit/Screens/Login/login_screen.dart';
import 'package:wdit/design_course/models/model_club.dart';
import 'package:wdit/design_course/models/rec_card.dart';
import 'package:wdit/fcm_set.dart/fcm_service.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final CollectionReference _tokensDB =
      FirebaseFirestore.instance.collection('Tokens');
  final FCMNotificationService _fcmNotificationService =
      FCMNotificationService();
  late String _otherDeviceToken = '';
  final _auth = FirebaseAuth.instance;
  String? userName;
  String? userEmail;
  String? userImage;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
    _fcmNotificationService.subscribeToTopic(topic: 'NEWS');

    load();
  }

  Future<void> load() async {
    if (Platform.isIOS) {
      _fcm.requestPermission();
    }

    String? token = await _fcm.getToken(
      vapidKey: 'BI-Recr5QEpW8clHg9PnlXuQV8-R3166XAZviFIVuKARBv1rQh50IulV7CzIWrrk88xFsIJ4cGXzR_-RZHncTFQ'
      );

    assert(token != null);

    late String thisDevice;
    late String otherDevice;

    if (Platform.isIOS) {
      thisDevice = 'iOS';
      otherDevice = 'Android';
    } else {
      thisDevice = 'Android';
      otherDevice = 'iOS';
    }

    print(await FirebaseMessaging.instance.getToken());

    // DocumentReference docRef = _tokensDB.doc(thisDevice);
    // docRef.set({'token': token});

    // DocumentSnapshot docSnapshot = await _tokensDB.doc(otherDevice).get();
    // _otherDeviceToken = docSnapshot['token'];
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        userName = user.displayName;
        userEmail = user.email;
        userImage = user.photoURL;
        print(user.uid);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          '마이페이지',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _information(),
            Container(
                margin: const EdgeInsets.all(20),
                height: 1,
                color: Colors.grey[400]),
            _recommendMeet(),
            Container(
                margin: const EdgeInsets.all(20),
                height: 1,
                color: Colors.grey[400]),
            _settingUI(),
            Container(
                margin: const EdgeInsets.all(20),
                height: 1,
                color: Colors.grey[400]),
            _LogoutUI(),
          ],
        ),
      ),
    );
  }

  Widget _information() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.network('$userImage'),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(
                      '$userName',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(
                      '$userEmail',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _recommendMeet(
      // BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> data
      ) {
    // final groupData = GroupData.fromSnapshot(data);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '참가중인 모임',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  '더보기',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: Row(
            children: List.generate(
                10,
                (index) => RecCard(
                    className: '$userName'
                    // groupData.name
                    ,
                    description: '$userName')).toList(),
          ),
        ),
      ],
    );
  }

  Widget _settingUI() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '앱 설정',
                style: TextStyle(fontSize: 20),
              ),
              IconButton(
                onPressed: () async {
                  try {
                    await _fcmNotificationService.sendNotificationToUser(
                      fcmToken: 'cl-n2Zl1SPaWPOnp9ai-jU:APA91bGJOxsmCw-1f1NpbU2HZtYNrZhQnUSG_wakhLmdE0rmBqnpVgnxWATqXh8iMx35E8B9IWiOlMaek0W2dD-kuKQe6eFrOdnEvvi2WpbqzcGWIpN9u7oD6xRlVkp68vaLgUFusucF',
                      title: '모임에 가입되셨습니다.',
                      body: '${userName}님이 모임에 참여하였습니다.',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('알림 전송 완료')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('에러 발생, ${e.toString()},'),
                      ),
                    );
                  }
                },
                icon: Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '알림 설정',
                style: TextStyle(fontSize: 20),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _LogoutUI() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {},
            child: Text(
              "로그아웃",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  signOutWithGoogle() {}
}
