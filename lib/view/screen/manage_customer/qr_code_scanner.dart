import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:gas_accounting/data/model/response/gas_detail_response.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/customer_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/screen/manage_customer/customer_detail.dart';
import 'package:gas_accounting/view/screen/manage_customer/search_customer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_utils/qr_code_utils.dart';
import 'package:url_launcher/url_launcher.dart';


class QRCodeScan extends StatefulWidget {
  GasDetailData gasDetailData;
  QRCodeScan(this.gasDetailData,{Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRCodeScanState();
}

class _QRCodeScanState extends State<QRCodeScan> {
  bool isLoading = true;
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String pa = "";

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  url(data) async {
    var url = Uri.parse(data);

    if (await canLaunchUrl(url)) {
      print("object::::$url");
      await launchUrl(url);
    } else {
      print("objectttt");
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusLost: () => controller?.pauseCamera(),
      onFocusGained: () => controller?.resumeCamera(),
      child: WillPopScope(
        onWillPop: () async{
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchCustomer(),));
          return true;
        },
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(flex: 8, child: _buildQrView(context)),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Scan a code',style: poppinsRegular.copyWith(fontSize: 14)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: AppConstants.itemHeight*0.05,
                          child: ElevatedButton(
                              onPressed: () async {
                                await controller?.toggleFlash();
                              },
                              style: const ButtonStyle(
                                  alignment: Alignment.center,
                                  backgroundColor: MaterialStatePropertyAll(
                                      ColorResources.LINE_BG)),
                              child: FutureBuilder(
                                future: controller?.getFlashStatus(),
                                builder: (context, snapshot) {
                                  var on = snapshot.data == false ? "On" : "Off";
                                  print("object:::${snapshot.data}");
                                  return Text('Flash Light',
                                      style: poppinsBold.copyWith(fontSize: 14,color: Colors.white));
                                },
                              )),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: AppConstants.itemHeight*0.05,
                          child: ElevatedButton(
                              onPressed: () async {
                                initPlatformState();
                              },
                              style: const ButtonStyle(
                                  alignment: Alignment.center,
                                  backgroundColor: MaterialStatePropertyAll(
                                      ColorResources.LINE_BG)),
                              child: Text('Upload from gallery',
                                  style: poppinsBold.copyWith(fontSize: 14,color: Colors.white))),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /* Scan Qr to Data */
  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 500 ||
        MediaQuery.of(context).size.height < 500)
        ? 190.0
        : 380.0;
    return QRView(
      key: qrKey,
      cameraFacing: CameraFacing.back,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 20,
          borderLength: 40,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, permission) => _onPermissionSet(context, ctrl, permission),
    );
  }

