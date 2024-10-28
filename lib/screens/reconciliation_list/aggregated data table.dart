import 'package:flutter/material.dart';
import 'package:gstark/utils/text_utils/normal_text.dart';
import '../../models/excel_data_model.dart';

class AggregatedDataTable extends StatelessWidget {
  final List<AggregatedData> aggregatedData;

  const AggregatedDataTable({super.key, required this.aggregatedData});

  @override
  Widget build(BuildContext context) {
    // Calculate grand totals
    final grandTotal = calculateGrandTotals(aggregatedData);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                dividerThickness: 0,
                columns: const [
                  DataColumn(label: NormalText(text: 'Trade/Legal Name',textFontWeight: FontWeight.w700,)),
                  DataColumn(
                      label:
                          NormalText(text: 'Sum of Taxable Value (\u{20B9})',textFontWeight: FontWeight.w700,)),
                  DataColumn(
                      label:
                          NormalText(text: 'Sum of Integrated Tax (\u{20B9})',textFontWeight: FontWeight.w700,)),
                  DataColumn(
                      label: NormalText(text: 'Sum ofCentral Tax (\u{20B9})',textFontWeight: FontWeight.w700,)),
                  DataColumn(
                      label:
                          NormalText(text: 'Sum of State/UT Tax (\u{20B9})',textFontWeight: FontWeight.w700,)),
                ],
                rows: aggregatedData.map((data) {
                  return DataRow(cells: [
                    DataCell(NormalText(text: data.tradeLegalName)),
                    DataCell(NormalText(
                        text: data.sumTaxableValue.toStringAsFixed(2))),
                    DataCell(NormalText(
                        text: data.sumIntegratedTax.toStringAsFixed(2))),
                    DataCell(NormalText(
                        text: data.sumCentralTax.toStringAsFixed(2))),
                    DataCell(NormalText(
                        text: data.sumStateUtTax.toStringAsFixed(2))),
                  ]);
                }).toList()
                  ..add(
                    DataRow(
                      cells: [
                        const DataCell(NormalText(
                          text: 'Grand Total',
                          textFontWeight: FontWeight.w700,
                          textSize: 16,
                        )),
                        DataCell(NormalText(
                            text: grandTotal.sumTaxableValue.toStringAsFixed(2),
                            textFontWeight: FontWeight.w700,
                            textSize: 16)),
                        DataCell(NormalText(
                            text:
                                grandTotal.sumIntegratedTax.toStringAsFixed(2),
                            textFontWeight: FontWeight.w700,
                            textSize: 16)),
                        DataCell(NormalText(
                            text: grandTotal.sumCentralTax.toStringAsFixed(2),
                            textFontWeight: FontWeight.w700,
                            textSize: 16)),
                        DataCell(NormalText(
                            text: grandTotal.sumStateUtTax.toStringAsFixed(2),
                            textFontWeight: FontWeight.w700,
                            textSize: 16)),
                      ],
                    ),
                  ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 50)
      ],
    );
  }
}

class AggregatedData {
  final String tradeLegalName;
  final double sumTaxableValue;
  final double sumIntegratedTax;
  final double sumCentralTax;
  final double sumStateUtTax;

  AggregatedData({
    required this.tradeLegalName,
    required this.sumTaxableValue,
    required this.sumIntegratedTax,
    required this.sumCentralTax,
    required this.sumStateUtTax,
  });
}

List<AggregatedData> aggregateData(List<ExcelData> data) {
  // Create a map to store the aggregated values
  final Map<String, AggregatedData> aggregatedMap = {};

  for (var item in data) {
    final tradeName = item.tradeLegalName ?? 'Unknown';
    final taxableValue = double.tryParse(item.taxableValue ?? '0') ?? 0;
    final integratedTax = double.tryParse(item.integratedTax ?? '0') ?? 0;
    final centralTax = double.tryParse(item.centralTax ?? '0') ?? 0;
    final stateUtTax = double.tryParse(item.stateUtTax ?? '0') ?? 0;

    if (aggregatedMap.containsKey(tradeName)) {
      // Update existing entry
      final existing = aggregatedMap[tradeName]!;
      aggregatedMap[tradeName] = AggregatedData(
        tradeLegalName: tradeName,
        sumTaxableValue: existing.sumTaxableValue + taxableValue,
        sumIntegratedTax: existing.sumIntegratedTax + integratedTax,
        sumCentralTax: existing.sumCentralTax + centralTax,
        sumStateUtTax: existing.sumStateUtTax + stateUtTax,
      );
    } else {
      // Create new entry
      aggregatedMap[tradeName] = AggregatedData(
        tradeLegalName: tradeName,
        sumTaxableValue: taxableValue,
        sumIntegratedTax: integratedTax,
        sumCentralTax: centralTax,
        sumStateUtTax: stateUtTax,
      );
    }
  }

  // Convert map to list
  return aggregatedMap.values.toList();
}

AggregatedData calculateGrandTotals(List<AggregatedData> data) {
  double totalTaxableValue = 0;
  double totalIntegratedTax = 0;
  double totalCentralTax = 0;
  double totalStateUtTax = 0;

  for (var item in data) {
    totalTaxableValue += item.sumTaxableValue;
    totalIntegratedTax += item.sumIntegratedTax;
    totalCentralTax += item.sumCentralTax;
    totalStateUtTax += item.sumStateUtTax;
  }

  return AggregatedData(
    tradeLegalName: 'Grand Total',
    sumTaxableValue: totalTaxableValue,
    sumIntegratedTax: totalIntegratedTax,
    sumCentralTax: totalCentralTax,
    sumStateUtTax: totalStateUtTax,
  );
}
