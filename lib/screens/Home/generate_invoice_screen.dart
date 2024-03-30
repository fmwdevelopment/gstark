import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../constants/app_colors.dart';
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(

            // isExtended: true,
            backgroundColor: kPrimaryMain,
            onPressed: () {
              print("pdf generator tapped");
            },
            // isExtended: true,
            child:  NormalText(
              text: "PDF",
              textAlign: TextAlign.center,
              textFontWeight: FontWeight.w500,
              textSize: 20,
              textColor: kWhite,
            ),
          ),
        ),
      appBar: AppBar(
        title: NormalText(
          text: "Generate Invoice",
          textAlign: TextAlign.center,
          textFontWeight: FontWeight.w500,
          textSize: 20,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: kPrimaryMain,
                borderRadius: BorderRadius.circular(10)
              ),
              child: TextButton(onPressed: (){

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('New product'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:[
                          TextField(
                            controller: _productNameController,
                            decoration: InputDecoration(labelText: 'Product Name'),
                          ),
                          TextField(
                            controller: _quantityController,
                            decoration: InputDecoration(labelText: 'Quantity'),
                          ),
                          TextField(
                            controller: _unitPriceController,
                            decoration: InputDecoration(labelText: 'Unit Price'),
                          ),
                          TextField(
                            controller: _taxController,
                            decoration: const InputDecoration(labelText: 'Tax(%)'),
                          ),
                        ],
                      ),
                      actions:[
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              }, child:  const NormalText(
                text: "Add Items",
                textAlign: TextAlign.center,
                textFontWeight: FontWeight.w500,
                textSize: 16,
                textColor: kWhite,
              ),),
            ),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
              BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 35, vertical: 10),
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
