import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  HomeTab({super.key,
    this.postResult,
    this.addMore,
    this.getNum,
    // this.photoUrl,
    // this.postList,
    this.postDict,
  });
  final postResult;
  final addMore;
  final getNum;
  // final photoUrl;
  // final postList;
  final postDict;


  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  var scroll = ScrollController();


  getMore() {
      setState(() {
        widget.addMore();
      });
  }

  @override
  void initState() {

    super.initState();
    scroll.addListener(() {
      // 왼쪽 (scroll) 변수가 변할떄 마다 중괄호 안 실행 / 리스너라 칭함
      // 필요 없어지면 지우는게 성능에 좋음
      // print(scroll.position.pixels);
      // scroll.position.pixels 위에서 얼마나 스크롤 했는지 알려줌
      // scroll.position.maxScrollExtent 스크롤바 최대 내릴 수 있는 높이
      // scroll.position.userScrollDirection 유저가 어느 방향으로 스크롤 하는지 확인 가능
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        getMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    // return ListView.builder(
    //   itemCount: postResult.length,
    //
    //   itemBuilder: (content, index){
    //     final post = postResult[index];
    //     return FeedView(
    //         photo: photoUrl[index],
    //         postText: postList[index],
    //         like: postResult[index]['likes']
    //     );
    //
    //   },
    // );
    // api 요청이 안되는 경우 if else 로 쓴다

    if (widget.postResult.isNotEmpty) { // stateful  인 경우 부모의 변수 가져오면 widget.{변수} 형태로 해야함
      return ListView.builder(
        itemCount: widget.postResult.length,
        controller: scroll, // 스크롤바 높이 측정
        itemBuilder: (content, index){
          return FeedView(
              photo: widget.postDict[index]['photo'],
              postText: widget.postDict[index]['content'],
              like: widget.postDict[index]['likes']
          );

        },
      );
    }
    else {
      return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text('로딩 중...'),
        ],
      ));
      // return Text('loading');
    }

  }
}

class FeedView extends StatelessWidget {
  const FeedView({super.key, this.photo, this.postText, this.like});
  final photo;
  final postText;
  final like;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 60,
                    child: Row(
                      children: [
                        ClipOval(
                            clipper: MyClipper(),
                            child: SizedBox.fromSize(
                              // Image.network <- 웹상 이미지 가져옴
                                child: Image.asset('assets/oh.jpeg',width: 60,height: 60,)
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: GestureDetector(
                            child: Text('ogu_official',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,),
                            ),
                            onTap: (){
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (c, a1, a2) => Profile(),
                                      transitionsBuilder: (c, a1, a2, child) =>
                                          FadeTransition(opacity: a1, child: child),
                                      transitionDuration: Duration(microseconds: 5000)
                                      // 전환 속도 조절 가능
                                  ) // child = Profile
                                // a1 = animation object 페이지 얼마나 전환 됐는지 0~1 사이값으로 변함
                                // a2 = animation object 임, 기존페이지 애니메이션 줄 때 씀

                              );
                            },
                          )
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Icon(Icons.more_horiz),
                  )
                ],
              )
          ),
          if(photo.runtimeType.toString() != '_File') FractionallySizedBox(
            widthFactor: 1,
            child: Image.asset('assets/$photo',),
          ),
          if(photo.runtimeType.toString() == '_File') FractionallySizedBox(
            widthFactor: 1,
            child: Image.file(photo),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.favorite_border_outlined),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(Icons.mode_comment_outlined),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(CupertinoIcons.paperplane),
                      ),

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(Icons.bookmark_outline),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(12, 0, 5, 0),
            child: Text('좋아요 $like개',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(12, 5, 5, 12),
            child: Row(
              children: [
                Text('ogu_official',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Text(postText,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )

              ],
            ),
          )
        ],
      ),
    );
  }
}


class MyClipper extends CustomClipper<Rect>{

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(10, 5, 50, 50);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;

  }
}


class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text('프로필 페이지'),
    );
  }
}