  bool gotValidQR = false;
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      if(gotValidQR) {
        gotValidQR  = false;
        print("object:::1");
        print("got::0:$gotValidQR");
        return;
      }
      result = scanData;
      print("object:::2:::${result!.code.toString()}");
      print("object:::2.0:::${result!.code!.length}");
      // try {
      //   if (result != null) {
      //     result = scanData;
      //     print("gallery:::::${result!.code}");
      //     // route;
      //     Provider.of<CustomerProvider>(context, listen: false).getGasDetailByMobile(context,result!.code.toString(),PreferenceUtils.getString("${AppConstants.companyId}")).then((value) async {
      //       setState(()  {
      //         gotValidQR = true;
      //         for(int i=0;i<Provider.of<CustomerProvider>(context, listen: false).searchList.length;i++){
      //           _id = Provider.of<CustomerProvider>(context, listen: false).searchList[i].intId.toString();
      //           print("for::$_id");
      //           if (int.parse(result!.code.toString()) == Provider.of<CustomerProvider>(context, listen: false).searchList[i].intId) {
      //             widget.gasDetailData = Provider.of<CustomerProvider>(context, listen: false).searchList[i];
      //             _id = Provider.of<CustomerProvider>(context, listen: false).searchList[i].intId.toString();
      //           }
      //         }
      //       });
      //       print("for::$_id");
      //     });
      //     gotValidQR = true;
      //     var next = await Navigator.push(context, MaterialPageRoute(builder: (context) => Search_Customer_Detail(gasDetailData,result!.code.toString(),_id,"qr"),));
      //   }else{
      //     gotValidQR = false;
      //     AppConstants.getToast("Invalid QR Code");
      //   }
      // } on PlatformException {
      //   _decoded = 'Failed to get decoded.';
      //   AppConstants.getToast("Invalid QR Code");
      //   print("object:::1$_decoded");
      // }
      // Provider.of<CustomerProvider>(context, listen: false).getGasDetailByMobile(context,result!.code.toString(),PreferenceUtils.getString("${AppConstants.companyId}")).then((value) async {
      //   setState(()  {
      //     gotValidQR  = true;
      //     for(int i=0;i<Provider.of<CustomerProvider>(context, listen: false).searchList.length;i++){
      //       _id = Provider.of<CustomerProvider>(context, listen: false).searchList[i].intId.toString();
      //       print("for::$_id");
      //       if (int.parse(_id) == Provider.of<CustomerProvider>(context, listen: false).searchList[i].intId) {
      //         widget.gasDetailData = Provider.of<CustomerProvider>(context, listen: false).searchList[i];
      //         _id = Provider.of<CustomerProvider>(context, listen: false).searchList[i].intId.toString();
      //         print("for::$_id");
      //       }
      //     }
      //   });
      //   print("for::$_id");
      //   // var next = await Navigator.push(context, MaterialPageRoute(builder: (context) => Search_Customer_Detail(gasDetailData,result!.code.toString(),_id,"qr"),));
      // });

