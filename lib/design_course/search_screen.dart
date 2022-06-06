import 'package:wdit/design_course/course_info_screen.dart';
import 'package:wdit/design_course/models/model_club.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'design_course_app_theme.dart';
import 'package:wdit/main.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({ Key? key }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();
  String _searchText = "";

  _SearchScreenState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
        .collection('groups')
        .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final groupData =  snapshot.data!.docs;
        return _buildList(context, groupData);
      },
    );
  }

  Widget _buildList(BuildContext context, List<QueryDocumentSnapshot<Map<String, dynamic>>> groupData) {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> searchResults = [];
    for(QueryDocumentSnapshot<Map<String, dynamic>> d in groupData) {
      // debugPrint(d.data().toString());
      if (d.data().toString().contains(_searchText)) {
        searchResults.add(d);
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
    // return Flexible(
    //   child: GridView.count(
    //     crossAxisCount: 2,
    //     // childAspectRatio: 1 / 1.1,
    //     padding: EdgeInsets.zero,
    //     children: searchResults.map((e) => _buildListItem(context, e)).toList(),
    //   ),
    // );
  }

  Widget _buildListItem(BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> data) {
    final groupData = GroupData.fromSnapshot(data);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return CourseInfoScreen(groupData: groupData,);
              },
            ),
          );
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
                                          groupData.name,
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
            Padding(padding: EdgeInsets.all(23)),
            Container(
              color: DesignCourseAppTheme.nearlyWhite,
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: TextField(
                      focusNode: focusNode,
                      style: TextStyle(
                          fontFamily: 'WorkSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: DesignCourseAppTheme.nearlyBlue,
                      ),
                      autofocus: true,
                      controller: _filter,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        filled: true,
                        fillColor: HexColor('#F8FAFB'),
                        prefixIcon: Icon(
                          Icons.search,
                          color: HexColor('#B9BABC'),
                          size: 20,
                        ),
                        suffixIcon: focusNode.hasFocus
                        ? IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: (){
                            setState(() {
                              _filter.clear();
                              _searchText = "";
                            });
                          },
                        )
                        : Container(),
                        // hintText: '검색',
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
                    ),
                  ),
                  focusNode.hasFocus
                  ? Expanded(
                    child: TextButton(
                      child: Text("취소"),
                      onPressed: (){
                        setState(() {
                          _filter.clear();
                          _searchText = "";
                          // focusNode.unfocus();
                          Navigator.pop(context);
                        });
                      },
                    ),
                  )
                  : Expanded(
                    flex: 0,
                    child: Container(),
                  )
                ],
              ),
            ),
            _buildBody(context)
          ],
        ),
      ),
    );
  }

}

