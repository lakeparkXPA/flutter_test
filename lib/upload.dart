import 'package:flutter/material.dart';
import 'dart:io';

class Upload extends StatefulWidget {
  Upload({super.key, this.image, this.addPost});

  final image;
  final addPost;
  final myController = TextEditingController();

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  addPost2(String content, File photo) {
    setState(() {
      widget.addPost(content: content, photo: photo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('새 게시물',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        centerTitle: false,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        actions: [
          IconButton(
            onPressed: (){
              print(widget.image);
              print(widget.image.runtimeType);
              setState(() {
                widget.addPost(widget.myController.text, widget.image);
              });

              Navigator.pop(context); //context 는 material app 의 context
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.file(widget.image,width: 70,height: 70,),
              Container(
                width: 100,
                child: TextField(controller: widget.myController,)
              )

            ],
          ),
          Container(
              child: Text('사람 태그하기', style: TextStyle(fontSize: 20),),
            height: 50,
          ),

        ],
      ),
    );
  }
}
