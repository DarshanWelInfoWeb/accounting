import 'package:flutter/material.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/images.dart';

import '../../../utill/styles.dart';

class CustomPasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintTxt;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final Color? fillColor;

  CustomPasswordTextField({this.controller, this.hintTxt, this.focusNode, this.nextNode, this.textInputAction,this.textInputType,this.fillColor});

  @override
  _CustomPasswordTextFieldState createState() => _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.itemHeight*0.06,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: ColorResources.GREY.withOpacity(0.05),
        borderRadius:BorderRadius.circular(10),
      ),
      child: TextFormField(
        cursorColor: Theme.of(context).primaryColor,
        controller: widget.controller,
        obscureText: _obscureText,
        focusNode: widget.focusNode,
        keyboardType: widget.textInputType ?? TextInputType.text,
        textInputAction: widget.textInputAction ?? TextInputAction.next,
        maxLines: 1,
        style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
        onFieldSubmitted: (v) {
          setState(() {
            widget.textInputAction == TextInputAction.done
                ? FocusScope.of(context).consumeKeyboardToken()
                : FocusScope.of(context).requestFocus(widget.nextNode);
          });
        },
        validator: (value) {
          return null;
        },
        decoration: InputDecoration(
            counterText: '',
            focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
            hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),
            errorStyle: TextStyle(height: 1.5),
            suffixIcon: GestureDetector(
              onTap: _toggle,
                child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility,color: ColorResources.LINE_BG,)),
            hintText: widget.hintTxt ?? '',
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
            isDense: true,
            filled: widget.fillColor != null,
            fillColor: widget.fillColor,
            border: InputBorder.none),
      ),
    );
  }
}

class CustomDateTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintTxt;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final Color? fillColor;

  CustomDateTextField({this.controller, this.hintTxt, this.focusNode, this.nextNode, this.textInputAction,this.textInputType,this.fillColor});

  @override
  State<CustomDateTextField> createState() => _CustomDateTextFieldState();
}

class _CustomDateTextFieldState extends State<CustomDateTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.itemHeight*0.06,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: ColorResources.GREY.withOpacity(0.05),
        borderRadius:BorderRadius.circular(10),
      ),
      child: TextFormField(
        cursorColor: Theme.of(context).primaryColor,
        controller: widget.controller,
        focusNode: widget.focusNode,
        keyboardType: widget.textInputType ?? TextInputType.text,
        textInputAction: widget.textInputAction ?? TextInputAction.next,
        maxLines: 1,
        enabled: false,
        style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.BLACK),
        onFieldSubmitted: (v) {
          setState(() {
            widget.textInputAction == TextInputAction.done
                ? FocusScope.of(context).consumeKeyboardToken()
                : FocusScope.of(context).requestFocus(widget.nextNode);
          });
        },
        validator: (value) {
          return null;
        },
        decoration: InputDecoration(
            counterText: '',
            focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
            hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),
            errorStyle: TextStyle(height: 1.5),
            suffixIcon: Container(
              height: AppConstants.itemHeight*0.005,
              width: AppConstants.itemWidth*0.005,
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03,vertical: AppConstants.itemHeight*0.01),
              child: Image.asset(Images.calendar,color: ColorResources.LINE_BG,fit: BoxFit.fill,),
            ),
            hintText: widget.hintTxt ?? '',
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
            isDense: true,
            filled: widget.fillColor != null,
            fillColor: widget.fillColor,
            border: InputBorder.none),
      ),
    );
  }
}


class CustomDateTextFieldEnable extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintTxt;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final Color? fillColor;

  CustomDateTextFieldEnable({this.controller, this.hintTxt, this.focusNode, this.nextNode, this.textInputAction,this.textInputType,this.fillColor});

  @override
  State<CustomDateTextFieldEnable> createState() => _CustomDateTextFieldEnableState();
}

class _CustomDateTextFieldEnableState extends State<CustomDateTextFieldEnable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.itemHeight*0.06,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: ColorResources.GREY.withOpacity(0.05),
        borderRadius:BorderRadius.circular(10),
      ),
      child: TextFormField(
        cursorColor: Theme.of(context).primaryColor,
        controller: widget.controller,
        focusNode: widget.focusNode,
        keyboardType: widget.textInputType ?? TextInputType.text,
        textInputAction: widget.textInputAction ?? TextInputAction.next,
        maxLines: 1,
        enabled: false,
        style: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: ColorResources.GREY),
        onFieldSubmitted: (v) {
          setState(() {
            widget.textInputAction == TextInputAction.done
                ? FocusScope.of(context).consumeKeyboardToken()
                : FocusScope.of(context).requestFocus(widget.nextNode);
          });
        },
        validator: (value) {
          return null;
        },
        decoration: InputDecoration(
            counterText: '',
            focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
            hintStyle: montserratRegular.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).hintColor),
            errorStyle: TextStyle(height: 1.5),
            suffixIcon: Container(
              height: AppConstants.itemHeight*0.005,
              width: AppConstants.itemWidth*0.005,
              padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03,vertical: AppConstants.itemHeight*0.01),
              child: Image.asset(Images.calendar,color: ColorResources.LINE_BG,fit: BoxFit.fill),
            ),
            hintText: widget.hintTxt ?? '',
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
            isDense: true,
            enabled: false,
            filled: widget.fillColor != null,
            fillColor: widget.fillColor,
            border: InputBorder.none),
      ),
    );
  }
}

