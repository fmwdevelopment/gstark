import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import '../../controller/reconciliation_screen_controller.dart';
import 'aggregated data table.dart';

class TaxSumView extends StatefulWidget {
  const TaxSumView({Key? key}) : super(key: key);

  @override
  State<TaxSumView> createState() => _TaxSumViewState();
}

class _TaxSumViewState extends State<TaxSumView> {

  late final ReconciliationScreenController reconciliationScreenController;
  @override
  void initState() {
    super.initState();

    reconciliationScreenController =
    Get.isRegistered<ReconciliationScreenController>()
        ? Get.find<ReconciliationScreenController>()
        : Get.put(ReconciliationScreenController());

  }

  @override
  Widget build(BuildContext context) {
    // Aggregate data
    final aggregatedData = aggregateData(reconciliationScreenController.data);
    return AggregatedDataTable(aggregatedData: aggregatedData);
  }

}


