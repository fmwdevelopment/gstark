import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/constants/app_colors.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import '../../controller/reconciliation_screen_controller.dart';
import '../../utils/text_utils/normal_text.dart';

class ExcelListView extends StatefulWidget {
  final String name;
  final String fileUrl;
  const ExcelListView({super.key,  required this.name,required this.fileUrl,});

  @override
  _ExcelListViewState createState() => _ExcelListViewState();
}

class _ExcelListViewState extends State<ExcelListView> {
  late final ReconciliationScreenController reconciliationScreenController;
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();

    reconciliationScreenController =
    Get.isRegistered<ReconciliationScreenController>()
        ? Get.find<ReconciliationScreenController>()
        : Get.put(ReconciliationScreenController());
    initCall(context);
  }
  void initCall(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      reconciliationScreenController.fetchDataFromAPI(widget.fileUrl);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchText(String searchText) {
    print("Search text: $searchText");
    setState(() {
      if (searchText.isEmpty) {
        reconciliationScreenController
            .setFilteredData(reconciliationScreenController.data);
      } else {
        var filteredData = reconciliationScreenController.data.where((element) {
          //row.firstColumnKey.toLowerCase().contains(searchText.toLowerCase())
          return element.tradeLegalName
              .toString()
              .toLowerCase()
              .contains(searchText.toLowerCase()) ||
              element.gstinOfSupplier
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              element.invoiceNumber
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase());
        }).toList();
        reconciliationScreenController.setFilteredData(filteredData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title:  NormalText(text: widget.name,textSize: 14,),
        // ),
        body: Obx(() => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                cursorColor: kApplicationThemeColor,
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for GSTIN/Name/Invoice No',
                  hintStyle: const TextStyle(
                    color: kNeutral400,
                    fontSize: 16,
                    fontFamily: 'ProximaNova'
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: kNeutral400,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: kNeutral400,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      _searchText(
                          ''); // Ensure this method handles empty search case
                    },
                  )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: kApplicationThemeColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: kApplicationThemeColor,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                ),
                onChanged: _searchText,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'ProximaNova'
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              reconciliationScreenController.isBusy?const Center(
                child: CircularProgressIndicator(color: kApplicationThemeColor,),
              ):
              reconciliationScreenController.filteredData.isEmpty
                  ? const Center(
                child: NormalText(text: "No Data Found"),
              )
                  : Expanded(
                child: HorizontalDataTable(
                  leftHandSideColumnWidth: 0,
                  rightHandSideColumnWidth: 2000,
                  isFixedHeader: true,
                  headerWidgets: _getTitleWidget(),
                  leftSideItemBuilder: _generateFirstColumnRow,
                  rightSideItemBuilder:
                  _generateRightHandSideColumnRow,
                  itemCount: reconciliationScreenController
                      .filteredData.length,
                  rowSeparatorWidget: const Divider(
                    color: Colors.black38,
                    height: 1.0,
                    thickness: 0.0,
                  ),
                  leftHandSideColBackgroundColor:
                  const Color(0xFFFFFFFF),
                  rightHandSideColBackgroundColor:
                  const Color(0xFFFFFFFF),
                  itemExtent: 55,
                ),
              ),
            ],
          ),
        )));
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('', 200),
      _getTitleItemWidget('GSTIN of Supplier', 200),
      _getTitleItemWidget('Trade/Legal Name', 200),
      _getTitleItemWidget('Invoice Number', 200),
      _getTitleItemWidget('Invoice Date', 200),
      _getTitleItemWidget('Invoice Value', 200),
      _getTitleItemWidget('Rate(%)', 200),
      _getTitleItemWidget('Taxable Value(₹)', 200),
      _getTitleItemWidget('Integrated Tax(₹)', 200),
      _getTitleItemWidget('Central Tax(₹)', 200),
      _getTitleItemWidget('State/UT Tax(₹)', 200)
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      width: width,
      height: 56,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold,fontFamily: 'ProximaNova')),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return const SizedBox();
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: NormalText(text:reconciliationScreenController
              .filteredData[index].gstinOfSupplier ??
              ''),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: NormalText(text:reconciliationScreenController
              .filteredData[index].tradeLegalName ??
              ''),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: NormalText(text:reconciliationScreenController
              .filteredData[index].invoiceNumber ??
              ''),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: NormalText(
              text:reconciliationScreenController.filteredData[index].invoiceDate ??
                  ''),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: NormalText(
              text:reconciliationScreenController.filteredData[index].invoiceValue ??
                  ''),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: NormalText(
              text:
              reconciliationScreenController.filteredData[index].rate ?? ''),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child:NormalText(
              text:
              reconciliationScreenController.filteredData[index].taxableValue ??
                  ''),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: NormalText(
              text:reconciliationScreenController
              .filteredData[index].integratedTax ??
              ''),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: NormalText(
              text:
              reconciliationScreenController.filteredData[index].centralTax ??
                  ''),
        ),
        Container(
          width: 200,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: NormalText(
              text:
              reconciliationScreenController.filteredData[index].stateUtTax ??
                  ''),
        )
      ],
    );
  }
}
