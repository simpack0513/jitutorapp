import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jitutorapp/DataStore/OrderStore.dart';
import 'package:jitutorapp/MasterPage/giftconUpload.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class OrderManage extends StatefulWidget {
  const OrderManage({Key? key}) : super(key: key);

  @override
  State<OrderManage> createState() => _OrderManageState();
}

class _OrderManageState extends State<OrderManage> {
  // 변수
  var bodyTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'Pretendard',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  var headTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'Pretendard',
    fontSize: 16,
  );
  //

  @override
  void initState() {
    context.read<OrderStore>().getAllBeforeOrder();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: IconButton(onPressed: () {
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back, color: Colors.black,))),
        title: Text('학생들 주문 내역'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: 'Pretendard',
          fontSize: 20,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Material(
      color: Colors.white,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1/1.4,
        ),
        itemCount: context.watch<OrderStore>().orderList.length,
        itemBuilder: (context, i) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.zero,
              elevation: 0,
            ),
            onPressed: (){
              showBarModalBottomSheet(
                  context: context,
                  builder: (context) => GiftconUpload(index : i)
              );
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Column(children: [
                Container(
                  width: MediaQuery.of(context).size.width/2.1 - 20,
                  height: MediaQuery.of(context).size.width/2.1 - 20,
                  color: Colors.white,
                  child: ExtendedImage.network(
                    context.watch<OrderStore>().orderList[i]['image'],
                    fit: BoxFit.fill,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                    width: double.infinity,
                    child: Text(context.watch<OrderStore>().orderList[i]['name'], style: headTextStyle,)
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    width: double.infinity,
                    child: Text('주문한 학생 : ' + context.watch<OrderStore>().orderList[i]['userName'], style: bodyTextStyle,)
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    width: double.infinity,
                    child: Text('주문 날짜 : ' + context.watch<OrderStore>().orderList[i]['orderTime'].split(' ')[0], style: bodyTextStyle,)
                ),

              ],),
            ),
          );
        },

      ),
    )
    );
  }
}