//여기는 외부파일 import
import 'package:jitutorapp/DataStore/ClassStore.dart';
import 'package:jitutorapp/DataStore/PostStore.dart';
import 'package:jitutorapp/DataStore/UserStore.dart';
import 'photoUpload.dart';
//
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



//스타일
var textTheme = TextStyle(
  fontFamily: 'Pretendard',
  fontSize: 15,
);

//

class Photo extends StatefulWidget {
  const Photo({Key? key}) : super(key: key);

  @override
  State<Photo> createState() => _PhotoState();
}

class _PhotoState extends State<Photo> {
  @override
  void initState() {
    context.read<PostStore>().initgetPostDoc(context.read<ClassStore>().userClassUIDList);
    super.initState();
  }

  //변수, 함수
  // 리스트뷰 빌러 스크롤 바
  var scroll = ScrollController();
  // 게시글 하트 state 변수
  bool heart = false;
  // 새 게시물 창 띄우기
  void showPhotoUpload() {
    if(context.read<ClassStore>().userClassList[0]=='NULL') {
      Fluttertoast.showToast(
          msg: '현재 배정받은 수업이 없어 새 게시글을 작성할 수 없습니다.',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.grey,
          fontSize: 12
      );
    }
    else Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoUpload()));
  }

  @override
  Widget build(BuildContext context) {
    if(context.watch<PostStore>().postDocList.isEmpty) {
      return Container();
    }
    else {
    return Scaffold(
      body: ListView.builder(
          itemCount: 3,
          itemBuilder: (c, i){return ListView.builder(
            itemCount: context.watch<PostStore>().postDocList.length,
            controller: scroll,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      height: MediaQuery.of(context).size.width/7,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.all(7) ,child: Icon(Icons.account_circle, size: 40,)),
                          Text(context.read<PostStore>().postDocList[i]['className'], style: textTheme,),
                        ],
                      )),
                  Container(
                    child: Image.network(context.read<PostStore>().postDocList[i]['image'], fit: BoxFit.fill),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    color: Colors.lightBlueAccent,
                  ),
                  Container(
                      padding: EdgeInsets.all(13),
                      child: Row(
                        children: [
                          context.watch<PostStore>().postDocList[i]['heart'] == false ? IconButton(icon:  Icon(Icons.favorite_border, size: 30,),padding: EdgeInsets.zero, onPressed: (){context.read<PostStore>().changeHeart(context.read<PostStore>().postDocList[i]);},constraints: BoxConstraints(),) : IconButton(icon:  Icon(Icons.favorite, size: 30, color: Colors.red,), padding: EdgeInsets.zero, onPressed: (){context.read<PostStore>().changeHeart(context.read<PostStore>().postDocList[i]);},constraints: BoxConstraints(),),
                          Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0), child: IconButton(icon: Icon(Icons.bookmark_border_rounded, size: 30), onPressed: (){}, constraints: BoxConstraints(), padding: EdgeInsets.zero,),),
                        ],
                      )
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(13, 0, 0, 5), child: Text(context.read<PostStore>().postDocList[i]['date'], style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold,
                  ),)),
                  Container(
                    padding: EdgeInsets.fromLTRB(13, 0, 15, 10),
                    child: Text(context.read<PostStore>().postDocList[i]['comment'], style: textTheme,),
                  )
                ],
              );
            },
          );}
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        backgroundColor: Colors.indigoAccent,
        child: Icon(Icons.add_a_photo),
        onPressed: (){
          showPhotoUpload();
        },
      ),
    );
  } //else문 끝
  }
}
