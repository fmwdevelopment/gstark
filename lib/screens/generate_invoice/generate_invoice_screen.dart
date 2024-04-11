import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:gstark/utils/gst_calculation.dart';
import 'package:gstark/utils/phone_number_validation.dart';
import 'package:gstark/utils/toast_utils/error_toast.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_decorations.dart';
import '../../utils/text_utils/normal_text.dart';
import '../../widgets/input_textfield.dart';

class GenerateInvoiceScreen extends StatefulWidget {
  const GenerateInvoiceScreen({Key? key}) : super(key: key);

  @override
  State<GenerateInvoiceScreen> createState() => _GenerateInvoiceScreenState();
}

class _GenerateInvoiceScreenState extends State<GenerateInvoiceScreen> {
  final _customerNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  final _productNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _taxController = TextEditingController();

  List<List<String>> dataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            // isExtended: true,
            backgroundColor: kApplicationThemeColor,
            onPressed: () {
              if(_customerNameController.text.isEmpty){
                errorToast("Please enter the custome name", context);
              }else if(_phoneNumberController.text.isEmpty || validatePhoneNumber(_phoneNumberController.text)==false){
                errorToast("Please enter valid phone number", context);
              }else{

                //TODO: code for generating PDF
              }
            },
            // isExtended: true,
            child: NormalText(
              text: "PDF",
              textAlign: TextAlign.center,
              textFontWeight: FontWeight.w500,
              textSize: 20,
              textColor: kWhite,
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: kApplicationThemeColor,
          iconTheme: const IconThemeData(color: kWhite, size: 24),
          title: const NormalText(
            text: "Generate Invoice",
            textAlign: TextAlign.center,
            textFontWeight: FontWeight.w500,
            textSize: 20,
            textColor: kWhite,
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: kWhite, borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                  onPressed: () {

                    _productNameController.text = '';
                    _quantityController.text = '';
                    _unitPriceController.text = '';
                    _taxController.text = '';

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const NormalText(
                            text: "New Product",
                            textAlign: TextAlign.center,
                            textFontWeight: FontWeight.w500,
                            textSize: 20,
                            textColor: kApplicationThemeColor,
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _productNameController,
                                decoration: const InputDecoration(
                                    labelText: 'Product Name'),
                              ),
                              TextField(
                                controller: _quantityController,
                                decoration:
                                    InputDecoration(labelText: 'Quantity'),
                              ),
                              TextField(
                                controller: _unitPriceController,
                                decoration:
                                    InputDecoration(labelText: 'Unit Price'),
                              ),
                              TextField(
                                controller: _taxController,
                                decoration:
                                    const InputDecoration(labelText: 'Tax(%)'),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const NormalText(
                                text: "Cancel",
                                textAlign: TextAlign.center,
                                textFontWeight: FontWeight.w500,
                                textSize: 16,
                                textColor: kApplicationThemeColor,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  dataList.add([
                                    _productNameController.text,
                                    _quantityController.text,
                                    _unitPriceController.text,
                                    _taxController.text
                                  ]);
                                });
                                Get.back();
                              },
                              child: Container(
                                child: const NormalText(
                                  text: "Add",
                                  textAlign: TextAlign.center,
                                  textFontWeight: FontWeight.w500,
                                  textSize: 16,
                                  textColor: kWhite,
                                ),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: kApplicationThemeColor,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const NormalText(
                    text: "Add Items",
                    textAlign: TextAlign.center,
                    textFontWeight: FontWeight.w500,
                    textSize: 16,
                    textColor: kApplicationThemeColor,
                  ),
                ),
              ),
            )
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const NormalText(
                          text: "Customer Name",
                          textSize: 14,
                          textColor: kNeutral400,
                        ),
                        const SizedBox(height: 8),
                        InputTextField(
                          controller: _customerNameController,
                          hintText: "Customer Name",
                          obscureText: false,
                          autofocus: false,
                        ),
                        const SizedBox(height: 16),
                        const NormalText(
                          text: "Phone Number",
                          textSize: 14,
                          textColor: kNeutral400,
                        ),
                        const SizedBox(height: 8),
                        InputTextField(
                          controller: _phoneNumberController,
                          hintText: "Phone Number",
                          obscureText: false,
                          autofocus: false,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          child: ListView.builder(
                              itemCount: dataList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onLongPress: (){
                                    print("long pressed");
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: kPrimary100,
                                        borderRadius: BorderRadius.circular(10)),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              NormalText(
                                                text: '${dataList[index][1]}',
                                                textSize: 24,
                                                textFontWeight: FontWeight.w800,
                                              ),
                                              const NormalText(
                                                text: 'Unit',
                                                textSize: 14,
                                                textFontWeight: FontWeight.w500,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              NormalText(
                                                text: '${dataList[index][0]}',
                                                textSize: 16,
                                                textFontWeight: FontWeight.w700,
                                              ),
                                              NormalText(
                                                text:
                                                    'Unit Price: ${dataList[index][2]}, GST ${dataList[index][3]} %',
                                                textSize: 14,
                                              ),
                                            ],
                                          ),
                                          NormalText(
                                            text:
                                                '\u{20B9} ${calculatePriceWithGst(int.parse(dataList[index][1]), double.parse(dataList[index][2]), double.parse(dataList[index][3]))}',
                                            textSize: 14,
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  dataList.removeAt(index);
                                                });
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: kPrimaryBlack,
                                                size: 24,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
