//여기는 외부파일 import
import 'package:jitutorapp/DataStore/ClassStore.dart';
import 'package:jitutorapp/DataStore/PostStore.dart';
//
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:provider/provider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

//스타일
var textTheme = TextStyle(
  fontFamily: 'LINESeedKR',
  fontSize: 13,
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
    // 스크롤 최하단에 도달하면 게시글 더 불러오기
    scroll.addListener(() {
      if(scroll.position.pixels == scroll.position.maxScrollExtent) {
        context.read<PostStore>().moregetPostDoc(context.read<ClassStore>().userClassUIDList);
      }
    });
    super.initState();
  }

  //변수, 함수
  // 리스트뷰 빌러 스크롤 바
  var scroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    if(context.watch<PostStore>().postDocList.isEmpty) {
      return Container();
    }
    else {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: context.watch<PostStore>().postDocList.isNotEmpty ? RefreshIndicator(
          onRefresh: ()async{context.read<PostStore>().refreshPost(context.read<ClassStore>().userClassUIDList);},
          child: ListView.builder(
                itemCount: context.watch<PostStore>().postDocList.length,
                controller: scroll,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          height: MediaQuery.of(context).size.width/8,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(padding: EdgeInsets.all(7) ,child: Icon(Icons.account_circle, size: 30,)),
                                  Text(context.read<PostStore>().postDocList[i]['className'], style: textTheme,),
                                ],
                              ),
                              IconButton(onPressed: (){
                                context.read<PostStore>().setlistNum(i);
                                showMaterialModalBottomSheet(
                                    context: context,
                                    builder: (context) => ModalFit()
                                );}
                              , icon: Icon(Icons.more_vert)),
                            ],
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: ExtendedImage.network(
                            context.read<PostStore>().postDocList[i]['image'],
                            fit: BoxFit.fill)
                      ),
                      Container(
                          padding: EdgeInsets.all(13),
                          child: Row(
                            children: [
                              context.watch<PostStore>().postDocList[i]['heart'] == false
                                  ? IconButton(icon:  Icon(Icons.favorite_border, size: 30,),padding: EdgeInsets.zero, onPressed: (){context.read<PostStore>().changeHeart(i);},constraints: BoxConstraints(),)
                                  : IconButton(icon:  Icon(Icons.favorite, size: 30, color: Colors.red,), padding: EdgeInsets.zero, onPressed: (){context.read<PostStore>().changeHeart(i);},constraints: BoxConstraints(),),
                              Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0), child: IconButton(icon: Icon(Icons.bookmark_border_rounded, size: 30), onPressed: (){}, constraints: BoxConstraints(), padding: EdgeInsets.zero,),),
                            ],
                          )
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(13, 0, 0, 5), child: Text(context.read<PostStore>().postDocList[i]['date'], style: TextStyle(
                        fontFamily: 'LINESeedKR',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),)),
                      Container(
                        padding: EdgeInsets.fromLTRB(13, 0, 15, 10),
                        child: Text(context.read<PostStore>().postDocList[i]['comment'], style: TextStyle(
                          fontFamily: 'LINESeedKR',
                          fontSize: 13,
                        ),),
                      )
                    ],
                  );
                },
          ) ,
        ) : Text('게시글이 없습니다.'),
      ),
    );
  } //else문 끝
  }
}


// 댓글달기 버튼 다이로그 위젯 - 아직 개발전
class ModalFit extends StatelessWidget {
  const ModalFit({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text('댓글달기'),
              leading: const Icon(Icons.edit),
              onTap: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
