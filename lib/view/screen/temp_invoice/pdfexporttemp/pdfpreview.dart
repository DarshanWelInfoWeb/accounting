// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gas_accounting/data/model/response/edittempinvoice_response.dart';
import 'package:gas_accounting/data/model/response/tempstock_response.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/customer_provider.dart';
import 'package:gas_accounting/provider/supplier_provider.dart';
import 'package:gas_accounting/provider/tempinvoice_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/screen/temp_invoice/tempinvoice_list.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'pdf/pdfexport.dart';

class PdfPreviewPageTemp extends StatelessWidget {
  String type,id,customerName,invoiceNumber,address,gstNo;
  double subTotal,total;
  EditTempInvoiceData editTempInvoiceData = EditTempInvoiceData();
  TempStockData? tempStockData;
  PdfPreviewPageTemp(this.type,this.id,this.customerName,this.invoiceNumber,this.address,this.gstNo,this.subTotal,this.total,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalGstAmount = 0.0;
    double cgst = 0.0;
    double cgstValue = 0.0;
    double sgst = 0.0;
    double sgstValue = 0.0;
    double gstValue = 0.0;
    // double calculatedGst,total = 0.0;
    int customerId = 0;
    double dueAmount = 0.0;
    double dueTotalAmount = 0.0;
    double dueInAmount = 0.0;
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
    Provider.of<TempInvoiceProvider>(context, listen: false).getTempInvoiceEdit(context,id).then((value) {
      isLoading = false;
      Provider.of<CustomerProvider>(context, listen: false).getCustomerDueReport(context,PreferenceUtils.getString(AppConstants.companyId.toString())).then((value) {
        for(int i=0;i<Provider.of<CustomerProvider>(context, listen: false).customerDueReportList.length;i++){
          if(customerId == Provider.of<CustomerProvider>(context, listen: false).customerDueReportList[i].intCustomerid){
            dueAmount = Provider.of<CustomerProvider>(context, listen: false).customerDueReportList[i].decDueAmount!;
            dueTotalAmount = dueAmount + total;
          }
          print("due:: $dueAmount ::$dueTotalAmount");
        }
      });
      for(int i=0;i<Provider.of<TempInvoiceProvider>(context, listen: false).editTempInvoiceList.length;i++){
        editTempInvoiceData = Provider.of<TempInvoiceProvider>(context, listen: false).editTempInvoiceList[i];
        customerId = Provider.of<TempInvoiceProvider>(context, listen: false).editTempInvoiceList[i].intCustomerid!;
        totalGstAmount = Provider.of<TempInvoiceProvider>(context, listen: false).editTempInvoiceList[i].decGrandTotal!;
        // cgst = totalGstAmount * cgstValue / 100.0;
        // sgst = totalGstAmount * sgstValue / 100.0;
        gstValue = cgstValue + sgstValue;
        // calculatedGst = double.parse(cgst.round().toString()) + double.parse(sgst.round().toString());
        // total = totalGstAmount + calculatedGst;
        // dueInAmount = dueTotalAmount + total;
        // cgst = calculatedGst;
        print("GST::$total::$cgst::$sgst::$gstValue::$dueInAmount");
      }
      print("total:::$totalGstAmount");
    });
    Provider.of<TempInvoiceProvider>(context, listen: false).getTempStockList(context,id,"18",PreferenceUtils.getString(AppConstants.companyId.toString())).then((value) {
      for(int i=0;i<Provider.of<TempInvoiceProvider>(context, listen: false).tempStockList.length;i++){
        // print("remove gst rate:::${Provider.of<TempInvoiceProvider>(context, listen: false).tempStockList[i].decRate!.round() * 18.0.round() / 100.0.round()}");
      }
    });
    return WillPopScope(
      onWillPop: () async{
        Navigator.push(context,MaterialPageRoute(builder: (context) => TempInvoiceList("","","Side"),));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorResources.LINE_BG,
          centerTitle: true,
          leading: IconButton(onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => TempInvoiceList("","","Side"),));
          }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
          title: Text("PDF Preview",style: montserratSemiBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
        ),
        body: Consumer<TempInvoiceProvider>(builder: (context, temp, child) {
          return
            isLoading
              ?
           const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
              :
            PdfPreview(
              build: (context) => makePdf(customerName,invoiceNumber,address,gstNo,editTempInvoiceData,temp.tempStockList,totalGstAmount,total,dueAmount,cgst,sgst,cgstValue,sgstValue,gstValue),
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
                  makePdf(customerName,invoiceNumber,address,gstNo,editTempInvoiceData,temp.tempStockList,totalGstAmount,total,dueAmount,cgst,sgst,cgstValue,sgstValue,gstValue).then((value) async {
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

