import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'design_course_app_theme.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({ Key? key , required this.groupName}) : super(key: key);
  final String groupName;
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _userEnterMessage = '';
  FocusNode focusNode = FocusNode();

  void _sendMessage() async{
    // FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    
    FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupName)
        .collection('chat')
        .add({
      'text' : _userEnterMessage,
      'time' : Timestamp.now(),
      'userName' : user!.displayName,
      'userId' : user.uid,
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: null,
              style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: DesignCourseAppTheme.nearlyBlue,
              ),
              controller: _controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                suffixIcon: focusNode.hasFocus
                ? GestureDetector(
                  onTap: (){
                    focusNode.unfocus();
                    _controller.text = '';
                  },
                  child: Icon(Icons.cancel)
                )
                : Container(),
                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                filled: true,
                fillColor: Colors.grey.shade100,
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                  borderSide: BorderSide(color: Colors.transparent)
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                  borderSide: BorderSide(color: Colors.transparent)
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                  borderSide: BorderSide(color: Colors.transparent)
                ),
              ),
              onChanged: (value){
                setState(() {
                  _userEnterMessage = value;
                });
              },              
            ),
            // child: TextField(
            //   maxLines: null,
            //   controller: _controller,
            //   decoration: const InputDecoration(
            //     labelText: "Send a message..."
            //   ),
            //   onChanged: (value){
            //     setState(() {
            //       _userEnterMessage = value;
            //     });
            //   },
            // ),
          ),
          // focusNode.hasFocus 
          // ? IconButton(
          //   icon: Icon(Icons.cancel),
          //   onPressed: (){
          //     focusNode.unfocus();
          //   },
          // )
          // : Container(),
          IconButton(
            onPressed: _userEnterMessage.trim().isEmpty ? null : _sendMessage,
            icon: const Icon(Icons.send),
            color: Colors.blue,
          )
        ],
      ),
    );
  }
}