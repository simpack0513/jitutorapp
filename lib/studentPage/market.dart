import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:jitutorapp/DataStore/MarketStore.dart';
import 'package:jitutorapp/DataStore/PointStore.dart';
import 'package:jitutorapp/DataStore/UserStore.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class Market extends StatefulWidget {
  const Market({Key? key}) : super(key: key);

  @override
  State<Market> createState() => _MarketState();
}

class _MarketState extends State<Market> {
  //변수
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


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1/1.4,
        ),
        itemCount: context.watch<MarketStore>().marketItem.length,
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
                        context.watch<MarketStore>().marketItem[i]['image'],
                        fit: BoxFit.fill,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                    width: double.infinity,
                    child: Text(context.watch<MarketStore>().marketItem[i]['name'], style: headTextStyle,)
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    width: double.infinity,
                    child: Text(context.watch<MarketStore>().marketItem[i]['price'].toString() + '포인트', style: bodyTextStyle,)
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    padding: EdgeInsets.zero,
                    width: double.infinity,
                    child: Row(children: [
                      Icon(Icons.favorite, color: Colors.grey, size: 12,),
                      Text(' 134', style: TextStyle(color: Colors.grey, fontSize: 12),),
                    ])
                ),

              ],),
            ),
          );
        },

      ),
    );
  }
}

// 구매하기
class Product extends StatelessWidget {
  const Product({super.key, required this.index});

  final index;

  @override
  Widget build(BuildContext context) {
    var bodyTextStyle = TextStyle(
      color: Colors.black,
      fontFamily: 'Pretendard',
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );
    var headTextStyle = TextStyle(
      color: Colors.black,
      fontFamily: 'Pretendard',
      fontSize: 20,
    );
    var buttonTextStyle = TextStyle(
      color: Colors.white,
      fontFamily: 'Pretendard',
      fontSize: 20,
    );
    double siedMargin = MediaQuery.of(context).size.width/10;

    bool isCanBuy = context.read<MarketStore>().checkPointBeforeBuy(context.read<UserStore>().point, index);

    return Material(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height/1.3,
        margin: EdgeInsets.fromLTRB(siedMargin, 20, siedMargin, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: MediaQuery.of(context).size.width/2.3,
              height: MediaQuery.of(context).size.width/2.3,
              color: Colors.white,
              child: ExtendedImage.network(
                context.read<MarketStore>().marketItem[index]['image'],
                fit: BoxFit.fill,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
              width: double.infinity,
              child: Text(context.read<MarketStore>().marketItem[index]['name'], style: headTextStyle,),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              width: double.infinity,
              child: Text(context.read<MarketStore>().marketItem[index]['price'].toString() +'포인트', style: bodyTextStyle,),
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height/13,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0x55ffdfd4),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  width: 2,
                  color: Color(0xffe98c8c),
                )
              ),
              child: RichText(
                text: TextSpan(children: [
                  WidgetSpan(child: Icon(Icons.priority_high, size: 15,)),
                  TextSpan(
                    text: '주의 사항 : 구매 후 약 1일 - 2일 후 보관함으로 기프티콘이 전송됩니다.',
                    style: bodyTextStyle,
                  )
                ]),
              )
            ),
          ],),
          Column(children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text('현재 남은 포인트 : ' + context.read<UserStore>().point.toString(), style: bodyTextStyle,),
            ),
            (isCanBuy) ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff0067a3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                ),
                onPressed: (){
                  FlutterDialog(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height/18,
                  child: Text('구매하기', style: buttonTextStyle,),
                )) : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                        ),
                        onPressed: (){},
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height/18,
                          child: Text('포인트가 부족합니다', style: buttonTextStyle,),
                )),
          ],),
        ]),
      ),
    );
  }

  // 예 아니로 다이얼로그 함수
  void FlutterDialog(var context) {
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
                  height: MediaQuery.of(context).size.height/15,
                  alignment: Alignment.center,
                  child: Text('취소가 불가능합니다. 그래도 구매하시겠습니까?', style : TextStyle(
                    fontFamily: 'Pretendard',
                    color: Colors.black,
                    fontSize: 14,
                  )),
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
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text('아니오', style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 15,
                        color: Colors.black,)),
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    width: 0.5,
                    height: MediaQuery.of(context).size.height/20,
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                      ),
                      onPressed: () async{
                        context.read<UserStore>().givePoint(context.read<MarketStore>().marketItem[index]['price']);
                        context.read<PointStore>().calOrderPoint(context.read<UserStore>().userUID, context.read<MarketStore>().marketItem[index]['price']);
                        context.read<MarketStore>().postNewOrder(index, context.read<UserStore>().name, context.read<UserStore>().userUID);
                        Navigator.of(context).pop();
                        Navigator.pop(parrentContext);
                      },
                      child: Text('네', style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 15,
                        color: Colors.black,)),
                    ),
                  ),
                ]
            ),
          );
        });
  }
}
