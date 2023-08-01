import 'package:flutter/material.dart';

// _ 가 앞에 붙은 변수는 해당 파일 지역 변수
var _var1;

var theme = ThemeData(
  // textButtonTheme: TextButtonThemeData(
  //   style: TextButton.styleFrom(
  //     backgroundColor: Colors.pink,
  //   )
  // ),
    iconTheme: IconThemeData(color: Colors.black, size: 30),
    appBarTheme: AppBarTheme(
        color: Colors.white, //가까운걸 쓰기 때문에 action 경우 별도 지정 해야함
        actionsIconTheme: IconThemeData(color: Colors.black, size: 30)
    ),
    textTheme: TextTheme(
      // bodyText2 -> Text()
      // subtitle1 -> listTile()
      // button -> TextButton()
      // headline6 -> AppBar() 등등
      //
        bodyMedium: TextStyle(color: Colors.black)
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        selectedIconTheme: IconThemeData(fill: 1, size: 30),
        unselectedIconTheme: IconThemeData(fill: 0, size: 30),

    )
);