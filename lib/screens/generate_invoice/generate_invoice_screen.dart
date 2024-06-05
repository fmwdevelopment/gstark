import 'dart:io';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gstark/utils/validation_utils/quantity_validation.dart';
import 'package:gstark/utils/gst_calculation.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../constants/shared_preference_string.dart';
import '../../controller/generate_invoice_controller.dart';
import '../../utils/invoice_generation.dart';
import '../../utils/invoice_pdf_generator.dart';
import '../../utils/shared_preference/custom_shared_preference.dart';
import '../../utils/toast_utils/error_toast.dart';
import '../../utils/validation_utils/phone_number_validation.dart';
import '../../utils/validation_utils/price_validation.dart';
import '../../utils/text_utils/normal_text.dart';
import '../../widgets/button.dart';
import '../../widgets/input_textfield.dart';

class GenerateInvoiceScreen extends StatefulWidget {
  const GenerateInvoiceScreen({Key? key}) : super(key: key);

  @override
  State<GenerateInvoiceScreen> createState() => _GenerateInvoiceScreenState();
}

class _GenerateInvoiceScreenState extends State<GenerateInvoiceScreen> {

  final _customerNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _customerGSTNController = TextEditingController();
  final _customerAddressController = TextEditingController();


  final _productNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _taxController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final GenerateInvoiceController generateInvoiceController;

  String? selectedOption = 'Inter State'; // Initial value
  String? selectedTax = '5'; // Initial value
  var invoiceInfo = {};

