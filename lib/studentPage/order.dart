import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jitutorapp/DataStore/OrderStore.dart';
import 'package:jitutorapp/DataStore/UserStore.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  // 변수
  var bodyTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'LINESeedKR',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  var headTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'LINESeedKR',
    fontSize: 16,
  );
  //

  @override
  void initState() {
   if (context.read<OrderStore>().needRefresh) {
     context.read<OrderStore>().initOrderList(context.read<UserStore>().userUID);
     context.read<OrderStore>().setRefreshFalse();
   }
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
        title: Text('기프티콘 보관함'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: 'LINESeedKR',
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
              if (context.read<OrderStore>().orderList[i]['state'] == 'before') {
                Fluttertoast.showToast(
                  msg: '아직 기프티콘이 도착하지 않았습니다.\n1-2일 후 다시 확인해주세요.',
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.black87,
                  fontSize: 12,
                );
                return ;
              }
              showBarModalBottomSheet(
                  context: context,
                  builder: (context) => Product(index : i)
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

// 기프티콘 확인하기
class Product extends StatelessWidget {
  const Product({super.key, required this.index});

  final index;

  @override
  Widget build(BuildContext context) {
    var bodyTextStyle = TextStyle(
      color: Colors.black,
      fontFamily: 'LINESeedKR',
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );
    var headTextStyle = TextStyle(
      color: Colors.black,
      fontFamily: 'LINESeedKR',
      fontSize: 20,
    );
    var buttonTextStyle = TextStyle(
      color: Colors.white,
      fontFamily: 'LINESeedKR',
      fontSize: 20,
    );
    double siedMargin = MediaQuery.of(context).size.width / 10;

    return Material(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height / 1.3,
        margin: EdgeInsets.fromLTRB(siedMargin, 20, siedMargin, 40),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: MediaQuery.of(context).size.width - (2 * siedMargin),
                height: MediaQuery.of(context).size.height / 1.3 - 60 - MediaQuery.of(context).size.height / 18,
                color: Colors.white,
                child: ExtendedImage.network(
                  context.read<OrderStore>().orderList[index]['giftconImage'],
                  fit: BoxFit.fill,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ],),
              Column(children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff0067a3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))
                    ),
                    onPressed: () {
                      FlutterDialog(context, index);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 18,
                      child: Text('보관함에서 삭제하기', style: buttonTextStyle,),
                    )),
              ],),
            ]),
      ),
    );
  }
}


  // 예 아니로 다이얼로그 함수
  void FlutterDialog(var context, int index) {
    var parrentContext = context;
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            contentPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            //Dialog Main Title
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height / 15,
                  alignment: Alignment.center,
                  child: Text('삭제하면 더 이상 복구할 수 없습니다.\n 그래도 하시겠습니까?', style: TextStyle(
                    fontFamily: 'LINESeedKR',
                    color: Colors.black,
                    fontSize: 14,
                  ), textAlign: TextAlign.center,),
                ),
                Container(
                  color: Colors.grey,
                  height: 0.5,
                  width: double.infinity,
                )
              ],
            ),
            //
            content: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('아니오', style: TextStyle(
                        fontFamily: 'LINESeedKR',
                        fontSize: 15,
                        color: Colors.black,)),
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    width: 0.5,
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                      ),
                      onPressed: () async {
                        context.read<OrderStore>().deleteOrder(index);
                        Navigator.of(context).pop();
                        Navigator.pop(parrentContext);
                      },
                      child: Text('네', style: TextStyle(
                        fontFamily: 'LINESeedKR',
                        fontSize: 15,
                        color: Colors.black,)),
                    ),
                  ),
                ]
            ),
          );
        });
  }
