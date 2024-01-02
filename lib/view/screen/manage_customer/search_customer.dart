import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gas_accounting/data/model/response/gas_detail_response.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/customer_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/no_internet_screen.dart';
import 'package:gas_accounting/view/screen/dashboard/dashboard_screen.dart';
import 'package:gas_accounting/view/screen/manage_customer/customer_detail.dart';
import 'package:gas_accounting/view/screen/manage_customer/customer_list.dart';
import 'package:gas_accounting/view/screen/manage_customer/qr_code_scanner.dart';
import 'package:gas_accounting/view/screen/manage_customer/transaction_history.dart';
import 'package:gas_accounting/view/screen/manage_temp_payment/add_temp_payment.dart';
import 'package:gas_accounting/view/screen/temp_invoice/add_tempinvoice.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchCustomer extends StatefulWidget {
  SearchCustomer({Key? key}) : super(key: key);

  @override
  State<SearchCustomer> createState() => _SearchCustomerState();
}

class _SearchCustomerState extends State<SearchCustomer> with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  FocusScopeNode search = FocusScopeNode();
  bool is_loading = true;
  bool is_load = true;
  String mobile = '';
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    is_load = false;
    _loadData(context, true);
    searchController.clear();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween(begin: 300.0, end: 50.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    search.addListener(() {
      if (search.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }
  GasDetailData gasDetailData = GasDetailData();
  List<GasDetailData> customerFiltered = [];

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<CustomerProvider>(context, listen: false).getGasDetailByMobile(context,"0000000000",PreferenceUtils.getString("${AppConstants.companyId}"),route).then((value) {
        setState(() {
          is_loading = false;
          is_load = false;
          customerFiltered = is_loading
              ? Provider.of<CustomerProvider>(context, listen: false).searchList
              : Provider.of<CustomerProvider>(context, listen: false).searchList
              .where((item) => item.strMobileno!.contains(""))
              .toList();
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

  route(isRoute,String msg){
    if (isRoute) {
      print("object::0:$msg");
      if (msg == "No Record Available") {
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
  void dispose() {
    _controller.dispose();
    search.dispose();
    super.dispose();
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      print("search::$text");
      customerFiltered = text.isEmpty
          ? Provider.of<CustomerProvider>(context, listen: false).searchList
          : Provider.of<CustomerProvider>(context, listen: false).searchList
          .where((item) => item.strMobileno!.contains(text))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        // Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerList(),));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorResources.LINE_BG,
          centerTitle: true,
          leading: IconButton(onPressed: () {
            // Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerList(),));
          }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
          title: Text("Search Customer",style: montserratSemiBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
        ),
        body: Consumer<CustomerProvider>(builder: (context, customer, child) {
          for(int i=0;i<Provider.of<CustomerProvider>(context, listen: false).searchList.length;i++){
            gasDetailData = Provider.of<CustomerProvider>(context, listen: false).searchList[i];
          }
          return Column(
            children: [
              Row(
                children: [
                  Container(
                    width: AppConstants.itemWidth*0.68,
                    margin: EdgeInsets.symmetric(horizontal: AppConstants.itemHeight*0.01,vertical: AppConstants.itemHeight*0.01),
                    decoration: BoxDecoration(
                      color: ColorResources.WHITE,
                      borderRadius:BorderRadius.circular(10),
                      border: Border.all(color: ColorResources.GREY),
                    ),
                    child: TextFormField(
                      // autofocus: true,
                      controller: searchController,
                      maxLines: 1,
                      // focusNode: search,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.search,
                      cursorColor: ColorResources.LINE_BG,
                      maxLength: 10,
                      style: montserratRegular.copyWith(fontWeight: FontWeight.w500,color: ColorResources.BLACK,fontSize: 17),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly,FilteringTextInputFormatter.singleLineFormatter],
                      onChanged: _onSearchTextChanged,
                      // onFieldSubmitted: (v) {
                        // Provider.of<CustomerProvider>(context, listen: false).getGasDetailByMobile(context,v,PreferenceUtils.getString("${AppConstants.companyId}"),route).then((value) {
                        //   setState(() {
                        //     is_load = false;
                        //   });
                        // });
                      //   searchController.clear();
                      // },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search,color: ColorResources.GREY,size: 30),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.cancel,color: ColorResources.GREY,size: 25),
                          onPressed: () {
                            setState(() {
                              searchController.clear();
                              customerFiltered = Provider.of<CustomerProvider>(context, listen: false).searchList;
                              AppConstants.closeKeyboard();
                            });
                          },
                        ),
                        hintText: "Search by Mobile Number",
                        fillColor: ColorResources.WHITE,
                        contentPadding: EdgeInsets.symmetric(vertical: AppConstants.itemHeight*0.02, horizontal: AppConstants.itemWidth*0.006),
                        counterText: '',
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                        hintStyle: montserratBold.copyWith(fontWeight: FontWeight.w600,color: ColorResources.GREY,fontSize: 16),
                        errorStyle: const TextStyle(height: 1.5),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(onPressed: () {
                    searchController.clear();
                    AppConstants.closeKeyboard();
                    is_load = true;
                    _loadData(context, true);
                  }, icon: const Icon(Icons.refresh,color: ColorResources.LINE_BG)),
                  IconButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => QRCodeScan(gasDetailData),));
                  }, icon: const Icon(Icons.qr_code_scanner,color: ColorResources.LINE_BG,)),
                ],
              ),
              is_loading
                  ?
              Padding(
                padding: EdgeInsets.only(top: AppConstants.itemHeight * 0.35),
                child: const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG)),
              )
                  :
              is_load
                  ?
              Padding(
                padding: EdgeInsets.only(top: AppConstants.itemHeight * 0.35),
                child: const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG)),
              )
                  :
              Flexible(
                child:
                customerFiltered.isNotEmpty
                    ?
                ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: customerFiltered.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Search_Customer_Detail(customerFiltered[index],customerFiltered[index].strMobileno.toString(),"0","search"),));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: AppConstants.itemHeight*0.01,vertical: AppConstants.itemHeight*0.005),
                        padding: EdgeInsets.only(left: AppConstants.itemWidth*0.02,right: AppConstants.itemWidth*0.02,top: AppConstants.itemHeight*0.01),
                        decoration: BoxDecoration(
                          color: ColorResources.WHITE,
                          borderRadius:BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(color: Colors.grey.withOpacity(0.70), spreadRadius: 1, blurRadius: 2) // changes position of shadow
                          ],
                        ),
                        child: Column(
                          children: [
                            // Row(
                            //   children: [
                            //     const Icon(Icons.circle,size: 10,color: ColorResources.LINE_BG),
                            //     SizedBox(width: AppConstants.itemWidth*0.01),
                            //     Text("Customer Detail",style: montserratBold.copyWith(fontSize: 19),)
                            //   ],
                            // ),
                            // SizedBox(height: AppConstants.itemHeight*0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Name",style: montserratSemiBold.copyWith(fontSize: 16)),
                                Text("${customerFiltered[index].strUserName}",style: montserratSemiBold.copyWith(fontSize: 17),)
                              ],
                            ),
                            customerFiltered.length == 1?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Mobile",style: montserratSemiBold.copyWith(fontSize: 16)),
                                GestureDetector(onTap: () {
                                  makingPhoneCall(customerFiltered[index].strMobileno);
                                },child: Text("${customerFiltered[index].strMobileno}",style: montserratSemiBold.copyWith(fontSize: 17),))
                              ],
                            )
                                :customerFiltered[index].strCompanyName == null ?const SizedBox():
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Company Name",style: montserratSemiBold.copyWith(fontSize: 16)),
                                Container(alignment: Alignment.centerRight,width: AppConstants.itemWidth*0.55,child: Text("${customerFiltered[index].strCompanyName}",maxLines: 2,style: montserratSemiBold.copyWith(fontSize: 17),))
                              ],
                            ),
                            customerFiltered.length == 1 ?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total Balance",style: montserratSemiBold.copyWith(fontSize: 16)),
                                Text("\u20b9 ${customerFiltered[index].decBalance}",style: montserratSemiBold.copyWith(fontSize: 17),)
                              ],
                            ):const SizedBox(),
                            customerFiltered[index].paymentDetail==null?const SizedBox():
                            customerFiltered.length ==1?
                            Visibility(
                                visible: customerFiltered[index].paymentDetail!.isNotEmpty?true:false,
                              child: Row(
                                children: [
                                  const Icon(Icons.circle,size: 10,color: ColorResources.LINE_BG),
                                  SizedBox(width: AppConstants.itemWidth*0.01),
                                  Text("Last 3 Transaction",style: montserratBold.copyWith(fontSize: 19),)
                                ],
                              ),
                            ):const SizedBox(),
                            customerFiltered[index].paymentDetail==null?const SizedBox():
                            customerFiltered.length == 1?
                            Visibility(
                              visible: customerFiltered[index].paymentDetail!.isNotEmpty?true:false,
                              child: Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: customerFiltered[index].paymentDetail!.length,
                                    itemBuilder: (context, i) {
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(customerFiltered[index].paymentDetail![i].intType==1?"Payment":"Invoice",style: montserratBold.copyWith(color: ColorResources.BLACK)),
                                              Text("${AppConstants.date_formate_change(customerFiltered[index].paymentDetail![i].dtPaymentDate!)}",style: montserratBold.copyWith(color: ColorResources.BLACK)),
                                            ],
                                          ),
                                            Text("\u20b9 ${customerFiltered[index].paymentDetail![i].decAmount}",style: montserratBold.copyWith(color: ColorResources.BLACK)),
                                        ],),
                                        Divider(color: ColorResources.GREY.withOpacity(0.60))
                                      ],
                                    );
                                  },),
                                ],
                              ),
                            ):const SizedBox(),
                            customerFiltered.length == 1?
                            SizedBox(height: AppConstants.itemHeight*0.01):const SizedBox(),
                            customerFiltered.length == 1?
                            Row(
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
                                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddTempInvoice("","",0.0,"","","","",0,"0",int.parse(customerFiltered[index].intId.toString()),1),)),
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
                                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionHistory(int.parse(customerFiltered[index].intId.toString()),1,
                                        customerFiltered[index].strMobileno.toString(),customerFiltered[index].strCompanyName.toString(),"${customerFiltered[index].strFirstName.toString()} ${customerFiltered[index].strLastName.toString()}"),)),
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
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddTempPayment(int.parse(customerFiltered[index].intId.toString()),1),));
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
                            ):const SizedBox(),
                            SizedBox(height: AppConstants.itemHeight*0.01),
                          ],
                        ),
                      ),
                    );
                  },)
                    :
                DataNotFoundScreen("No Data Found"),
              ),
            ],
          );
        },),
      ),
    );
  }
}

