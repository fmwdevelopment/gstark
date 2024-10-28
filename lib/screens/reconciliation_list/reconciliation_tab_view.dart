import 'package:flutter/material.dart';
import 'package:gstark/constants/app_colors.dart';
import 'package:gstark/screens/reconciliation_list/excel_list_view.dart';
import 'package:gstark/screens/reconciliation_list/tax_sum_view.dart';

class ReconciliationTabView extends StatefulWidget {
  final String name;
  final String fileUrl;

  const ReconciliationTabView(
      {Key? key, required this.name, required this.fileUrl})
      : super(key: key);

  @override
  State<ReconciliationTabView> createState() => _ReconciliationTabViewState();
}

class _ReconciliationTabViewState extends State<ReconciliationTabView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            //tab controller.index can be used to get the name of current index value of the tabview.
            title: const Text("2A/2B Reconciliation"),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: TabBar(
                dividerColor:Colors.transparent,
                controller: tabController,
                indicator: const BoxDecoration(
                  color: Colors.transparent,
                ),
                labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                tabs: [
                  Container(
                    decoration: BoxDecoration(
                      color: tabController.index == 0
                          ? kApplicationThemeColor
                          : kNeutral100,
                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: Tab(
                      child: Center(
                        child: Text(
                          "INVOICES",
                          style: TextStyle(
                            color: tabController.index == 0
                                ? Colors.white
                                : kApplicationThemeColor,
                            fontFamily: "ProximaNova",
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: tabController.index == 1
                          ? kApplicationThemeColor
                          : kNeutral100,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Tab(
                      child: Center(
                        child: Text(
                          "PARTY WISE",
                          style: TextStyle(
                            color: tabController.index == 1
                                ? Colors.white
                                : kApplicationThemeColor,
                            fontFamily: 'ProximaNova',
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
        body: TabBarView(controller: tabController, children: [
          ExcelListView(name: widget.name, fileUrl: widget.fileUrl),
          const TaxSumView(),
        ]));
  }
}
