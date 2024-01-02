// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'package:gas_accounting/data/model/response/edittempinvoice_response.dart';
import 'package:gas_accounting/data/model/response/tempstock_response.dart';
import 'package:gas_accounting/utill/app_constants.dart';
import 'package:gas_accounting/utill/images.dart';
import 'package:number_to_words_english/number_to_words_english.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as p;
import 'package:flutter/services.dart' show rootBundle;

Future<Uint8List> makePdf(String customerName,String invoiceNumber,String address,String gstNo,EditTempInvoiceData tempInvoiceData, List<TempStockData> tempStockList, double totalAmount, double total, double dueTotalAmount,double cgst, double sgst,double cgstValue,double sgstValue,double gstValue) async {
  final pdf = Document();
  final imageLogo = MemoryImage((await rootBundle.load(Images.logo)).buffer.asUint8List());
  double dueInAmount = 0.0;
  double subAmount = 0.0;
  // dueInAmount = totalAmount - totalAmount * gstValue / 100;
  for(int i=0;i<tempStockList.length;i++){
    subAmount += tempStockList[i].decRate! * tempStockList[i].decQty!;
    cgstValue = double.parse(tempStockList[i].ActualGST!) / 2;
    sgstValue = double.parse(tempStockList[i].ActualGST!) / 2;
    cgst = double.parse(tempStockList[i].gST!) * tempStockList[i].decQty! / 2;
    sgst = double.parse(tempStockList[i].gST!) * tempStockList[i].decQty! / 2;
    // cgst = subAmount * cgstValue / 100;
    // sgst = subAmount * sgstValue / 100;
    // subAmount = 920 * gstValue / 100 ;
    // subAmount += tempStockList[i].decRate!.round() * tempStockList[i].decQty!.round() - tempStockList[i].decRate!.round() * gstValue.round() / 100.0.round() * (tempStockList[i].decQty!.round());
    print("gst rate:::$gstValue  ::$dueInAmount  ::$totalAmount ::$subAmount ::$cgst ::$sgst");
  }
  pdf.addPage(
    MultiPage(
      build: (context) {
        return [
            Container(
              alignment: Alignment.center,
              child: Text("WELMART INDIA",style: TextStyle(fontSize: AppConstants.itemHeight*0.05,fontWeight: FontWeight.bold)),
            ),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: AppConstants.itemHeight*0.005),
                child: Text("No 32, Survey No 57/1, 11th Cross, Garvebhavipalya Bangalore - 560 068",style: TextStyle(fontSize: AppConstants.itemHeight*0.016)),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: AppConstants.itemHeight*0.005),
              child: Text("Ph : 8320793121 Email : info@welmartindia.in",style: TextStyle(fontSize: AppConstants.itemHeight*0.016))
            ),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: AppConstants.itemHeight*0.005),
                child: Text("GSTIN-29BSUPV0745A1ZC",style: TextStyle(fontSize: AppConstants.itemHeight*0.018,fontBold: Font.symbol()))
            ),
            SizedBox(height: AppConstants.itemHeight*0.005),
            Table(
              border: TableBorder.all(color: PdfColors.black),
              children: [
                TableRow(
                  children: [
                    paddedText('INVOICE NO : $invoiceNumber'),
                    paddedText('Date : ${tempInvoiceData.dtInvoiceDate}')
                  ],
                ),
                TableRow(
                  children: [
                    paddedText('RECEIVER CHARGE :'),
                    paddedText('Original for Recipient')
                  ],
                ),
                TableRow(
                  children: [
                    paddedText('STATE : KARNATAKA'),
                    paddedText('Duplicate for Supplier / Transporter'),
                  ],
                )
              ],
            ),
            SizedBox(height: AppConstants.itemHeight*0.005),
            Table(
              border: TableBorder.all(color: PdfColors.black),
              children: [
                TableRow(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: AppConstants.itemWidth*0.10,
                      padding: const EdgeInsets.all(05),
                      child: Text('DETAILS OF RECEIVER : BILLED TO :'),
                    ),
                    // PaddedText('DETAILS OF RECEIVER : BILLED TO :'),
                    paddedText('Transportation Mode : By Rode'),
                  ],
                ),
                TableRow(
                  children: [
                    paddedText('NAME : $customerName'),
                    paddedText('Vehicle Number : '),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: AppConstants.itemWidth*0.10,
                      padding: const EdgeInsets.all(05),
                      child: Text('ADDRESS : ${address=="null"?"":address}',),
                    ),
                    paddedText('Date of Supply : ')
                  ],
                ),
                TableRow(
                  children: [
                    paddedText('GSTIN. : ${gstNo=="null"?"":gstNo}'),
                    paddedText('Place of Supply : ')
                  ],
                ),
              ],
            ),
            SizedBox(height: AppConstants.itemHeight*0.005),
            p.Table(
                border: TableBorder.all(color: PdfColors.black),
                children: [
                  p.TableRow(
                    children: [
                      p.Container(
                        alignment: p.Alignment.center,
                        width: AppConstants.itemWidth*0.10,
                        padding: const p.EdgeInsets.all(05),
                        child: p.Text('No.',style: const p.TextStyle(fontSize: 10))
                      ),
                      p.Container(
                          alignment: p.Alignment.center,
                          padding: const EdgeInsets.all(05),
                          child: p.Text('ITEM DESCRIPTION',style: const p.TextStyle(fontSize: 10))
                      ),
                      p.Container(
                          alignment: p.Alignment.center,
                          padding: const p.EdgeInsets.all(05),
                          child: p.Text('HSN',style: const p.TextStyle(fontSize: 10))
                      ),
                      p.Container(
                          alignment: p.Alignment.center,
                          padding: const p.EdgeInsets.all(05),
                          child: p.Text('QTY (NOS)',style: const p.TextStyle(fontSize: 10))
                      ),
                      p.Container(
                          alignment: p.Alignment.center,
                          padding: const p.EdgeInsets.all(05),
                          child: p.Text('RATE PER UNIT',style: const p.TextStyle(fontSize: 10))
                      ),
                      p.Container(
                          alignment: p.Alignment.center,
                          padding: const p.EdgeInsets.all(05),
                          child: p.Text('TAXABLE VALUE',style: const p.TextStyle(fontSize: 10))
                      ),
                    ],
                  ),
                  for (int i = 0; i < tempStockList.length; i++)
                    p.TableRow(
                        children: [
                          p.Container(
                              alignment: p.Alignment.center,
                              padding: const p.EdgeInsets.all(05),
                              child: p.Text("${i + 1}",style: const p.TextStyle(fontSize: 10))
                          ),
                          p.Container(
                              alignment: p.Alignment.center,
                              padding: const p.EdgeInsets.all(05),
                              child: p.Text(tempStockList[i].strItemName.toString(),style: const p.TextStyle(fontSize: 10))
                          ),
                          p.Container(
                              alignment: p.Alignment.center,
                              padding: const p.EdgeInsets.all(05),
                              child: p.Text("27111900",style: const p.TextStyle(fontSize: 10))
                          ),
                          p.Container(
                              alignment: p.Alignment.center,
                              padding: const p.EdgeInsets.all(05),
                              child: p.Text("${tempStockList[i].decQty?.round().toString()}",style: const p.TextStyle(fontSize: 10))
                          ),
                          p.Container(
                              alignment: p.Alignment.center,
                              padding: const p.EdgeInsets.all(05),
                              child: p.Text(tempStockList[i].decRate!.toStringAsFixed(2),style: const p.TextStyle(fontSize: 10))
                          ),
                          p.Container(
                              alignment: p.Alignment.center,
                              padding: const p.EdgeInsets.all(05),
                              child: p.Text("${num.parse(tempStockList[i].decRate!.toStringAsFixed(2)) * tempStockList[i].decQty!.round()}",style: const p.TextStyle(fontSize: 10))
                          ),
                        ]
                    ),
                  p.TableRow(
                    children: [
                      p.Container(
                          alignment: p.Alignment.center,
                          width: AppConstants.itemWidth*0.10,
                          padding: const p.EdgeInsets.all(05),
                          child: p.Text('No.',style: const p.TextStyle(fontSize: 10,color: PdfColors.white))
                      ),
                      p.Container(
                          alignment: p.Alignment.center,
                          padding: const EdgeInsets.all(05),
                          child: p.Text('',style: const p.TextStyle(fontSize: 10))
                      ),
                      p.Container(
                          alignment: p.Alignment.center,
                          padding: const p.EdgeInsets.all(05),
                          child: p.Text('',style: const p.TextStyle(fontSize: 10))
                      ),
                      p.Container(
                          alignment: p.Alignment.center,
                          padding: const p.EdgeInsets.all(05),
                          child: p.Text('',style: const p.TextStyle(fontSize: 10))
                      ),
                      p.Container(
                          alignment: p.Alignment.center,
                          padding: const p.EdgeInsets.all(05),
                          child: p.Text('',style: const p.TextStyle(fontSize: 10))
                      ),
                      p.Container(
                          alignment: p.Alignment.center,
                          padding: const p.EdgeInsets.all(05),
                          child: p.Text('',style: const p.TextStyle(fontSize: 10))
                      ),
                    ],
                  ),
                  p.TableRow(
                    children: [
                      p.Container(
                          alignment: p.Alignment.center,
                          width: AppConstants.itemWidth*0.10,
                          padding: const p.EdgeInsets.all(05),
                          child: p.Text('No.',style: const p.TextStyle(fontSize: 10,color: PdfColors.white))
                      ),
                      p.Container(
                          alignment: p.Alignment.center,
                          padding: const EdgeInsets.all(05),
                          child: p.Text('',style: const p.TextStyle(fontSize: 10))
                      ),
                      p.Container(
                          alignment: p.Alignment.center,
                          padding: const p.EdgeInsets.all(05),
                          child: p.Text('',style: const p.TextStyle(fontSize: 10))
                      ),
                      p.Container(
                          alignment: p.Alignment.center,
                          padding: const p.EdgeInsets.all(05),
                          child: p.Text('',style: const p.TextStyle(fontSize: 10))
                      ),
                      p.Container(
                          alignment: p.Alignment.center,
                          padding: const p.EdgeInsets.all(05),
                          child: p.Text('',style: const p.TextStyle(fontSize: 10))
                      ),
                      p.Container(
                          alignment: p.Alignment.center,
                          padding: const p.EdgeInsets.all(05),
                          child: p.Text('',style: const p.TextStyle(fontSize: 10))
                      ),
                    ],
                  ),
                  p.TableRow(
                    children: [
                      p.Container(
                          alignment: p.Alignment.center,
                          width: AppConstants.itemWidth*0.10,
                          padding: const p.EdgeInsets.all(05),
                          child: p.Text('No.',style: const p.TextStyle(fontSize: 10,color: PdfColors.white))
                      ),
                      p.Container(
                          alignment: p.Alignment.center,
                          padding: const EdgeInsets.all(05),
                          child: p.Text('',style: const p.TextStyle(fontSize: 10))
                      ),
                      p.Container(
                          alignment: p.Alignment.center,
                          padding: const p.EdgeInsets.all(05),
                          child: p.Text('',style: const p.TextStyle(fontSize: 10))
                      ),
                      p.Container(
                          alignment: p.Alignment.center,
                          padding: const p.EdgeInsets.all(05),
                          child: p.Text('',style: const p.TextStyle(fontSize: 10))
                      ),
                      p.Container(
                          alignment: p.Alignment.center,
                          padding: const p.EdgeInsets.all(05),
                          child: p.Text('',style: const p.TextStyle(fontSize: 10))
                      ),
                      p.Container(
                          alignment: p.Alignment.center,
                          padding: const p.EdgeInsets.all(05),
                          child: p.Text('',style: const p.TextStyle(fontSize: 10))
                      ),
                    ],
                  ),
                ]
            ),
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: AppConstants.itemWidth*0.414,
                  height: AppConstants.itemHeight*0.118,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    // image: DecorationImage(image: imageLogo,fit: BoxFit.fill),
                  ),
                  child: BarcodeWidget(
                      data: "https://www.welinfoweb.com/",
                      barcode: Barcode.qrCode(),
                      width: AppConstants.itemWidth*0.17,
                      height: AppConstants.itemHeight*0.17
                  ),
                ),
                Table(
                  border: TableBorder.all(color: PdfColors.black),
                  children: [
                    TableRow(
                      children: [
                        Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.all(02),
                            margin: EdgeInsets.only(right: AppConstants.itemWidth*0.01,top: AppConstants.itemHeight*0.005),
                            child: Text('TOTAL AMOUNT BEFORE TAX')
                        ),
                        // PaddedText("TOTAL AMOUNT BEFORE TAX"),
                        paddedText(subAmount.toStringAsFixed(2)),
                      ],
                    ),
                    TableRow(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        // PaddedText("ADD : CGST 9%/2.5%"),
                        Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.all(02),
                            margin: EdgeInsets.only(right: AppConstants.itemWidth*0.01,top: AppConstants.itemHeight*0.005),
                            child: Text('ADD : CGST ${cgstValue.toStringAsFixed(2)}%')
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: AppConstants.itemWidth*0.01,top: AppConstants.itemHeight*0.005),
                          width: AppConstants.itemWidth*0.412,
                          child: Text(cgst.toStringAsFixed(2))
                        ),
                        // PaddedText("1701"),
                      ],
                    ),
                    TableRow(
                      children: [
                        Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.all(02),
                            margin: EdgeInsets.only(right: AppConstants.itemWidth*0.01,top: AppConstants.itemHeight*0.005),
                            child: Text('ADD SGST ${sgstValue.toStringAsFixed(2)}%')
                        ),
                        // PaddedText("ADD SGST 9%/2.5%"),
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: AppConstants.itemWidth*0.01,top: AppConstants.itemHeight*0.005),
                            width: AppConstants.itemWidth*0.40,
                            child: Text(sgst.toStringAsFixed(2))
                        ),
                      ],
                    ),
                    // TableRow(
                    //   children: [
                    //     Container(
                    //         alignment: Alignment.centerRight,
                    //         padding: const EdgeInsets.all(02),
                    //         margin: EdgeInsets.only(right: AppConstants.itemWidth*0.01,top: AppConstants.itemHeight*0.005),
                    //         child: Text('DUE AMOUNT')
                    //     ),
                    //     Container(
                    //         alignment: Alignment.centerLeft,
                    //         margin: EdgeInsets.only(left: AppConstants.itemWidth*0.01,top: AppConstants.itemHeight*0.005),
                    //         width: AppConstants.itemWidth*0.40,
                    //         child: Text('${dueTotalAmount.round()}')
                    //     ),
                    //     // PaddedText("68040"),
                    //   ],
                    // ),
                    TableRow(
                      children: [
                        Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.all(02),
                            margin: EdgeInsets.only(right: AppConstants.itemWidth*0.01,top: AppConstants.itemHeight*0.005),
                            child: Text('TOTAL AMOUNT AFTER TAX')
                        ),
                        // PaddedText("TOTAL AMOUNT AFTER TAX"),
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: AppConstants.itemWidth*0.01,top: AppConstants.itemHeight*0.005),
                            width: AppConstants.itemWidth*0.40,
                            child: Text('${totalAmount}')
                        ),
                        // PaddedText("68040"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: AppConstants.itemHeight*0.005),
            Table(
              border: TableBorder.all(color: PdfColors.black),
              children: [
                TableRow(
                  children: [
                    paddedText('Rupees (In Words) : ${NumberToWordsEnglish.convert(totalAmount.round()).toUpperCase()} -/ Only'),
                  ],
                ),
              ],
            ),
            SizedBox(height: AppConstants.itemHeight*0.015),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Certified that the particulars given above are\ntrue and correct",
                  style: Theme.of(context).header5,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "For ",
                          style: Theme.of(context).header5,
                        ),
                        Text(
                          "WELMART INDIA",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: AppConstants.itemHeight*0.02),
                        ),
                      ]
                    ),
                    Container(
                      height: AppConstants.itemHeight*0.05,
                      width: AppConstants.itemWidth*0.10,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: imageLogo,fit: BoxFit.fill)
                      ),
                    ),
                    Text(
                      "Authorise Signature",
                      style: Theme.of(context).header5,
                    ),
                  ]
                ),
              ],
            ),
          ];
      },
      header: (context) {
        return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: AppConstants.itemWidth*0.50,vertical: AppConstants.itemHeight*0.005),
          padding: EdgeInsets.symmetric(vertical: AppConstants.itemHeight*0.005),
          decoration: BoxDecoration(
              color: PdfColors.black,
              borderRadius: BorderRadius.circular(07)
          ),
          child: Text("TAX INVOICE",style: TextStyle(color: PdfColors.white,fontSize: AppConstants.itemHeight*0.022,fontBold: Font.courierBoldOblique())),
        );
      },
    ),
  );

  final directory = await getExternalStorageDirectory();
  final file = File("${directory?.path}/$customerName.pdf");

  final pdfBytes = await pdf.save();
  await file.writeAsBytes(pdfBytes.toList());

  print("Directory::::$directory");
  print("SavePDF::::$file");

  return pdf.save();
}

Widget paddedText(final String text, {final TextAlign align = TextAlign.left,}) =>
    Padding(
      padding: const EdgeInsets.all(05),
      child: Text(
        text,
        textAlign: align,
      ),
    );