      if (result!.code!.length == 10) {
        Provider.of<CustomerProvider>(context, listen: false).getGasDetailByMobile(context,result!.code.toString(),PreferenceUtils.getString("${AppConstants.companyId}"),route).then((value) async {
          setState(()  {
            gotValidQR  = true;
            print("got::1:$gotValidQR");
            for(int i=0;i<Provider.of<CustomerProvider>(context, listen: false).searchList.length;i++){
              print("for::$_id");
              if (result!.code == Provider.of<CustomerProvider>(context, listen: false).searchList[i].strMobileno) {
                widget.gasDetailData = Provider.of<CustomerProvider>(context, listen: false).searchList[i];
                _id = Provider.of<CustomerProvider>(context, listen: false).searchList[i].intId.toString();
              }
              controller.pauseCamera();
              gotValidQR  = false;
              print("got::2:$gotValidQR");
            }
          });
          var next = await Navigator.push(context, MaterialPageRoute(builder: (context) => Search_Customer_Detail(gasDetailData,result!.code.toString(),_id,"qr"),));
          gotValidQR  = false;
          print("got::3:$gotValidQR");
        });
        setState(() {
          controller.pauseCamera();
        });
      }else{
        Uri uri = Uri.parse("${result!.code}");
        String? pa = uri.queryParameters['pa'];

        List<String> parts = pa!.split('@');
        if (parts.length == 2) {
          String separatedValue = parts[0];
          print("Separated Value: $separatedValue");
          Provider.of<CustomerProvider>(context, listen: false).getGasDetailByMobile(context,separatedValue,PreferenceUtils.getString("${AppConstants.companyId}"),route).then((value) async {
            setState(()  {
              for(int i=0;i<Provider.of<CustomerProvider>(context, listen: false).searchList.length;i++){
                print("url code::$separatedValue::$_id");
                if (separatedValue == Provider.of<CustomerProvider>(context, listen: false).searchList[i].strMobileno) {
                  widget.gasDetailData = Provider.of<CustomerProvider>(context, listen: false).searchList[i];
                  _id = Provider.of<CustomerProvider>(context, listen: false).searchList[i].intId.toString();
                  separatedValue = Provider.of<CustomerProvider>(context, listen: false).searchList[i].strMobileno.toString();
                }
                controller.pauseCamera();
              }
            });
            var next = await Navigator.push(context, MaterialPageRoute(builder: (context) => Search_Customer_Detail(gasDetailData,separatedValue,_id,"qr"),));
          });
          setState(() {
            controller.pauseCamera();
          });
          // Navigator.push(context, MaterialPageRoute(builder: (context) => Search_Customer_Detail(gasDetailData,separatedValue,_id,"qr"),));
        } else {
          print("Invalid UPI URL format");
        }
      }
      gotValidQR  = false;
      // setState(() {
      //   result = scanData;
      //   if (result != null) {
      //     Provider.of<CustomerProvider>(context, listen: false).getGasDetailByMobile(context,"7258412385",PreferenceUtils.getString("${AppConstants.companyId}")).then((value) {
      //       setState(() {
      //         isLoading = false;
      //         for(int i=0;i<Provider.of<CustomerProvider>(context, listen: false).searchList.length;i++){
      //           if (1626 == Provider.of<CustomerProvider>(context, listen: false).searchList[i].intId) {
      //             gasDetailData = Provider.of<CustomerProvider>(context, listen: false).searchList[i];
      //           }
      //         }
      //       });
      //       Navigator.push(context, MaterialPageRoute(builder: (context) => Search_Customer_Detail(gasDetailData,"0000000000","qr"),));
      //     });
      //     // Navigator.push(context, MaterialPageRoute(builder: (context) => Search_Customer_Detail(gasDetailData,"7258412385","qr"),));
      //     print("scan code::1:${result!.code}");
      //     // Provider.of<CustomerProvider>(context, listen: false).getGasDetailByMobile(context,"7258412385",PreferenceUtils.getString("${AppConstants.companyId}")).then((value) {
      //     //   setState(() {
      //     //     isLoading = false;
      //     //     for(int i=0;i<Provider.of<CustomerProvider>(context, listen: false).searchList.length;i++){
      //     //       gasDetailData = Provider.of<CustomerProvider>(context, listen: false).searchList[i];
      //     //     }
      //     //     Navigator.push(context, MaterialPageRoute(builder: (context) => Search_Customer_Detail(gasDetailData,"7258412385"),));
      //     //   });
      //     // });
      //
      //     // url(result!.code);
      //   }  else {
      //     print("scan code::2:${result!.code}");
      //     AppConstants.getToast("Scan a Code");
      //   }
      //   print("scan code::3:${result!.code}");
      // });
    });
  }

  GasDetailData gasDetailData = GasDetailData();

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool permission) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $permission');
    if (!permission) {
      AppConstants.getToast("No Permission");
    }
  }

  String _decoded = 'Unknown';
  String _id = '';

  route(isRoute,String msg){
    if (isRoute) {
      print("object::0:$msg");
      if (msg == "No Record Available") {
        AppConstants.getToast("This QR Code Invalid");
        setState(() {
          controller!.resumeCamera();
        });
      } else {
        print("list find out mobile");
        // AppConstants.getToast("Customer Added Successfully");
      }
    }  else {
      print("object:1::$msg");
      AppConstants.getToast("Please Try After Some Time");
    }
  }

  /* Gallery to qr data */
  Future<void> initPlatformState() async {
    var imagePicker = ImagePicker();

    XFile? xfile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (xfile != null) {
      String? decoded;
      try {
        decoded = await QrCodeUtils.decodeFrom(xfile.path) ?? 'Unknown platform version';
        if (decoded != null) {
          _decoded = decoded;
          // Uri uri = Uri.parse(_decoded);
          // pa = uri.queryParameters['pa']!;
          //
          // List<String> parts = pa.split('@');
          print("gallery:::::$_decoded");
          // if (parts.length == 2) {
          //   String separatedValue = parts[0];
          //   print("Separated Value: $separatedValue");
          //   Provider.of<CustomerProvider>(context, listen: false).getGasDetailByMobile(context,separatedValue,PreferenceUtils.getString("${AppConstants.companyId}"),route).then((value) async {
          //     setState(()  {
          //       for(int i=0;i<Provider.of<CustomerProvider>(context, listen: false).searchList.length;i++){
          //         print("url code::$separatedValue::$_id");
          //         if (separatedValue == Provider.of<CustomerProvider>(context, listen: false).searchList[i].strMobileno) {
          //           widget.gasDetailData = Provider.of<CustomerProvider>(context, listen: false).searchList[i];
          //           _id = Provider.of<CustomerProvider>(context, listen: false).searchList[i].intId.toString();
          //           separatedValue = Provider.of<CustomerProvider>(context, listen: false).searchList[i].strMobileno.toString();
          //         }
          //       }
          //     });
          //     var next = await Navigator.push(context, MaterialPageRoute(builder: (context) => Search_Customer_Detail(gasDetailData,separatedValue,_id,"qr"),));
          //   });
          //   // Navigator.push(context, MaterialPageRoute(builder: (context) => Search_Customer_Detail(gasDetailData,separatedValue,_id,"qr"),));
          // } else {
          //   print("Invalid UPI URL format");
          // }
          if(_decoded.length == 10){
            Provider.of<CustomerProvider>(context, listen: false).getGasDetailByMobile(context,_decoded,PreferenceUtils.getString("${AppConstants.companyId}"),route).then((value) async {
              setState(()  {
                for(int i=0;i<Provider.of<CustomerProvider>(context, listen: false).searchList.length;i++){
                  // _id = Provider.of<CustomerProvider>(context, listen: false).searchList[i].intId.toString();
                  print("for::$_id");
                  if (_decoded == Provider.of<CustomerProvider>(context, listen: false).searchList[i].strMobileno) {
                    widget.gasDetailData = Provider.of<CustomerProvider>(context, listen: false).searchList[i];
                    _id = Provider.of<CustomerProvider>(context, listen: false).searchList[i].intId.toString();
                    _decoded = Provider.of<CustomerProvider>(context, listen: false).searchList[i].strMobileno.toString();
                  }
                }
              });
              var next = await Navigator.push(context, MaterialPageRoute(builder: (context) => Search_Customer_Detail(gasDetailData,_decoded,_id,"qr"),));
            });
          }else{
            Uri uri = Uri.parse(_decoded);
            String? pa = uri.queryParameters['pa'];

            List<String> parts = pa!.split('@');
            if (parts.length == 2) {
              String separatedValue = parts[0];
              print("Separated Value: $separatedValue");
              Provider.of<CustomerProvider>(context, listen: false).getGasDetailByMobile(context,separatedValue,PreferenceUtils.getString("${AppConstants.companyId}"),route).then((value) async {
                setState(()  {
                  for(int i=0;i<Provider.of<CustomerProvider>(context, listen: false).searchList.length;i++){
                    print("url code::$separatedValue::$_id");
                    if (separatedValue == Provider.of<CustomerProvider>(context, listen: false).searchList[i].strMobileno) {
                      widget.gasDetailData = Provider.of<CustomerProvider>(context, listen: false).searchList[i];
                      _id = Provider.of<CustomerProvider>(context, listen: false).searchList[i].intId.toString();
                      separatedValue = Provider.of<CustomerProvider>(context, listen: false).searchList[i].strMobileno.toString();
                    }
                  }
                });
                var next = await Navigator.push(context, MaterialPageRoute(builder: (context) => Search_Customer_Detail(gasDetailData,separatedValue,_id,"qr"),));
              });
              // Navigator.push(context, MaterialPageRoute(builder: (context) => Search_Customer_Detail(gasDetailData,separatedValue,_id,"qr"),));
            } else {
              print("Invalid UPI URL format");
            }
          }

        }else{
          AppConstants.getToast("Invalid QR Code");
        }
      } on PlatformException {
        _decoded = 'Failed to get decoded.';
        AppConstants.getToast("Invalid QR Code");
      }
    }

    if (!mounted) return;
    setState(() {
      // _platformVersion = platformVersion;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}