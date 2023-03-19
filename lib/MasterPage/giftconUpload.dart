import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jitutorapp/DataStore/OrderStore.dart';
import 'package:provider/provider.dart';
final firestore = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;


class GiftconUpload extends StatefulWidget {
  final index;
  const GiftconUpload({Key? key, required this.index}) : super(key: key);

  @override
  State<GiftconUpload> createState() => _GiftconUploadState();
}

class _GiftconUploadState extends State<GiftconUpload> {
  //여기는 변수, 함수

  String userImage = '';
  String itemName = '';
  String itemPrice = '';
  String postImageDownloadUrl = '';

  void setpostImageDownloadUrl(String s) {
    setState(() {
      postImageDownloadUrl = s;
    });
  }
  void setUserImage(String s) {
    setState(() {
      userImage = s;
    });
  }

  // 여기는 갤러리에서 이미지 경로 가져오기
  void pickUserImage() async{
    var picker = ImagePicker();
    try {
      var image = await picker.pickImage(source: ImageSource.gallery);
      if(image != null) {
        setUserImage(image.path);
        print(userImage);
      }
      else
        Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(
          msg: '이미지를 불러오는 중에 오류가 발생했습니다.',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          fontSize: 12
      );
      Navigator.pop(context);
    }
  }

  // 파이어베이스에 이미지 업로드 하는 코드
  // 여기는 게시글을 파이어베이스에 업로드하는 코드
  Future uploadItem(int index) async{
    File userphoto = File(userImage);
    if (userphoto == null) return;
    final filename = userImage.substring(userImage.lastIndexOf("/")+1);
    try {
      final ref = storage.ref().child('giftcon/$filename');
      await ref.putFile(userphoto);
      var url = await ref.getDownloadURL();
      setState(() {
        postImageDownloadUrl = url;
      });
    } catch (e) {
      print(e);
    }
    String uploadTime = DateTime.now().toString();
    var ref = context.read<OrderStore>().orderList[index];
    await ref.reference.update({
      'giftconUploadTime' : uploadTime,
      'state' : 'after',
      'giftconImage' : postImageDownloadUrl,
      'giftconFilename' : filename,
    });
    context.read<OrderStore>().deleteOrderListElement(index);
  }

  // 변수, 함수 끝

  @override
  void initState() {
    pickUserImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int index = widget.index;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0), child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Colors.black,))),
        title: Text('기프티콘 등록'),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: 'Pretendard',
          fontSize: 20,
        ),
        actions: [
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 5, 0), child: IconButton(onPressed: ()async{await uploadItem(index); Navigator.pop(context);}, icon: Icon(Icons.done, color: Colors.blue,)))
        ],
      ),
      body: userImage.isNotEmpty ? Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width/1.3,
            height: MediaQuery.of(context).size.height/2,
            child: Image.file(File(userImage), fit: BoxFit.fill,),
          ),
          Container(
            width: double.infinity,
            height: 0.5,
            color: Colors.grey,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Text('상품명 : ' + context.read<OrderStore>().orderList[index]['name'], style: TextStyle(fontSize: 15),),),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Text('학생 이름 : '+ context.read<OrderStore>().orderList[index]['userName'], style: TextStyle(fontSize: 15),),
          )
        ],
      ) : Container(width: 10, height: 10,),
    );

  }
}
