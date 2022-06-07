import 'package:wdit/design_course/design_course_app_theme.dart';
import 'package:wdit/design_course/writing_to_firebase.dart';
import 'package:flutter/material.dart';

var postNumber = 1;
var groupNumber = 1; //선택된 현재 그룹의 생성 번호를 받아와서 초기화 하는 작업 필요함.

class Group extends StatefulWidget {
  const Group({Key? key}) : super(key: key);

  @override
  State<Group> createState() => _GroupState();
}

class _GroupState extends State<Group> with TickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  late String name;
  late String category;
  late String explanation;
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  var _isSelected;
  var _selectedCategory;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    _isSelected = [
      {'name': '스포츠', 'state': false},
      {'name': '스터디', 'state': false},
      {'name': '취미', 'state': false},
      {'name': '카풀', 'state': false},
    ];
    _selectedCategory = _isSelected[0]['name'];
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
        elevation: 0,
        title: Text('그룹 생성'),
        toolbarHeight: 65,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25)),
        ),
        backgroundColor: DesignCourseAppTheme.nearlyBlue,
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
                  AnimatedOpacity(
                    opacity: opacity1,
                    duration: const Duration(milliseconds: 500),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('그룹 이름'),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Container(
                              height: 45,
                              child: TextField(
                                controller: controller1,
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: DesignCourseAppTheme.nearlyBlue,
                                ),
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10, 15, 10, 15),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(13)),
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(13)),
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(13)),
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          const Text('카테고리'),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Container(
                              height: 30,
                              // color: Colors.grey,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _isSelected.length,
                                itemBuilder: (context, i) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        for (var j in _isSelected) {
                                          j['state'] = false;
                                        }
                                        _isSelected[i]['state'] =
                                            !_isSelected[i]['state'];
                                      });
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: _isSelected[i]['state']
                                            ? DesignCourseAppTheme.nearlyBlue
                                                .withOpacity(0.9)
                                            : Colors.grey.withOpacity(0.2),
                                      ),
                                      padding:
                                          EdgeInsets.fromLTRB(15, 4, 15, 7),
                                      child: Text(
                                        _isSelected[i]['name'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: _isSelected[i]['state']
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: _isSelected[i]['state']
                                                ? FontWeight.w600
                                                : FontWeight.w500),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Container(
                            //   height: 45,
                            //   child: DropdownButton(
                            //     value: _selectedCategory,
                            //     isExpanded: true,
                            //     items: _categories.map((value) {
                            //       return DropdownMenuItem(
                            //         alignment: Alignment.center,
                            //         value: value,
                            //         child: Text(value),
                            //       );
                            //     }).toList(),
                            //     onChanged: (value) {
                            //       setState(() {
                            //         _selectedCategory = value.toString();
                            //       });
                            //     },
                            //   ),
                            // ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          const Text('내용'),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Container(
                              height: 200,
                              child: TextField(
                                keyboardType: TextInputType.multiline,
                                maxLines: 100,
                                controller: controller3,
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: DesignCourseAppTheme.nearlyBlue,
                                ),
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10, 15, 10, 15),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(13)),
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(13)),
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(13)),
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: opacity2,
                    duration: const Duration(milliseconds: 500),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: GestureDetector(
                        onTap: () {
                          name = controller1.text;
                          category = _selectedCategory;
                          explanation = controller3.text;
                          addGroup(name, category, explanation, 3);
                          postNumber++;
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 48,
                          // margin: EdgeInsets.fromLTRB(0, 0, 0, 35),
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: BoxDecoration(
                            color: DesignCourseAppTheme.nearlyBlue,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16.0),
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: DesignCourseAppTheme.nearlyBlue
                                      .withOpacity(0.5),
                                  offset: const Offset(1.1, 1.1),
                                  blurRadius: 5.0),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '만들기',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                letterSpacing: 0.0,
                                color: DesignCourseAppTheme.nearlyWhite,
                              ),
                            ),
                          ),
                        ),
                      ),
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
