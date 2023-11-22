import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/item_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/images.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/basewidget/custom_button.dart';
import 'package:gas_accounting/view/screen/manage_item/items/item_list.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:gas_accounting/view/basewidget/custom_textfield.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';


class EditItem extends StatefulWidget {
  String id;
  EditItem(this.id,{super.key});

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  TextEditingController itemCodeController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemDescriptionController = TextEditingController();
  TextEditingController itemSpecificationController = TextEditingController();
  TextEditingController rankController = TextEditingController();
  TextEditingController openingStockController = TextEditingController();
  FocusNode itemCode = FocusNode();
  FocusNode itemNameCode = FocusNode();
  FocusNode itemDescriptionCode = FocusNode();
  FocusNode itemSpecificationCode = FocusNode();
  FocusNode rankCode = FocusNode();
  FocusNode openingStockCode = FocusNode();
  int? routeDropdownValue;
  String? unitName;
  List expense = ["WelMart","Wel InfoWeb","Test"];
  String displayButtonItem = 'No';
  String isNewButtonItem = 'No';
  int id = 0;
  bool? ids;
  int idNew = 0;
  bool? idNews;

  bool is_loading = true;

  File? files;
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

  ImageCropper imagecropp = ImageCropper();
  File imageFile = File('');
  File imageTempFile = File('');
  File profileimageFile = File('');
  File documnetimageFile = File('');
  final picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData(context, true);
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Future.delayed(Duration.zero, () async {
      Provider.of<ItemProvider>(context, listen: false).getItemsEdit(context,widget.id).then((value) async {
        // setState(() async {
          is_loading = false;
          for(int i=0;i<Provider.of<ItemProvider>(context, listen: false).itemEdit.length;i++){
            itemCodeController.text = Provider.of<ItemProvider>(context, listen: false).itemEdit[i].strItemCode.toString();
            routeDropdownValue = int.parse(Provider.of<ItemProvider>(context, listen: false).itemEdit[i].strUnitselection.toString());
            itemNameController.text = Provider.of<ItemProvider>(context, listen: false).itemEdit[i].itemName.toString();
            itemDescriptionController.text = Provider.of<ItemProvider>(context, listen: false).itemEdit[i].strDescription.toString()=="null"?"":convertHtml(Provider.of<ItemProvider>(context, listen: false).itemEdit[i].strDescription.toString());
            itemSpecificationController.text = Provider.of<ItemProvider>(context, listen: false).itemEdit[i].strSpecification.toString()=="null"?"":convertHtml(Provider.of<ItemProvider>(context, listen: false).itemEdit[i].strSpecification.toString());
            openingStockController.text = Provider.of<ItemProvider>(context, listen: false).itemEdit[i].decAvailablestock!.round().toString();
            rankController.text = Provider.of<ItemProvider>(context, listen: false).itemEdit[i].intRank.toString();
            _imageName = Provider.of<ItemProvider>(context, listen: false).itemEdit[i].strImageFileName.toString();
            idNews = Provider.of<ItemProvider>(context, listen: false).itemEdit[i].bisIsNew;
            ids = Provider.of<ItemProvider>(context, listen: false).itemEdit[i].bisIsdisplayonweb;
            ids == true ? id = 1 : id = 2;
            idNews == true ? idNew = 1 : idNew = 2;
            print("object::::$idNews::::::$ids");
            Map<Permission, PermissionStatus> statuses = await [
              Permission.storage,
            ].request();

            // if (_imageName == 'http://support.welinfoweb.com/Data/Item/scaled_IMG-20230706-WA0000.jpg') {
            //   print("imageName:::::");
            // }  else {
              // if(statuses[Permission.storage]!.isGranted){
              var dir = await DownloadsPathProvider.downloadsDirectory;
              if(dir != null){
                String savePath = "${dir.path}/$_imageName";
                print("pathSave:::::$savePath");
                imageFile = File(savePath);
                print("imageDownloadPath:::${imageFile.path}");

                try {
                  await Dio().download(_imageName!,
                      savePath,
                      onReceiveProgress: (received, total) {
                        if (total != -1) {
                          print("progress::${(received / total * 100).toStringAsFixed(0)}" + "%");
                        }
                      });
                  print("File is saved to download folder.");
                } on DioError catch (e) {
                  print("error::${e.message}");
                }
              }
              // }else{
              //   print("No permission to read and write.");
              // }
            }
          // }
        // });
      });
      Provider.of<ItemProvider>(context, listen: false).getUnit(context,PreferenceUtils.getString("${AppConstants.companyId}")).then((value) {
        setState(() {
          is_loading = false;
        });
      });
    });
  }

  String convertHtml(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body?.text).documentElement!.text;
    print("object:::$parsedString");
    return parsedString;
  }

  void _pickFiles() async {
    _resetState();
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print("status::::::$status"),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
        lockParentWindow: _lockParentWindow,
      ))
          ?.files;
      print("ImagePath::::${_paths![0].path}");
    } on PlatformException catch (e) {
      print("Unsupported operation:${e.toString()}");
      AppConstants.getToast("Unsupported operation:${e.toString()}");
    } catch (e) {
      _imageName = '';
      AppConstants.getToast("File Not Selected");
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName = _paths != null ? _paths!.map((e) {
        _imageName = e.name;
        return e.name;
      }).toString() : '...';
      _userAborted = _paths == null;
      print("ImageName:::::::$_imageName");
    });
  }

  Future profile_Image() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    File? file = File(profileimageFile.path);

    print("image:::${profileimageFile.path}");
    if (pickedFile != null) {
   /*   CroppedFile? cropped = await (imagecropp.cropImage(
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
    } else {
      AppConstants.getToast("File Not Selected");
    }
    return file;
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

  addItem() async {
    if (itemCodeController.text == '') {
      AppConstants.getToast("Please Enter Item Code");
    }  else if (id == 0) {
      AppConstants.getToast("Please Select Is Display");
    }  else if (itemNameController.text == '') {
      AppConstants.getToast("Please Enter Item Name");
    }  else if (idNew == 0) {
      AppConstants.getToast("Please Select Is New");
    }  else if (rankController.text == '') {
      AppConstants.getToast("Please Enter Rank");
    } else if (routeDropdownValue == null) {
      AppConstants.getToast("Please Select Unit Selection");
    } else if (openingStockController.text == '') {
      AppConstants.getToast("Please Enter Opening Stock");
    }
    /*else if (itemDescriptionController.text == '') {
      AppConstants.getToast("Please Enter Item Description");
    }  else if (itemSpecificationController.text == '') {
      AppConstants.getToast("Please Enter Item Specification");
    }*/
    else {
          setState(() {
            _isLoad = true;
          });
          var request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.UPDATE_ITEM_URI}'));

          //for token
          request.headers.addAll({"Authorization": "Bearer token"});

          //for image and videos and files
          var fileName = imageFile.path.split('/').last;
          print("object:::::$fileName");
          request.fields['intId'] = widget.id;
          var bytes = (await rootBundle.load(Images.noImage)).buffer.asUint8List();
          imageFile.path == ''
              ?
          request.files.add(http.MultipartFile.fromBytes("strImageFileName", bytes, filename: Images.noImage))
              :
          request.files.add(await http.MultipartFile.fromPath("strImageFileName", imageFile.path));
          request.fields['intCompanyId'] = PreferenceUtils.getString(AppConstants.companyId.toString());
          request.fields['strItemCode'] = itemCodeController.text;
          request.fields['ItemName'] = itemNameController.text;
          request.fields['strDescription'] = itemDescriptionController.text;
          request.fields['strUnitselection'] = routeDropdownValue.toString();
          request.fields['strSpecification'] = itemSpecificationController.text;
          request.fields['intRank'] = rankController.text;
          request.fields['decAvailablestock'] = openingStockController.text;
          request.fields['bisIsdisplayonweb'] = ids.toString();
          request.fields['bisIsNew'] = idNews.toString();

        //for completing the request
        var response =await request.send();
        //for getting and decoding the response into json format
        var responsed = await http.Response.fromStream(response);
        final responseData = json.decode(responsed.body);
        print("sendResponse:::${responsed.body}");
        setState(() {
        _isLoad = false;
        });
        if (response.statusCode==200) {
          print("SUCCESS");
          AppConstants.getToast("Item Edited Successfully");
          route();
          print("response:::$responseData");
        } else {
          AppConstants.getToast("Please Try After Sometime");
          print("ERROR");
        }
    }
  }

  route(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ItemList(),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.LINE_BG,
        centerTitle: true,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
        title: Text("Item",style: montserratBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
      ),
      body: Consumer<ItemProvider>(builder: (context, item, child) {
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
                    Text("Item Code",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                    Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                  ],
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
              child: CustomTextField(
                controller: itemCodeController,
                focusNode: itemCode,
                nextNode: itemNameCode,
                hintText: "Item Code",
                isPhoneNumber: false,
                maxLine: 1,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Is display on web",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                  Radio(
                    value: 1,
                    groupValue: id,
                    activeColor: ColorResources.LINE_BG,
                    onChanged: (val) {
                      setState(() {
                        displayButtonItem = 'Yes';
                        id = 1;
                        ids = true;
                        print("object::::$ids");
                      });
                    },
                  ),
                  const Text('Yes', style: TextStyle(fontSize: 17.0)),
                  Radio(
                    value: 2,
                    groupValue: id,
                    activeColor: ColorResources.LINE_BG,
                    onChanged: (val) {
                      setState(() {
                        displayButtonItem = 'No';
                        id = 2;
                        ids = false;
                        print("object::::$ids");
                      });
                    },
                  ),
                  const Text('No', style: TextStyle(fontSize: 17.0)),
                ],
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Row(
                  children: [
                    Text("Item Name",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                    Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                  ],
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
              child: CustomTextField(
                controller: itemNameController,
                focusNode: itemNameCode,
                nextNode: rankCode,
                hintText: "Item Name",
                isPhoneNumber: false,
                maxLine: 1,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Is New",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                  Radio(
                    value: 1,
                    groupValue: idNew,
                    activeColor: ColorResources.LINE_BG,
                    onChanged: (val) {
                      setState(() {
                        isNewButtonItem = 'Yes';
                        idNew = 1;
                        idNews = true;
                        print("object::::$idNews");
                      });
                    },
                  ),
                  const Text('Yes', style: TextStyle(fontSize: 17.0)),
                  Radio(
                    value: 2,
                    groupValue: idNew,
                    activeColor: ColorResources.LINE_BG,
                    onChanged: (val) {
                      setState(() {
                        isNewButtonItem = 'No';
                        idNew = 2;
                        idNews = false;
                        print("object::::$idNews");
                      });
                    },
                  ),
                  const Text('No', style: TextStyle(fontSize: 17.0)),
                ],
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Row(
                  children: [
                    Text("Rank",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                    Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                  ],
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
              child: CustomTextField(
                controller: rankController,
                focusNode: rankCode,
                nextNode: openingStockCode,
                hintText: "Rank",
                isPhoneNumber: true,
                maxLine: 1,
                textInputType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Row(
                  children: [
                    Text("Unit Selection",style: montserratBold.copyWith(color: ColorResources.BLACK),),
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
              child: Consumer<ItemProvider>(builder: (context, route, child) {
                for(int i=0;i<Provider.of<ItemProvider>(context, listen: false).itemEdit.length;i++){
                  for(int k=0;k<Provider.of<ItemProvider>(context, listen: false).unitList.length;k++){
                    if (Provider.of<ItemProvider>(context, listen: false).itemEdit[i].strUnitselection == Provider.of<ItemProvider>(context, listen: false).unitList[k].intId) {
                      unitName = Provider.of<ItemProvider>(context, listen: false).unitList[k].strName.toString();
                      routeDropdownValue = Provider.of<ItemProvider>(context, listen: false).unitList[k].intId;
                    }
                  }
                }
                return DropdownButtonHideUnderline(
                    child: CustomSearchableDropDown(
                      menuPadding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.15),
                      padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                      multiSelect: false,
                      dropDownMenuItems: route.unitList.map((areaList) {
                        return areaList.strName;
                      }).toList(),
                      dropdownItemStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                      label: unitName ?? 'Select Unit Selection',
                      labelStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
                      items : route.unitList.map((areaList) {
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
                    hint: Text('Select Unit Selection',style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),),
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
                    items: route.unitList.map((areaList) {
                      return DropdownMenuItem<String>(
                        value: areaList.intId.toString(),
                        child: Text(areaList.strName.toString()),
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
                    Text("Opening Stock",style: montserratBold.copyWith(color: ColorResources.BLACK),),
                    Text("*",style: montserratBold.copyWith(color: ColorResources.RED_1),)
                  ],
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
              child: CustomTextField(
                controller: openingStockController,
                focusNode: openingStockCode,
                nextNode: itemDescriptionCode,
                hintText: "Opening Stock",
                isPhoneNumber: true,
                maxLine: 1,
                textInputType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Text("Item Description",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
              child: CustomTextField(
                controller: itemDescriptionController,
                focusNode: itemDescriptionCode,
                nextNode: itemSpecificationCode,
                hintText: "Item Description",
                isPhoneNumber: false,
                maxLine: 3,
                textInputType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Text("Item Specification",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02,vertical: AppConstants.itemHeight*0.01),
              child: CustomTextField(
                controller: itemSpecificationController,
                focusNode: itemSpecificationCode,
                nextNode: null,
                hintText: "Item Specification",
                isPhoneNumber: false,
                maxLine: 3,
                textInputType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03),
                child: Text("Image",style: montserratBold.copyWith(color: ColorResources.BLACK),)),
           /* _isLoading
                ?
            const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
                :*/
            Container(
              alignment: Alignment.centerLeft,
              height: AppConstants.itemHeight*0.06,
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
                  //     child: Text(imageFile.path != null ? "$_imageName" :imageFile.path,
                  //       style: montserratBold.copyWith(color: ColorResources.BLACK),
                  //     ))
                ],
              ),
            ),
            imageFile.path==''?_imageName==null?SizedBox():
            // _imageName == 'http://support.welinfoweb.com/Data/Item/scaled_IMG-20230706-WA0000.jpg'?SizedBox():
            GestureDetector(
              onTap: () {
                imageFile.path == '/storage/emulated/0/Download/http://support.welinfoweb.com/Data/Item/no_image.png'?SizedBox():
                showDialog(context: context, builder: (context) {
                  return Dialog(
                    child: Container(
                      height: AppConstants.itemHeight*0.45,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: NetworkImage("$_imageName"),fit: BoxFit.fill)
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
                    margin: EdgeInsets.only(top: AppConstants.itemHeight*0.01),
                    child: CachedNetworkImage(
                      alignment: Alignment.center,
                      fit: BoxFit.fill,
                      height: AppConstants.itemHeight*0.35,
                      width: AppConstants.itemWidth*0.70,
                      imageUrl: "$_imageName",
                      imageBuilder: (context, imageProvider) =>
                          Container(
                            alignment: Alignment.center,
                            width: AppConstants.itemWidth * 0.35,
                            height: AppConstants.itemWidth * 0.70,
                            padding: EdgeInsets.only(left: AppConstants.itemWidth*0.60,bottom: AppConstants.itemHeight*0.30),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fill),
                            ),
                            child:
                            imageFile.path == '/storage/emulated/0/Download/http://support.welinfoweb.com/Data/Item/no_image.png'?SizedBox():
                            GestureDetector(
                              onTap: () {
                                showDialog<bool>(
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: const Text("Are You Sure You Want to Remove ?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              setState(() {
                                                _imageName = null;
                                                imageFile = File('');
                                                print("imageName:::$_imageName");
                                                print("imagePath::${imageFile.path}");
                                                AppConstants.getToast("Image Remove Successfully.");
                                                Navigator.pop(context);
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
                      placeholder: (context, url) =>
                          Container(alignment: Alignment.center,child: const CircularProgressIndicator(color: ColorResources.LINE_BG,)),
                      errorWidget: (context, url, error) => Container(
                        alignment: Alignment.center,
                        width: AppConstants.itemWidth * 0.35,
                        height: AppConstants.itemWidth * 0.70,
                        padding: EdgeInsets.only(left: AppConstants.itemWidth*0.60,bottom: AppConstants.itemHeight*0.30),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1200px-No-Image-Placeholder.svg.png"),
                              fit: BoxFit.fill),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ):
            GestureDetector(
              onTap: () {
                imageFile.path == '/storage/emulated/0/Download/http://support.welinfoweb.com/Data/Item/no_image.png'?SizedBox():
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
                    decoration: BoxDecoration(
                        image: DecorationImage(image: FileImage(imageFile.path=='/storage/emulated/0/Download/http://support.welinfoweb.com/Data/Item/'?File('/storage/emulated/0/Download/http://support.welinfoweb.com/Data/Item/no_image.png'):imageFile),fit: BoxFit.fill)
                    ),
                    child:
                    imageFile.path == '/storage/emulated/0/Download/http://support.welinfoweb.com/Data/Item/no_image.png'?SizedBox():
                    GestureDetector(
                      onTap: () {
                        showDialog<bool>(
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const Text("Are You Sure You Want to Remove ?"),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      setState(() {
                                        imageFile = File('');
                                        _imageName = null;
                                        print("imagePath::${imageFile.path}");
                                        print("imageName:::$_imageName");
                                        AppConstants.getToast("Image Remove Successfully.");
                                        Navigator.pop(context);
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
              addItem();
            }, buttonText: "Save"),
          ],
        );
      },),
    );
  }
}
