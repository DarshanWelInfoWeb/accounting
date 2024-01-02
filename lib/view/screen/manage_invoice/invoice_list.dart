// ignore_for_file: avoid_print

import 'dart:math';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gas_accounting/data/model/body/add_tempinvoice.dart';
import 'package:gas_accounting/data/model/response/driver_response.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/invoice_provider.dart';
import 'package:gas_accounting/provider/route_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:gas_accounting/view/basewidget/no_internet_screen.dart';
import 'package:gas_accounting/view/screen/dashboard/dashboard_screen.dart';
import 'package:gas_accounting/view/screen/manage_invoice/add_invoice.dart';
import 'package:gas_accounting/view/screen/manage_invoice/edit_invoice.dart';
import 'package:gas_accounting/view/screen/manage_invoice/pdfexport/online_pdf_view.dart';
import 'package:gas_accounting/view/screen/manage_invoice/pdfexport/pdfpreview.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

import 'view_invoice.dart';

class InvoiceList extends StatefulWidget {
  String startDate,endDate,customerId,type;
  InvoiceList(this.startDate,this.endDate,this.customerId,this.type,{Key? key}) : super(key: key);

  @override
  State<InvoiceList> createState() => _InvoiceListState();
}

class _InvoiceListState extends State<InvoiceList> {
  TextEditingController customerController = TextEditingController();
  bool is_loading = true;
  late String formattedMonth = '';
  late String formattedMonthNumber = '';
  late String formattedYear = '';
  late String month = '';
  late String monthNumber = '0';
  late String year = '0';
  TimeOfDay selectedTime = TimeOfDay.now();
  late String formattedDate = '';
  late String date_shcedule = '';
  DateTime? selectedDate;
  late String start_date = '';
  late String end_date = '';
  DateTime? startDate;
  DateTime? endDate;
  String? customerName;
  int customerDropDown = 0;
  List<MainInvoiceStockBody> modelList = new List.empty(growable: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData(context, true);
    DateTime today = DateTime.now();
    formattedDate = DateFormat('dd/MM/yyyy').format(today);
    formattedMonth = DateFormat('MMMM').format(today);
    formattedMonthNumber = DateFormat('MM').format(today);
    formattedYear = DateFormat('yyyy').format(today);
    month = formattedMonth;
    monthNumber = formattedMonthNumber;
    year = formattedYear;
    _startDate = widget.type != "Invoice" ? widget.startDate: _startDate;
    _enddate = widget.type != "Invoice" ? widget.endDate: _enddate;
    var firstDayThisMonth = DateTime(today.year, today.month, 1);
    var firstDayNextMonth = DateTime(today.year, today.month + 1, 0);
    start_date = DateFormat('MM/dd/yyyy').format(firstDayThisMonth);
    end_date = DateFormat('MM/dd/yyyy').format(firstDayNextMonth);
    print("object:::::$start_date::::$end_date:$firstDayNextMonth:::$firstDayThisMonth");
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<InvoiceProvider>(context, listen: false).getMainInvoiceList(
          context,
          PreferenceUtils.getString("${AppConstants.companyId}"),
          widget.type != "Invoice" ? widget.startDate : start_date,
          widget.type != "Invoice" ? widget.endDate : end_date,
          widget.customerId==""?"0":widget.customerId).then((value) {
        setState(() {
          is_loading = false;
        });
      });
      Provider.of<RouteProvider>(context, listen: false).getDriverHelper(context,PreferenceUtils.getString("${AppConstants.companyId}"),"3").then((value) {
        setState(() {
          is_loading = false;
          for(int i=0;i<Provider.of<RouteProvider>(context, listen: false).driverList.length;i++){
            if (int.parse(widget.customerId==""?"0":widget.customerId) == Provider.of<RouteProvider>(context, listen: false).driverList[i].intId) {
              customerDropDown = int.parse(widget.customerId);
              customerName = Provider.of<RouteProvider>(context, listen: false).driverList[i].srtFullName;
            }
          }
        });
      });
    });
  }


  String _startDate = '';
  String _enddate = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoiceProvider>(builder: (context, invoice, child) {
      return WillPopScope(
        onWillPop: () async{
          // print("object:: ${widget.type}");
          // widget.type == widget.type?
          // Navigator.pop(context):
          Navigator.push(context,MaterialPageRoute(builder: (context) => Dashboard(widget.type != "Invoice" ?"":"Home"),));
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorResources.LINE_BG,
            centerTitle: true,
            leading: IconButton(onPressed: () {
              // print("object:: ${widget.type}");
              // widget.type == "0"?
              // Navigator.pop(context):
              Navigator.push(context,MaterialPageRoute(builder: (context) => Dashboard(widget.type != "Invoice" ?"":"Home"),));
            }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
            title: Text("Invoice",style: montserratSemiBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddInvoice(0,"","","0","0","0","0"),));
            },
            backgroundColor: ColorResources.LINE_BG,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)
            ),
            child: const Icon(Icons.add,size: 40,color: ColorResources.WHITE),
          ),
          body:
          is_loading
              ?
          const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
              :
          Container(
            margin: EdgeInsets.all(AppConstants.itemHeight*0.01),
            padding: EdgeInsets.symmetric(vertical: AppConstants.itemHeight*0.01,horizontal: AppConstants.itemWidth*0.01),
            decoration: BoxDecoration(
              color: ColorResources.WHITE,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(2, 4),
                    blurRadius: 3,
                    spreadRadius: 1)
              ],
            ),
            child:
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCalendarDialogButton(),
                    GestureDetector(
                      onTap: () {
                        showMonthPicker(
                            context: context,
                            selectedMonthBackgroundColor: ColorResources.LINE_BG,
                            selectedMonthTextColor: ColorResources.WHITE,
                            unselectedMonthTextColor: ColorResources.BLACK,
                            cancelWidget: Text('Cancel',style: robotoSemiBold.copyWith(color: ColorResources.LINE_BG,fontSize: Dimensions.FONT_SIZE_15)),
                            confirmWidget: Text('Ok',style: robotoSemiBold.copyWith(color: ColorResources.LINE_BG,fontSize: Dimensions.FONT_SIZE_15)),
                            initialDate: DateTime.utc(int.parse(year),int.parse(monthNumber)),
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2040)
                        ).then((pickedDate) {
                          if (pickedDate == null) {
                            return;
                          }
                          setState(() {
                            formattedMonth = DateFormat('MMMM').format(pickedDate);
                            formattedMonthNumber = DateFormat('MM').format(pickedDate);
                            formattedYear = DateFormat('yyyy').format(pickedDate);
                            month = formattedMonth;
                            monthNumber = formattedMonthNumber;
                            year = formattedYear;
                            var firstDayThisMonth = DateTime(pickedDate.year, pickedDate.month, 1);
                            var firstDayNextMonth = DateTime(pickedDate.year, pickedDate.month + 1, 0);
                            start_date = DateFormat('MM/dd/yyyy').format(firstDayThisMonth);
                            end_date = DateFormat('MM/dd/yyyy').format(firstDayNextMonth);
                            print("object:::::$start_date::::$end_date:$firstDayNextMonth:::$firstDayThisMonth");
                            print("object:::$pickedDate:$month:::::$year::$monthNumber");
                            Provider.of<InvoiceProvider>(context, listen: false).getMainInvoiceList(context,PreferenceUtils.getString("${AppConstants.companyId}"),start_date,end_date,customerDropDown.toString()).then((value) {
                              setState(() {
                                is_loading = false;
                              });
                            });
                          });
                        });
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: AppConstants.itemHeight*0.05,
                        margin: EdgeInsets.only(right: AppConstants.itemWidth*0.03,top: AppConstants.itemHeight*0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(month == ""?"Select Month":month,style: poppinsBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
                            const Icon(Icons.keyboard_arrow_down_outlined,color: ColorResources.BLACK,size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.01,vertical: AppConstants.itemHeight*0.01),
                  padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
                  decoration: BoxDecoration(
                    color: ColorResources.GREY.withOpacity(0.05),
                    borderRadius:BorderRadius.circular(10),
                  ),
                  child: Consumer<RouteProvider>(builder: (context, customer, child) {
                    for(int k=0;k<Provider.of<RouteProvider>(context, listen: false).driverList.length;k++){
                      if (int.parse(widget.customerId==""?"0":widget.customerId) == Provider.of<RouteProvider>(context, listen: false).driverList[k].intId) {
                        customerDropDown = Provider.of<RouteProvider>(context, listen: false).driverList[k].intId!;
                        customerName = Provider.of<RouteProvider>(context, listen: false).driverList[k].srtFullName.toString();
                      }
                    }
                    return DropdownButtonHideUnderline(
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: AppConstants.itemWidth*0.80,
                              // height: AppConstants.itemHeight*0.05,
                              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*.005),
                              child: TypeAheadFormField<DriverData>(
                                textFieldConfiguration: TextFieldConfiguration(
                                  controller: customerController,
                                  keyboardType: TextInputType.text,
                                  onTap: () {
                                    customerController.clear();
                                    customerName = "";
                                  },
                                  style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: customerName==""?ColorResources.GREY:ColorResources.BLACK),
                                  decoration: InputDecoration(
                                    hintText: customerName ?? 'Select Customer',
                                    hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: customerName==""?ColorResources.GREY:ColorResources.BLACK),
                                    border: InputBorder.none,
                                  ),
                                ),
                                suggestionsCallback: (pattern) {
                                  return customer.driverList
                                      .where((driver) =>
                                  driver.srtFullName!.toLowerCase().contains(pattern.toLowerCase()) ||
                                      driver.srtFullName!.toUpperCase().contains(pattern.toUpperCase()))
                                      .toList();
                                },
                                itemBuilder: (context, suggestion) {
                                  return Container(
                                    alignment: Alignment.centerLeft,
                                    height: AppConstants.itemHeight*0.05,
                                    padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                                    child: Text(suggestion.srtFullName.toString(),style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK)),
                                  );
                                },
                                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    )
                                ),
                                onSuggestionSelected: (suggestion) {
                                  setState(() {
                                    customerName = suggestion.srtFullName!;
                                    customerDropDown = suggestion.intId!;
                                    customerController.text = customerName!;
                                    AppConstants.closeKeyboard();
                                    Provider.of<InvoiceProvider>(context, listen: false).getMainInvoiceList(context,PreferenceUtils.getString("${AppConstants.companyId}"),start_date,end_date,customerDropDown.toString()).then((value) {
                                      setState(() {
                                        is_loading = false;
                                      });
                                    });
                                  });
                                },
                                noItemsFoundBuilder: (context) {
                                  return DataNotFoundScreen("No Item Found");
                                },
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down_outlined,color: ColorResources.GREY),
                          ],
                        )
                    );
                  },),
                ),
                Provider.of<InvoiceProvider>(context, listen: false).isLoading
                    ?
                const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG,))
                    :
                Flexible(
                  child:
                  invoice.mainInvoiceList.isNotEmpty
                      ?
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: invoice.mainInvoiceList.length,
                    itemBuilder: (context, index) {
                      return Container(
                          margin: EdgeInsets.symmetric(vertical: AppConstants.itemHeight*0.003),
                          padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.01,vertical: AppConstants.itemHeight*0.01),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: AppConstants.itemWidth*0.12,
                              height: AppConstants.itemHeight*0.06,
                              decoration: BoxDecoration(
                                color: Color(Random().nextInt(0xffffffff)).withAlpha(0xff).withOpacity(0.30),
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Text(
                                invoice.mainInvoiceList[index].strCustomerName!.substring(0,1).toUpperCase(),
                                style: poppinsBlack.copyWith(fontSize: Dimensions.FONT_SIZE_18,color: ColorResources.BLACK),
                              ),
                            ),
                            SizedBox(width: AppConstants.itemWidth * 0.03),
                            Container(
                              alignment: Alignment.centerLeft,
                              width: AppConstants.itemWidth*0.65,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  invoice.mainInvoiceList[index].strInvoiceno == null ? const SizedBox():
                                  Text("#${invoice.mainInvoiceList[index].strInvoiceno ?? ""}",style: poppinsSemiBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_14),),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth * 0.005),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const Icon(Icons.person,size: 13,color: ColorResources.BLACK),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                width: AppConstants.itemWidth*0.37,
                                                child: Text(
                                                  invoice.mainInvoiceList[index].strCustomerName.toString(),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: poppinsSemiBold.copyWith(
                                                      color: ColorResources.BLACK,
                                                      fontSize: Dimensions.FONT_SIZE_15),
                                                ),
                                              ),
                                            ],
                                          )),
                                      Text("\u20b9 ${invoice.mainInvoiceList[index].decTotal!.round().toString()}",style: poppinsBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${invoice.mainInvoiceList[index].dtInvoicedate}",style: poppinsSemiBold.copyWith(color: ColorResources.GREY,fontSize: Dimensions.FONT_SIZE_14),),
                                      InkWell(
                                        onTap: () {
                                          // PreferenceUtils.getlogin(AppConstants.includeGst) != true
                                          //     ?
                                          // Navigator.push(context, MaterialPageRoute(builder: (context) => OnlinePDFView("${invoice.mainInvoiceList[index].strCustomerName}",""),))
                                          //     :
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => PdfPreviewPageMain(
                                              "Invoice",
                                              invoice.mainInvoiceList[index].intid.toString(),
                                              invoice.mainInvoiceList[index].strCustomerName.toString(),
                                              invoice.mainInvoiceList[index].strAddress.toString(),
                                              invoice.mainInvoiceList[index].strAddress.toString(),
                                              invoice.mainInvoiceList[index].strGSTIN.toString()),));
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: AppConstants.itemHeight*0.03,
                                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                          decoration: BoxDecoration(
                                            color: ColorResources.LINE_BG,
                                            borderRadius: BorderRadius.circular(05),
                                          ),
                                          child: Text('View',style: poppinsSemiBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_15),maxLines: 1,
                                            overflow: TextOverflow.ellipsis,),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            PopupMenuButton(
                              color: ColorResources.WHITE,
                              surfaceTintColor: ColorResources.WHITE,
                              elevation: 10,
                              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              onSelected: (result) {
                                if (result == 0) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditInvoice(invoice.mainInvoiceList[index].intid.toString(),customerDropDown.toString(),"","","","0","0","0","0",modelList,"edit"),));
                                }else{
                                  showDialog<bool>(
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: const Text("Are You Sure You Want to Delete ?"),
                                          contentTextStyle: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_16),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Provider.of<InvoiceProvider>(context, listen: false).getDeleteMainInvoice(context,"${invoice.mainInvoiceList[index].intid}").then((value) {
                                                  AppConstants.getToast("Deleted Successfully");
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => InvoiceList("","",customerDropDown.toString(),"Invoice")));
                                                });
                                              },
                                              style: const ButtonStyle(
                                                  backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                                                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                                              ),
                                              child: Text('Yes',style: poppinsRegular.copyWith(color: ColorResources.WHITE)),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: const ButtonStyle(
                                                  backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                                                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                                              ),
                                              child: Text('No',style: poppinsRegular.copyWith(color: ColorResources.WHITE)),
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
                                      const Icon(Icons.edit,color: ColorResources.BLACK,),
                                      Text('Edit',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
                                    ],
                                  )),
                                  PopupMenuItem(value: 1,child: Row(
                                    children: [
                                      const Icon(Icons.delete,color: ColorResources.BLACK),
                                      Text('Delete',style: poppinsRegular.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15)),
                                    ],
                                  )),
                                ];
                              },
                              child: const Icon(Icons.more_vert,color: ColorResources.BLACK,),
                            ),
                          ],
                        )
                      );
                    },)
                        :
                  DataNotFoundScreen("No Data Found"),
                ),
              ],
            ),
          ),
        ),
      );
    },);
  }

  String _getValueText(
      CalendarDatePicker2Type datePickerType,
      List<DateTime?> values,
      ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
          .map((v) => v.toString().replaceAll('00:00:00.000', ''))
          .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        DateTime parseDate =DateFormat("yyyy-MM-dd").parse(values[0].toString().replaceAll('00:00:00.000', ''),true);
        DateTime parsDate =DateFormat("yyyy-MM-dd").parse(values[1].toString().replaceAll('00:00:00.000', ''),true);
        var inputDate = DateTime.parse(parseDate.toLocal().toString());
        var inputsDate = DateTime.parse(parsDate.toLocal().toString());
        var outputFormat = widget.type != "Invoice" ? DateFormat("dd/MM/yyyy"):DateFormat("MM/dd/yyyy");
        var outputDate = outputFormat.format(inputDate);
        var outputsDate = outputFormat.format(inputsDate);
        _startDate = outputDate;
        _enddate = outputsDate;
        Provider.of<InvoiceProvider>(context, listen: false).getMainInvoiceList(context,PreferenceUtils.getString("${AppConstants.companyId}"),_startDate,_enddate,customerDropDown.toString()).then((value) {
          setState(() {
            is_loading = false;
          });
        });
        valueText = '$_startDate to $_enddate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }

  List<DateTime?> _dialogCalendarPickerValue = [];

  _buildCalendarDialogButton() {
    const dayTextStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle = TextStyle(color: Colors.red[500], fontWeight: FontWeight.w600);
    final config = CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: ColorResources.LINE_BG,
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      firstDate: DateTime(1995),
      lastDate: DateTime.now(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      currentDate: DateTime.now(),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        return textStyle;
      },
    );
    return GestureDetector(
      onTap: () async {
        final values = await showCalendarDatePicker2Dialog(
          context: context,
          config: config,
          dialogSize: const Size(325, 400),
          borderRadius: BorderRadius.circular(15),
          value: _dialogCalendarPickerValue,
          dialogBackgroundColor: Colors.white,
        );
        if (values != null) {
          print("date::1:${_getValueText(config.calendarType, values,)}");
          print("date::2:$_startDate::$_enddate");
          setState(() {
            _dialogCalendarPickerValue = values;
            print("object::${_dialogCalendarPickerValue[0]}");
          });
        }
      },
      child: Container(
        alignment: Alignment.centerLeft,
        height: AppConstants.itemHeight*0.05,
        margin: EdgeInsets.only(left: AppConstants.itemWidth*0.03,top: AppConstants.itemHeight*0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // widget.type != "Invoice" ?
            // Text(_startDate == "" ? "Select Date" : "${AppConstants.changeDateToMDY(widget.startDate)}  To  ${AppConstants.changeDateToMDY(widget.endDate)}",style: poppinsBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),):
            Text(_startDate == "" ? "Select Date" : "${AppConstants.changeDateToMDY(_startDate)}  To  ${AppConstants.changeDateToMDY(_enddate)}",style: poppinsBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
            const Icon(Icons.keyboard_arrow_down_outlined,color: ColorResources.BLACK,size: 20),
          ],
        ),
      ),
    );
  }

}
