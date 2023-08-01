import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'themedata_plus.dart' as themedata;
import 'home.dart' as home;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart'; //스크롤 높이 다룰 때 씀

void main() {
  runApp(
      MaterialApp(
        //스타일 테그로 다 넣을 수 있는거랑 비슷
        theme: themedata.theme,
          home: MyApp()
      )
  );
}
var a = TextStyle();
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // tab 에 현재 state 저장
  int tab = 0;
  var data = [];
  int getNum = 0;
  var url;
  var photoUrl = ['go_home.jpeg', 'bed_good.jpeg', 'no_taste.jpeg'];
  var postList = ['집에 가고 싶다', '따뜻한 이불속이 최고야', '요즘 입맛이 없어'];

  getData() async{
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    // 요청 성고 했을때
    // Dio 가 더 http 보다 좋음
    if(result.statusCode==200) {
      var result2 = jsonDecode(result.body); //dio 쓰면 이거 안써도 됨
      print(result2[0]);
      setState(() {
        data = result2;
      });
    } else {
      data = [];

    }

  }
  addMore() async{
    getNum++;
    if (getNum <= 2){
      if (getNum==1) {
        url = 'https://codingapple1.github.io/app/more1.json';
        photoUrl.add('iloveu.jpeg');
        postList.add('널 좋아해');
      } else {
        url = 'https://codingapple1.github.io/app/more2.json';
        photoUrl.add('hug.jpeg');
        postList.add('꼬옥 안아줄게');
      }
      var result = await http.get(Uri.parse(url));
      var result2 = jsonDecode(result.body);
      setState(() {
        data.add(result2);
      });
    }



  }
  // 앱실행할때 실행
  @override
  void initState(){
    super.initState();
    getData();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            children: [
              Image.asset('assets/insta_logo.png',width: 120),
              Icon(Icons.expand_more)
            ],
          ),
          centerTitle: false,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite_border_outlined),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(CupertinoIcons.paperplane),
            ),
          ]
      ),
      body: [
        // FutureBuilder 는 한번 가져오는거로 사용해주는게 좋음
        // FutureBuilder(builder: (){}, future: data),
        home.HomeTab(
            postResult: data,
            addMore: addMore,
            getNum: getNum,
            photoUrl: photoUrl,
            postList: postList,
        ),
        Text('검색')
      ][tab],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: (i){
          setState(() {
            tab = i;
          });
        },

        // 페이지 나누고 싶으면 Navigator, Router, tab 으로 구현 가능

        // 동적 ui 만들기 3 steps
        // 1. state 만들기 : state 에 ui의 현재상태 저장 (몇번쨰 페이지가 보이는건지)
        // 2. state 에 따라 tab 이 어떻게 보일지 작성 (state 가 무엇인지에 따라 해당 페이지 보여주기
        // 3. 유저가 쉽게 state 조작할 수 있게

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'post'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_outlined),
            label: 'video'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'profile'
          ),
        ],
      ),
    );

  }
}

