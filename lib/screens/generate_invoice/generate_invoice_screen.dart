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
import '../../utils/invoice_pdf_generator.dart';
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
            onPressed: () async {
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

                List<Map<String, dynamic>> formattedProductList = generateInvoiceController.dataList.map((product) {
                  return {
                    'name': product[0],
                    'quantity': product[1],
                    'price': product[2],
                    'tax': product[3]
                  };
                }).toList();

                double overallTotal = 0;
                double overallTotalWithTax = 0;

                // Calculate total price for each product without tax and sum up
                for (var product in formattedProductList) {
                  double totalPrice =  double.parse(product['price']) * double.parse(product['quantity']);
                  overallTotal += totalPrice;
                }

                // Calculate total price for each product
                for (var product in formattedProductList) {
                  double totalPrice = double.parse(product['price']) * double.parse(product['quantity']) * (1 + double.parse(product['tax']) / 100);
                  overallTotalWithTax += totalPrice;
                }

                //total tax
                var totalTax = overallTotal * (double.parse(_taxController.text) / 100);

                final invoiceData = {
                  'customer_name': _customerNameController.text,
                  'customer_address': _phoneNumberController.text,
                  'invoice_date': DateFormat("MMMM d, y").format(DateTime.now()),
                  'invoice_no': inoviceNo,
                  'total_before_tax': overallTotal,
                  'total_tax': _taxController.text,
                  'total_after_tax': overallTotalWithTax,
                  'tax_amount':totalTax,
                  "items":formattedProductList

                  // "customer_name":_customerNameController.text,
                  // "customer_address":inoviceNo,
                  // "inoviceAddress":_phoneNumberController.text,
                  // "cgst":double.parse(_taxController.text)/2,
                  // "sgst":double.parse(_taxController.text)/2,
                  // "salesDate": DateFormat("MMMM d, y").format(DateTime.now()),
                  // "productData":generateInvoiceController.dataList,

                };

                // final invoiceData = {
                //   'customer_name': 'John Doe',
                //   'customer_address': '123 Main St',
                //   'invoice_date': 'Mar 27, 2024',
                //   'invoice_no': '6884876403',
                //   'total_before_tax': 100.00,
                //   'total_tax': 18.00,
                //   'total_after_tax': 118.00,
                //   'items': [
                //     {
                //       'name': 'Product A',
                //       'quantity': 2,
                //       'price': 25.00,
                //       'tax': 18
                //     },
                //     {
                //       'name': 'Product B',
                //       'quantity': 1,
                //       'price': 50.00,
                //       'tax': 18
                //     },
                //     {
                //       'name': 'Product C',
                //       'quantity': 3,
                //       'price': 15.00,
                //       'tax': 5
                //     },
                //   ]
                // };

                final generator = InvoicePdfGenerator();
                final filePath = await generator.generateInvoicePdf(
                    'Apollo Pharmaceutical Lab. LTD.',
                    'Central Sales Depo: Plot # 11, Block # Ka, Main Road-1, Section # 6, Mirpur, Dhaka 1216, Bangladesh\nTel:- +88 02 9030747, 9001794, 9025719, Fax:- +88 02 900 713\nMobile:- 01711-697995',
                    invoiceData);

                print('Invoice PDF generated at: $filePath');

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
                                  print(generateInvoiceController.dataList);
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
