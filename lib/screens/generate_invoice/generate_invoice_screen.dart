import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:gstark/utils/invoice_generation.dart';
import 'package:gstark/utils/validation_utils/quantity_validation.dart';
import 'package:gstark/utils/gst_calculation.dart';
import 'package:gstark/utils/validation_utils/phone_number_validation.dart';
import 'package:gstark/utils/toast_utils/error_toast.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../controller/generate_invoice_controller.dart';
import '../../utils/validation_utils/price_validation.dart';
import '../../utils/text_utils/normal_text.dart';
import '../../utils/validation_utils/tax_validation.dart';
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final GenerateInvoiceController generateInvoiceController;

  @override
  void initState() {
    super.initState();
    generateInvoiceController = Get.isRegistered<GenerateInvoiceController>()
        ? Get.find<GenerateInvoiceController>()
        : Get.put(GenerateInvoiceController());
  }


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
              if (_customerNameController.text.isEmpty) {
                errorToast("Please enter the custome name", context);
              } else if (_phoneNumberController.text.isEmpty ||
                  validatePhoneNumber(_phoneNumberController.text) == false) {
                errorToast("Please enter valid phone number", context);
              } else if(generateInvoiceController.dataList.isEmpty) {
                errorToast("Please add the products to genearate invoice", context);
                //TODO: code for generating PDF
              }else{
                var inoviceNo = generateRandomInvoiceNumber(_phoneNumberController.text);
                print("inovice No: $inoviceNo");

                var invoiceData = {
                  "invoiceName":_customerNameController.text,
                  "inoviceNumber":inoviceNo,
                  "inoviceAddress":_phoneNumberController.text,
                  "cgst":double.parse(_taxController.text)/2,
                  "sgst":double.parse(_taxController.text)/2,
                  "salesDate": DateFormat("MMMM d, y").format(DateTime.now()),
                  "productData":generateInvoiceController.dataList,
                };

                print("invoiceData $invoiceData");

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
                          content: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: _productNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Product Name',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a Product Name';
                                      }
                                    },
                                  ),
                                  TextFormField(
                                    controller: _quantityController,
                                    decoration: InputDecoration(
                                      labelText: 'Quantity',
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a quantity';
                                      }
                                      if (!validateQuantity(value)) {
                                        return 'Please enter a valid quantity';
                                      }
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    controller: _unitPriceController,
                                    decoration: const InputDecoration(
                                        labelText: 'Unit Price'),
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a price';
                                      }
                                      if (!validatePrice(value)) {
                                        return 'Please enter a valid price';
                                      }
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    controller: _taxController,
                                    decoration: const InputDecoration(
                                        labelText: 'Tax(%)'),
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a tax rate';
                                      }
                                      if (!validateTax(value)) {
                                        return 'Please enter a valid tax rate';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
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
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    generateInvoiceController.dataList.add(RxList<String>([
                                      _productNameController.text,
                                      _quantityController.text,
                                      _unitPriceController.text,
                                      _taxController.text
                                    ]));
                                  });
                                  Get.back();
                                }
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
                        Obx(() => SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          child: ListView.builder(
                              itemCount: generateInvoiceController.dataList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onLongPress: () {
                                    print("long pressed");
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: kPrimary100,
                                        borderRadius:
                                        BorderRadius.circular(10)),
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
                                                text: '${generateInvoiceController.dataList[index][1]}',
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
                                                text: '${generateInvoiceController.dataList[index][0]}',
                                                textSize: 16,
                                                textFontWeight: FontWeight.w700,
                                              ),
                                              NormalText(
                                                text:
                                                'Unit Price: ${generateInvoiceController.dataList[index][2]}, GST ${generateInvoiceController.dataList[index][3]} %',
                                                textSize: 14,
                                              ),
                                            ],
                                          ),
                                          NormalText(
                                            text:
                                            '\u{20B9} ${calculatePriceWithGst(int.parse(generateInvoiceController.dataList[index][1]), double.parse(generateInvoiceController.dataList[index][2]), double.parse(generateInvoiceController.dataList[index][3]))}',
                                            textSize: 14,
                                          ),
                                          // IconButton(
                                          //     onPressed: () {
                                          //       setState(() {
                                          //         dataList.removeAt(index);
                                          //       });
                                          //     },
                                          //     icon: const Icon(
                                          //       Icons.delete,
                                          //       color: kPrimaryBlack,
                                          //       size: 24,
                                          //     ))
                                          IconButton(
                                              onPressed: () {
                                                print("pressed at: $index");
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [

                                                            const NormalText(
                                                              text: "New Product",
                                                              textAlign:
                                                              TextAlign.center,
                                                              textFontWeight:
                                                              FontWeight.w500,
                                                              textSize: 20,
                                                              textColor:
                                                              kApplicationThemeColor,
                                                            ),
                                                            const SizedBox(width: 20,),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(50),
                                                                color: kLightRedColor,
                                                              ),

                                                              child: IconButton(onPressed: (){
                                                                Get.back();
                                                              }, icon: const Icon(Icons.close,size: 32,color: kSecondaryError500,)),
                                                            ),
                                                          ],
                                                        ),
                                                        content: Form(
                                                          key: _formKey,
                                                          child:
                                                          SingleChildScrollView(
                                                            child: Column(
                                                              mainAxisSize:
                                                              MainAxisSize
                                                                  .min,
                                                              children: [
                                                                TextFormField(
                                                                  controller:
                                                                  _productNameController,
                                                                  decoration:
                                                                  const InputDecoration(
                                                                    labelText:
                                                                    'Product Name',
                                                                  ),
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                        null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'Please enter a Product Name';
                                                                    }
                                                                  },
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                  _quantityController,
                                                                  decoration:
                                                                  InputDecoration(
                                                                    labelText:
                                                                    'Quantity',
                                                                  ),
                                                                  keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                        null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'Please enter a quantity';
                                                                    }
                                                                    if (!validateQuantity(
                                                                        value)) {
                                                                      return 'Please enter a valid quantity';
                                                                    }
                                                                    return null;
                                                                  },
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                  _unitPriceController,
                                                                  decoration: const InputDecoration(
                                                                      labelText:
                                                                      'Unit Price'),
                                                                  keyboardType:
                                                                  TextInputType.numberWithOptions(
                                                                      decimal:
                                                                      true),
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                        null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'Please enter a price';
                                                                    }
                                                                    if (!validatePrice(
                                                                        value)) {
                                                                      return 'Please enter a valid price';
                                                                    }
                                                                    return null;
                                                                  },
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                  _taxController,
                                                                  decoration: const InputDecoration(
                                                                      labelText:
                                                                      'Tax(%)'),
                                                                  keyboardType:
                                                                  TextInputType.numberWithOptions(
                                                                      decimal:
                                                                      true),
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                        null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'Please enter a tax rate';
                                                                    }
                                                                    if (!validateTax(
                                                                        value)) {
                                                                      return 'Please enter a valid tax rate';
                                                                    }
                                                                    return null;
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                generateInvoiceController.dataList.removeAt(index);
                                                              });
                                                              Get.back();
                                                            },
                                                            child:
                                                            const NormalText(
                                                              text: "Delete",
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                              textFontWeight:
                                                              FontWeight
                                                                  .w500,
                                                              textSize: 16,
                                                              textColor:
                                                              kApplicationThemeColor,
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              if (_formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                setState(() {
                                                                  generateInvoiceController.dataList
                                                                      .replaceRange(
                                                                      index,
                                                                      index +
                                                                          1,
                                                                      [
                                                                        RxList<String>([
                                                                          _productNameController
                                                                              .text,
                                                                          _quantityController
                                                                              .text,
                                                                          _unitPriceController
                                                                              .text,
                                                                          _taxController
                                                                              .text
                                                                        ])
                                                                      ]);
                                                                });
                                                                Get.back();
                                                              }
                                                            },
                                                            child: Container(
                                                              padding:
                                                              EdgeInsets
                                                                  .all(10),
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                  kApplicationThemeColor,
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      10)),
                                                              child:
                                                              const NormalText(
                                                                text: "Update",
                                                                textAlign:
                                                                TextAlign
                                                                    .center,
                                                                textFontWeight:
                                                                FontWeight
                                                                    .w500,
                                                                textSize: 16,
                                                                textColor:
                                                                kWhite,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              },
                                              icon: const Icon(
                                                Icons.edit,
                                                color: kPrimaryBlack,
                                                size: 24,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        )),
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
