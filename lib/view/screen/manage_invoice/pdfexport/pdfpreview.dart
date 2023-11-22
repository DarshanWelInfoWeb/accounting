import 'package:flutter/material.dart';
import 'package:gas_accounting/data/model/response/editmaininvoice_response.dart';
import 'package:gas_accounting/data/model/response/maininvopciestock_response.dart';
import 'package:gas_accounting/helper/preferenceutils.dart';
import 'package:gas_accounting/provider/invoice_provider.dart';
import 'package:gas_accounting/provider/route_provider.dart';
import 'package:gas_accounting/provider/supplier_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:gas_accounting/view/screen/manage_invoice/invoice_list.dart';
import 'package:gas_accounting/view/screen/manage_invoice/view_invoice.dart';
import 'package:gas_accounting/view/screen/temp_invoice/tempinvoice_list.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'pdf/pdfexport.dart';

class PdfPreviewPageMain extends StatelessWidget {
  String type,id,customerName,companyName,address,gstNo;
  EditMainInvoiceData editMainInvoiceData = EditMainInvoiceData();
  MainInvoiceStockData? mainInvoiceStockData;
  PdfPreviewPageMain(this.type,this.id,this.customerName,this.companyName,this.address,this.gstNo,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalGstAmount = 0.0;
    double discountAmount = 0.0;
    double cgst = 0.0;
    double sgstValue = 0.0;
    double cgstValue = 0.0;
    double gstValue = 0.0;
    double rate = 0.0;
    double amount = 0.0;
    double taxableAmount = 0.0;
    double calculatedGst,total = 0.0;
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
    Provider.of<InvoiceProvider>(context, listen: false).getMainInvoiceStockList(context,id).then((value) {
      isLoading = false;
      for(int i=0;i<Provider.of<InvoiceProvider>(context, listen: false).mainInvoiceStockList.length;i++){
        rate = Provider.of<InvoiceProvider>(context, listen: false).mainInvoiceStockList[i].decRate!;
        amount = Provider.of<InvoiceProvider>(context, listen: false).mainInvoiceStockList[i].decAmount!;
        taxableAmount = rate * 9.0 / 100.0;
        // gstValue = cgstValue + sgstValue;
        rate = rate - taxableAmount;
        amount = amount - taxableAmount;
        print("object:: $rate ::$taxableAmount :: $amount");
      }
    });
    Provider.of<InvoiceProvider>(context, listen: false).getMainInvoiceEdit(context,id).then((value) {
      for(int i=0;i<Provider.of<InvoiceProvider>(context, listen: false).editMainInvoiceList.length;i++){
        editMainInvoiceData = Provider.of<InvoiceProvider>(context, listen: false).editMainInvoiceList[i];
        totalGstAmount = Provider.of<InvoiceProvider>(context, listen: false).editMainInvoiceList[i].decGrandTotal!;
        discountAmount = Provider.of<InvoiceProvider>(context, listen: false).editMainInvoiceList[i].decDiscount!;
        calculatedGst = totalGstAmount * 9.0 / 100.0;
        total = totalGstAmount - calculatedGst;
        cgst = calculatedGst;
        gstValue = cgstValue + sgstValue;
        print("object:$total::$cgst:::$calculatedGst");
      }
      print("total:::$totalGstAmount");
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.LINE_BG,
        centerTitle: true,
        leading: IconButton(onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder: (context) => InvoiceList("","","","Invoice"),));
        }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
        title: Text("PDF Preview",style: montserratSemiBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
      ),
      body: Consumer<InvoiceProvider>(builder: (context, invoice, child) {
        return
          isLoading
              ?
          const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
              :
          PdfPreview(
            build: (context) => makePdfMain(customerName,companyName,address,gstNo,editMainInvoiceData,invoice.mainInvoiceStockList,totalGstAmount,total,cgst,cgstValue,sgstValue,gstValue,discountAmount),
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
                makePdfMain(customerName,companyName,address,gstNo,editMainInvoiceData,invoice.mainInvoiceStockList,totalGstAmount,total,cgst,cgstValue,sgstValue,gstValue,discountAmount).then((value) async {
                  print("object:::2:::");
                  final box = context.findRenderObject() as RenderBox?;
                  String link = "http://support.welinfoweb.com/company";
                  final directory = await getExternalStorageDirectory();
                  try {
                    await Share.shareFiles(
                      ['${directory?.path}/$customerName.pdf'],
                      text: "Thank you for doing business with us !!!\nMake invoices like this with WELMART INDIA\n\nRegister with WELMART INDIA now- $link",
                      subject: "$customerName Invoice PDF",
                      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                    );
                  } catch (e) {
                    print('Error sharing to WhatsApp: $e');
                  }
                  // Share.shareFiles(
                  //     ['${directory?.path}/$customerName.pdf'],
                  //     text: "Thank you for doing business with us !!!\nMake invoice like this with WELMART INDIA\n\nRegister with WELMART INDIA now- $link",
                  //     subject: "$customerName Invoice PDF",
                  //     sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
                });
              }, icon: const Icon(Icons.share))
            ],
            loadingWidget: const CircularProgressIndicator(color: ColorResources.LINE_BG),
        );
      },),
    );
  }
}

