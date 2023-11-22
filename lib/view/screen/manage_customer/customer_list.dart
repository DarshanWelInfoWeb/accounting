// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/customer_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/images.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/no_internet_screen.dart';
import 'package:gas_accounting/view/screen/dashboard/dashboard_screen.dart';
import 'package:gas_accounting/view/screen/manage_customer/add_customer.dart';
import 'package:gas_accounting/view/screen/manage_customer/edit_customer.dart';
import 'package:gas_accounting/view/screen/manage_customer/search_customer.dart';
import 'package:gas_accounting/view/screen/manage_customer/transaction_history.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerList extends StatefulWidget {
  CustomerList({Key? key}) : super(key: key);

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  bool isLoading= true;
  File imageFile = File('');
  // String? _imageName = "http://support.welinfoweb.com/Data/Item/scaled_scaled_IMG_20230731_211851.jpg";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData(context, true);
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<CustomerProvider>(context, listen: false).getCustomerList(context,PreferenceUtils.getString("${AppConstants.companyId}")).then((value) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  makingPhoneCall(mobile) async {
    var url = Uri.parse("tel: $mobile");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("objectttt");
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(builder: (context, customer, child) {
      return WillPopScope(
        onWillPop: () async{
          // Navigator.pop(context);
          Navigator.push(context,MaterialPageRoute(builder: (context) => Dashboard("Home")));
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorResources.LINE_BG,
            centerTitle: true,
            leading: IconButton(onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => Dashboard("Home"),));
            }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
            title: Text("Customer",style: montserratSemiBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchCustomer(),));
                  },
                  icon: const Icon(Icons.search,color: ColorResources.WHITE,)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddCustomer(),));
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)
            ),
            backgroundColor: ColorResources.LINE_BG,
            child: const Icon(Icons.add,size: 40,color: ColorResources.WHITE),
          ),
          body:
              isLoading
                  ?
              const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
                  :
              customer.customerList.isNotEmpty
                  ?
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                // padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
                itemCount: customer.customerList.length,
                itemBuilder: (context, index) {
                  String myString = customer.customerList[index].strCompanyName.toString();
                  String capitalizedString = myString=="null"?"":myString.capitalize();
                  String nameString = customer.customerList[index].strFirstName.toString();
                  String nameCapitalizedString = nameString.capitalize();

                  String lNameString = customer.customerList[index].strLastName.toString();
                  String lNameCapitalizedString = lNameString.capitalize();

                  DateTime parseDate = DateFormat("MM/dd/yyyy HH:mm:ss a").parse(customer.customerList[index].dtCreatedDate.toString(),true);
                  var inputDate = DateTime.parse(parseDate.toLocal().toString());
                  var outputFormat = DateFormat("dd MMMM yyyy");
                  // var outputFormat = DateFormat("dd-MM-yyyy hh:mm a");
                  var outputDate = outputFormat.format(inputDate);

                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
                    decoration: BoxDecoration(
                        color: index.isEven ? ColorResources.WHITE : Colors.grey.shade100,
                        border: Border.symmetric(horizontal: BorderSide(color: index == 0 ?ColorResources.WHITE:ColorResources.BLACK,width: 0.02))
                    ),
                    child:
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                                radius: 25,
                                backgroundColor: ColorResources.transparant,
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: "https://ps.w.org/user-avatar-reloaded/assets/icon-256x256.png?rev=2540745",
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                        width: AppConstants.itemWidth * 0.25,
                                        height: AppConstants.itemWidth * 0.25,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(ColorResources.LINE_BG))),
                                  errorWidget: (context, url, error) => const Image(image: AssetImage(Images.logo)),
                                )),
                            SizedBox(width: AppConstants.itemWidth*0.02),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: AppConstants.itemWidth*0.50,
                                  child: Text(customer.customerList[index].strCompanyName.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: montserratSemiBold.copyWith(
                                          color: ColorResources.BLACK,
                                          fontWeight: FontWeight.w500,
                                          fontSize: Dimensions.FONT_SIZE_18)),
                                ),
                                SizedBox(height: AppConstants.itemHeight * 0.01),
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: AppConstants.itemWidth*0.45,
                                      child: Text(
                                          "${customer.customerList[index].strFirstName} ${customer.customerList[index].strLastName}",
                                          overflow: TextOverflow.visible,
                                          maxLines: 1,
                                          style: montserratRegular.copyWith(
                                              color: ColorResources.BLACK,
                                              fontSize: Dimensions.FONT_SIZE_14)),
                                    ),
                                    SizedBox(width: AppConstants.itemWidth * 0.005),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: AppConstants.itemWidth*0.23,
                          child: Row(
                            children: [
                              IconButton(onPressed: () => makingPhoneCall(customer.customerList[index].strMobileno), icon: const Icon(Icons.call,color: ColorResources.LINE_BG,size: 20)),
                              PopupMenuButton(
                                color: ColorResources.WHITE,
                                surfaceTintColor: ColorResources.WHITE,
                                elevation: 10,
                                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                onSelected: (value) {
                                  if (value==0) {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditCustomer(customer.customerList[index].intId.toString()),));
                                  }  else if (value==1) {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionHistory(int.parse(customer.customerList[index].intId.toString()),0,
                                        customer.customerList[index].strMobileno.toString(),customer.customerList[index].strCompanyName.toString(),"${customer.customerList[index].strFirstName.toString()} ${customer.customerList[index].strLastName.toString()}"),));
                                  } else if (value==2) {

                                  }   else {
                                    showDialog<bool>(
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: const Text("Are You Sure You Want to Delete ?"),
                                            contentTextStyle: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_16),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Provider.of<CustomerProvider>(context, listen: false).getDeleteCustomer(context,"${customer.customerList[index].intId}").then((value) {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerList(),));
                                                  });
                                                },
                                                style: const ButtonStyle(
                                                    backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                                                ),
                                                child: Text('Yes',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                style: const ButtonStyle(
                                                    backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                                                ),
                                                child: Text('No',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
                                              ),
                                            ],
                                          );
                                        },context: context);
                                  }
                                },
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(value: 0,child: Row(
                                      children: [
                                        Icon(Icons.edit,color: ColorResources.BLACK),
                                        SizedBox(width: AppConstants.itemWidth*0.01),
                                        Text('Edit',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
                                      ],
                                    )),
                                    PopupMenuItem(value:1,child: Row(
                                      children: [
                                        Icon(Icons.balance_outlined,color: ColorResources.BLACK),
                                        SizedBox(width: AppConstants.itemWidth*0.01),
                                        Text('Transaction History',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
                                      ],
                                    )),
                                    PopupMenuItem(value: 2,child: Row(
                                      children: [
                                        const Icon(Icons.person_off,color: ColorResources.BLACK),
                                        SizedBox(width: AppConstants.itemWidth*0.01),
                                        ToggleSwitch(
                                          minWidth: 46.0,
                                          cornerRadius: 20.0,
                                          minHeight: AppConstants.itemHeight*0.03,
                                          activeBgColors: [[Colors.green[800]!], [Colors.red[800]!]],
                                          activeFgColor: Colors.white,
                                          inactiveBgColor: Colors.grey,
                                          inactiveFgColor: Colors.white,
                                          initialLabelIndex: 1,
                                          totalSwitches: 2,
                                          labels: const ['ON', 'OFF'],
                                          radiusStyle: true,
                                          onToggle: (index) {
                                            print('switched to: $index');
                                          },
                                        ),
                                      ],
                                    )),
                                    PopupMenuItem(value: 3,child: Row(
                                      children: [
                                        Icon(Icons.delete,color: ColorResources.BLACK),
                                        SizedBox(width: AppConstants.itemWidth*0.01),
                                        Text('Delete',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
                                      ],
                                    )),
                                  ];
                                },
                                child: const Icon(Icons.more_vert,color: ColorResources.BLACK),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),*/
                    ListTile(
                      contentPadding: EdgeInsets.all(AppConstants.itemHeight*0.0),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                              radius: 25,
                              backgroundColor: ColorResources.transparant,
                              child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl: "https://ps.w.org/user-avatar-reloaded/assets/icon-256x256.png?rev=2540745",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      width: AppConstants.itemWidth * 0.25,
                                      height: AppConstants.itemWidth * 0.25,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.fill),
                                      ),
                                    ),
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(ColorResources.LINE_BG))),
                                errorWidget: (context, url, error) => const Image(image: AssetImage(Images.logo)),
                              )),
                          SizedBox(width: AppConstants.itemWidth*0.02),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                width: AppConstants.itemWidth*0.50,
                                child: Text(capitalizedString,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: poppinsSemiBold.copyWith(
                                        color: ColorResources.BLACK,
                                        fontWeight: FontWeight.w500,
                                        fontSize: Dimensions.FONT_SIZE_18)),
                              ),
                              SizedBox(height: AppConstants.itemHeight * 0.01),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: AppConstants.itemWidth*0.18,
                                    child: Text("$nameCapitalizedString $lNameCapitalizedString",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: poppinsRegular.copyWith(
                                            color: ColorResources.BLACK,
                                            fontSize: Dimensions.FONT_SIZE_14)),
                                  ),
                                  SizedBox(width: AppConstants.itemWidth * 0.005),
                                  const Icon(Icons.date_range,color: ColorResources.GREY,size: 14),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: AppConstants.itemWidth*0.332,
                                    child: Text(" $outputDate",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: poppinsRegular.copyWith(
                                            color: ColorResources.BLACK,
                                            fontSize: Dimensions.FONT_SIZE_14)),
                                  ),
                                  // SizedBox(width: AppConstants.itemWidth * 0.005),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Container(
                        alignment: Alignment.centerRight,
                        width: AppConstants.itemWidth*0.20,
                        child: Row(
                          children: [
                            IconButton(onPressed: () => makingPhoneCall(customer.customerList[index].strMobileno), icon: const Icon(Icons.call,color: ColorResources.LINE_BG,size: 20)),
                            customer.customerList[index].strQrCode == null?
                            PopupMenuButton(
                              color: ColorResources.WHITE,
                              surfaceTintColor: ColorResources.WHITE,
                              elevation: 10,
                              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              onSelected: (value) async {
                                if (value==0) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditCustomer(customer.customerList[index].intId.toString()),));
                                }  else if (value==1) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionHistory(int.parse(customer.customerList[index].intId.toString()),0,
                                      customer.customerList[index].strMobileno.toString(),customer.customerList[index].strCompanyName.toString(),"${customer.customerList[index].strFirstName.toString()} ${customer.customerList[index].strLastName.toString()}"),));
                                }  else if (value==2) {
                                  Provider.of<CustomerProvider>(context, listen: false).getCustomerQRCodeGenerate(context,customer.customerList[index].strMobileno.toString(),route);
                                }  else if (value==3) {

                                }  else {
                                  showDialog<bool>(
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: const Text("Are You Sure You Want to Delete ?"),
                                          contentTextStyle: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_16),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Provider.of<CustomerProvider>(context, listen: false).getDeleteCustomer(context,"${customer.customerList[index].intId}").then((value) {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerList(),));
                                                });
                                              },
                                              style: const ButtonStyle(
                                                  backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                                                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                                              ),
                                              child: Text('Yes',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: const ButtonStyle(
                                                  backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                                                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                                              ),
                                              child: Text('No',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
                                            ),
                                          ],
                                        );
                                      },context: context);
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(value: 0,child: Row(
                                    children: [
                                      const Icon(Icons.edit,color: ColorResources.BLACK),
                                      SizedBox(width: AppConstants.itemWidth*0.01),
                                      Text('Edit',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
                                    ],
                                  )),
                                  PopupMenuItem(value: 1,child: Row(
                                    children: [
                                      const Icon(Icons.balance_outlined,color: ColorResources.BLACK),
                                      SizedBox(width: AppConstants.itemWidth*0.01),
                                      Text('Transaction History',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
                                    ],
                                  )),
                                  PopupMenuItem(value: 2,child: Row(
                                    children: [
                                      const Icon(Icons.qr_code_sharp,color: ColorResources.BLACK),
                                      SizedBox(width: AppConstants.itemWidth*0.01),
                                      Text('Generate QR Code',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
                                    ],
                                  )),
                                  PopupMenuItem(value: 3,child: Row(
                                    children: [
                                      const Icon(Icons.person_off,color: ColorResources.BLACK),
                                      SizedBox(width: AppConstants.itemWidth*0.01),
                                      ToggleSwitch(
                                        minWidth: 46.0,
                                        cornerRadius: 20.0,
                                        minHeight: AppConstants.itemHeight*0.03,
                                        activeBgColors: [[Colors.green[800]!], [Colors.red[800]!]],
                                        activeFgColor: Colors.white,
                                        inactiveBgColor: Colors.grey,
                                        inactiveFgColor: Colors.white,
                                        initialLabelIndex: 1,
                                        totalSwitches: 2,
                                        labels: const ['ON', 'OFF'],
                                        radiusStyle: true,
                                        onToggle: (index) {
                                          print('switched to: $index');
                                        },
                                      ),
                                    ],
                                  )),
                                  PopupMenuItem(value: 4,child: Row(
                                    children: [
                                      const Icon(Icons.delete,color: ColorResources.BLACK),
                                      SizedBox(width: AppConstants.itemWidth*0.01),
                                      Text('Delete',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
                                    ],
                                  )),
                                ];
                              },
                              child: const Icon(Icons.more_vert,color: ColorResources.BLACK),
                            ):
                            PopupMenuButton(
                              color: ColorResources.WHITE,
                              surfaceTintColor: ColorResources.WHITE,
                              elevation: 10,
                              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              onSelected: (value) async {
                                if (value==0) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditCustomer(customer.customerList[index].intId.toString()),));
                                }  else if (value==1) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionHistory(int.parse(customer.customerList[index].intId.toString()),0,
                                      customer.customerList[index].strMobileno.toString(),customer.customerList[index].strCompanyName.toString(),"${customer.customerList[index].strFirstName.toString()} ${customer.customerList[index].strLastName.toString()}"),));
                                }  else if (value==2) {
                                  Provider.of<CustomerProvider>(context, listen: false).getCustomerQRCodeGenerate(context,customer.customerList[index].strMobileno.toString(),route);
                                }  else if (value==3) {
                                  var dir = await DownloadsPathProvider.downloadsDirectory;
                                  if(dir != null) {
                                    String savePath = "${dir.path}/Qr/${customer.customerList[index].strQrCode}";
                                    print("pathSave:::::$savePath");
                                    imageFile = File(savePath);
                                    print("imageDownloadPath:::${imageFile.path}");

                                    try {
                                      await Dio().download("http://support.welinfoweb.com/Content/Qr/${customer.customerList[index].strQrCode.toString()}",
                                          savePath,
                                          onReceiveProgress: (received, total) {
                                            if (total != -1) {
                                              print("progress::${(received / total * 100).toStringAsFixed(0)}" "%");
                                            }
                                          });
                                      AppConstants.getToast("File is saved to download folder.");
                                      print("File is saved to download folder.");
                                    } on DioError catch (e) {
                                      if (customer.customerList[index].strQrCode == null) {
                                        AppConstants.getToast("Please Generate QR Code.");
                                      }else{
                                        AppConstants.getToast("File is saved to download folder.");
                                      }
                                      print("error::${e.message}");
                                    }
                                  }
                                }  else if (value==4) {

                                }  else {
                                  showDialog<bool>(
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: const Text("Are You Sure You Want to Delete ?"),
                                          contentTextStyle: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_16),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Provider.of<CustomerProvider>(context, listen: false).getDeleteCustomer(context,"${customer.customerList[index].intId}").then((value) {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerList(),));
                                                });
                                              },
                                              style: const ButtonStyle(
                                                  backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                                                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                                              ),
                                              child: Text('Yes',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: const ButtonStyle(
                                                  backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                                                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                                              ),
                                              child: Text('No',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
                                            ),
                                          ],
                                        );
                                      },context: context);
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(value: 0,child: Row(
                                    children: [
                                      const Icon(Icons.edit,color: ColorResources.BLACK),
                                      SizedBox(width: AppConstants.itemWidth*0.01),
                                      Text('Edit',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
                                    ],
                                  )),
                                  PopupMenuItem(value: 1,child: Row(
                                    children: [
                                      const Icon(Icons.balance_outlined,color: ColorResources.BLACK),
                                      SizedBox(width: AppConstants.itemWidth*0.01),
                                      Text('Transaction History',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
                                    ],
                                  )),
                                  PopupMenuItem(value: 2,child: Row(
                                    children: [
                                      const Icon(Icons.qr_code_sharp,color: ColorResources.BLACK),
                                      SizedBox(width: AppConstants.itemWidth*0.01),
                                      Text('Generate QR Code',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
                                    ],
                                  )),
                                  PopupMenuItem(value: 3,child: Row(
                                    children: [
                                      const Image(image: AssetImage(Images.download),height: 24,width: 24,),
                                      SizedBox(width: AppConstants.itemWidth*0.01),
                                      Text('Download QR Code',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
                                    ],
                                  )),
                                  PopupMenuItem(value: 4,child: Row(
                                    children: [
                                      const Icon(Icons.person_off,color: ColorResources.BLACK),
                                      SizedBox(width: AppConstants.itemWidth*0.01),
                                      ToggleSwitch(
                                        minWidth: 46.0,
                                        cornerRadius: 20.0,
                                        minHeight: AppConstants.itemHeight*0.03,
                                        activeBgColors: [[Colors.green[800]!], [Colors.red[800]!]],
                                        activeFgColor: Colors.white,
                                        inactiveBgColor: Colors.grey,
                                        inactiveFgColor: Colors.white,
                                        initialLabelIndex: 1,
                                        totalSwitches: 2,
                                        labels: const ['ON', 'OFF'],
                                        radiusStyle: true,
                                        onToggle: (index) {
                                          print('switched to: $index');
                                        },
                                      ),
                                    ],
                                  )),
                                  PopupMenuItem(value: 5,child: Row(
                                    children: [
                                      const Icon(Icons.delete,color: ColorResources.BLACK),
                                      SizedBox(width: AppConstants.itemWidth*0.01),
                                      Text('Delete',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
                                    ],
                                  )),
                                ];
                              },
                              child: const Icon(Icons.more_vert,color: ColorResources.BLACK),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },)
                  :
              DataNotFoundScreen("No Data Found"),
          //     customer.customerList.isNotEmpty?
          // Container(
          //   margin: EdgeInsets.all(AppConstants.itemHeight*0.01),
          //   padding: EdgeInsets.symmetric(vertical: AppConstants.itemHeight*0.01),
          //   decoration: BoxDecoration(
          //     color: ColorResources.WHITE,
          //     borderRadius: const BorderRadius.all(Radius.circular(10)),
          //     boxShadow: <BoxShadow>[
          //       BoxShadow(
          //           color: Colors.grey.shade400,
          //           offset: const Offset(2, 4),
          //           blurRadius: 3,
          //           spreadRadius: 1)
          //     ],
          //   ),
          //   child: ListView.builder(
          //     scrollDirection: Axis.vertical,
          //     physics: const BouncingScrollPhysics(),
          //     shrinkWrap: true,
          //     itemCount: customer.customerList.length,
          //     padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
          //     itemBuilder: (context, index) {
          //       return Container(
          //         margin: EdgeInsets.symmetric(vertical: AppConstants.itemHeight*0.003),
          //         decoration: BoxDecoration(
          //           color: Colors.grey.shade50,
          //           borderRadius: const BorderRadius.all(Radius.circular(10)),
          //         ),
          //         child: ListTile(
          //           horizontalTitleGap: AppConstants.itemHeight*0.01,
          //           leading: Container(
          //             alignment: Alignment.center,
          //             width: AppConstants.itemWidth*0.12,
          //             height: AppConstants.itemHeight*0.06,
          //             decoration: BoxDecoration(
          //               color: Color(Random().nextInt(0xffffffff)).withAlpha(0xff).withOpacity(0.30),
          //               borderRadius: const BorderRadius.all(Radius.circular(10)),
          //             ),
          //             child: Text(
          //               customer.customerList[index].strCompanyName!.substring(0,1).toUpperCase(),
          //               style: poppinsBlack.copyWith(fontSize: Dimensions.FONT_SIZE_18,color: ColorResources.BLACK),
          //             ),
          //           ),
          //           title: Text("${customer.customerList[index].strCompanyName}",style: poppinsSemiBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_17),),
          //           subtitle: Row(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text("${customer.customerList[index].strFirstName} ${customer.customerList[index].strLastName} ",style: poppinsSemiBold.copyWith(color: ColorResources.GREY,fontSize: Dimensions.FONT_SIZE_12),),
          //               const Icon(Icons.phone,color: ColorResources.GREY,size: 13),
          //               Text(":-${customer.customerList[index].strMobileno}",style: poppinsSemiBold.copyWith(color: ColorResources.GREY,fontSize: Dimensions.FONT_SIZE_12),),
          //             ],
          //           ),
          //           trailing: Column(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               PopupMenuButton(
          //                 color: ColorResources.WHITE,
          //                 surfaceTintColor: ColorResources.WHITE,
          //                 elevation: 10,
          //                 child: const Icon(Icons.more_vert,color: ColorResources.BLACK,),
          //                 shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          //                 onSelected: (value) {
          //                   if (value==0) {
          //                     Navigator.push(context, MaterialPageRoute(builder: (context) => EditCustomer(customer.customerList[index].intId.toString()),));
          //                   }  else if (value==1) {
          //                     Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionHistory(int.parse(customer.customerList[index].intId.toString()),0,
          //                     customer.customerList[index].strMobileno.toString(),customer.customerList[index].strCompanyName.toString(),"${customer.customerList[index].strFirstName.toString()} ${customer.customerList[index].strLastName.toString()}"),));
          //                   } else if (value==2) {
          //
          //                   }   else {
          //                     showDialog<bool>(
          //                         barrierDismissible: false,
          //                         builder: (BuildContext context) {
          //                           return AlertDialog(
          //                             content: const Text("Are You Sure You Want to Delete ?"),
          //                             contentTextStyle: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_16),
          //                             actions: [
          //                               TextButton(
          //                                 onPressed: () {
          //                                   Provider.of<CustomerProvider>(context, listen: false).getDeleteCustomer(context,"${customer.customerList[index].intId}").then((value) {
          //                                     Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerList(),));
          //                                   });
          //                                 },
          //                                 style: const ButtonStyle(
          //                                     backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
          //                                     shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
          //                                 ),
          //                                 child: Text('Yes',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
          //                               ),
          //                               TextButton(
          //                                 onPressed: () {
          //                                   Navigator.pop(context);
          //                                 },
          //                                 style: const ButtonStyle(
          //                                     backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
          //                                     shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
          //                                 ),
          //                                 child: Text('No',style: poppinsRegular.copyWith(color: ColorResources.WHITE),),
          //                               ),
          //                             ],
          //                           );
          //                         },context: context);
          //                   }
          //                 },
          //                 itemBuilder: (context) {
          //                   return [
          //                     PopupMenuItem(value: 0,child: Row(
          //                       children: [
          //                         Icon(Icons.edit,color: ColorResources.BLACK),
          //                         SizedBox(width: AppConstants.itemWidth*0.01),
          //                         Text('Edit',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
          //                       ],
          //                     )),
          //                     PopupMenuItem(value:1,child: Row(
          //                       children: [
          //                         Icon(Icons.balance_outlined,color: ColorResources.BLACK),
          //                         SizedBox(width: AppConstants.itemWidth*0.01),
          //                         Text('Transaction History',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
          //                       ],
          //                     )),
          //                     PopupMenuItem(value: 2,child: Row(
          //                       children: [
          //                         const Icon(Icons.person_off,color: ColorResources.BLACK),
          //                         SizedBox(width: AppConstants.itemWidth*0.01),
          //                         ToggleSwitch(
          //                           minWidth: 46.0,
          //                           cornerRadius: 20.0,
          //                           minHeight: AppConstants.itemHeight*0.03,
          //                           activeBgColors: [[Colors.green[800]!], [Colors.red[800]!]],
          //                           activeFgColor: Colors.white,
          //                           inactiveBgColor: Colors.grey,
          //                           inactiveFgColor: Colors.white,
          //                           initialLabelIndex: 1,
          //                           totalSwitches: 2,
          //                           labels: const ['ON', 'OFF'],
          //                           radiusStyle: true,
          //                           onToggle: (index) {
          //                             print('switched to: $index');
          //                           },
          //                         ),
          //                       ],
          //                     )),
          //                     PopupMenuItem(value: 3,child: Row(
          //                       children: [
          //                         Icon(Icons.delete,color: ColorResources.BLACK),
          //                         SizedBox(width: AppConstants.itemWidth*0.01),
          //                         Text('Delete',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
          //                       ],
          //                     )),
          //                   ];
          //                 },
          //               )
          //             ],
          //           ),
          //         ),
          //       );
          //     },),
          // ):DataNotFoundScreen("No Data Found"),
        ),
      );
    },);
  }

  route(isRoute){
    if (isRoute) {
      AppConstants.getToast("QR Code Generated Successfully");
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  CustomerList(),));
    }  else {
      AppConstants.getToast("Please try after some time");
    }
  }

}


extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}