import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utill/app_constants.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/styles.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? textInputType;
  final int? maxLine;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final bool isPhoneNumber;
  final bool isValidator;
  final String? validatorMessage;
  final Color? fillColor;
  final TextCapitalization capitalization;

  CustomTextField(
      {this.controller,
      this.hintText,
      this.textInputType,
      this.maxLine,
      this.focusNode,
      this.nextNode,
      this.textInputAction,
      this.isPhoneNumber = false,
      this.isValidator=false,
      this.validatorMessage,
      this.capitalization = TextCapitalization.none,
      this.fillColor});

  @override
  Widget build(context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: ColorResources.GREY.withOpacity(0.05),
        borderRadius:BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLine ?? 1,
        textCapitalization: capitalization,
        maxLength: isPhoneNumber ? 10 : null,
        focusNode: focusNode,
        keyboardType: textInputType ?? TextInputType.text,
        initialValue: null,
        textInputAction: textInputAction ?? TextInputAction.next,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(nextNode);
        },
        cursorColor: ColorResources.LINE_BG,
        style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
        inputFormatters: [isPhoneNumber ? FilteringTextInputFormatter.digitsOnly : FilteringTextInputFormatter.singleLineFormatter],
        validator: (input){
          if(input!.isEmpty){
            if(isValidator){
              return validatorMessage??"";
            }
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hintText ?? '',
          filled: fillColor != null,
          fillColor: fillColor,
          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
          isDense: true,
          counterText: '',
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
          hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),
          errorStyle: TextStyle(height: 1.5),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class CustomTextFields extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? textInputType;
  final int? maxLine;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final bool isPhoneNumber;
  final bool isValidator;
  final String? validatorMessage;
  final Color? fillColor;
  final void Function(String)? onSubmitted;
  final TextCapitalization capitalization;

  CustomTextFields(
      {this.controller,
      this.hintText,
      this.textInputType,
      this.maxLine,
      this.focusNode,
      this.nextNode,
      this.textInputAction,
      this.isPhoneNumber = false,
      this.isValidator=false,
      this.validatorMessage,
      this.capitalization = TextCapitalization.none,
      this.fillColor,
      this.onSubmitted});

  @override
  Widget build(context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: ColorResources.GREY.withOpacity(0.05),
        borderRadius:BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLine ?? 1,
        textCapitalization: capitalization,
        maxLength: isPhoneNumber ? 10 : null,
        focusNode: focusNode,
        keyboardType: textInputType ?? TextInputType.text,
        initialValue: null,
        cursorColor: ColorResources.LINE_BG,
        textInputAction: textInputAction ?? TextInputAction.next,
        onFieldSubmitted: (v) {
          onSubmitted;
          FocusScope.of(context).requestFocus(nextNode);
        },
        style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
        inputFormatters: [isPhoneNumber ? FilteringTextInputFormatter.digitsOnly : FilteringTextInputFormatter.singleLineFormatter],
        validator: (input){
          if(input!.isEmpty){
            if(isValidator){
              return validatorMessage??"";
            }
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hintText ?? '',
          filled: fillColor != null,
          fillColor: fillColor,
          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
          isDense: true,
          counterText: '',
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
          hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),
          errorStyle: TextStyle(height: 1.5),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class CustomTextField_GREY_Color extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? textInputType;
  final int? maxLine;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final bool isPhoneNumber;
  final bool isValidator;
  final String? validatorMessage;
  final Color? fillColor;
  final TextCapitalization capitalization;

  CustomTextField_GREY_Color(
      {this.controller,
        this.hintText,
        this.textInputType,
        this.maxLine,
        this.focusNode,
        this.nextNode,
        this.textInputAction,
        this.isPhoneNumber = false,
        this.isValidator=false,
        this.validatorMessage,
        this.capitalization = TextCapitalization.none,
        this.fillColor});

  @override
  Widget build(context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: ColorResources.GREY.withOpacity(0.30),
        borderRadius:BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLine ?? 1,
        textCapitalization: capitalization,
        maxLength: isPhoneNumber ? 10 : null,
        focusNode: focusNode,
        keyboardType: textInputType ?? TextInputType.text,
        initialValue: null,
        cursorColor: ColorResources.LINE_BG,
        textInputAction: textInputAction ?? TextInputAction.next,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(nextNode);
        },
        style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
        inputFormatters: [isPhoneNumber ? FilteringTextInputFormatter.digitsOnly : FilteringTextInputFormatter.singleLineFormatter],
        validator: (input){
          if(input!.isEmpty){
            if(isValidator){
              return validatorMessage??"";
            }
          }
          return null;
        },
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hintText ?? '',
          filled: fillColor != null,
          fillColor: fillColor,
          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
          isDense: true,
          counterText: '',
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
          hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w500,color:ColorResources.WHITE),
          errorStyle: TextStyle(height: 1.5),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class CustomTextFieldEnabled extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? textInputType;
  final int? maxLine;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final bool isPhoneNumber;
  final bool enabled;
  final bool isValidator;
  final String? validatorMessage;
  final Color? fillColor;
  final TextCapitalization capitalization;

  CustomTextFieldEnabled(
      {this.controller,
        this.hintText,
        this.textInputType,
        this.maxLine,
        this.focusNode,
        this.nextNode,
        this.textInputAction,
        this.isPhoneNumber = false,
        this.enabled = false,
        this.isValidator=false,
        this.validatorMessage,
        this.capitalization = TextCapitalization.none,
        this.fillColor});

  @override
  Widget build(context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: ColorResources.GREY.withOpacity(0.05),
        borderRadius:BorderRadius.circular(10),
      ),
      child: TextFormField(
        enabled: false,
        controller: controller,
        maxLines: maxLine ?? 1,
        cursorColor: ColorResources.LINE_BG,
        textCapitalization: capitalization,
        maxLength: isPhoneNumber ? 10 : null,
        focusNode: focusNode,
        keyboardType: textInputType ?? TextInputType.text,
        initialValue: null,
        textInputAction: textInputAction ?? TextInputAction.next,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(nextNode);
        },
        style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),
        inputFormatters: [isPhoneNumber ? FilteringTextInputFormatter.digitsOnly : FilteringTextInputFormatter.singleLineFormatter],
        validator: (input){
          if(input!.isEmpty){
            if(isValidator){
              return validatorMessage??"";
            }
          }
          return null;

        },
        decoration: InputDecoration(
          hintText: hintText ?? '',
          filled: fillColor != null,
          fillColor: fillColor,
          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
          isDense: true,
          counterText: '',
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
          hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),
          errorStyle: TextStyle(height: 1.5),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class CustomTextFixWidthFieldEnabled extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? textInputType;
  final int? maxLine;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final bool isPhoneNumber;
  final bool enabled;
  final bool isValidator;
  final String? validatorMessage;
  final Color? fillColor;
  final TextCapitalization capitalization;

  CustomTextFixWidthFieldEnabled(
      {this.controller,
        this.hintText,
        this.textInputType,
        this.maxLine,
        this.focusNode,
        this.nextNode,
        this.textInputAction,
        this.isPhoneNumber = false,
        this.enabled = false,
        this.isValidator=false,
        this.validatorMessage,
        this.capitalization = TextCapitalization.none,
        this.fillColor});

  @override
  Widget build(context) {
    return Container(
      width: AppConstants.itemWidth*0.28,
      padding: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: ColorResources.GREY.withOpacity(0.05),
        borderRadius:BorderRadius.circular(10),
      ),
      child: TextFormField(
        enabled: false,
        controller: controller,
        maxLines: maxLine ?? 1,
        cursorColor: ColorResources.LINE_BG,
        textCapitalization: capitalization,
        maxLength: isPhoneNumber ? 10 : null,
        focusNode: focusNode,
        keyboardType: textInputType ?? TextInputType.text,
        initialValue: null,
        textInputAction: textInputAction ?? TextInputAction.next,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(nextNode);
        },
        style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),
        inputFormatters: [isPhoneNumber ? FilteringTextInputFormatter.digitsOnly : FilteringTextInputFormatter.singleLineFormatter],
        validator: (input){
          if(input!.isEmpty){
            if(isValidator){
              return validatorMessage??"";
            }
          }
          return null;

        },
        decoration: InputDecoration(
          hintText: hintText ?? '',
          filled: fillColor != null,
          fillColor: fillColor,
          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
          isDense: true,
          counterText: '',
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
          hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),
          errorStyle: TextStyle(height: 1.5),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class CustomTextField_Pincode extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? textInputType;
  final int? maxLine;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final bool isPhoneNumber;
  final bool isValidator;
  final String? validatorMessage;
  final Color? fillColor;
  final TextCapitalization capitalization;

  CustomTextField_Pincode(
      {this.controller,
        this.hintText,
        this.textInputType,
        this.maxLine,
        this.focusNode,
        this.nextNode,
        this.textInputAction,
        this.isPhoneNumber = false,
        this.isValidator=false,
        this.validatorMessage,
        this.capitalization = TextCapitalization.none,
        this.fillColor});

  @override
  Widget build(context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: ColorResources.GREY.withOpacity(0.30),
        borderRadius:BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLine ?? 1,
        textCapitalization: capitalization,
        maxLength: 6,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        initialValue: null,
        cursorColor: ColorResources.LINE_BG,
        textInputAction: textInputAction ?? TextInputAction.next,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(nextNode);
        },
        style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (input){
          if(input!.isEmpty){
            if(isValidator){
              return validatorMessage??"";
            }
          }
          return null;

        },
        decoration: InputDecoration(
          hintText: hintText ?? '',
          filled: fillColor != null,
          fillColor: fillColor,
          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
          isDense: true,
          counterText: '',
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
          hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),
          errorStyle: TextStyle(height: 1.5),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class CustomTextField_GREY_ColorEnabled extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? textInputType;
  final int? maxLine;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final bool isPhoneNumber;
  final bool isValidator;
  final String? validatorMessage;
  final Color? fillColor;
  final TextCapitalization capitalization;

  CustomTextField_GREY_ColorEnabled(
      {this.controller,
        this.hintText,
        this.textInputType,
        this.maxLine,
        this.focusNode,
        this.nextNode,
        this.textInputAction,
        this.isPhoneNumber = false,
        this.isValidator=false,
        this.validatorMessage,
        this.capitalization = TextCapitalization.none,
        this.fillColor});

  @override
  Widget build(context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorResources.GREY.withOpacity(0.30),
        borderRadius:BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLine ?? 1,
        textCapitalization: capitalization,
        maxLength: isPhoneNumber ? 10 : null,
        cursorColor: ColorResources.LINE_BG,
        focusNode: focusNode,
        keyboardType: textInputType ?? TextInputType.text,
        initialValue: null,
        textInputAction: textInputAction ?? TextInputAction.next,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(nextNode);
        },
        style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
        inputFormatters: [isPhoneNumber ? FilteringTextInputFormatter.digitsOnly : FilteringTextInputFormatter.singleLineFormatter],
        validator: (input){
          if(input!.isEmpty){
            if(isValidator){
              return validatorMessage??"";
            }
          }
          return null;
        },
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          enabled: false,
          hintText: hintText ?? '',
          filled: fillColor != null,
          fillColor: fillColor,
          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
          isDense: true,
          counterText: '',
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
          hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w500,color:ColorResources.WHITE),
          errorStyle: TextStyle(height: 1.5),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
