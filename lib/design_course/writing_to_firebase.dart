import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//그룹 파이어베이스 연동 부분
void addGroup(String groupName, String groupCategory, String groupExplanation,
    int groupNumber) async {
  final String _groupName = groupName;
  final String _groupCategory = groupCategory;
  final String _groupExplanation = groupExplanation;
  final int _groupNumber = groupNumber;

  //카테고리 별로 컬렉션 저장.
  await FirebaseFirestore.instance
      .collection('groups')
      .doc('$_groupName')
      .set({
    'name': _groupName,
    'category': _groupCategory,
    'explanation': _groupExplanation,
    'number': _groupNumber,
    'time': Timestamp.now()
  });
}

//게시판 파이어베이스 연동 부분
void addNotice(
    String title, String content, int postNumber, String groupName) async {
  final String _title = title;
  final String _content = content;
  final int _postNumber = postNumber;
  final String _groupName = groupName;

  //카테고리 별로 컬렉션 저장.
  await FirebaseFirestore.instance
      .collection('groups')
      .doc('$_groupName')
      .collection('notice')
      .add({'title': _title, 'content': _content, 'number': _postNumber, 'time': Timestamp.now()});
}

//약속 파이어베이스 연동 부분
void addAppointment(
  String apptName,
  String apptStartDate,
  String apptLocale,
  String apptExplanation,
  int apptLimit,
  String startTime,
  String endTime,
  String groupName
  ) async {
  final String _apptName = apptName;
  final String _apptStartDate = apptStartDate;
  final String _apptLocale = apptLocale;
  final String _apptExplanation = apptExplanation;
  final int _apptLimit = apptLimit;
  final String _startTime = startTime;
  final String _endTime = endTime;
  final String _groupName = groupName;

  //카테고리 별로 컬렉션 저장.
  await FirebaseFirestore.instance
      .collection('groups')
      .doc('$_groupName')
      .collection('appointment')
      .doc('$_apptName')
      .set({
    'name': _apptName,
    'start_date': _apptStartDate,
    'locale': _apptLocale,
    'start_time': _startTime,
    'end_time': _endTime,
    'explanation': _apptExplanation,
    'user_limit': _apptLimit,
    'created_time': Timestamp.now()
  });
}