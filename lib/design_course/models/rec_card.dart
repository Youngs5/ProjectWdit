import 'package:flutter/material.dart';
import 'package:wdit/design_course/club_list_view.dart';
import 'package:wdit/design_course/design_course_app_theme.dart';

class RecCard extends StatelessWidget {
  final String className;
  final String description;
  const RecCard({ Key? key, required this.className, required this.description }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: 150,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: Colors.black12,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(className, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                const SizedBox(height: 20,),
                Text(description, style: const TextStyle(fontSize: 13,),textAlign: TextAlign.center,),
                const SizedBox(height: 20,),
                ElevatedButton(onPressed: () {
                }, child: Text('모임 참가',),)
              ],
            )
          ),
          Positioned(
            right: 5, 
            top: 5, 
            child: GestureDetector(
              onTap: () {
              },
              child: Icon(
                Icons.close,
                size: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}