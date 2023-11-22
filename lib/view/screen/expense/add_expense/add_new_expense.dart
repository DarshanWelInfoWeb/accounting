import 'dart:convert';
import 'dart:io';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/expense_provider.dart';
import 'package:gas_accounting/provider/route_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/images.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/custom_button.dart';
import 'package:gas_accounting/view/basewidget/custom_password_textfield.dart';
import 'package:gas_accounting/view/basewidget/custom_textfield.dart';
import 'package:gas_accounting/view/screen/expense/add_expense/expense_list.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class Add_New_Expense extends StatefulWidget {
  const Add_New_Expense({super.key});

  @override
  State<Add_New_Expense> createState() => _Add_New_ExpenseState();
}

class _Add_New_ExpenseState extends State<Add_New_Expense> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController onlineController = TextEditingController();
  TextEditingController cashController = TextEditingController();
  TextEditingController search = TextEditingController();
  FocusNode titleCode = FocusNode();
  FocusNode descriptionCode = FocusNode();
  FocusNode amountCode = FocusNode();
  FocusNode dateCode = FocusNode();
  FocusNode onlineCode = FocusNode();
  FocusNode cashCode = FocusNode();
  FocusNode searchCode = FocusNode();
  int? routeDropdownValue ;
  String? routeName;
  String? expenseDropdownValue;
  late String formattedDate = '';
  late String date_shcedule = '';
  TimeOfDay selectedTime = TimeOfDay.now();
  List expense = ["WelMart","Wel InfoWeb","Test"];

  int? total_amount;
  bool is_loading = true;
  String? _fileName;
  String? _imageName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _isLoad = false;
  bool _lockParentWindow = false;
  bool _userAborted = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;

  File? files;
  ImageCropper imagecropp = ImageCropper();
  File imageFile = File('');
  File profileimageFile = File('');
  File documnetimageFile = File('');
  final picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime today = DateTime.now();
    formattedDate = DateFormat('dd/MM/yyyy').format(today);
    dateController.text = formattedDate;
    _loadData(context, true);
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<RouteProvider>(context, listen: false).getSelectRoute(context,PreferenceUtils.getString("${AppConstants.companyId}")).then((value) {
        setState(() {
          is_loading = false;
          for(int k=0;k<Provider.of<RouteProvider>(context, listen: false).selectrouteList.length;k++){
            if (Provider.of<RouteProvider>(context, listen: false).selectrouteList[0].intId == Provider.of<RouteProvider>(context, listen: false).selectrouteList[k].intId) {
              routeDropdownValue = Provider.of<RouteProvider>(context, listen: false).selectrouteList[k].intId;
              routeName = Provider.of<RouteProvider>(context, listen: false).selectrouteList[k].strRoute.toString();
            }
            print("object::::1:::$routeDropdownValue:::::$routeName");
          }
        });
      });
      Provider.of<ExpenseProvider>(context, listen: false).getExpenseType(context,PreferenceUtils.getString("${AppConstants.companyId}")).then((value) {
        setState(() {
          is_loading = false;
        });
      });
    });
  }

  Future profile_Image() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    File? file = File(profileimageFile.path);

    print("image:::${profileimageFile.path}");
    if (pickedFile != null) {
  /*    CroppedFile? cropped = await (imagecropp.cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
          compressQuality: 100,
          maxHeight: 4160,
          maxWidth: 4160,
          compressFormat: ImageCompressFormat.jpg,
          uiSettings: [
            IOSUiSettings(
              minimumAspectRatio: 1.0,
            ),
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Colors.grey,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.square,
                lockAspectRatio: false),
          ]
      ));*/
      setState(() {
          imageFile = File(pickedFile.path);
          print("object:::${pickedFile.path}");
      });
      print('Image file Path:::::::::${imageFile.path}');
    }
    return file;
  }

  void _date_pik_shcedule() {
    showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: ColorResources.LINE_BG, // header background color
                onPrimary: ColorResources.WHITE, // header text color
                onSurface: ColorResources.BLACK, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: ColorResources.LINE_BG, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1970),
        lastDate: DateTime(2040))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
        dateController.text = formattedDate;
        // if (routeName!.split("-")[0] != dateController.text) {
        //   print("object::1:");
        // }  else {
        //   print("object::2");
        // }
      });
    });
  }


  _addExpense() async {
    if (routeDropdownValue == null) {
      AppConstants.getToast("Please Select Route");
    }  else if (selected == null) {
      AppConstants.getToast("Please Select Expense Type");
    } else if (titleController.text == '') {
      AppConstants.getToast("Please Enter Title");
    }
   /* else if (descriptionController.text == '') {
      AppConstants.getToast("Please Enter Description");
    } */
    else if (amountController.text == '') {
      AppConstants.getToast("Please Enter Amount");
    }
    else if (onlineController.text == '') {
      AppConstants.getToast("Please Enter Online Payment");
    }  else if (cashController.text == '') {
      AppConstants.getToast("Please Enter Cash Payment");
    }
    // else if (imageFile.path == '') {
    //   AppConstants.getToast("Please Select File");
    // }
    else {
      setState(() {
        _isLoad = true;
      });
      var request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.ADD_EXPENSE_URI}'));

      //for token
      request.headers.addAll({"Authorization": "Bearer token"});

      //for image and videos and files
      request.fields['intRouteid'] = routeDropdownValue.toString();
      request.fields['intExpenseTypeId'] = selected.toString();
      request.fields['strTitle'] = titleController.text;
      request.fields['strDescription'] = descriptionController.text;
      request.fields['decAmount'] = amountController.text;
      request.fields['dtDate'] = dateController.text;
      request.fields['intCompanyId'] = PreferenceUtils.getString(AppConstants.companyId.toString());
      request.fields['decOnlinepayment'] = onlineController.text;
      request.fields['decCashpayment'] = cashController.text;
      var bytes = (await rootBundle.load(Images.noImage)).buffer.asUint8List();
      imageFile.path == ''
          ?
      request.files.add(http.MultipartFile.fromBytes("strAttachment", bytes, filename: Images.noImage))
          :
      request.files.add(await http.MultipartFile.fromPath("strAttachment", imageFile.path));

      //for completing the request
      var response =await request.send();
      //for getting and decoding the response into json format
      var responsed = await http.Response.fromStream(response);
      final responseData = json.decode(responsed.body);
      setState(() {
        _isLoad = false;
      });
      if (response.statusCode==200) {
        print("SUCCESS");
        AppConstants.getToast("Expense Added Successfully");
        Navigator.push(context, MaterialPageRoute(builder: (context) => Expense_List("","","Expense"),));
        print("response:::$responseData");
      }
      else {
        AppConstants.getToast("Please Try After Sometime");
        print("ERROR");
      }
    }
  }
  var selected;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.LINE_BG,
        centerTitle: true,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25)),
        title: Text("Add Expense",style: montserratBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
      ),
      body: Consumer<ExpenseProvider>(builder: (context, expense, child) {
        return
          is_loading
              ?
          const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
              :
          ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
          children: [
            Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: AppConstants.itemHeight*0.02),
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Row(
                  children: [
                    Text("Select Route",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                    Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                  ],
                )),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
              decoration: BoxDecoration(
                color: ColorResources.GREY.withOpacity(0.05),
                borderRadius:BorderRadius.circular(10),
              ),
              child: Consumer<RouteProvider>(builder: (context, route, child) {
                return DropdownButtonHideUnderline(
                    child: CustomSearchableDropDown(
                      menuPadding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.15),
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                      multiSelect: false,
                      dropDownMenuItems: route.selectrouteList.map((areaList) {
                        return areaList.strRoute;
                      }).toList(),
                      dropdownItemStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                      label: routeName ?? 'Select Route',
                      labelStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                      items : route.selectrouteList.map((areaList) {
                        return  areaList.intId;
                      }).toList(),
                      onChanged: (value){
                        if(value!=null)
                        {
                          routeDropdownValue = value;
                          print("object:::$value");
                        }
                        else{
                          routeDropdownValue = null;
                          print("object:::$value");
                        }
                      },
                    )
                  /*DropdownButton<String>(
                      hint: Text('Select Route',style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),),
                      value: routeDropdownValue,
                      dropdownColor: Colors.white,
                      menuMaxHeight: 200,
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 15,
                      style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                      underline: Container(
                        height: 0,
                        color: Colors.white,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          routeDropdownValue = newValue!;
                        });
                      },
                      items: route.selectrouteList.map((areaList) {
                        return DropdownMenuItem<String>(
                          value: areaList.intId.toString(),
                          child: Row(
                            children: [
                              Text(areaList.strRoute.toString()),
                            ],
                          ),
                        );
                      }).toList(),
                      itemHeight: AppConstants.itemHeight*0.07,
                    ),*/
                );
              },),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Row(
                  children: [
                    Text("Expense Type",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                    Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1))
                  ],
                )),
           /* Container(
              height: AppConstants.itemHeight*0.06,
              width: AppConstants.itemWidth*0.50,
              margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
              decoration: BoxDecoration(
                color: ColorResources.GREY.withOpacity(0.05),
                borderRadius:BorderRadius.circular(10),
              ),
              child: Consumer<ExpenseProvider>(builder: (context, item, child) {
                return DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text('Select Expense Type',style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),),
                    value: expenseDropdownValue,
                    dropdownColor: Colors.white,
                    menuMaxHeight: 200,
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 15,
                    style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
                    underline: Container(
                      height: 0,
                      color: Colors.white,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        expenseDropdownValue = newValue!;
                        print("object:::$newValue");
                      });
                    },
                    items: item.expenseTypeList.map((areaList) {
                      return DropdownMenuItem<String>(
                        value: areaList.intExpenseTypeId.toString(),
                        child: Text(areaList.expenseType.toString()),
                      );
                    }).toList(),
                    itemHeight: AppConstants.itemHeight*0.07,
                  ),
                );
              },),
            ),*/
           /*SearchField<ExpenseTypeData>(
                    controller: search,
                    focusNode: searchCode,
                    suggestionState: Suggestion.expand,
                    // suggestionAction: SuggestionAction.unfocus,
                    // onSubmit: (value) {
                    //   print("object::::$value");
                    //   SuggestionAction.unfocus;
                    //   return value;
                    // },
                    suggestions: expense.expenseTypeList.map((e) =>
                        SearchFieldListItem<ExpenseTypeData>(
                        e.expenseType.toString(),
                        item: e,
                        child: GestureDetector(
                          onTap: () {
                            print("object::::${e.expenseType}");
                            SuggestionAction.unfocus;
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: AppConstants.itemWidth*0.01),
                            child: Text(e.expenseType.toString()),
                          ),
                        ),
                      ),
                    ).toList(),
                  ),*/
            Container(
              alignment: Alignment.center,
              width: AppConstants.itemWidth*0.50,
              margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.005),
              decoration: BoxDecoration(
                color: ColorResources.GREY.withOpacity(0.05),
                borderRadius:BorderRadius.circular(10),
              ),
              child: Consumer<ExpenseProvider>(builder: (context, item, child) {
                return DropdownButtonHideUnderline(
                  child:
                  CustomSearchableDropDown(
                    menuPadding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.15),
                    padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.0),
                    multiSelect: false,
                      dropDownMenuItems: expense.selectExpenseTypeList.map((areaList) {
                      return areaList.expenseType;
                    }).toList(),
                    dropdownItemStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                    label: 'Select Expense Type',
                    labelStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                    items : expense.selectExpenseTypeList.map((areaList) {
                      return  areaList.intExpenseTypeId;
                    }).toList(),
                    onChanged: (value){
                      // setState(() {
                        if(value!=null)
                        {
                          selected = value;
                          print("object:::$value");
                        }
                        else{
                          selected = null;
                          print("object:::$value");
                        }
                      // });
                    },
                  ),
                );
              },),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Row(
                  children: [
                    Text("Title",style: montserratBold.copyWith(color: ColorResources.BLACK)),
                    Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1))
                  ],
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
              child: CustomTextField(
                controller: titleController,
                focusNode: titleCode,
                nextNode: descriptionCode,
                hintText: "Title",
                isPhoneNumber: false,
                maxLine: 1,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Text("Description",style: montserratBold.copyWith(color: ColorResources.BLACK))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
              child: CustomTextField(
                controller: descriptionController,
                focusNode: descriptionCode,
                nextNode: amountCode,
                hintText: "Description",
                isPhoneNumber: false,
                maxLine: 3,
                textInputType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
            ),

            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Row(
                  children: [
                    Text("Date",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                    Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                  ],
                )),
            GestureDetector(
              onTap: () {
                _date_pik_shcedule();
                print("object:::$date_shcedule");
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                child: CustomDateTextField(
                  controller: dateController,
                  focusNode: dateCode,
                  nextNode: onlineCode,
                ),
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Row(
                  children: [
                    Text("Amount",style: montserratBold.copyWith(color: ColorResources.BLACK)),
                    Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1))
                  ],
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
              child: CustomTextField(
                controller: amountController,
                focusNode: amountCode,
                nextNode: dateCode,
                hintText: "Amount",
                isPhoneNumber: true,
                maxLine: 1,
                textInputType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Text("Online Payment",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
                child:
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: ColorResources.GREY.withOpacity(0.05),
                    borderRadius:BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: onlineController,
                    focusNode: onlineCode,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onChanged: (v) {
                      setState(() {
                        onlineController.text!=''?
                        total_amount = int.parse(amountController.text) - int.parse(onlineController.text):
                        total_amount = int.parse(amountController.text) - 0;
                        cashController.text = total_amount.toString();
                        print("amount::::${cashController.text}");
                      });
                    },
                    style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly ,FilteringTextInputFormatter.singleLineFormatter],
                    decoration: InputDecoration(
                      hintText: 'Online Payment',
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
                      isDense: true,
                      counterText: '',
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                      hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),
                      errorStyle: TextStyle(height: 1.5),
                      border: InputBorder.none,
                    ),
                  ),
                )
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Text("Cash Payment",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
              child:
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: ColorResources.GREY.withOpacity(0.05),
                  borderRadius:BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: cashController,
                  focusNode: cashCode,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onChanged: (v) {
                    setState(() {
                      cashController.text!=''?
                      total_amount = int.parse(amountController.text) - int.parse(cashController.text):
                      total_amount = int.parse(amountController.text) - 0;
                      onlineController.text = total_amount.toString();
                      print("amount::::${onlineController.text}");
                    });
                  },
                  style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly ,FilteringTextInputFormatter.singleLineFormatter],
                  decoration: InputDecoration(
                    hintText: 'Cash Payment',
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
                    isDense: true,
                    counterText: '',
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),
                    errorStyle: TextStyle(height: 1.5),
                    border: InputBorder.none,
                  ),
                ),
              )
              // CustomTextField(
              //   controller: cashController,
              //   focusNode: cashCode,
              //   nextNode: null,
              //   hintText: "Cash Payment",
              //   isPhoneNumber: true,
              //   maxLine: 1,
              //   textInputType: TextInputType.number,
              //   textInputAction: TextInputAction.done,
              // ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Row(
                  children: [
                    Text("Image",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                    // Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                  ],
                )),
            _isLoading
                ?
            const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
                :
            Container(
              alignment: Alignment.centerLeft,
              height: AppConstants.itemHeight*0.065,
              margin: EdgeInsets.only(left: AppConstants.itemWidth*0.02,right: AppConstants.itemWidth*0.02,top: AppConstants.itemHeight*0.01),
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(05),
                  border: Border.all(color: ColorResources.BLACK)
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => profile_Image(),
                    child: Container(
                        alignment: Alignment.center,
                        height: AppConstants.itemHeight*0.04,
                        width: AppConstants.itemWidth*0.20,
                        decoration: BoxDecoration(
                            color: ColorResources.GREY.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(05),
                            border: Border.all(color: ColorResources.BLACK)
                        ),
                        child: Text('Pick File',style: montserratBold.copyWith(color: ColorResources.BLACK))),
                  ),
                  // Container(
                  //     width: AppConstants.itemWidth * 0.65,
                  //     margin: EdgeInsets.only(left: AppConstants.itemWidth * 0.01),
                  //     child: Text(imageFile.path != null ? imageFile.path : 'Pick File',
                  //       style: montserratBold.copyWith(color: ColorResources.BLACK),
                  //     ))
                        ],
              ),
            ),
            imageFile.path == ''?SizedBox():
            GestureDetector(
              onTap: () {
                showDialog(context: context, builder: (context) {
                  return Dialog(
                    child: Container(
                      height: AppConstants.itemHeight*0.45,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: FileImage(imageFile),fit: BoxFit.fill)
                      ),
                    ),
                  );
                },);
              },
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: AppConstants.itemHeight*0.35,
                    width: AppConstants.itemWidth*0.70,
                    padding: EdgeInsets.only(bottom: AppConstants.itemHeight*0.30,left: AppConstants.itemWidth*0.60),
                    margin: EdgeInsets.only(top: AppConstants.itemHeight*0.01),
                    decoration: BoxDecoration(image: DecorationImage(image: FileImage(imageFile),fit: BoxFit.fill)),
                    child: GestureDetector(
                      onTap: () {
                        showDialog<bool>(
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const Text("Are You Sure You Want to Remove ?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        imageFile = File('');
                                        AppConstants.getToast("Image Remove Successfully.");
                                        Navigator.pop(context);
                                        print("imagePath::${imageFile.path}");
                                      });
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                                    ),
                                    child: Text('Yes',style: montserratRegular.copyWith(color: ColorResources.WHITE),),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor: MaterialStatePropertyAll(ColorResources.LINE_BG),
                                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(05))))
                                    ),
                                    child: Text('No',style: montserratRegular.copyWith(color: ColorResources.WHITE),),
                                  ),
                                ],
                              );
                            },context: context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: AppConstants.itemHeight*0.01),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorResources.WHITE,
                        ),
                        child: Icon(Icons.clear,color: ColorResources.LINE_BG,size:27),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _isLoad
                ?
            const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
                :
            CustomButtonFuction(onTap: (){
             _addExpense();
            }, buttonText: "Add"),
          ],
        );
      },),
    );
  }
}



