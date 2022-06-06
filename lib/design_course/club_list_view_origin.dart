import 'package:wdit/design_course/models/model_club.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'design_course_app_theme.dart';
import 'package:wdit/main.dart';
import 'package:wdit/design_course/course_info_screen.dart';

class ClubListView extends StatefulWidget {
  const ClubListView({ Key? key, required this.filterData }) : super(key: key);
  final List filterData;

  @override
  State<ClubListView> createState() => _ClubListViewState();
}

class _ClubListViewState extends State<ClubListView> {

  Widget _buildBody(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
        .collection('chat')
        .orderBy('time', descending: true)
        .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs =  snapshot.data!.docs;
        return _buildList(context, chatDocs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<QueryDocumentSnapshot<Map<String, dynamic>>> chatDocs) {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> searchResults = [];
    if(widget.filterData.length == 0) {
      for(QueryDocumentSnapshot<Map<String, dynamic>> d in chatDocs) {
        if (d.data().toString().contains('')) {
          searchResults.add(d);
        }
      }
    } else {
      for(int i = 0; i < widget.filterData.length; i++) {
        for(QueryDocumentSnapshot<Map<String, dynamic>> d in chatDocs) {
          if (d.data().toString().contains(widget.filterData[i])) {
            searchResults.add(d);
          }
        }
      }
    }

    return Flexible(
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.07,
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: searchResults.map((e) => _buildListItem(context, e)).toList(),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> data) {
    final club = Club.fromSnapshot(data);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: (){
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) {
          //       return CourseInfoScreen(title: club.text,);
          //     },
          //   ),
          // );
        },
        child: InkWell(
          splashColor: Colors.transparent,
          child: SizedBox(
            height: 280,
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: HexColor('#F8FAFB'),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(16.0)),
                            // border: new Border.all(
                            //     color: DesignCourseAppTheme.notWhite),
                          ),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 16, left: 16, right: 16),
                                        child: Text(
                                          club.text,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            letterSpacing: 0.27,
                                            color: DesignCourseAppTheme
                                                .darkerText,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8,
                                            left: 16,
                                            right: 16,
                                            bottom: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              '23 users',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontSize: 12,
                                                letterSpacing: 0.27,
                                                color: DesignCourseAppTheme
                                                    .grey,
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    '4.5',
                                                    textAlign:
                                                        TextAlign.left,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      fontSize: 12,
                                                      letterSpacing: 0.27,
                                                      color:
                                                          DesignCourseAppTheme
                                                              .grey,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    color:
                                                        DesignCourseAppTheme
                                                            .nearlyBlue,
                                                    size: 12,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 48,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 24, right: 16, left: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: DesignCourseAppTheme.grey
                                  .withOpacity(0.2),
                              offset: const Offset(0.0, 0.0),
                              blurRadius: 6.0),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                        child: AspectRatio(
                            aspectRatio: 1.28,
                            child: Image.asset('assets/design_course/interFace3.png')),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.all(5.0),
    //   child: Container(
    //     color: Colors.green,
    //     child: Text(club.text),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            _buildBody(context)
          ],
        ),
      ),
    );
  }

}

