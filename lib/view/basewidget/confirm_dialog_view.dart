import 'package:flutter/material.dart';
import 'package:gas_accounting/utill/styles.dart';

import '../../utill/color_resources.dart';
import '../../utill/dimensions.dart';

class ConfirmDialogView extends StatefulWidget {
  const ConfirmDialogView(
      {Key? key,
      required this.description,
      required this.leftButtonText,
      required this.rightButtonText,
      required this.onAgreeTap})
      : super(key: key);

  final String description, leftButtonText, rightButtonText;
  final Function onAgreeTap;

  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<ConfirmDialogView> {
  @override
  Widget build(BuildContext context) {
    return NewDialog(widget: widget);
  }
}

class NewDialog extends StatelessWidget {
  const NewDialog({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final ConfirmDialogView widget;

  @override
  Widget build(BuildContext context) {
    const Widget _spacingWidget = SizedBox(
      width: 204.0,
    );
    const Widget _largeSpacingWidget = SizedBox(
      height: 20.0,
    );
    final Widget _headerWidget = Row(
      children: <Widget>[
        _spacingWidget,
        Icon(
          Icons.help_outline,
          color: Colors.white,
        ),
        _spacingWidget,
        Text(
          "CONFIRM",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );

    final Widget _messageWidget = Text(widget.description, style: Theme.of(context).textTheme.subtitle2,);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              height: 60,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)), color: Theme.of(context).primaryColor),
              /*child: _headerWidget*/
          child: Row(
            children: <Widget>[
              Icon(
                Icons.help_outline,
                color: Colors.white,
              ),
              Padding(padding: EdgeInsets.only(left: 5.0),
              child: Text(
                "CONFIRM",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              ),)
            ],
          ),
          ),
          _largeSpacingWidget,
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: _messageWidget,
          ),
          _largeSpacingWidget,
          Divider(
            color: Theme.of(context).iconTheme.color,
            height: 0.4,
          ),
          Row(children: <Widget>[
            Expanded(
                child: MaterialButton(height: 50, minWidth: double.infinity,
                  onPressed: () {
                  Navigator.of(context).pop();
                  },
                  child: Text(widget.leftButtonText,
                      style: Theme.of(context).textTheme.button),
            )),
            Container(
                height: 50,
                width: 0.4,
                color: Theme.of(context).iconTheme.color),
            Expanded(
                child: MaterialButton(height: 50, minWidth: double.infinity,
                  onPressed: () {
                  widget.onAgreeTap();
                  },
                  child: Text(widget.rightButtonText, style: Theme.of(context).textTheme.button!.copyWith(color: Colors.black),),
            )),
          ])
        ],
      ),
    );
  }
}

class ConfirmDialogView_Active extends StatefulWidget {
  const ConfirmDialogView_Active(
      {Key? key,
        required this.description,
        required this.rightButtonText,
        required this.onAgreeTap})
      : super(key: key);

  final String description, rightButtonText;
  final Function onAgreeTap;

  @override
  _LogoutDialogState_Active createState() => _LogoutDialogState_Active();
}

class _LogoutDialogState_Active extends State<ConfirmDialogView_Active> {
  @override
  Widget build(BuildContext context) {
    return NewDialog_Active(widget: widget);
  }
}

class NewDialog_Active extends StatelessWidget {
  const NewDialog_Active({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final ConfirmDialogView_Active widget;

  @override
  Widget build(BuildContext context) {
    const Widget _spacingWidget = SizedBox(
      width: 204.0,
    );
    const Widget _largeSpacingWidget = SizedBox(
      height: 20.0,
    );
    final Widget _headerWidget = Row(
      children: <Widget>[
        _spacingWidget,
        Icon(
          Icons.help_outline,
          color: Colors.white,
        ),
        _spacingWidget,
        Text(
          "CONFIRM",
          textAlign: TextAlign.center,
          style: montserratSemiBold.copyWith(color: Colors.white,),
        ),
      ],
    );

    final Widget _messageWidget = Text(widget.description,textAlign: TextAlign.center, style: montserratSemiBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15,fontWeight: FontWeight.w500),);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 60,
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)), color: Theme.of(context).primaryColor),
            /*child: _headerWidget*/
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.help_outline,
                  color: Colors.white,
                ),
                Padding(padding: EdgeInsets.only(left: 5.0),
                  child: Text(
                    "CONFIRM",
                    textAlign: TextAlign.center,
                    style: montserratBold.copyWith(color: Colors.white,fontWeight: FontWeight.bold),
                  ),)
              ],
            ),
          ),
          _largeSpacingWidget,
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: _messageWidget,
          ),
          _largeSpacingWidget,
          Divider(
            color: Theme.of(context).iconTheme.color,
            height: 0.4,
          ),
          Row(children: <Widget>[
            Expanded(
                child: MaterialButton(height: 50, minWidth: double.infinity,
                  onPressed: () {
                    widget.onAgreeTap();
                  },
                  child: Text(widget.rightButtonText, style: montserratSemiBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15,fontWeight: FontWeight.w600),),
                )),
          ])
        ],
      ),
    );
  }
}
