import 'package:flutter/material.dart';
import 'design_course_app_theme.dart';
import 'dart:convert';


class FilterScreen extends StatefulWidget {
  const FilterScreen({ Key? key, required this.filterStateList }) : super(key: key);
  final List filterStateList;

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class MapToList {
  MapToList(this.text, this.state);

  String text;
  dynamic state;
}

class _FilterScreenState extends State<FilterScreen> with TickerProviderStateMixin {
  
  List filterState = [];
  List bufferFilterState = [];


  void initState() {
    filterState = [...widget.filterStateList];
    deepCopy([...widget.filterStateList]);
    super.initState();
  }

  void deepCopy(List<dynamic> stateList) {
    for (int i = 0; i < filterState.length; i++) {
      var m = json.decode(json.encode(filterState[i]));
      bufferFilterState.add(m);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context, bufferFilterState);
            },
            icon: Icon(Icons.clear, color: Colors.black,)
          ),
          title: Text("필터", style: TextStyle(color: Colors.black),),
          actions: [
            TextButton(
              onPressed: (){
                // seleted = '';
                for(int i = 0; i < filterState.length; i++) {
                  setState(() {
                    filterState[i]['state'] = false;
                  });
                }
              },              
              child: Text(
                '초기화',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Container(
              child: Stack(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Positioned(
                    child: Column(
                      children: [
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Container(
                        //       margin: EdgeInsets.symmetric(horizontal: 5),
                        //       child: Text(
                        //         "성별",
                        //         style: TextStyle(
                        //           fontSize: 15,
                        //           fontWeight: FontWeight.w600
                        //         ),
                        //       ),
                        //     ),
                        //     SizedBox(height: 8,),
                        //     Row(
                        //       children: [
                        //         for(int i = 0; i < filterState.length; i++)
                        //           if(filterState[i]['menu'] == '성별')
                        //             GestureDetector(
                        //               onTap: (){
                        //                 setState(() {
                        //                   // print(filterState[i]['text']);
                        //                   filterState[i]['state'] = !filterState[i]['state'];
                        //                 });                 
                        //               },
                        //               child: Container(
                        //                 margin: EdgeInsets.symmetric(horizontal: 5),
                        //                 decoration: BoxDecoration(
                        //                   borderRadius: BorderRadius.circular(15),
                        //                   color: filterState[i]['state']
                        //                     ?DesignCourseAppTheme.nearlyBlue.withOpacity(0.9)
                        //                     : Colors.grey.withOpacity(0.3),
                        //                 ),
                        //                 padding: EdgeInsets.fromLTRB(14, 7, 14, 7),
                        //                 child: Text(
                        //                   filterState[i]['text'],
                        //                   textAlign: TextAlign.center,
                        //                   style: TextStyle(
                        //                     color: filterState[i]['state']
                        //                     ?Colors.white
                        //                     : Colors.black,
                        //                     fontWeight: filterState[i]['state']
                        //                     ? FontWeight.w600
                        //                     : FontWeight.w500
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 15,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                "카테고리",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                            SizedBox(height: 8,),
                            Row(
                              children: [
                                for(int i = 0; i < filterState.length; i++)
                                  if(filterState[i]['menu'] == '카테고리')
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          // print(filterState[i]['text']);
                                          filterState[i]['state'] = !filterState[i]['state'];
                                        });                 
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: filterState[i]['state']
                                            ?DesignCourseAppTheme.nearlyBlue.withOpacity(0.9)
                                            : Colors.grey.withOpacity(0.3),
                                        ),
                                        padding: EdgeInsets.fromLTRB(14, 7, 14, 7),
                                        child: Text(
                                          filterState[i]['text'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: filterState[i]['state']
                                            ?Colors.white
                                            : Colors.black,
                                            fontWeight: filterState[i]['state']
                                            ? FontWeight.w600
                                            : FontWeight.w500
                                          ),
                                        ),
                                      ),
                                    ),
                                  
                              ],
                            ),
                          ]
                        ),
                      ],
                    )
                  ),
                  Positioned(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: (){                    
                          Navigator.pop(context, filterState);
                        },
                        child: Container(
                          height: 48,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            color: DesignCourseAppTheme.nearlyBlue,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16.0),
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: DesignCourseAppTheme
                                      .nearlyBlue
                                      .withOpacity(0.5),
                                  offset: const Offset(1.1, 1.1),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '적용',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                letterSpacing: 0.0,
                                color: DesignCourseAppTheme
                                    .nearlyWhite,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )                  
                ],
              )
            ),
          ),
        )
      ),
    );
  }
}
