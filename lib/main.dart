import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart'; //스크롤 높이 다룰 때 씀
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'themedata_plus.dart' as themedata;
import 'home.dart' as home;
import 'upload.dart' as upload;

void main() {
  runApp(
      MaterialApp(
        //스타일 테그로 다 넣을 수 있는거랑 비슷
        theme: themedata.theme,
          // initialRoute: '/', //페이지 많으면 routes 사용
          // routes: {
          //   '/' : (c) => Text('첫페이지'),
          //   '/detail': (c) => Text('둘째페이지'),
          // },
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
  var postDict = [
    {
      "id": 1,
      "photo": 'go_home.jpeg',
      "content": '집에 가고 싶다',
      "likes": 5,
    },
    {
      "id": 2,
      "photo": 'bed_good.jpeg',
      "content": '따뜻한 이불속이 최고야',
      "likes": 22,
    },
    {
      "id": 3,
      "photo": 'no_taste.jpeg',
      "content": '요즘 입맛이 없어',
      "likes": 10,
    }
  ];
  // var photoUrl = ['go_home.jpeg', 'bed_good.jpeg', 'no_taste.jpeg'];
  // var postList = ['집에 가고 싶다', '따뜻한 이불속이 최고야', '요즘 입맛이 없어'];

  var userImage;

  saveData(String tmpString) async {
    var storage = await SharedPreferences.getInstance();
    storage.setString('name', tmpString); // 저장
    var result = storage.getString('name'); // string 출력
    print(result);
    storage.remove('name');

    var map = {'age': 20};
    storage.setString('map', jsonEncode(map));
    var mapResult = storage.getString('map') ?? 'null'; // object? 에러 발생시 null check
    print(mapResult);
    print(jsonDecode(mapResult)['age']);
    // 이미지는 저장 불가능 -> cached_network_image 사용

  }

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
  addPost(String content, File photo){
    var pTmp = {
      "id": postDict.length + 1,
      "content": content,
      "photo" : photo,
      "likes" : 0,
    };
    postDict.add(pTmp);

    data.add(123);
  }
  addMore() async{
    getNum++;
    if (getNum <= 2){
      if (getNum==1) {
        url = 'https://codingapple1.github.io/app/more1.json';
        var tmp = {
          "id": postDict.length + 1,
          "photo": 'iloveu.jpeg',
          "content": '널 좋아해',
          "likes": 12,
        };
        postDict.add(tmp);
      } else {
        url = 'https://codingapple1.github.io/app/more2.json';
        var tmp = {
          "id": postDict.length + 1,
          "photo": 'hug.jpeg',
          "content": '꼬옥 안아줄게',
          "likes": 29,
        };
        postDict.add(tmp);
      }
      var result = await http.get(Uri.parse(url));
      var result2 = jsonDecode(result.body);
      data.add(result2);
    }



  }
  // 앱실행할때 실행
  @override
  void initState(){
    super.initState();
    getData();
    saveData('lakeparkxpa');

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
              onPressed: () async {
                // Navigation : 기존 페이지 위에 새로운 페이지 올리기, 계속 올리기 가능 (stack 식)
                var picker = ImagePicker();
                var image = await picker.pickImage(source: ImageSource.gallery);
                // image 여러개 선책은 pickMultiImage() 사용
                if (image != null) {
                  setState(() {
                    userImage = File(image.path);
                  });
                }
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => upload.Upload(
                      image: userImage,
                      addPost: addPost,
                    )) //중괄호 안에 return 중괄호만 있으면 오른쪽과 같이 사용 가능
                );
              },
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
            postDict: postDict,
            // photoUrl: photoUrl,
            // postList: postList,
        ),
        Text('검색'),

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
            label: 'post',
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
