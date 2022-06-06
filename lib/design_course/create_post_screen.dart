import 'package:wdit/design_course/models/model_club.dart';
import 'package:wdit/design_course/writing_to_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

var postNumber = 1;
var groupNumber = 1; //선택된 현재 그룹의 생성 번호를 받아와서 초기화 하는 작업 필요함.

class Notice extends StatefulWidget {
  const Notice({Key? key, required this.groupData}) : super(key: key);
  final GroupData groupData;
  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> with TickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  late String title;
  late String content;
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("게시글 생성"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                children: [
                  Row(
                    children: [
                      AnimatedOpacity(
                        opacity: opacity1,
                        duration: const Duration(milliseconds: 500),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('제목'),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  SizedBox(
                                    width: 300,
                                    height: 45,
                                    child: TextField(
                                      controller: controller1,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  const Text('내용'),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Container(
                                    width: 300,
                                    height: 300,
                                    child: TextField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 100,
                                      controller: controller2,
                                      style: TextStyle(),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  AnimatedOpacity(
                    opacity: opacity2,
                    duration: const Duration(milliseconds: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          child: ElevatedButton(
                            onPressed: () {
                              title = controller1.text;
                              content = controller2.text;
                              addNotice(
                                  title, content, postNumber, widget.groupData.name);
                              postNumber++;
                              Navigator.pop(context);
                            },
                            child: const Text(
                              '생성하기',
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
