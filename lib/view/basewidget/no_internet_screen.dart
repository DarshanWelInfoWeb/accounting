import 'package:flutter/material.dart';

import '../../utill/color_resources.dart';
import '../../utill/dimensions.dart';
import '../../utill/images.dart';
import '../../utill/styles.dart';

class NoInternetOrDataScreen extends StatelessWidget {
  final bool isNoInternet;
  final Widget? child;
  NoInternetOrDataScreen({required this.isNoInternet, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.025),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(isNoInternet ? Images.noInternet : Images.noData, width: 150, height: 150),
            Text(isNoInternet ? "Opps!" : "Sorry !", style: montserratBold.copyWith(
              fontSize: 30,
              color: isNoInternet ? Theme.of(context).textTheme.bodyText1?.color : ColorResources.getColombiaBlue(context),
            )),
            const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Text(
              isNoInternet ? "No Internet Connection" : 'No Data Found',
              textAlign: TextAlign.center,
              style: montserratRegular,
            ),
            const SizedBox(height: 40),
            isNoInternet ? Container(
              height: 45,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0.0), color: ColorResources.getYellow(context)),
              child: TextButton(
                onPressed: () async {
                  // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SplashScreen()));
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text("Retry", style: montserratSemiBold.copyWith(color: Theme.of(context).highlightColor, fontSize: Dimensions.FONT_SIZE_16)),
                ),
              ),
            ) : const SizedBox.shrink(),

          ],
        ),
      ),
    );
  }
}

class DataNotFoundScreen extends StatelessWidget {
  String title;
  DataNotFoundScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.025),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Images.noData, width: 150, height: 150),
            Text("Sorry !", style: montserratBold.copyWith(
              fontSize: 30,
              color: ColorResources.getColombiaBlue(context),
            )),
            const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Text(
              title,
              textAlign: TextAlign.center,
              style: montserratRegular,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
