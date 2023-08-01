import 'package:flutter/material.dart';
import '../themedata_plus.dart' as themedata;

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
class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
              icon: Icon(Icons.add_box_outlined),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite_border_outlined),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.send),
            ),
          ]
      ),
      body: Row(
        children: [
          Icon(Icons.star,),
          TextButton(onPressed: (){}, child:Text('asd')),
          Text('asdf'),
          //Theme.of(context) 는 만들어진 themedata 에 있는 bodyMedium 의 테마 가져옴
          Text('fdsd', style: Theme.of(context).textTheme.bodyMedium,)
        ],
      ),
    );

  }
}