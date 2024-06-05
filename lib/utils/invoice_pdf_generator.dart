import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:gstark/utils/collection_extensions.dart';
import 'package:pdf/pdf.dart';


class InvoicePdfGenerator {
  Future<File> generateInvoicePdf(String companyName, String companyAddress,
      Map<String, dynamic> invoiceData) async {
    final pdf = pw.Document();

    // Calculate the required page height based on the number of items
    int numberOfItems = invoiceData['items'].length;
    double itemHeight = 40.0; // Estimated height of each item row
    double baseHeight = 400.0; // Base height for header and other sections
    double pageHeight = baseHeight + (numberOfItems * itemHeight);

    // Ensure the minimum height of an A4 page to avoid any layout issues
    pageHeight = pageHeight < PdfPageFormat.a4.height ? PdfPageFormat.a4.height : pageHeight;


    pdf.addPage(
      pw.Page(
          pageFormat: PdfPageFormat(
              PdfPageFormat.a4.width, pageHeight),
        build: (context) => pw.Container(
          decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.SizedBox(height: 40),
              _buildHeader(companyName, companyAddress),
              pw.Container(
                  decoration: pw.BoxDecoration(
                    border:
                        pw.Border.all(width: 1, color: PdfColors.lightBlue200),
                  ),
                  padding: const pw.EdgeInsets.all(15),
                  margin: const pw.EdgeInsets.all(15),
                  child: pw.Column(children: [
                    _buildCustomerDetails(invoiceData),
                    pw.Padding(
                      padding: const pw.EdgeInsets.fromLTRB(10, 10, 10, 30),
                      child: _buildItemsTable(invoiceData),
                    ),
                  ]))
            ],
          ),
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final timestamp = DateTime.now().toIso8601String();
    final uniqueId = const Uuid().v4();
    final fileName = 'invoice_$timestamp$uniqueId.pdf';
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    // OpenFile.open(file.path);

    return file;
  }

  pw.Widget _buildHeader(
    String companyName,
    String companyAddress,
  ) {
    return pw.Container(
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: <pw.Widget>[
          pw.Container(
              color: ColorPalette.background,
              width: double.infinity,
              child: pw.Text(
                'INVOICE',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              )),
          pw.SizedBox(height: 5),
          pw.Text(
            companyName,
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            companyAddress,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.Divider(color: PdfColor.fromHex('#E0E0E0'), thickness: 1),
          // pw.SizedBox(height: 20),
          // pw.Row(
          //   mainAxisAlignment: pw.MainAxisAlignment.center,
          //   children: <pw.Widget>[
          //     pw.Container(
          //       width: 180,
          //       height: 2,
          //       color: PdfColor.fromHex('#E0E0E0'),
          //     ),
          //     pw.Padding(
          //       padding: const pw.EdgeInsets.symmetric(horizontal: 10),
          //       child: pw.Text(
          //         'Invoice Details',
          //         style: pw.TextStyle(
          //             fontSize: 12, fontWeight: pw.FontWeight.normal),
          //       ),
          //     ),
          //     pw.Container(
          //       width: 180,
          //       height: 2,
          //       color: PdfColor.fromHex('#E0E0E0'),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  pw.Widget _buildCustomerDetails(Map<String, dynamic> invoiceData) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: <pw.Widget>[
        pw.Container(
          padding: const pw.EdgeInsets.only(bottom: 20),
          child: pw.FittedBox(
            fit: pw.BoxFit.contain,
            child: pw.Table(
              border: pw.TableBorder.all(width: 1, color: PdfColors.grey400),
              children: [
                pw.TableRow(children: [
                  _getText('Customer Name'),
                  pw.Expanded(
                    child: _getText('${invoiceData['customer_name']}'),
                  ),
                  _getText('Invoice No.'),
                  pw.Expanded(
                    child: _getText('${invoiceData['invoice_no']}'),
                  ),
                ]),
                pw.TableRow(children: [
                  _getText('Customer Number'),
                  pw.Expanded(
                    child: _getText('${invoiceData['customer_number']}'),
                  ),
                  _getText('Sales Date'),
                  pw.Expanded(
                    child: _getText('${invoiceData['invoice_date']}'),
                  ),
                ]),
                pw.TableRow(children: [
                  _getText('Customer GSTN'),
                  pw.Expanded(
                    child: _getText('${invoiceData['customer_gstn']}'),
                  ),
                  _getText('Address'),
                  pw.Expanded(
                    child: _getText('${invoiceData['customer_address']}'),
                  ),
                ]),
              ],
            ),
          ),
        )
      ],
    );
  }

  pw.Widget _getText(String text) {
    return pw.Container(
        padding: const pw.EdgeInsets.all(5),
        child: pw.Text(text, style: const pw.TextStyle(fontSize: 10)));
  }

  pw.Widget _buildItemsTable(Map<String, dynamic> invoiceData) {
    List<Map<String, dynamic>> items = invoiceData['items'];
    return pw.Column(
      children: [
        pw.Table(
          border: pw.TableBorder.all(width: 1, color: PdfColors.grey400),
          children: [
            _buildTableRow([
              'SL',
              'Product Name',
              'Unit Price',
              'Quantity',
              'Amount',
              'Tax %'
            ], isHeader: true),
            ...items.mapIndexed((item, index) => _buildTableRow([
                  (index + 1).toString(),
                  item['name'],
                  '${item['price']}',
                  item['quantity'].toString(),
                  '${double.parse(item['price']) * double.parse(item['quantity'])}',
                  '${item['tax']}',
                ])),
          ],
        ),
        pw.Table(
            border: pw.TableBorder.all(width: 1, color: PdfColors.grey400),
            children: [
              _buildTotalAmount("Total", '${invoiceData['total_before_tax']}'),
              invoiceData['inter_state'] == true
                  ? _buildTotalAmount(
                      "CGST Tax", '${invoiceData['tax_amount'] / 2}')
                  : _buildTotalAmount(
                      'IGST Tax', '${invoiceData['tax_amount']}'),
              invoiceData['inter_state'] == true
                  ? _buildTotalAmount(
                      "SGST Tax", '${invoiceData['tax_amount'] / 2}')
                  : _buildTotalAmount('', ''),
              _buildTotalAmount(
                  "Total Tax Amount", '${invoiceData['tax_amount']}'),
              _buildTotalAmount(
                  "Net payable", '${invoiceData['total_after_tax']}'),
            ])
      ],
    );
  }

  pw.TableRow _buildTableRow(List<String> data, {bool isHeader = false}) {
    return pw.TableRow(
      decoration: isHeader
          ? pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(
                  width: 1,
                  color: PdfColor.fromHex('#000000'),
                ),
              ),
            )
          : null,
      children: data
          .map(
            (cellData) => pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(cellData,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: isHeader
                          ? pw.FontWeight.bold
                          : pw.FontWeight.normal)),
            ),
          )
          .toList(),
    );
  }

  pw.TableRow _buildTotalAmount(String title, String value) {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            width: 1,
            color: PdfColors.grey400,
          ),
        ),
      ),
      children: [
        pw.Container(
            padding: const pw.EdgeInsets.all(8),
            width: 200,
            child: pw.Text(title, textAlign: pw.TextAlign.right)),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child:
              pw.Text(value, tightBounds: true, textAlign: pw.TextAlign.right),
        )
      ],
    );
  }
}

class ColorPalette {
  static PdfColor background = PdfColor.fromHex('#E0E0E0');
}
