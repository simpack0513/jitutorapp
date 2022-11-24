import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class PhotoUpload extends StatefulWidget {
  const PhotoUpload({Key? key}) : super(key: key);

  @override
  State<PhotoUpload> createState() => _PhotoUploadState();
}

class _PhotoUploadState extends State<PhotoUpload> {
  //여기는 변수, 함수
  var classList = ['황인규 영어 수업 - 신지호 선생님', '이승재 수학 수업 - 신지호 선생님', '신채현 수학 수업 - 신지호 선생님'];
  late var selectedClass = classList[0];
  DateTime date = DateTime.now();

  String userImage = '';
  String comment = '';
  void changeComment(String text) {
    setState(() {
      comment = text;
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
      else {
        Navigator.pop(context);
        print('NULL Image');
      }
    } catch (e) {
      print(e);
    }
  }
  //여기는 날짜 고르기 함수
  void showDatePickerPop() async {
    Future<DateTime?> selectedDate = showDatePicker(
      context: context,
      initialDate: DateTime.now(), //초기값
      firstDate: DateTime(2020), //시작일
      lastDate: DateTime(2023), //마지막일
    );
    selectedDate.then((value) {
      if(value == null) value = date;
      setState(() {
      date = value!;
    });});
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
        title: Text('새 게시물'),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: 'Pretendard',
          fontSize: 25,
        ),
        actions: [
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 5, 0), child: IconButton(onPressed: (){}, icon: Icon(Icons.done, color: Colors.blue,)))
        ],
      ),
      body: userImage.isNotEmpty ? Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(width: 100, height: 100, child: Image.file(File(userImage), fit: BoxFit.fill,)),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                  width: MediaQuery.of(context).size.width-120,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (text){changeComment(text);},
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '문구 입력...',
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
                DropdownButton(
                  value: selectedClass,
                    items: classList.map((value) {
                      return DropdownMenuItem(
                          value: value,
                          child: Text(value),);
                    }).toList(),
                    onChanged: (text) {
                      setState(() {
                        selectedClass = text.toString();
                      });
                    }
                )
              ],
          ),),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('수업 날짜', style: TextStyle(fontSize: 15),),
                Row(
                  children: [
                    Text(date.toString().split(' ')[0], style: TextStyle(color: Colors.black)),
                    IconButton(onPressed: (){showDatePickerPop();}, icon: Icon(Icons.add)),
                  ],
                ),
              ],
            ),
          )


        ],
      ) : Container(width: 10, height: 10,),
    );

  }
}
