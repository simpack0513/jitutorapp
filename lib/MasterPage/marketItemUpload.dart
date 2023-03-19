import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
final firestore = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;


class MarketItemUpload extends StatefulWidget {
  const MarketItemUpload({Key? key}) : super(key: key);

  @override
  State<MarketItemUpload> createState() => _MarketItemUploadState();
}

class _MarketItemUploadState extends State<MarketItemUpload> {
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
  Future uploadItem() async{
    File userphoto = File(userImage);
    if (userphoto == null) return;
    final filename = userImage.substring(userImage.lastIndexOf("/")+1);
    try {
      final ref = storage.ref().child('marketItem/$filename');
      await ref.putFile(userphoto);
      var url = await ref.getDownloadURL();
      setState(() {
        postImageDownloadUrl = url;
      });
      print(postImageDownloadUrl);
    } catch (e) {
      print(e);
    }
    firestore.collection('MarketItem').add({
      'name' : itemName,
      'price' : int.parse(itemPrice),
      'image' : postImageDownloadUrl,
      'filename' : filename,
      'likes' : 0,
    });
  }

  // 변수, 함수 끝

  @override
  void initState() {
    pickUserImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0), child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Colors.black,))),
        title: Text('새 상품 등록'),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: 'Pretendard',
          fontSize: 20,
        ),
        actions: [
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 5, 0), child: IconButton(onPressed: ()async{await uploadItem(); Navigator.pop(context);}, icon: Icon(Icons.done, color: Colors.blue,)))
        ],
      ),
      body: userImage.isNotEmpty ? Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width/2,
            height: MediaQuery.of(context).size.width/2,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('상품명', style: TextStyle(fontSize: 15),),
                SizedBox(
                  width: MediaQuery.of(context).size.width/2,
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '여기 입력...',
                    ),
                    onChanged: (text){
                      setState(() {
                        itemName = text;
                      });
                    },
                  ),
                ),
              ],
          ),),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('상품 가격', style: TextStyle(fontSize: 15),),
                SizedBox(
                  width: MediaQuery.of(context).size.width/2,
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '여기 입력...',
                    ),
                    onChanged: (text){
                      setState(() {
                        itemPrice = text;
                      });
                    },
                  ),
                ),
              ],
            ),
          )


        ],
      ) : Container(width: 10, height: 10,),
    );

  }
}
