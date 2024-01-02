// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gas_accounting/data/model/response/edittempinvoice_response.dart';
import 'package:gas_accounting/data/model/response/supplier_response.dart';
import 'package:gas_accounting/data/model/response/tempstock_response.dart';
import 'package:gas_accounting/provider/supplier_provider.dart';
import 'package:gas_accounting/provider/tempinvoice_provider.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/screen/supplier/supplier_invoice/supplier_invoice_list.dart';
import 'package:gas_accounting/view/screen/temp_invoice/tempinvoice_list.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'pdf/pdfexportsuplierinvoice.dart';

class PdfPreviewPageSupplierInvoice extends StatelessWidget {
  String type,id,customerName,address,gstNo;
  SupplierInvoiceData1 supplierInvoiceData = SupplierInvoiceData1();
  SupplierInvoiceItemData1? tempStockData;
  PdfPreviewPageSupplierInvoice(this.type,this.id,this.customerName,this.address,this.gstNo,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0.0;
    double cgst = 0.0;
    double sgst = 0.0;
    double sgstValue = 0.0;
    double cgstValue = 0.0;
    double gstValue = 0.0;
    double total = 0.0;
    bool isLoading = true;
    Provider.of<SupplierProvider>(context, listen: false).getSupplierTax(context, "25").then((value){
      isLoading = false;
      for(int i=0;i<Provider.of<SupplierProvider>(context, listen: false).supplierSGST.length;i++){
        sgstValue = double.parse(Provider.of<SupplierProvider>(context, listen: false).supplierSGST[i].strValue.toString());
      }
    });
    Provider.of<SupplierProvider>(context, listen: false).getSupplierTax(context, "26").then((value){
      isLoading = false;
      for(int i=0;i<Provider.of<SupplierProvider>(context, listen: false).supplierCGST.length;i++){
        cgstValue = double.parse(Provider.of<SupplierProvider>(context, listen: false).supplierCGST[i].strValue.toString());
      }
    });
    Provider.of<SupplierProvider>(context, listen: false).getUpdateSupplierInvoice(context,id).then((value) {
      isLoading = false;
      for(int i=0;i<Provider.of<SupplierProvider>(context, listen: false).updateSupplierInvoice.length;i++){
        supplierInvoiceData = Provider.of<SupplierProvider>(context, listen: false).updateSupplierInvoice[i];
        totalAmount = Provider.of<SupplierProvider>(context, listen: false).updateSupplierInvoice[i].decTotal!;
        cgst = totalAmount * cgstValue / 100.0;
        sgst = totalAmount * sgstValue / 100.0;
        total = totalAmount + cgst + sgst;
        gstValue = cgstValue + sgstValue;
        print("GST::$totalAmount::$cgst:::$sgst::$total");
      }
      print("total:::$totalAmount");
    });
    Provider.of<SupplierProvider>(context, listen: false).getSupplierInvoiceItemList(context,id);

    return WillPopScope(
      onWillPop: () async{
        Navigator.push(context,MaterialPageRoute(builder: (context) => SupplierInvoiceList("","","","SupplierInvoice"),));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorResources.LINE_BG,
          centerTitle: true,
          leading: IconButton(onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => SupplierInvoiceList("","","","SupplierInvoice"),));
          }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
          title: Text("PDF Preview",style: montserratSemiBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
        ),
        body: Consumer<SupplierProvider>(builder: (context, temp, child) {
          return
            isLoading
              ?
           const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
              :
            PdfPreview(
              build: (context) => makeSupplierInvoicePdf(customerName,address,gstNo,supplierInvoiceData,temp.supplierInvoiceItemList,totalAmount,total,cgst,sgst,cgstValue,sgstValue,gstValue),
              pdfFileName: 'Invoice',
              initialPageFormat: PdfPageFormat.standard,
              canChangePageFormat: false,
              canChangeOrientation: false,
              canDebug: false,
              allowPrinting: true,
              allowSharing: false,
              actions: [
                IconButton(onPressed: () {
                  print("object::1::");
                  makeSupplierInvoicePdf(customerName,address,gstNo,supplierInvoiceData,temp.supplierInvoiceItemList,totalAmount,total,cgst,sgst,cgstValue,sgstValue,gstValue).then((value) async {
                    print("object:::2:::");
                    final box = context.findRenderObject() as RenderBox?;
                    String link = "http://support.welinfoweb.com/company";
                    final directory = await getExternalStorageDirectory();
                    Share.shareFiles(
                        ['${directory?.path}/$customerName.pdf'],
                        text: "Thank you for doing business with us !!!\nMake invoice like this with WELMART INDIA\n\nRegister with WELMART INDIA now- $link",
                        subject: "$customerName Invoice PDF",
                        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
                  });
                }, icon: const Icon(Icons.share))
              ],
              loadingWidget: const CircularProgressIndicator(color: ColorResources.LINE_BG),
          );
        },),
      ),
    );
  }
}

