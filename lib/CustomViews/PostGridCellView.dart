import 'package:flutter/material.dart';

class PostGridCellView extends StatelessWidget{

  final String sNickName;
  final String sBody;
  final String sDate;
  final int iColorCode;
  final double dFontSize;
  final int iPosition;
  final Function(int index) onItemListClickedFun;

  const PostGridCellView({super.key,
    required this.sNickName,
    required this.sBody,
    required this.sDate,
    required this.iColorCode,
    required this.dFontSize,
    required this.iPosition,
    required this.onItemListClickedFun,
  });


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      child: FractionallySizedBox(
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(108, 99, 255, .2),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(
                color: Color.fromRGBO(108, 99, 255, .4),
                blurRadius: 20,
                offset: Offset(0, 20)
            )
            ]
        ),
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(25),
        child: Row(
          children: [
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sNickName,style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                    const SizedBox(height: 10,),
                    Expanded(
                      child: Container(
                        child: Text(
                        sBody,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(sDate),
                    //"$sNickName • $sDate"
                  ],
                )
            )
          ],
        )
      ),
    ),
      onTap: (){
        onItemListClickedFun(iPosition);
      },
    );
  }


}