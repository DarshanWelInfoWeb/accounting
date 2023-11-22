import 'package:flutter/material.dart';

import '../../../../utill/color_resources.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';
import '../../../../utill/styles.dart';

class Social_Login_Screen extends StatefulWidget {
  const Social_Login_Screen({Key? key}) : super(key: key);

  @override
  State<Social_Login_Screen> createState() => _Social_Login_ScreenState();
}

class _Social_Login_ScreenState extends State<Social_Login_Screen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          margin: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            color: Color(0xff3A5897),
            borderRadius: BorderRadius.circular(50),),
          child: TextButton(
            onPressed: () {

            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(Images.facebook,width: 24,height: 24),
                Text("Continue with Facebook", style: montserratSemiBold.copyWith(fontWeight: FontWeight.w600,color: Colors.white, fontSize: Dimensions.FONT_SIZE_14))
              ],
            ),
          ),
        ),
        Container(
          height: 40,
          margin: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: ColorResources.COLORPRIMERY,width: 1)
          ),
          child: TextButton(
            onPressed: () {

            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(Images.gmail,width: 24,height: 24,),
                Text("Continue with Gmail", style: montserratSemiBold.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK, fontSize: Dimensions.FONT_SIZE_14))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
