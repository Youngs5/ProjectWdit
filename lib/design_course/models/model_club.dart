import 'package:cloud_firestore/cloud_firestore.dart';

class Club {
  final String text;
  final String userName;
  final String userId;

  Club.fromMap(Map<String, dynamic> map)
    : text = map['text'],
      userName = map['userName'],
      userId = map['userId'];

  Club.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
    : this.fromMap(snapshot.data());
}

class GroupData {
  final String name;
  final String category;
  final String explanation;
  final int number;

  GroupData.fromMap(Map<String, dynamic> map)
    : name = map['name'],
      category = map['category'],
      explanation = map['explanation'],
      number = map['number'];

  GroupData.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
    : this.fromMap(snapshot.data());
}