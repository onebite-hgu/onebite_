// 공지사항 리스트업
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'notice_detail.dart';

class NoticeListPage extends StatefulWidget {
  @override
  _NoticeListPageState createState() => _NoticeListPageState();
}

class _NoticeListPageState extends State<NoticeListPage> {
  @override
  Future _data;

  Future getPosts() async {
    // instantiate my cloud firestore first
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("notice").getDocuments();
    return qn.documents;
  }

  navigateToDetail(DocumentSnapshot post) {
    Navigator.push(context,MaterialPageRoute(builder: (context) => NoticeDetailPage(post: post,)));
  }

  @override
  void initState() {
    // future: getPosts() 로 하면 매번 notice detail 에서 돌아올 때에도 계속 execute함. 그걸 해결하기 위해서
    super.initState();
    _data = getPosts(); // now, instead of call getpost every time, the future can simply use _data! no more re-render
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("공지사항"),
      ),
      body: Container(
        child: FutureBuilder(
            //  future: getPosts(), 에서 future : _data로!
            future: _data,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text("Loading..."),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length, // actual length of returned data from future
                  itemBuilder: (_, index) {
                    return ListTile(
                      // length - index - 1 부터 display 한다는 것은 date 이 최근일 수록 list의 위로 오도록 sorting 함
                      title: Text(snapshot.data[snapshot.data.length-index-1].data["title"]),
                      subtitle: Text(snapshot.data[snapshot.data.length-index-1].data["date"]),
                      onTap: () => navigateToDetail(snapshot.data[snapshot.data.length-index-1]),
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}