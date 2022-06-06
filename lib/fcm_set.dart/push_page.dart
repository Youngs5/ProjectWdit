import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wdit/fcm_set.dart/fcm_service.dart';

import 'package:wdit/app_theme.dart';
import 'package:flutter/material.dart';

class FcmPage extends StatefulWidget {
  @override
  _FcmPageState createState() => _FcmPageState();
}

class _FcmPageState extends State<FcmPage> {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final CollectionReference _tokensDB =
      FirebaseFirestore.instance.collection('Tokens');
  final FCMNotificationService _fcmNotificationService =
      FCMNotificationService();
  late String _otherDeviceToken;

  @override
  void initState() {
    super.initState();

    _fcmNotificationService.subscribeToTopic(topic: 'NEWS');

    load();
  }

  Future<void> load() async {
    if (Platform.isIOS) {
      _fcm.requestPermission();
    }

    String? token = await _fcm.getToken();

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

    DocumentReference docRef = _tokensDB.doc(thisDevice);
    docRef.set({'token': token});

    DocumentSnapshot docSnapshot = await _tokensDB.doc(otherDevice).get();
    _otherDeviceToken = docSnapshot['token'];
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
