import 'package:flutter/services.dart';
import 'package:gas_accounting/data/model/response/editmaininvoice_response.dart';
import 'package:gas_accounting/provider/invoice_provider.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/color_resources.dart';
import 'package:gas_accounting/utill/dimensions.dart';
import 'package:gas_accounting/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:gas_accounting/view/basewidget/custom_button.dart';
import 'package:gas_accounting/view/screen/manage_invoice/invoice_list.dart';
import 'package:gas_accounting/view/screen/manage_invoice/pdfexport/pdf/pdfexport.dart';
import 'package:gas_accounting/view/screen/manage_invoice/pdfexport/pdfpreview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ViewInvoice extends StatefulWidget {
  String id,customerName,address,gstNo;
  ViewInvoice(this.id,this.customerName,this.address,this.gstNo,{Key? key}) : super(key: key);

  @override
  State<ViewInvoice> createState() => _ViewInvoiceState();
}

class _ViewInvoiceState extends State<ViewInvoice> {
  bool is_loading = true;

  double grandTotal = 0.0;
  double subTotal = 0.0;
  double discount = 0.0;
  double totalGstAmount = 0.0;
  double cgst = 0.0;
  double calculatedGst = 0.0;
  double total = 0.0;

  void _onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    // Share.shareFiles(['/storage/emulated/0/Android/data/com.gas_accounting.com/files/Invoice.pdf'],text: "Share Invoice PDF",sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    // await Share.share("Text",
    //     sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  EditMainInvoiceData editMainInvoiceData = EditMainInvoiceData();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData(context, true);
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    Provider.of<InvoiceProvider>(context, listen: false).getMainInvoiceEdit(context,widget.id).then((value) {
      setState(() {
        is_loading = false;
        for(int i=0;i<Provider.of<InvoiceProvider>(context, listen: false).editMainInvoiceList.length;i++){
          editMainInvoiceData = Provider.of<InvoiceProvider>(context, listen: false).editMainInvoiceList[i];
          discount += double.parse(Provider.of<InvoiceProvider>(context, listen: false).editMainInvoiceList[i].decDiscount!.round().toString());
          totalGstAmount = Provider.of<InvoiceProvider>(context, listen: false).editMainInvoiceList[i].decGrandTotal!;
          calculatedGst = totalGstAmount * 9.0 / 100.0;
          total = totalGstAmount + calculatedGst;
          cgst = calculatedGst;
        }
      });
    });
    Provider.of<InvoiceProvider>(context, listen: false).getMainInvoiceStockList(context,widget.id).then((value) {
      setState(() {
        is_loading = false;
        for(int i=0;i<Provider.of<InvoiceProvider>(context, listen: false).mainInvoiceStockList.length;i++){
          subTotal += Provider.of<InvoiceProvider>(context, listen: false).mainInvoiceStockList[i].decAmount!.round();
          grandTotal = subTotal - discount;
        }
        print("stock::1:$subTotal:::$grandTotal");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  InvoiceList("",widget.id,"","Invoice"),));
        return true;
      },
      child: Consumer<InvoiceProvider>(builder: (context, invoice, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorResources.LINE_BG,
            centerTitle: true,
            leading: IconButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => InvoiceList("","",widget.id,"Invoice"),));
            }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: ColorResources.WHITE,size: 25,)),
            title: Text("Invoice Detail",style: montserratSemiBold.copyWith(color: ColorResources.WHITE,fontSize: Dimensions.FONT_SIZE_20),),
          ),
          body:
          is_loading
              ?
          const Center(child: CircularProgressIndicator(color: ColorResources.LINE_BG))
              :
          ListView(
            children: [
              Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: AppConstants.itemHeight*0.02,horizontal: AppConstants.itemWidth*0.02),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                    margin: EdgeInsets.all(AppConstants.itemHeight*0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Item Id",style: montserratSemiBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
                        Text(editMainInvoiceData.strInvoiceNo ?? "",style: montserratSemiBold.copyWith(color: ColorResources.BLACK,fontSize: Dimensions.FONT_SIZE_15),),
                      ],
                    )),
              ),
              SizedBox(height: AppConstants.itemHeight * 0.01),
              Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.02),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.itemWidth * 0.03),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Text('Item Detail',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  textAlign: TextAlign.start,
                                  style: montserratSemiBold.copyWith(
                                      color: ColorResources.BLACK,
                                      fontSize: Dimensions.FONT_SIZE_15,
                                      fontWeight: FontWeight.w600))),
                        ],
                      ),
                      SizedBox(height: AppConstants.itemHeight * 0.01),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: invoice.mainInvoiceStockList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: AppConstants.itemHeight*0.003),
                            padding: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.03,vertical: AppConstants.itemHeight*0.005),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Item',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        textAlign: TextAlign.start,
                                        style: montserratSemiBold.copyWith(
                                            color: ColorResources.BLACK,
                                            fontSize: Dimensions.FONT_SIZE_14,
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        '${invoice.mainInvoiceStockList[index].strItemName}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        textAlign: TextAlign.start,
                                        style: montserratSemiBold.copyWith(
                                            color: ColorResources.BLACK,
                                            fontSize: Dimensions.FONT_SIZE_14,
                                            fontWeight: FontWeight.w600))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Rate',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        textAlign: TextAlign.start,
                                        style: montserratSemiBold.copyWith(
                                            color: ColorResources.BLACK,
                                            fontSize: Dimensions.FONT_SIZE_14,
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        '\u20b9 ${invoice.mainInvoiceStockList[index].decRate}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        textAlign: TextAlign.start,
                                        style: montserratSemiBold.copyWith(
                                            color: ColorResources.BLACK,
                                            fontSize: Dimensions.FONT_SIZE_14,
                                            fontWeight: FontWeight.w600))
                                  ],
                              ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Qty',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        textAlign: TextAlign.start,
                                        style: montserratSemiBold.copyWith(
                                            color: ColorResources.BLACK,
                                            fontSize: Dimensions.FONT_SIZE_14,
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        '${invoice.mainInvoiceStockList[index].decQty}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        textAlign: TextAlign.start,
                                        style: montserratSemiBold.copyWith(
                                            color: ColorResources.BLACK,
                                            fontSize: Dimensions.FONT_SIZE_14,
                                            fontWeight: FontWeight.w600))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Amount',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        textAlign: TextAlign.start,
                                        style: montserratSemiBold.copyWith(
                                            color: ColorResources.BLACK,
                                            fontSize: Dimensions.FONT_SIZE_14,
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        '${invoice.mainInvoiceStockList[index].decAmount}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        textAlign: TextAlign.start,
                                        style: montserratSemiBold.copyWith(
                                            color: ColorResources.BLACK,
                                            fontSize: Dimensions.FONT_SIZE_14,
                                            fontWeight: FontWeight.w600))
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: AppConstants.itemHeight * 0.01),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppConstants.itemHeight * 0.01),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.itemWidth * 0.05),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Text('Payment Detail',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  textAlign: TextAlign.start,
                                  style: montserratSemiBold.copyWith(
                                      color: ColorResources.BLACK,
                                      fontSize: Dimensions.FONT_SIZE_15,
                                      fontWeight: FontWeight.w600))),
                        ],
                      ),
                      SizedBox(height: AppConstants.itemHeight * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Sub Total',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              textAlign: TextAlign.start,
                              style: montserratSemiBold.copyWith(
                                  color: ColorResources.BLACK,
                                  fontSize: Dimensions.FONT_SIZE_14,
                                  fontWeight: FontWeight.w400)),
                          Text(
                              '\u20b9 $subTotal',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              textAlign: TextAlign.start,
                              style: montserratSemiBold.copyWith(
                                  color: ColorResources.BLACK,
                                  fontSize: Dimensions.FONT_SIZE_14,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                      SizedBox(height: AppConstants.itemHeight * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Discount',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              textAlign: TextAlign.start,
                              style: montserratSemiBold.copyWith(
                                  color: ColorResources.BLACK,
                                  fontSize: Dimensions.FONT_SIZE_14,
                                  fontWeight: FontWeight.w400)),
                          Text(
                              '\u20b9 $discount',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              textAlign: TextAlign.start,
                              style: montserratSemiBold.copyWith(
                                  color: ColorResources.BLACK,
                                  fontSize: Dimensions.FONT_SIZE_14,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                      SizedBox(height: AppConstants.itemHeight * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Grand Total",
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: montserratSemiBold.copyWith(
                              color: ColorResources.BLACK,
                              fontSize: Dimensions.FONT_SIZE_14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                              '\u20b9 $grandTotal',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              textAlign: TextAlign.start,
                              style: montserratSemiBold.copyWith(
                                  color: ColorResources.BLACK,
                                  fontSize: Dimensions.FONT_SIZE_14,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                      SizedBox(height: AppConstants.itemHeight * 0.01),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppConstants.itemHeight * 0.01),
              CustomButtonFuction(onTap: (){
                // Navigator.push(context, MaterialPageRoute(builder: (context) => PdfPreviewPageMain("Invoice",widget.id,widget.customerName,widget.address,widget.gstNo),));
              }, buttonText: "Download"),
              CustomButtonFuction(onTap: (){
                // makePdfMain(widget.customerName,widget.address,widget.gstNo,editMainInvoiceData,invoice.mainInvoiceStockList,totalGstAmount,total,cgst).then((value) async {
                //   // shareWhatsapp.share(
                //   //   file: XFile('/storage/emulated/0/Android/data/com.gas_accounting.com/files/${widget.customerName}.pdf'),
                //   //   text: "Thank you for doing business with us !!!\nMake invoice like this with WELMART INDIA\n\nRegister with WELMART INDIA now- http://support.welinfoweb.com/company",
                //   // );
                //   final box = context.findRenderObject() as RenderBox?;
                //   String link = "http://support.welinfoweb.com/company";
                //   final directory = await getExternalStorageDirectory();
                //   Share.shareFiles(
                //       ['${directory!.path}/${widget.customerName}.pdf'],
                //       text: "Thank you for doing business with us !!!\nMake invoice like this with WELMART INDIA\n\nRegister with WELMART INDIA now- $link",
                //       subject: "${widget.customerName} Invoice PDF",
                //       sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
                //   // Share.shareXFiles([XFile('/storage/emulated/0/Android/data/com.gas_accounting.com/files/${widget.customerName}.pdf')],text: "Thank You",subject: "Thank");
                // });
              }, buttonText: "Share")
            ],
          ),
        );
      },),
    );
  }
}
