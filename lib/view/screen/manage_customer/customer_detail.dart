import 'package:flutter/material.dart';
import 'package:gas_accounting/data/model/response/gas_detail_response.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/customer_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/no_internet_screen.dart';
import 'package:gas_accounting/view/screen/manage_customer/transaction_history.dart';
import 'package:gas_accounting/view/screen/manage_temp_payment/add_temp_payment.dart';
import 'package:gas_accounting/view/screen/temp_invoice/add_tempinvoice.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Search_Customer_Detail extends StatefulWidget {
  GasDetailData gasDetailData;
  String mobile,id,type;
  Search_Customer_Detail(this.gasDetailData,this.mobile,this.id,this.type,{Key? key}) : super(key: key);

  @override
  State<Search_Customer_Detail> createState() => _Search_Customer_DetailState();
}

class _Search_Customer_DetailState extends State<Search_Customer_Detail> {
  String mobile = '';
  String name = 'name';
  bool is_loading = true;
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
  void initState() {
    // TODO: implement initState
    super.initState();
    print("id::${widget.mobile}::::${widget.id}");
    widget.type == "qr" ? _loadData(context, true) : _loadDatas(context, true);
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<CustomerProvider>(context, listen: false).getGasDetailByMobile(context,widget.mobile,PreferenceUtils.getString("${AppConstants.companyId}"),route).then((value) {
        setState(() {
          is_loading = false;
          for(int i=0;i<Provider.of<CustomerProvider>(context, listen: false).searchList.length;i++){
            if (int.parse(widget.id) == Provider.of<CustomerProvider>(context, listen: false).searchList[i].intId
            && widget.mobile == Provider.of<CustomerProvider>(context,listen: false).searchList[i].strMobileno) {
              print("id::::${Provider.of<CustomerProvider>(context, listen: false).searchList[i].intId}");
              widget.gasDetailData = Provider.of<CustomerProvider>(context, listen: false).searchList[i];
            }
          }
        });
      });
    });
  }

  Future<void> _loadDatas(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      setState(() {
        is_loading = false;
      });
    });
  }

  route(isRoute,String msg){
    if (isRoute) {
      print("object::0:$msg");
      if (msg == "No Record Available") {
        is_loading = false;
        // AppConstants.getToast("No Record Available");
      } else {
        // AppConstants.getToast("Customer Added Successfully");
      }
    }  else {
      print("object:1::$msg");
      AppConstants.getToast("Please Try After Some Time");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(builder: (context, customer, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorResources.LINE_BG,
          centerTitle: true,
          leading: IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
          title: Text("Customer Detail",style: montserratSemiBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
        ),
        body:
        is_loading
            ?
        const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
            :
        widget.mobile != widget.gasDetailData.strMobileno?DataNotFoundScreen("No Data Found"):
        Container(
          margin: EdgeInsets.symmetric(horizontal: AppConstants.itemHeight*0.01,vertical: AppConstants.itemHeight*0.005),
          padding: EdgeInsets.only(left: AppConstants.itemWidth*0.02,right: AppConstants.itemWidth*0.02,top: AppConstants.itemHeight*0.01),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.circle,size: 10,color: ColorResources.LINE_BG),
                  SizedBox(width: AppConstants.itemWidth*0.01),
                  Text("Customer Detail",style: montserratBold.copyWith(fontSize: 19),)
                ],
              ),
              SizedBox(height: AppConstants.itemHeight*0.01),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: AppConstants.itemHeight*0.01),
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
                decoration: BoxDecoration(
                  color: ColorResources.WHITE,
                  borderRadius:BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.70), spreadRadius: 1, blurRadius: 2) // changes position of shadow
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Name",style: montserratSemiBold.copyWith(fontSize: 16)),
                        Text("${widget.gasDetailData.strUserName}",style: montserratSemiBold.copyWith(fontSize: 17),)
                      ],
                    ),
                    widget.gasDetailData.strCompanyName == null ?const SizedBox():
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Company Name",style: montserratSemiBold.copyWith(fontSize: 16)),
                        Text(widget.gasDetailData.strCompanyName ?? "",style: montserratSemiBold.copyWith(fontSize: 17),)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Mobile",style: montserratSemiBold.copyWith(fontSize: 16)),
                        GestureDetector(onTap: () {
                          makingPhoneCall(widget.gasDetailData.strMobileno);
                        },child: Text("${widget.gasDetailData.strMobileno}",style: montserratSemiBold.copyWith(fontSize: 17),))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Balance",style: montserratSemiBold.copyWith(fontSize: 16)),
                        Text("\u20b9 ${widget.gasDetailData.decBalance}",style: montserratSemiBold.copyWith(fontSize: 17),)
                      ],
                    ),
                  ],
                ),
              ),
              // widget.gasDetailData.paymentDetail! == null ? SizedBox():
              Visibility(
                visible: widget.gasDetailData.paymentDetail != null ? true : false,
                child: Row(
                  children: [
                    const Icon(Icons.circle,size: 10,color: ColorResources.LINE_BG),
                    SizedBox(width: AppConstants.itemWidth*0.01),
                    Text("Last 3 Transaction",style: montserratBold.copyWith(fontSize: 19),)
                  ],
                ),
              ),
              // widget.gasDetailData.paymentDetail! == null ? SizedBox():
              Visibility(
                visible: widget.gasDetailData.paymentDetail != null ? true : false,
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.center,
                        // height: AppConstants.itemHeight*0.18,
                        margin: EdgeInsets.only(top: AppConstants.itemHeight*0.01),
                        padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
                        decoration: BoxDecoration(
                          color: ColorResources.WHITE,
                          borderRadius:BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(color: Colors.grey.withOpacity(0.70), spreadRadius: 1, blurRadius: 2) // changes position of shadow
                          ],
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.gasDetailData.paymentDetail?.length,
                          itemBuilder: (context, i) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            widget.gasDetailData.paymentDetail?[i].intType==1?"Payment":"Invoice",
                                            style: montserratBold.copyWith(
                                                color: ColorResources.BLACK)),
                                        Text(
                                            "${AppConstants.date_formate_change(widget.gasDetailData.paymentDetail![i].dtPaymentDate.toString())}",
                                            style: montserratBold.copyWith(
                                                color: ColorResources.BLACK)),
                                      ],
                                    ),
                                    Text(
                                        "\u20b9 ${widget.gasDetailData.paymentDetail?[i].decAmount}",
                                        style: montserratBold.copyWith(
                                            color: ColorResources.BLACK)),
                                  ],),
                                Divider(color: ColorResources.GREY.withOpacity(0.60))
                              ],
                            );
                          },)
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppConstants.itemHeight*0.01),
            ],
          ),
        ),
        bottomNavigationBar: widget.mobile != widget.gasDetailData.strMobileno?SizedBox():Container(
          alignment: Alignment.center,
          height: AppConstants.itemHeight*0.063,
          margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: AppConstants.itemHeight*0.063,
                width: AppConstants.itemWidth*0.29,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                        end: Alignment.bottomLeft,
                        colors: [
                          ColorResources.gradient_top,
                          ColorResources.gradient_bottom,
                        ])),
                child: TextButton(
                  onPressed: () =>Navigator.push(context, MaterialPageRoute(builder: (context) => AddTempInvoice("","",0.0,"","","","",0,"0",int.parse(widget.gasDetailData.intId.toString()),1),)),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text("Temp Invoice",
                        textAlign: TextAlign.center,
                        style: montserratSemiBold.copyWith(fontWeight: FontWeight.w600,color: Colors.white, fontSize: Dimensions.FONT_SIZE_14)),
                  ),
                ),
              ),
              Container(
                height: AppConstants.itemHeight*0.063,
                width: AppConstants.itemWidth*0.29,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                        end: Alignment.bottomLeft,
                        colors: [
                          ColorResources.gradient_top,
                          ColorResources.gradient_bottom,
                        ])),
                child: TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionHistory(int.parse(widget.gasDetailData.intId.toString()),1,widget.gasDetailData.strMobileno.toString(),widget.gasDetailData.strCompanyName.toString(),"${widget.gasDetailData.strFirstName.toString()} ${widget.gasDetailData.strLastName.toString()}"),)),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text("Transaction History",
                        textAlign: TextAlign.center,
                        style: montserratSemiBold.copyWith(fontWeight: FontWeight.w600,color: Colors.white, fontSize: Dimensions.FONT_SIZE_14)),
                  ),
                ),
              ),
              Container(
                height: AppConstants.itemHeight*0.063,
                width: AppConstants.itemWidth*0.29,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                        end: Alignment.bottomLeft,
                        colors: [
                          ColorResources.gradient_top,
                          ColorResources.gradient_bottom,
                        ])),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return AddTempPayment(int.parse(widget.gasDetailData.intId.toString()),1);
                    },));
                  },
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text("Payment",
                        textAlign: TextAlign.center,
                        style: montserratSemiBold.copyWith(fontWeight: FontWeight.w600,color: Colors.white, fontSize: Dimensions.FONT_SIZE_14)),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },);
  }
}
