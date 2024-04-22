import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/app_colors.dart';
import '../../constants/string_constants.dart';
import '../../controller/sales_invoice_image_upload_screen_controller.dart';
import '../../utils/text_utils/normal_text.dart';
import '../../widgets/button.dart';
import 'image_upload_screen_loader.dart';

class SalesInvoiceImageUploadScreen extends StatefulWidget {
  const SalesInvoiceImageUploadScreen({super.key});

  @override
  State<SalesInvoiceImageUploadScreen> createState() =>
      _SalesInvoiceImageUploadScreenState();
}

class _SalesInvoiceImageUploadScreenState
    extends State<SalesInvoiceImageUploadScreen> {
  late final SalesInvoiceImageUploadScreenController
      salesInvoiceImageUploadScreenController;

  @override
  void initState() {
    super.initState();

    salesInvoiceImageUploadScreenController =
        Get.isRegistered<SalesInvoiceImageUploadScreenController>()
            ? Get.find<SalesInvoiceImageUploadScreenController>()
            : Get.put(SalesInvoiceImageUploadScreenController());

    salesInvoiceImageUploadScreenController.setIsImageCaptured(false);
  }

  File? _image;
  String imageName = '';
  String imagePath = '';
  final picker = ImagePicker();

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imageName = pickedFile.name;
        imagePath = pickedFile.path;
        salesInvoiceImageUploadScreenController.setIsImageCaptured(true);
      }
    });
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imageName = pickedFile.name;
        imagePath = pickedFile.path;
        salesInvoiceImageUploadScreenController.setIsImageCaptured(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kApplicationThemeColor,
        iconTheme: const IconThemeData(color: kWhite),
        title: const NormalText(
          text: uploadSalesInvoice,
          textAlign: TextAlign.center,
          textFontWeight: FontWeight.w500,
          textSize: 20,
          textColor: kWhite,
        ),
        centerTitle: true,
      ),
      body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Obx(
            () => salesInvoiceImageUploadScreenController.isBusy
                ? const ImageUploadScreenLoader()
                : (salesInvoiceImageUploadScreenController.isImageCaptured &&
                        _image != null)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: InteractiveViewer(
                              panEnabled: false, // Set it to false
                              boundaryMargin: const EdgeInsets.all(0),
                              minScale: 0.5,
                              maxScale: 5,
                              child: Image.file(_image!),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Button(
                            buttonText: chooseDifferent,
                            fontSize: 18,
                            buttonWidth: MediaQuery.of(context).size.width,
                            backgroundColor: kError.withOpacity(.85),
                            borderColor: kError.withOpacity(.85),
                            onPress: () {
                              salesInvoiceImageUploadScreenController
                                  .setIsImageCaptured(false);
                              _image = null;
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Button(
                            buttonText: uploadBill,
                            fontSize: 18,
                            buttonWidth: MediaQuery.of(context).size.width,
                            backgroundColor: kApplicationThemeColor,
                            borderColor: kApplicationThemeColor,
                            onPress: () =>
                                salesInvoiceImageUploadScreenController
                                    .salesInvoiceUploadApi(
                                        context, _image!, imageName, imagePath),
                          ),
                          const SizedBox(
                            height: 30,
                          )
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const NormalText(
                            text: captureSalesBill,
                            textSize: 25,
                            textFontWeight: FontWeight.bold,
                          ),
                          const Icon(
                            Icons.photo,
                            color: kNeutral300,
                            size: 300,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const NormalText(
                            text: chooseTheBillFromGalleryOrCaptureFromCamera,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Button(
                            buttonText: cameraString,
                            fontSize: 18,
                            buttonWidth: MediaQuery.of(context).size.width,
                            backgroundColor: kApplicationThemeColor,
                            borderColor: kApplicationThemeColor,
                            onPress: () => getImageFromCamera(),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Button(
                            buttonText: photoGallery,
                            fontSize: 18,
                            buttonWidth: MediaQuery.of(context).size.width,
                            backgroundColor: kApplicationThemeColor,
                            borderColor: kApplicationThemeColor,
                            onPress: () => getImageFromGallery(),
                          )
                        ],
                      ),
          )),
    );
  }
}
