import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gstark/screens/Home/home_screen.dart';
import 'package:gstark/screens/sales_invoice/sales_invoice_screen.dart';
import '../constants/shared_preference_string.dart';
import '../constants/string_constants.dart';
import '../helper/network/api_end_point.dart';
import '../helper/network/network_helper.dart';
import '../utils/internet_utils.dart';
import '../utils/shared_preference/custom_shared_preference.dart';
import '../utils/toast_utils/error_toast.dart';
import '../utils/toast_utils/success_toast.dart';
import 'package:http/http.dart' as http;
import 'package:gstark/helper/network/common_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:pdf_render/pdf_render.dart' as pdfRender;

class GenerateInvoiceController extends GetxController {
  RxList<RxList<String>> dataList = RxList<RxList<String>>();

  ApiService apiService = ApiService();

  final RxBool _isBusy = RxBool(false);

  bool get isBusy => _isBusy.value;

  setBusy(bool value) {
    _isBusy.value = value;
  }

  final Rxn<File> _generatedPdf = Rxn<File>();

  File? get generatedPdf => _generatedPdf.value;

  setGeneratedPdf(File value) {
    _generatedPdf.value = value;
  }

  Timer? uploadInvoiceApiCallTimer;

  salesInvoiceUploadApi(BuildContext context, File file, String fileName) {

    uploadInvoiceApiCall(context, file, fileName);

    uploadInvoiceApiCallTimer = Timer(const Duration(seconds: 30), () async {
      setBusy(false);
      errorToast(tryAgainAfterSomeTime, Get.overlayContext ?? context,
          isShortDurationText: false);
      uploadInvoiceApiCallTimer?.cancel();
      Get.to(const SalesInvoiceScreen(), transition: Transition.rightToLeft);
    });
  }


  uploadInvoiceApiCall(BuildContext context, File file, String fileName) async {
    setBusy(true);
    String authToken =
        await CustomSharedPref.getPref(SharedPreferenceString.authToken);
    String email = await CustomSharedPref.getPref(SharedPreferenceString.email);
    String userId =
        await CustomSharedPref.getPref<String>(SharedPreferenceString.clientId);

    bool isConnectedToInternet = await checkIsConnectedToInternet();
    if (isConnectedToInternet) {
      try {
        // Convert PDF to Image
        final pdfDocument = await pdfRender.PdfDocument.openFile(file.path);
        final page = await pdfDocument.getPage(1); // Get the first page
        final pageImage = await page.render(
          width: page.width.toInt(),
          height: page.height.toInt(),
        );
        final imageBytes = pageImage.pixels;

        // Convert the raw image to PNG
        final image = await pageImage.createImageIfNotAvailable();
        final pngBytes = await image.toByteData(format: ImageByteFormat.png);
        final imageList = pngBytes!.buffer.asUint8List();

        // Compress Image
        final compressedImageBytes =
            await FlutterImageCompress.compressWithList(
          imageList,
          quality: 95,
        );

        // Prepare API call
        String url = ApiEndPoint.uploadInvoicePdf;
        String token = 'Bearer $authToken';
        Map<String, String> headers = {'Authorization': token};
        Map<String, String> headers1 = {'x-header-token': email};

        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.headers.addAll(headers);
        request.headers.addAll(headers1);

        String mimeType =
            lookupMimeType(fileName.replaceAll('.pdf', '.jpg')) ?? 'image/jpeg';
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          compressedImageBytes,
          contentType: MediaType('image', mimeType.split('/')[1]),
          filename: fileName.replaceAll('.pdf', '.jpg'),
        ));
        request.fields["userId"] = userId;
        request.fields["type"] = "sale";
        request.fields["description"] = "sale";

        var response = await request.send();

        print('Status Code : ${response.statusCode}');
        print(response.stream.toString());

        response.stream.bytesToString().asStream().listen((event) async {
          var parsedJson = json.decode(event);

          if (response.statusCode == 200 || response.statusCode == 201) {
            uploadInvoiceApiCallTimer?.cancel();
            setBusy(false);
            successToast(
                descriptionText: ' Invoice Uploaded Successfully',
                context: context);

            Get.off(const HomeScreen(), transition: Transition.rightToLeft);
          } else if (response.statusCode == 400) {
            uploadInvoiceApiCallTimer?.cancel();

            CommonModel commonModel = CommonModel.fromJson(parsedJson);
            if (commonModel.response != null) {
              errorToast(commonModel.response!, Get.overlayContext ?? context);
            } else {
              uploadInvoiceApiCallTimer?.cancel();
              errorToast(somethingWentWrong, Get.overlayContext ?? context);
            }

            setBusy(false);
          } else if (response.statusCode == 401) {
            uploadInvoiceApiCallTimer?.cancel();
            await apiService.storeJwt(false);

            uploadInvoiceApiCall(Get.overlayContext ?? context, file, fileName);
            setBusy(false);
          } else {
            uploadInvoiceApiCallTimer?.cancel();
            errorToast(somethingWentWrong, context);
            setBusy(false);
          }
        });
      } catch (e) {
        debugPrint(e.toString());
        uploadInvoiceApiCallTimer?.cancel();
        setBusy(false);
        rethrow;
      }
    } else {
      uploadInvoiceApiCallTimer?.cancel();
      setBusy(false);
      errorToast(pleaseCheckYourInternetConnectivityAndTryAgain,
          Get.overlayContext ?? context);
      return false;
    }
  }

  //call before upload invoice
  Future<bool> sendInvoiceData(
      BuildContext context,
      String gst_number,
      String party_name,
      String invoice_number,
      String phone_number,
      String address,
      double taxable_value,
      double cgst,
      double sgst,
      double igst) async {
    setBusy(true);
    bool isConnectedToInternet = await checkIsConnectedToInternet();
    if (isConnectedToInternet) {
      try {
        String authToken =
            await CustomSharedPref.getPref(SharedPreferenceString.authToken);
        String email =
            await CustomSharedPref.getPref(SharedPreferenceString.email);
        String userId = await CustomSharedPref.getPref<String>(
            SharedPreferenceString.clientId);

        String token = 'Bearer $authToken';

        print("token111:$token");
        print("xheadertoken111:$email");
        print("user-id:$userId");

        var value = await apiService.post(
            ApiEndPoint.baseUrl + ApiEndPoint.sendInvoiceData,
            Get.overlayContext ?? context,
            body: {
              "gst_number": gst_number,
              "party_name": party_name,
              "invoice_number": invoice_number,
              "phone_number": phone_number,
              "address": address,
              "taxable_value": taxable_value,
              "cgst": cgst,
              "sgst": sgst,
              "igst": igst
            },
            headers: {
              'x-header-token': email,
              'Authorization': token,
              'Content-Type': "application/json",
            });

        if (value.statusCode == 200 || value.statusCode == 201) {
           setBusy(false);
           print("sent data");
           return true;
        } else {
          setBusy(false);
          return false;
        }
      } catch (e) {
        debugPrint(e.toString());
        setBusy(false);
        return false;
      }
    }else{
      return false;
    }
  }
}


