import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';
import 'design_course_app_theme.dart';

class ChatBubbles extends StatelessWidget {
  const ChatBubbles(this.message, this.userName, this.isMe, {Key? key }) : super(key: key);

  final String message;
  final String userName;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if(isMe)
          Padding(
            padding: const EdgeInsets.fromLTRB(0,0,5,0),
            child: ChatBubble(
              clipper: ChatBubbleClipper4(type: BubbleType.sendBubble),
              alignment: Alignment.topRight,
              margin: const EdgeInsets.only(top: 16),
              backGroundColor: DesignCourseAppTheme.nearlyBlue,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                )
              ),
            ),
          ),
          if(!isMe)
          Padding(
            padding: const EdgeInsets.fromLTRB(5,0,0,0),
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16,),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    userName,
                    style: const TextStyle(color: Colors.black,),
                  ),
                ),
                const SizedBox(height: 4,),
                ChatBubble(
                  clipper: ChatBubbleClipper4(type: BubbleType.receiverBubble),
                  backGroundColor: const Color(0xffE7E7ED),
                  // margin: const EdgeInsets.only(top: 20),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.black),
                    )
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}