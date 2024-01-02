import 'package:flutter/material.dart';
import 'package:gas_accounting/utill/styles.dart';

import '../../../../utill/app_constants.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/dimensions.dart';

class OrderTypeButtonHead extends StatelessWidget {
  final String text;
  // final String? id;
  final String? image;
  final String amount;
  // final String static;
  final Widget onTap;
  OrderTypeButtonHead({required this.text,this.image ,required this.amount,required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaleFactor;
    // print("object:::$textScale");
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => onTap)),
      child: Container(
        margin: EdgeInsets.all(AppConstants.itemWidth*0.02),
        decoration: BoxDecoration(
            color: ColorResources.WHITE,
            borderRadius: BorderRadius.circular(10),
            boxShadow: <BoxShadow>[
        BoxShadow(
        color: Colors.grey.shade400,
            offset: Offset(2, 4),
            blurRadius: 3,
            spreadRadius: 1)
        ],
        ),
        child: Container(
          alignment: Alignment.center,
          width: AppConstants.itemWidth*0.46,
          height: AppConstants.itemHeight*0.12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(image!,height: AppConstants.itemWidth * 0.08, width: AppConstants.itemWidth * 0.08,color: ColorResources.LINE_BG,),
              // SizedBox(width: AppConstants.itemWidth*0.01),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.fill,
                    child: Text(text,
                        textAlign: TextAlign.center,
                        style: montserratRegular.copyWith(color: ColorResources.BLACK,fontWeight: FontWeight.w600,fontSize: MediaQuery.of(context).size.height*0.015)),
                  ),
                  SizedBox(height: AppConstants.itemHeight*0.01),
                  FittedBox(
                    fit: BoxFit.fill,
                    child: Text(amount,
                        textAlign: TextAlign.center,
                        style: montserratRegular.copyWith(color: ColorResources.GREY,fontWeight: FontWeight.w600)),
                  ),
                  /*Row(
                    children: [
                      Icon(id=="1"?Icons.arrow_upward:Icons.arrow_downward,size: 20,color: id=="1"?ColorResources.GREEN:Colors.red,),
                      Text(static,
                          textAlign: TextAlign.center,
                          style: montserratRegular.copyWith(color: id=="1"?ColorResources.GREEN:Colors.red,fontSize: 14,fontWeight: FontWeight.w600)),
                    ],
                  ),*/
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