// uploadInvoiceApiCall(BuildContext context, File file, String fileName) async {
//   setBusy(true);
//   String authToken = await CustomSharedPref.getPref(SharedPreferenceString.authToken);
//   String email = await CustomSharedPref.getPref(SharedPreferenceString.email);
//   String userId =
//       await CustomSharedPref.getPref<String>(SharedPreferenceString.clientId);
//
//   bool isConnectedToInternet = await checkIsConnectedToInternet();
//   if (isConnectedToInternet) {
//     try {
//       String url =  ApiEndPoint.uploadInvoicePdf;
//       String token = 'Bearer $authToken';
//
//       Map<String, String> headers = {'Authorization': token};
//       Map<String, String> headers1 = {'x-header-token': email};
//
//       var request = http.MultipartRequest('POST', Uri.parse(url));
//       request.headers.addAll(headers);
//       request.headers.addAll(headers1);
//
//       //request.files.add(await http.MultipartFile.fromPath("file", imagePath));
//       String imageType = getImageType(fileName);
//       request.files.add(http.MultipartFile.fromBytes(
//           'file', file.readAsBytesSync(),
//           contentType: MediaType('pdf', imageType), filename: fileName));
//       request.fields["userId"] = userId; //'c87fbc25-f168-4488-9f87-f0b08b5cb33c';
//       request.fields["type"] = "sale";
//       request.fields["description"] = "sale";
//
//       var response = await request.send();
//
//       print('Status Code : ${response.statusCode}');
//       print(response.stream.toString());
//
//       response.stream.bytesToString().asStream().listen((event) async {
//         var parsedJson = json.decode(event);
//
//         if (response.statusCode == 200 || response.statusCode == 201) {
//           uploadInvoiceApiCallTimer?.cancel();
//           setBusy(false);
//           successToast(
//               descriptionText: ' Invoice Uploaded Successfully',
//               context: context);
//
//           Get.off(const HomeScreen(), transition: Transition.rightToLeft);
//         } else if (response.statusCode == 400) {
//           uploadInvoiceApiCallTimer?.cancel();
//
//           CommonModel commonModel = CommonModel.fromJson(parsedJson);
//           if (commonModel.response != null) {
//             errorToast(commonModel.response!, Get.overlayContext ?? context);
//           } else {
//             uploadInvoiceApiCallTimer?.cancel();
//             errorToast(somethingWentWrong, Get.overlayContext ?? context);
//           }
//
//           setBusy(false);
//         } else if (response.statusCode == 401) {
//           uploadInvoiceApiCallTimer?.cancel();
//           await apiService.storeJwt(false);
//
//           uploadInvoiceApiCall(
//               Get.overlayContext ?? context, file, fileName);
//           setBusy(false);
//         } else {
//           uploadInvoiceApiCallTimer?.cancel();
//           errorToast(somethingWentWrong, context);
//           setBusy(false);
//         }
//       });
//     } catch (e) {
//       debugPrint(e.toString());
//       uploadInvoiceApiCallTimer?.cancel();
//       setBusy(false);
//       rethrow;
//     }
//   } else {
//     uploadInvoiceApiCallTimer?.cancel();
//     setBusy(false);
//     errorToast(pleaseCheckYourInternetConnectivityAndTryAgain,
//         Get.overlayContext ?? context);
//     return false;
//   }
// }
