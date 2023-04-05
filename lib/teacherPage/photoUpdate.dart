import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:jitutorapp/DataStore/ClassStore.dart';
import 'package:jitutorapp/DataStore/PostStore.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
final firestore = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;


class PhotoUpdate extends StatefulWidget {
  const PhotoUpdate({Key? key}) : super(key: key);

  @override
  State<PhotoUpdate> createState() => _PhotoUpdateState();
}

class _PhotoUpdateState extends State<PhotoUpdate> {
  //여기는 변수, 함수
  late var selectedClass = context.read<ClassStore>().userClassNameList[0];
  late String comment = context.read<PostStore>().postDocList[context.read<PostStore>().listNum]['comment'];

  void changeComment(String text) {
    setState(() {
      comment = text;
    });
  }

  // 변수, 함수 끝

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0), child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Colors.black,))),
        title: Text('게시물 수정'),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: 'LINESeedKR',
          fontSize: 20,
        ),
        actions: [
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: IconButton(onPressed: (){
                context.read<PostStore>().updatePost(comment, context.read<ClassStore>().userClassUIDList);
                Navigator.pop(context);},
              icon: Icon(Icons.done, color: Colors.blue,)))
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    width: 100,
                    height: 100,
                    child: ExtendedImage.network(
                        context.read<PostStore>().postDocList[context.read<PostStore>().listNum]['image'],
                        fit: BoxFit.fill),
                    ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                  width: MediaQuery.of(context).size.width-120,
                  child: TextFormField(
                    initialValue: comment,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (text){changeComment(text);},
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      // hintText: context.read<PostStore>().postDocList[context.read<PostStore>().listNum]['comment'],
                    ),
                  ),
                ),
            ],),

          ),
          Container(
            width: double.infinity,
            height: 0.5,
            color: Colors.grey,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('수업명', style: TextStyle(fontSize: 15),),
                Text(context.read<PostStore>().postDocList[context.read<PostStore>().listNum]['className'] , style: TextStyle(fontSize: 15),)
              ],
          ),),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('수업 날짜', style: TextStyle(fontSize: 15),),
                Text(context.read<PostStore>().postDocList[context.read<PostStore>().listNum]['date'], style: TextStyle(color: Colors.black)),
              ],
            ),
          )


        ],
      ),
    );

  }
}
