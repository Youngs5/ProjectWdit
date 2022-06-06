import 'package:wdit/design_course/category_list_view.dart';
import 'package:wdit/design_course/club_list_view.dart';
import 'package:wdit/design_course/course_info_screen.dart';
import 'package:wdit/design_course/create_group_screen.dart';
import 'package:wdit/design_course/mypage.dart';
import 'package:wdit/design_course/popular_course_list_view.dart';
import 'package:wdit/design_course/filter_screen.dart';
import 'package:wdit/design_course/search_screen.dart';
import 'package:wdit/main.dart';
import 'package:flutter/material.dart';
import 'design_course_app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DesignCourseHomeScreen extends StatefulWidget {
  @override
  _DesignCourseHomeScreenState createState() => _DesignCourseHomeScreenState();
}

class _DesignCourseHomeScreenState extends State<DesignCourseHomeScreen> {
  CategoryType categoryType = CategoryType.ui;
  final _auth = FirebaseAuth.instance;
  User? loggedUser;
  String? userName;
  String? userEmail;
  String? userImage;
  
  List filterList = [];

  List filterStateBuffer = [
    {'text': '스포츠', 'state': false, 'menu': '카테고리'},
    {'text': '스터디', 'state': false, 'menu': '카테고리'},
    {'text': '취미', 'state': false, 'menu': '카테고리'},
    {'text': '카풀', 'state': false, 'menu': '카테고리'},
    {'text': '남자', 'state': false, 'menu': '성별'},
    {'text': '여자', 'state': false, 'menu': '성별'},
    {'text': '아무나', 'state': false, 'menu': '성별'},
  ];

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser(){
    try{
      final user = _auth.currentUser;
      if(user != null){
        userName = user.displayName;
        userEmail = user.email;
        userImage = user.photoURL;
        print(user.uid);
      }
    }catch(e){
      print(e);
    }
  }  

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            getAppBarUI(),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    // getSearchBarUI(),
                    getCategoryUI(),
                    Flexible(
                      child: getPopularCourseUI(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getCategoryUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
          child: Text(
            'Category',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              letterSpacing: 0.27,
              color: DesignCourseAppTheme.darkerText,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: ()async {
                  final returnData = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FilterScreen(filterStateList: [...filterStateBuffer],)
                    )
                  );

                  if (returnData != null) {
                    List filter = [];
                    for (Map<String, dynamic> filterItem in returnData) {
                      if(filterItem['state'] == true) {
                        filter.add(filterItem['text']);
                      }
                    }
                    setState(() {
                      filterList = filter;
                      filterStateBuffer = [...returnData];
                    });
                  }
                },
                icon: Icon(Icons.filter_list)
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Container(
                  height: 30,
                  // color: Colors.grey,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filterStateBuffer.length,
                    itemBuilder: (context, i) {
                        return  GestureDetector(
                            onTap: (){
                              setState(() {
                                filterStateBuffer[i]['state'] = !filterStateBuffer[i]['state'];

                                List filter = [];
                                for (Map<String, dynamic> filterItem in filterStateBuffer) {
                                  if(filterItem['state'] == true) {
                                    filter.add(filterItem['text']);
                                  }
                                }
                                setState(() {
                                  filterList = filter;
                                  filterStateBuffer = [...filterStateBuffer];
                                });                            
                              }
                            );                 
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: filterStateBuffer[i]['state']
                                ?DesignCourseAppTheme.nearlyBlue.withOpacity(0.9)
                                : Colors.grey.withOpacity(0.2),
                            ),
                            padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                            child: Text(
                              filterStateBuffer[i]['text'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: filterStateBuffer[i]['state']
                                ?Colors.white
                                : Colors.black,
                                fontWeight: filterStateBuffer[i]['state']
                                ? FontWeight.w600
                                : FontWeight.w500
                              ),
                            ),
                          ),
                        );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getPopularCourseUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Clubs',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              letterSpacing: 0.27,
              color: DesignCourseAppTheme.darkerText,
            ),
          ),
          Flexible(
            child: ClubListView(filterData: filterList,),
          )
        ],
      ),
    );
  }

  Widget getButtonUI(CategoryType categoryTypeData, bool isSelected) {
    String txt = '';
    if (CategoryType.ui == categoryTypeData) {
      txt = 'Ui/Ux';
    } else if (CategoryType.coding == categoryTypeData) {
      txt = 'Coding';
    } else if (CategoryType.basic == categoryTypeData) {
      txt = 'Basic';
    }
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: isSelected
                ? DesignCourseAppTheme.nearlyBlue
                : DesignCourseAppTheme.nearlyWhite,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            border: Border.all(color: DesignCourseAppTheme.nearlyBlue)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            onTap: () {
              setState(() {
                categoryType = categoryTypeData;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 7, bottom: 7),
              child: Center(
                child: Text(
                  txt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color: isSelected
                        ? DesignCourseAppTheme.nearlyWhite
                        : DesignCourseAppTheme.nearlyBlue,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: 64,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: HexColor('#F8FAFB'),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(13.0),
                    bottomLeft: Radius.circular(13.0),
                    topLeft: Radius.circular(13.0),
                    topRight: Radius.circular(13.0),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: TextFormField(
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: DesignCourseAppTheme.nearlyBlue,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Search for course',
                            border: InputBorder.none,
                            helperStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: HexColor('#B9BABC'),
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 0.2,
                              color: HexColor('#B9BABC'),
                            ),
                          ),
                          onEditingComplete: () {},
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Icon(Icons.search, color: HexColor('#B9BABC')),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          )
        ],
      ),
    );
  }

  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset('assets/images/wdit4.png', height: 33,),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Group();
                      },
                    ),
                  );
                },
              ),              
              IconButton(
                icon: Icon(Icons.search),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        // return DesignCourseHomeScreen();
                        return SearchScreen();
                      },
                    ),
                  );
                },
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {return MyPage();},
                      ));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Image.network(
                      '$userImage',
                      height: 33,
                      width: 33,
                  ),
                ),
              ),
            ],
          )  
        ],
      ),
    );
  }
}

enum CategoryType {
  ui,
  coding,
  basic,
}
