import 'package:wdit/design_course/create_post_screen.dart';
import 'package:wdit/design_course/models/model_club.dart';
import 'package:wdit/design_course/writing_to_firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'design_course_app_theme.dart';

class Appointment extends StatefulWidget {
  const Appointment({Key? key, required this.groupData}) : super(key: key);
  final GroupData groupData;
  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  late String apptName;
  late String apptLocale;
  late String apptExplanation;
  late int apptLimit;
  String _startDate = '시작 날짜';
  String _startTime = '시작 시간';
  String _endTime = '종료 시간';
  var _selectedTime;
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();

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
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('약속 생성'),
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
              child: Container(
                height: MediaQuery.of(context).size.height * 0.84,
                child: Stack(
                  children: [
                    AnimatedOpacity(
                      opacity: opacity1,
                      duration: const Duration(milliseconds: 500),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('약속 이름'),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                height: 45,
                                child: TextField(
                                  maxLines: null,
                                  style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: DesignCourseAppTheme.nearlyBlue,
                                  ),
                                  controller: _controller1,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(13)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(13)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(13)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            const Text('약속 장소'),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                height: 45,
                                child: TextField(
                                  maxLines: null,
                                  style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: DesignCourseAppTheme.nearlyBlue,
                                  ),
                                  controller: _controller2,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(13)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(13)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(13)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            const Text('약속 인원'),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                height: 45,
                                child: TextField(
                                  maxLines: null,
                                  style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: DesignCourseAppTheme.nearlyBlue,
                                  ),
                                  controller: _controller3,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(13)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(13)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(13)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  flex: 2,
                                  fit: FlexFit.tight,
                                  child: const Text('약속 날짜'),
                                ),
                                Flexible(
                                  flex: 5,
                                  fit: FlexFit.tight,
                                  child: const Text('약속 시간'),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: OutlinedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.grey.shade100),
                                      side: MaterialStateProperty.all(
                                          const BorderSide(
                                              color: Colors.transparent)),
                                      minimumSize: MaterialStateProperty.all(
                                        Size(0, 45),
                                      ),
                                    ),
                                    onPressed: () {
                                      Future<DateTime?> selectedDate =
                                          showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime.now().add(
                                                  const Duration(days: 365)));

                                      selectedDate.then((value) {
                                        setState(() {
                                          _startDate =
                                              value.toString().substring(0, 10);
                                        });
                                      });
                                    },
                                    child: Text(
                                      _startDate,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: DesignCourseAppTheme.nearlyBlue,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: OutlinedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.grey.shade100),
                                      side: MaterialStateProperty.all(
                                          const BorderSide(
                                              color: Colors.transparent)),
                                      minimumSize: MaterialStateProperty.all(
                                          Size(0, 45)),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: this.context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('시간 선택'),
                                              content: SingleChildScrollView(
                                                child: TimePickerSpinner(
                                                  is24HourMode: true,
                                                  onTimeChange: (time) {
                                                    setState(() {
                                                      _selectedTime = time
                                                          .toString()
                                                          .substring(11, 16);
                                                    });
                                                  },
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _startTime =
                                                          _selectedTime;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('확인'),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: Text(
                                      _startTime,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: DesignCourseAppTheme.nearlyBlue,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Text(
                                    '~',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: OutlinedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.grey.shade100),
                                        side: MaterialStateProperty.all(
                                            const BorderSide(
                                                color: Colors.transparent)),
                                        minimumSize: MaterialStateProperty.all(
                                            Size(0, 45))),
                                    onPressed: () {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: this.context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('시간 선택'),
                                              content: SingleChildScrollView(
                                                child: TimePickerSpinner(
                                                  is24HourMode: true,
                                                  onTimeChange: (time) {
                                                    setState(() {
                                                      _selectedTime = time
                                                          .toString()
                                                          .substring(11, 16);
                                                    });
                                                  },
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _endTime = _selectedTime;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('확인'),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: Text(
                                      _endTime,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: DesignCourseAppTheme.nearlyBlue,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Text('약속 설명'),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                height: 220,
                                child: TextField(
                                  maxLines: 100,
                                  keyboardType: TextInputType.multiline,
                                  style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: DesignCourseAppTheme.nearlyBlue,
                                  ),
                                  controller: _controller4,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 15, 10, 15),
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(13)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(13)),
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(13)),
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
                    // AnimatedOpacity(
                    //   opacity: opacity2,
                    //   duration: const Duration(milliseconds: 500),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.stretch,
                    //     children: [
                    //       Container(
                    //         child: ElevatedButton(
                    //           onPressed: () {
                    //             apptName = controller1.text;
                    //             apptLocale = controller2.text;
                    //             apptExplanation = controller3.text;
                    //             addAppointment(
                    //               apptName,
                    //               _startDate,
                    //               apptLocale,
                    //               apptExplanation,
                    //               _startTime,
                    //               _endTime,
                    //               widget.groupData.name
                    //             );
                    //             Navigator.pop(context);
                    //           },
                    //           child: const Text(
                    //             '생성하기',
                    //             style: TextStyle(
                    //               fontSize: 15.0,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Positioned(
                        child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              apptName = _controller1.text;
                              apptLocale = _controller2.text;
                              apptLimit = int.parse(_controller3.text);
                              apptExplanation = _controller4.text;
                              addAppointment(
                                  apptName,
                                  _startDate,
                                  apptLocale,
                                  apptExplanation,
                                  apptLimit,
                                  _startTime,
                                  _endTime,
                                  widget.groupData.name);
                              Navigator.pop(context);
                              setState(() {
                                // isJoined = true;
                              });
                            },
                            child: Container(
                              height: 48,
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 35),
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
                          )
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void timePicker() {}
}