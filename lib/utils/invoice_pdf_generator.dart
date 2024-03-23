import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class InvoicePdfGenerator {
  Future<String> generateInvoicePdf(List<Map<String, dynamic>> items) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: <pw.Widget>[
            _buildHeader(),
            _buildItemsTable(items),
          ],
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final uniqueId = UniqueKey()
        .toString(); // Use a unique identifier like UUID if available
    final fileName = 'invoice_$timestamp$uniqueId.pdf';
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path); // Open the PDF for viewing

    return file.path;
  }

  pw.Widget _buildHeader() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: <pw.Widget>[
        // pw.Image(pw.MemoryImage(/* Add your logo image data here */)),
        pw.Text('Invoice', style: const pw.TextStyle(fontSize: 20)),
      ],
    );
  }

  pw.Widget _buildItemsTable(List<Map<String, dynamic>> items) {
    return pw.Table(
      border: null,
      children: [
        _buildTableRow(['Item', 'Quantity', 'Price', 'Total'], isHeader: true),
        ...items.map((item) => _buildTableRow([
              item['name'],
              item['quantity'].toString(),
              '\$${item['price']}',
              '\$${item['price'] * item['quantity']}'
            ])),
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
                  color: PdfColor.fromHex(
                      '#000000'), // Need to change the color code
                ),
              ),
            )
          : null,
      children: data
          .map(
            (cellData) => pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(cellData),
            ),
          )
          .toList(),
    );
  }
}