  @override
  void initState() {
    super.initState();
    generateInvoiceController = Get.isRegistered<GenerateInvoiceController>()
        ? Get.find<GenerateInvoiceController>()
        : Get.put(GenerateInvoiceController());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (generateInvoiceController.dataList.isEmpty) {
          Get.back();
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    content:
                        const NormalText(text: "Are you sure you want exit?"),
                    actions: [
                      // Close button
                      TextButton(
                        onPressed: () {
                          Get.back(); // Close the dialog
                          Get.back();
                        },
                        child: const NormalText(
                          text: "Yes",
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kApplicationThemeColor),
                        child: TextButton(
                          onPressed: () {
                            Get.back(); // Close the dialog
                          },
                          child: const NormalText(
                            text: "No",
                            textColor: kWhite,
                          ),
                        ),
                      ),
                    ]);
              });
        }

        return Future.value(false);
      },
      child: Scaffold(
          backgroundColor: kWhite,
          appBar: AppBar(
            backgroundColor: kApplicationThemeColor,
            iconTheme: const IconThemeData(color: kWhite, size: 24),
            leading: IconButton(
              onPressed: () {
                if (generateInvoiceController.dataList.isEmpty) {
                  Get.back();
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            content: const NormalText(
                                text: "Are you sure you want exit?"),
                            actions: [
                              // Close button
                              TextButton(
                                onPressed: () {
                                  Get.back(); // Close the dialog
                                  Get.back();
                                },
                                child: const NormalText(
                                  text: "Yes",
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: kApplicationThemeColor),
                                child: TextButton(
                                  onPressed: () {
                                    Get.back(); // Close the dialog
                                  },
                                  child: const NormalText(
                                    text: "No",
                                    textColor: kWhite,
                                  ),
                                ),
                              ),
                            ]);
                      });
                }
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
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
                      // _taxController.text = '';

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
                                child: StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          controller: _productNameController,
                                          cursorColor: kApplicationThemeColor,
                                          decoration: const InputDecoration(
                                            labelText: 'Product Name',
                                            // Set label text color
                                            labelStyle:
                                                TextStyle(color: kNeutral600),
                                            // Set initial label text color
                                            fillColor: kApplicationThemeColor,
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      kApplicationThemeColor),
                                            ),
                                            focusedErrorBorder:
                                                UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      kApplicationThemeColor),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a Product Name';
                                            }
                                          },
                                        ),
                                        TextFormField(
                                          controller: _quantityController,
                                          cursorColor: kApplicationThemeColor,
                                          decoration: const InputDecoration(
                                            labelText: 'Quantity',
                                            labelStyle:
                                                TextStyle(color: kNeutral600),
                                            // Set initial label text color
                                            fillColor: kApplicationThemeColor,
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      kApplicationThemeColor),
                                            ),
                                            focusedErrorBorder:
                                                UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      kApplicationThemeColor),
                                            ),
                                          ),
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
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
                                          cursorColor: kApplicationThemeColor,
                                          decoration: const InputDecoration(
                                            labelText: 'Unit Price',
                                            labelStyle:
                                                TextStyle(color: kNeutral600),
                                            // Set initial label text color
                                            fillColor: kApplicationThemeColor,
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      kApplicationThemeColor),
                                            ),
                                            focusedErrorBorder:
                                                UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color:
                                                      kApplicationThemeColor),
                                            ),
                                          ),
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter a price';
                                            }
                                            if (!validatePrice(value)) {
                                              return 'Please enter a valid price';
                                            }
                                            return null;
                                          },
                                        ),
                                        // TextFormField(
                                        //   controller: _taxController,
                                        //   decoration: const InputDecoration(
                                        //       labelText: 'Tax(%)'),
                                        //   keyboardType:
                                        //       TextInputType.numberWithOptions(
                                        //           decimal: true),
                                        //   validator: (value) {
                                        //     if (value == null || value.isEmpty) {
                                        //       return 'Please enter a tax rate';
                                        //     }
                                        //     if (!validateTax(value)) {
                                        //       return 'Please enter a valid tax rate';
                                        //     }
                                        //     return null;
                                        //   },
                                        // ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Align(
                                          alignment: Alignment.topLeft,
                                          child: NormalText(
                                            text: "Select Tax %",
                                            textSize: 16,
                                            textColor: kNeutral700,
                                          ),
                                        ),
                                        DropdownButton<String>(
                                          value: selectedTax,
                                          isExpanded: true,
                                          icon: const Icon(
                                            Icons.arrow_drop_down_rounded,
                                            size: 48,
                                          ),
                                          iconSize: 24,
                                          elevation: 10,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedTax = newValue;
                                            });
                                          },
                                          items: <String>['5', '12', '18', '24']
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: NormalText(
                                                text: value,
                                                textSize: 16,
                                                textColor: kNeutral700,
                                              ),
                                            );
                                          }).toList(),
                                        )
                                      ],
                                    );
                                  },
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
                                      generateInvoiceController.dataList
                                          .add(RxList<String>([
                                        _productNameController.text,
                                        _quantityController.text,
                                        _unitPriceController.text,
                                        selectedTax ?? '5'
                                      ]));

                                    });
                                    Get.back();
                                    print(generateInvoiceController.dataList);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: kApplicationThemeColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const NormalText(
                                    text: "Add",
                                    textAlign: TextAlign.center,
                                    textFontWeight: FontWeight.w500,
                                    textSize: 16,
                                    textColor: kWhite,
                                  ),
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

          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 16),
                  const NormalText(
                    text: "Customer GSTN",
                    textSize: 14,
                    textColor: kNeutral400,
                  ),
                  const SizedBox(height: 8),
                  InputTextField(
                    controller: _customerGSTNController,
                    hintText: "Customer GSTN",
                    obscureText: false,
                    autofocus: false,
                  ),
                  const SizedBox(height: 16),
                  const NormalText(
                    text: "Customer Address",
                    textSize: 14,
                    textColor: kNeutral400,
                  ),
                  const SizedBox(height: 8),
                  InputTextField(
                    controller: _customerAddressController,
                    hintText: "Customer Address",
                    obscureText: false,
                    autofocus: false,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const NormalText(
                    text: "Select inter state or intra state:",
                    textSize: 14,
                    textColor: kNeutral400,
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedOption,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.arrow_drop_down_rounded,
                          size: 48,
                        ),
                        iconSize: 24,
                        elevation: 16,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedOption = newValue;
                          });
                        },
                        items: <String>[
                          'Inter State',
                          'Intra State',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: NormalText(
                              text: value,
                              textSize: 16,
                              textColor: kNeutral400,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  SizedBox                           (
                      height: generateInvoiceController.dataList.isEmpty
                          ? 40
                          : (generateInvoiceController.dataList.length * 80.0).clamp(0.0, MediaQuery.of(context).size.height * 0.4),
                      child: ListView.builder(
                          itemCount: generateInvoiceController.dataList.length,
                          itemBuilder: (context, index) {
                            return Container(
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
                                          text:
                                              '${generateInvoiceController.dataList[index][1]}',
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
                                          text:
                                              '${generateInvoiceController.dataList[index][0]}',
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
                                    NormalText(
                                      text:
                                          '\u{20B9} ${calculatePriceWithGst(int.parse(generateInvoiceController.dataList[index][1]), double.parse(generateInvoiceController.dataList[index][2]), double.parse(generateInvoiceController.dataList[index][3]))}',
                                      textSize: 14,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          print("pressed at: $index");

                                          _productNameController.text =
                                              generateInvoiceController
                                                  .dataList[index][0];
                                          _quantityController.text =
                                              generateInvoiceController
                                                  .dataList[index][1];
                                          _unitPriceController.text =
                                              generateInvoiceController
                                                  .dataList[index][2];
                                          _taxController.text =
                                              generateInvoiceController
                                                  .dataList[index][3];

                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
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
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          color: kLightRedColor,
                                                        ),
                                                        child: IconButton(
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            icon: const Icon(
                                                              Icons.close,
                                                              size: 32,
                                                              color:
                                                                  kSecondaryError500,
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                  content: Form(
                                                    key: _formKey,
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          TextFormField(
                                                            controller:
                                                                _productNameController,
                                                            cursorColor:
                                                                kApplicationThemeColor,
                                                            decoration:
                                                                const InputDecoration(
                                                              labelText:
                                                                  'Product Name',
                                                              labelStyle: TextStyle(
                                                                  color:
                                                                      kNeutral600),
                                                              // Set initial label text color
                                                              fillColor:
                                                                  kApplicationThemeColor,
                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            kApplicationThemeColor),
                                                              ),
                                                              focusedErrorBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            kApplicationThemeColor),
                                                              ),
                                                            ),
                                                            validator: (value) {
                                                              if (value == null ||
                                                                  value.isEmpty) {
                                                                return 'Please enter a Product Name';
                                                              }
                                                            },
                                                          ),
                                                          TextFormField(
                                                            controller:
                                                                _quantityController,
                                                            cursorColor:
                                                                kApplicationThemeColor,
                                                            decoration:
                                                                const InputDecoration(
                                                              labelText:
                                                                  'Quantity',
                                                              labelStyle: TextStyle(
                                                                  color:
                                                                      kNeutral600),
                                                              // Set initial label text color
                                                              fillColor:
                                                                  kApplicationThemeColor,
                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            kApplicationThemeColor),
                                                              ),
                                                              focusedErrorBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            kApplicationThemeColor),
                                                              ),
                                                            ),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            validator: (value) {
                                                              if (value == null ||
                                                                  value.isEmpty) {
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
                                                            cursorColor:
                                                                kApplicationThemeColor,
                                                            decoration:
                                                                const InputDecoration(
                                                              labelText:
                                                                  'Unit Price',
                                                              labelStyle: TextStyle(
                                                                  color:
                                                                      kNeutral600),
                                                              // Set initial label text color
                                                              fillColor:
                                                                  kApplicationThemeColor,
                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            kApplicationThemeColor),
                                                              ),
                                                              focusedErrorBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            kApplicationThemeColor),
                                                              ),
                                                            ),
                                                            keyboardType:
                                                                TextInputType
                                                                    .numberWithOptions(
                                                                        decimal:
                                                                            true),
                                                            validator: (value) {
                                                              if (value == null ||
                                                                  value.isEmpty) {
                                                                return 'Please enter a price';
                                                              }
                                                              if (!validatePrice(
                                                                  value)) {
                                                                return 'Please enter a valid price';
                                                              }
                                                              return null;
                                                            },
                                                          ),
                                                          // TextFormField(
                                                          //   controller:
                                                          //   _taxController,
                                                          //   decoration: const InputDecoration(
                                                          //       labelText:
                                                          //       'Tax(%)'),
                                                          //   keyboardType:
                                                          //   TextInputType.numberWithOptions(
                                                          //       decimal:
                                                          //       true),
                                                          //   validator:
                                                          //       (value) {
                                                          //     if (value ==
                                                          //         null ||
                                                          //         value
                                                          //             .isEmpty) {
                                                          //       return 'Please enter a tax rate';
                                                          //     }
                                                          //     if (!validateTax(
                                                          //         value)) {
                                                          //       return 'Please enter a valid tax rate';
                                                          //     }
                                                          //     return null;
                                                          //   },
                                                          // ),

                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          const Align(
                                                            alignment:
                                                                Alignment.topLeft,
                                                            child: NormalText(
                                                              text:
                                                                  "Select Tax %",
                                                              textSize: 16,
                                                              textColor:
                                                                  kNeutral700,
                                                            ),
                                                          ),
                                                          DropdownButton<String>(
                                                            value: selectedTax,
                                                            isExpanded: true,
                                                            icon: const Icon(
                                                              Icons
                                                                  .arrow_drop_down_rounded,
                                                              size: 48,
                                                            ),
                                                            iconSize: 24,
                                                            elevation: 10,
                                                            onChanged: (String?
                                                                newValue) {
                                                              setState(() {
                                                                selectedTax =
                                                                    newValue;
                                                              });
                                                            },
                                                            items: <String>[
                                                              '5',
                                                              '12',
                                                              '18',
                                                              '24'
                                                            ].map<
                                                                DropdownMenuItem<
                                                                    String>>((String
                                                                value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child: NormalText(
                                                                  text: value,
                                                                  textSize: 16,
                                                                  textColor:
                                                                      kNeutral700,
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          generateInvoiceController
                                                              .dataList
                                                              .removeAt(index);
                                                        });
                                                        Get.back();
                                                      },
                                                      child: const NormalText(
                                                        text: "Delete",
                                                        textAlign:
                                                            TextAlign.center,
                                                        textFontWeight:
                                                            FontWeight.w500,
                                                        textSize: 16,
                                                        textColor:
                                                            kApplicationThemeColor,
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        if (_formKey.currentState!
                                                            .validate()) {
                                                          setState(() {
                                                            generateInvoiceController
                                                                .dataList
                                                                .replaceRange(
                                                                    index,
                                                                    index + 1, [
                                                              RxList<String>([
                                                                _productNameController
                                                                    .text,
                                                                _quantityController
                                                                    .text,
                                                                _unitPriceController
                                                                    .text,
                                                                selectedTax ?? '5'
                                                              ])
                                                            ]);
                                                          });
                                                          Get.back();
                                                        }
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            color:
                                                                kApplicationThemeColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: const NormalText(
                                                          text: "Update",
                                                          textAlign:
                                                              TextAlign.center,
                                                          textFontWeight:
                                                              FontWeight.w500,
                                                          textSize: 16,
                                                          textColor: kWhite,
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
                            );
                          })),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Button(
                          buttonWidth: MediaQuery.of(context).size.width * 0.43,
                          onPress: () async {
                            if (_customerNameController.text.isEmpty) {
                              errorToast(
                                  "Please enter the customer name", context);
                            } else if (_phoneNumberController.text.isEmpty ||
                                validatePhoneNumber(
                                        _phoneNumberController.text) ==
                                    false) {
                              errorToast(
                                  "Please enter valid phone number", context);
                            } else if(_customerGSTNController.text.isEmpty){
                              errorToast(
                                  "Please enter the custome GSTN", context);
                            }else if(_customerAddressController.text.isEmpty){
                              errorToast(
                                  "Please enter the custome Address", context);
                            }else if (generateInvoiceController
                                .dataList.isEmpty) {
                              errorToast(
                                  "Please add the products to genearate invoice",
                                  context);
                              //TODO: code for generating PDF
                            } else {
                              var invoicesNo = generateRandomInvoiceNumber(
                                  _phoneNumberController.text);

                              List<Map<String, dynamic>> formattedProductList =
                                  generateInvoiceController.dataList
                                      .map((product) {
                                return {
                                  'name': product[0],
                                  'quantity': product[1],
                                  'price': product[2],
                                  'tax': product[3]
                                };
                              }).toList();

                              double totalAmount = 0;
                              double totalAmountWithTax = 0;
                              bool interState = selectedOption == 'Inter State';

                              double totalTax = 0;

                              // Calculate total price for each product and sum up
                              for (var product in formattedProductList) {
                                double totalPrice =
                                    double.parse(product['price']) *
                                        double.parse(product['quantity']);
                                double taxAmount = totalPrice *
                                    (double.parse(product['tax']) / 100);
                                totalAmount += totalPrice.toPrecision(2);
                                totalTax += taxAmount.toPrecision(2);
                                print("Tax for ${product[0]}: ${taxAmount.toPrecision(2)}");
                              }

                              // Calculate total price for each product
                              for (var product in formattedProductList) {
                                double totalPrice =
                                    double.parse(product['price']) *
                                        double.parse(product['quantity']) *
                                        (1 + double.parse(product['tax']) / 100);
                                totalAmountWithTax += totalPrice.toPrecision(2);
                              }
                              var gstn = await CustomSharedPref.getPref(
                                  SharedPreferenceString.gstNumber);

                              final invoiceData = {
                                'gstn': gstn,
                                'customer_name': _customerNameController.text,
                                'customer_number': _phoneNumberController.text,
                                'invoice_date': DateFormat("MMMM d, y")
                                    .format(DateTime.now()),
                                'invoice_no': invoicesNo,
                                'total_before_tax': totalAmount.toPrecision(2),
                                'total_after_tax': totalAmountWithTax.toPrecision(2),
                                'tax_amount': totalTax.toPrecision(2),
                                'inter_state': interState,
                                "items": formattedProductList,
                                "customer_gstn":_customerGSTNController.text,
                                "customer_address":_customerAddressController.text,
                              };


                              final generator = InvoicePdfGenerator();
                              var clientName = await CustomSharedPref.getPref(
                                  SharedPreferenceString.clientName);
                              var clientAddress = await CustomSharedPref.getPref(
                                  SharedPreferenceString.clientAddress);
                              var phoneNumber = await CustomSharedPref.getPref(
                                  SharedPreferenceString.phoneNumber);
                              File pdfFile = await generator.generateInvoicePdf(
                                  clientName,
                                  '$clientAddress, \n Phone No:$phoneNumber, GST No: $gstn',
                                  invoiceData);

                              generateInvoiceController.setGeneratedPdf(pdfFile);
                              debugPrint('Invoice PDF generated at: $pdfFile');
                              debugPrint("invoiceData $invoiceData");

                              invoiceInfo.clear();
                              invoiceInfo.addAll(invoiceData);



                              if (generateInvoiceController.generatedPdf !=
                                  null) {
                                PDFDocument pdfDocument =
                                    await PDFDocument.fromFile(
                                        generateInvoiceController.generatedPdf!);
                                //show pdfviewer in dialog
                                await showDialog(
                                  context: context,
                                  builder: (context) => Stack(
                                    children: [
                                      PDFViewer(document: pdfDocument),
                                      Positioned(
                                        top: 15,
                                        left: 15,
                                        child: IconButton(
                                          icon: const Icon(Icons.close,
                                              color: kBlack, size: 24),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                          },
                          buttonText: "PDF Generator"),
                      Obx(() => Button(
                            buttonWidth: MediaQuery.of(context).size.width * 0.43,
                            onPress: () async{

                              if(!generateInvoiceController.isBusy){
                                if (generateInvoiceController.generatedPdf !=
                                    null) {

                                  bool isSuccess = await generateInvoiceController.sendInvoiceData(
                                      context,
                                      _customerGSTNController.text,
                                      _customerNameController.text,
                                      invoiceInfo['invoice_no'],
                                      _phoneNumberController.text,
                                      _customerAddressController.text,
                                      invoiceInfo['total_before_tax'],
                                      invoiceInfo['inter_state']==true?invoiceInfo['tax_amount'] / 2: 0,
                                      invoiceInfo['inter_state']==true?invoiceInfo['tax_amount'] / 2: 0,
                                      invoiceInfo['inter_state']==true?0:invoiceInfo['tax_amount']);

                                  if(isSuccess){
                                    generateInvoiceController.salesInvoiceUploadApi(
                                        context,
                                        generateInvoiceController.generatedPdf!,
                                        'example.pdf');

                                  }else{
                                    errorToast("Failed to Send data", context);
                                  }
                                } else {
                                  errorToast("Generate Invoice First", context);
                                }
                              }


                            },
                            buttonText: generateInvoiceController.isBusy?"Uploading...":"Upload PDF",
                            backgroundColor:
                                generateInvoiceController.generatedPdf == null
                                    ? kPrimary100
                                    : generateInvoiceController.isBusy? kPrimary100:kApplicationThemeColor,
                          )),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
