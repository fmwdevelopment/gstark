import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import '../../constants/shared_preference_string.dart';
import '../../constants/string_constants.dart';
import '../../utils/shared_preference/custom_shared_preference.dart';
import '../../utils/toast_utils/error_toast.dart';
import 'common_model.dart';
import 'config.dart';


class ApiService {
  ApiService();

  late String jwt;
  Map<String, String> defaultHeaders = {
    'Content-Type': "application/json",
  };

  storeJwt(bool isDesktopView) async {
    /// Store the token in shared preferences.
  }

  getJwt(bool isDesktopView) async {
    String idToken = await CustomSharedPref.getPref<String>(
        SharedPreferenceString.authToken);

    addHeader({'authorization': "Bearer $idToken"});
  }

  addHeader(Map<String, String> header) {
    defaultHeaders.addAll(header);
  }

  Future<NetworkResponse> get(String url, BuildContext context,
      {Map<String, String>? headers,
      Map<String, String>? qParams,
      bool isShowDialogForFailure = false,
      bool isDesktopView = true}) async {
    try {
      await getJwt(isDesktopView);
      if (headers != null) {
        headers.addAll(defaultHeaders);
      }

      Uri uri = Uri.parse(url);
      final finalUri = uri.replace(queryParameters: qParams);
      final http.Response response =
          await http.get(finalUri, headers: headers ?? defaultHeaders).timeout(
        const Duration(seconds: Config.timeoutSeconds),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Replace 500 with your http code.
        },
      );
      log("status code: ${response.statusCode}");
      log("on $url \n response: ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
            response: jsonDecode(utf8.decode(response.bodyBytes)),
            statusCode: response.statusCode);
      }
      if (response.statusCode == 400) {
        CommonModel commonResponse =
            CommonModel.fromJson(jsonDecode(response.body));
        if (commonResponse.response != null) {
          errorToast(commonResponse.response!, Get.overlayContext ?? context,
              isShortDurationText: false);
        } else {
          errorToast(somethingWentWrong, Get.overlayContext ?? context);
        }
        throw Exception("Bad Request");
      }
      if (response.statusCode == 409) {
        CommonModel commonResponse =
            CommonModel.fromJson(jsonDecode(response.body));
        if (commonResponse.response != null) {
          throw Exception(commonResponse.response!);
        } else {
          throw Exception(somethingWentWrong);
        }
      }
      if (response.statusCode == 401 || response.statusCode == 400) {
        await storeJwt(isDesktopView);
        throw Exception("Unauthorized");
      }
      if (response.statusCode == 404) {
        throw Exception("Not Found");
      }
      if (response.statusCode == 500) {
        throw Exception("Internal Server Error");
      }

      if (response.statusCode == 408) {
        throw Exception("Try after some time");
      }
      if (response.statusCode == 403) {
        // handles for accounting non finance user "Something went wrong issue"
        return NetworkResponse(
            response: jsonDecode(utf8.decode(response.bodyBytes)),
            statusCode: response.statusCode);
      }

      throw Exception("Something went wrong");
    } on SocketException catch (_) {
      errorToast(pleaseCheckYourInternetConnectivityAndTryAgain,
          Get.overlayContext ?? context);
      throw Exception('Not connected. Failed to load data');
    } catch (e) {
      /// If isShowDialogForFailure is true, no need to display the error toast, since will be displaying the error dialog instead.
      if (!isShowDialogForFailure) {
        if (e.toString().contains("Try after some time")) {
          errorToast('Try after some time', Get.overlayContext ?? context);
        }

        if (e.toString().contains("Unauthorized")) {
          // errorToast(reLogin, Get.overlayContext ?? context);
        } else if (e.toString().contains("Bad Request")) {
        } else {
          errorToast(somethingWentWrong, Get.overlayContext ?? context);
        }
      }

      rethrow;
    }
  }

  Future<NetworkResponse> getWithoutToken(String url, BuildContext context,
      {Map<String, String>? headers,
      Map<String, String>? qParams,
      bool isShowDialogForFailure = false,
      bool isDesktopView = true}) async {
    try {
      final http.Response response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: Config.timeoutSeconds),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Replace 500 with your http code.
        },
      );
      log("status code: ${response.statusCode}");
      log("on $url \n response: ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
            response: jsonDecode(utf8.decode(response.bodyBytes)),
            statusCode: response.statusCode);
      }
      if (response.statusCode == 400) {
        CommonModel commonResponse =
            CommonModel.fromJson(jsonDecode(response.body));
        if (commonResponse.response != null) {
          errorToast(commonResponse.response!, Get.overlayContext ?? context,
              isShortDurationText: false);
        } else {
          errorToast(somethingWentWrong,
              Get.overlayContext ?? Get.overlayContext ?? context);
        }
        throw Exception("Bad Request");
      }
      if (response.statusCode == 409) {
        CommonModel commonResponse =
            CommonModel.fromJson(jsonDecode(response.body));
        if (commonResponse.response != null) {
          throw Exception(commonResponse.response!);
        } else {
          throw Exception(somethingWentWrong);
        }
      }
      if (response.statusCode == 401 || response.statusCode == 400) {
        await storeJwt(isDesktopView);
        throw Exception("Unauthorized");
      }
      if (response.statusCode == 404) {
        throw Exception("Not Found");
      }
      if (response.statusCode == 500) {
        throw Exception("Internal Server Error");
      }

      if (response.statusCode == 408) {
        throw Exception("Try after some time");
      }

      throw Exception("Something went wrong");
    } on SocketException catch (_) {
      errorToast(pleaseCheckYourInternetConnectivityAndTryAgain,
          Get.overlayContext ?? context);
      throw Exception('Not connected. Failed to load data');
    } catch (e) {
      /// If isShowDialogForFailure is true, no need to display the error toast, since will be displaying the error dialog instead.
      if (!isShowDialogForFailure) {
        if (e.toString().contains("Try after some time")) {
          errorToast('Try after some time', Get.overlayContext ?? context);
        }

        if (e.toString().contains("Unauthorized")) {
          // errorToast(reLogin, Get.overlayContext ?? context);
        } else if (e.toString().contains("Bad Request")) {
        } else {
          errorToast(somethingWentWrong, Get.overlayContext ?? context);
        }
      }

      rethrow;
    }
  }

  Future<NetworkResponse> patch(String url, BuildContext context,
      {required Map<String, dynamic> body,
      Map<String, String>? headers,
      Encoding? encoding,
      bool isShowDialogForFailure = false,
      bool isDesktopView = true}) async {
    try {
      await getJwt(isDesktopView);
      if (headers != null) {
        headers.addAll(defaultHeaders);
      }

      final http.Response response = await http
          .patch(Uri.parse(url),
              body: jsonEncode(body),
              headers: headers ?? defaultHeaders,
              encoding: encoding)
          .timeout(
        const Duration(seconds: Config.timeoutSeconds),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Replace 500 with your http code.
        },
      );
      log("status code: ${response.statusCode}");
      log("$body");
      log("on $url \n response: ${response.body}");
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        return NetworkResponse(
            response: jsonDecode(response.body),
            statusCode: response.statusCode);
      }
      if (response.statusCode == 400) {
        CommonModel commonResponse =
            CommonModel.fromJson(jsonDecode(response.body));
        if (commonResponse.response != null) {
          errorToast(commonResponse.response!, Get.overlayContext ?? context,
              isShortDurationText: false);
        } else {
          errorToast(somethingWentWrong, Get.overlayContext ?? context);
        }

        throw Exception("Bad Request");
      }
      if (response.statusCode == 409) {
        CommonModel commonResponse =
            CommonModel.fromJson(jsonDecode(response.body));
        if (commonResponse.response != null) {
          throw Exception(commonResponse.response!);
        } else {
          throw Exception(somethingWentWrong);
        }
      }
      if (response.statusCode == 401 || response.statusCode == 400) {
        await storeJwt(isDesktopView);
        throw Exception("Unauthorized");
      }
      if (response.statusCode == 404) {
        // throw Exception(jsonDecode(response.body));
        CommonModel commonResponse =
            CommonModel.fromJson(jsonDecode(response.body));
        if (commonResponse.response != null) {
          errorToast(commonResponse.response!, Get.overlayContext ?? context,
              isShortDurationText: false);
        } else {
          errorToast(somethingWentWrong, Get.overlayContext ?? context);
        }
        throw Exception("Not Found");
      }
      if (response.statusCode == 500) {
        throw Exception("Internal Server Error");
      }
      if (response.statusCode == 504) {
        throw Exception("Bad Gateway");
      }
      if (response.statusCode == 408) {
        throw Exception("Try after some time");
      }
      throw Exception("Something went wrong");
    } on SocketException catch (_) {
      errorToast(pleaseCheckYourInternetConnectivityAndTryAgain,
          Get.overlayContext ?? context);
      throw Exception('Not connected. Failed to load data');
    } catch (e) {
      /// If isShowDialogForFailure is true, no need to display the error toast, since will be displaying the error dialog instead.
      if (!isShowDialogForFailure) {
        if (e.toString().contains("Try after some time")) {
          errorToast('Try after some time', Get.overlayContext ?? context);
        }
        if (e.toString().contains("Unauthorized")) {
          // errorToast(reLogin, Get.overlayContext ?? context);
        } else if (e.toString().contains("Not Found") ||
            e.toString().contains("Bad Request")) {
        } else {
          errorToast(somethingWentWrong, Get.overlayContext ?? context);
        }
      }
      rethrow;
    }
  }

  Future<NetworkResponse> post(String url, BuildContext context,
      {required Map<String, dynamic> body,
      Map<String, String>? headers,
      Encoding? encoding,
      bool isShowDialogForFailure = false,
      bool isDesktopView = true}) async {
    try {
      await getJwt(isDesktopView);
      if (headers != null) {
        headers.addAll(defaultHeaders);
      }

      final http.Response response = await http
          .post(Uri.parse(url),
              body: jsonEncode(body),
              headers: headers ?? defaultHeaders,
              encoding: encoding)
          .timeout(
        const Duration(seconds: Config.timeoutSeconds),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Replace 500 with your http code.
        },
      );
      log("status code: ${response.statusCode}");
      log("$body");
      log("on $url \n response: ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
            response: jsonDecode(response.body),
            statusCode: response.statusCode);
      }
      if (response.statusCode == 400) {
        CommonModel commonResponse =
            CommonModel.fromJson(jsonDecode(response.body));
        if (commonResponse.response != null) {
          errorToast(commonResponse.response!, Get.overlayContext ?? context,
              isShortDurationText: false);
        } else {
          errorToast(somethingWentWrong, Get.overlayContext ?? context);
        }

        throw Exception("Bad Request");
      }
      if (response.statusCode == 409) {
        CommonModel commonResponse =
            CommonModel.fromJson(jsonDecode(response.body));
        if (commonResponse.response != null) {
          throw Exception(commonResponse.response!);
        } else {
          throw Exception(somethingWentWrong);
        }
      }
      if (response.statusCode == 401 || response.statusCode == 400) {
        await storeJwt(isDesktopView);
        throw Exception("Unauthorized");
      }
      if (response.statusCode == 404) {
        // throw Exception(jsonDecode(response.body));
        CommonModel commonResponse =
            CommonModel.fromJson(jsonDecode(response.body));
        if (commonResponse.response != null) {
          errorToast(commonResponse.response!, Get.overlayContext ?? context,
              isShortDurationText: false);
        } else {
          errorToast(somethingWentWrong, Get.overlayContext ?? context);
        }
        throw Exception("Not Found");
      }
      if (response.statusCode == 500) {
        throw Exception("Internal Server Error");
      }
      if (response.statusCode == 504) {
        throw Exception("Bad Gateway");
      }
      if (response.statusCode == 408) {
        throw Exception("Try after some time");
      }
      throw Exception("Something went wrong");
    } on SocketException catch (_) {
      errorToast(pleaseCheckYourInternetConnectivityAndTryAgain,
          Get.overlayContext ?? context);
      throw Exception('Not connected. Failed to load data');
    } catch (e) {
      /// If isShowDialogForFailure is true, no need to display the error toast, since will be displaying the error dialog instead.
      if (!isShowDialogForFailure) {
        if (e.toString().contains("Try after some time")) {
          errorToast('Try after some time', Get.overlayContext ?? context);
        }
        if (e.toString().contains("Unauthorized")) {
          // errorToast(reLogin, Get.overlayContext ?? context);
        } else if (e.toString().contains("Not Found") ||
            e.toString().contains("Bad Request")) {
        } else {
          errorToast(somethingWentWrong, Get.overlayContext ?? context);
        }
      }
      rethrow;
    }
  }

  Future<NetworkResponse> put(String url, BuildContext context,
      {required Map<String, dynamic> body,
      Map<String, String>? headers,
      bool isDesktopView = true}) async {
    try {
      await getJwt(isDesktopView);
      if (headers != null) {
        headers.addAll(defaultHeaders);
      }

      final http.Response response = await http
          .put(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: headers ?? defaultHeaders,
      )
          .timeout(
        const Duration(seconds: Config.timeoutSeconds),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Replace 500 with your http code.
        },
      );

      log("status code: ${response.statusCode}");
      log("$body");
      log("on $url \n response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
            response: jsonDecode(response.body),
            statusCode: response.statusCode);
      }
      if (response.statusCode == 400) {
        CommonModel commonResponse =
            CommonModel.fromJson(jsonDecode(response.body));
        if (commonResponse.response != null) {
          errorToast(commonResponse.response!, Get.overlayContext ?? context,
              isShortDurationText: false);
        } else {
          errorToast(somethingWentWrong, Get.overlayContext ?? context);
        }
        throw Exception("Bad Request");
      }
      if (response.statusCode == 401) {
        await storeJwt(isDesktopView);
        throw Exception("Unauthorized");
      }
      if (response.statusCode == 404) {
        throw Exception("Not Found");
      }
      if (response.statusCode == 500) {
        throw Exception("Internal Server Error");
      }
      if (response.statusCode == 504) {
        throw Exception("Bad Gateway");
      }
      if (response.statusCode == 408) {
        throw Exception("Try after some time");
      }
      throw Exception("Something went wrong");
    } on SocketException catch (_) {
      errorToast(pleaseCheckYourInternetConnectivityAndTryAgain,
          Get.overlayContext ?? context);
      throw Exception('Not connected. Failed to load data');
    } catch (e) {
      if (e.toString().contains("Try after some time")) {
        errorToast('Try after some time', Get.overlayContext ?? context);
      }

      if (e.toString().contains("Unauthorized")) {
        // errorToast(reLogin, Get.overlayContext ?? context);
      } else if (e.toString().contains("Bad Request")) {
      } else {
        errorToast(somethingWentWrong, Get.overlayContext ?? context);
      }

      rethrow;
    }
  }

  Future<NetworkResponse> delete(String url, BuildContext context,
      {required Map<String, dynamic> body,
      Map<String, String>? headers,
      bool isDesktopView = true}) async {
    try {
      await getJwt(isDesktopView);
      if (headers != null) {
        headers.addAll(defaultHeaders);
      }

      final http.Response response = await http
          .delete(Uri.parse(url),
              body: jsonEncode(body), headers: headers ?? defaultHeaders)
          .timeout(
        const Duration(seconds: Config.timeoutSeconds),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Replace 500 with your http code.
        },
      );

      log("status code: ${response.statusCode}");
      log("$body");
      log("on $url \n response: ${response.body}");
      //todo: need to update in other projects.
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return NetworkResponse(
            response: jsonDecode(response.body),
            statusCode: response.statusCode);
      }
      if (response.statusCode == 400) {
        return NetworkResponse(
            response: jsonDecode(response.body),
            statusCode: response.statusCode);
      }
      if (response.statusCode == 400 || response.statusCode == 409) {
        CommonModel commonResponse =
            CommonModel.fromJson(jsonDecode(response.body));
        if (commonResponse.response != null) {
          errorToast(commonResponse.response!, Get.overlayContext ?? context,
              isShortDurationText: false);
        } else {
          errorToast(somethingWentWrong, Get.overlayContext ?? context);
        }
        throw Exception("Bad Request");
      }
      if (response.statusCode == 404) {
        throw Exception("Not Found");
      }
      if (response.statusCode == 401) {
        await storeJwt(isDesktopView);
        throw Exception("Unauthorized");
      }
      if (response.statusCode == 500) {
        throw Exception("Internal Server Error");
      }
      if (response.statusCode == 504) {
        throw Exception("Bad Gateway");
      }
      if (response.statusCode == 408) {
        throw Exception("Try after some time");
      }
      throw Exception("Something went wrong");
    } on SocketException catch (_) {
      errorToast(pleaseCheckYourInternetConnectivityAndTryAgain,
          Get.overlayContext ?? context);
      throw Exception('Not connected. Failed to load data');
    } catch (e) {
      if (e.toString().contains("Try after some time")) {
        errorToast('Try after some time', Get.overlayContext ?? context);
      }

      if (e.toString().contains("Unauthorized")) {
        // errorToast(reLogin, Get.overlayContext ?? context);
      } else if (e.toString().contains("Bad Request")) {
      } else {
        errorToast(somethingWentWrong, Get.overlayContext ?? context);
      }
      rethrow;
    }
  }

  Future<http.Response> getDownloadAll(String url,
      {Map<String, String>? headers,
      Map<String, String>? qParams,
      bool isShowDialogForFailure = false,
      bool isDesktopView = true}) async {
    try {
      await getJwt(isDesktopView);
      if (headers != null) {
        headers.addAll(defaultHeaders);
      }
      Uri uri = Uri.parse(url);

      final finalUri = uri.replace(queryParameters: qParams);
      final http.Response response =
          await http.get(finalUri, headers: headers ?? defaultHeaders).timeout(
        const Duration(seconds: Config.timeoutSeconds),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Replace 500 with your http code.
        },
      );
      log("status code: ${response.statusCode}");
      log("on $url \n response: ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      }
      if (response.statusCode == 400) {}
      if (response.statusCode == 401) {
        await storeJwt(isDesktopView);
        throw Exception("Unauthorized");
      }
      if (response.statusCode == 404) {
        throw Exception("Not Found");
      }
      if (response.statusCode == 500) {
        throw Exception("Internal Server Error");
      }

      if (response.statusCode == 408) {
        throw Exception("Try after some time");
      }
      throw Exception("Something went wrong");
    } catch (e) {
      if (e.toString().contains("Try after some time")) {}

      if (e.toString().contains("Unauthorized")) {
      } else if (e.toString().contains("Bad Request")) {
      } else {}

      rethrow;
    }
  }

  Future<http.Response> postDownload(String url,
      {required Map<String, dynamic> body,
      Map<String, String>? headers,
      Encoding? encoding,
      bool isDesktopView = true}) async {
    try {
      await getJwt(isDesktopView);
      if (headers != null) {
        headers.addAll(defaultHeaders);
      }

      final http.Response response = await http
          .post(Uri.parse(url),
              body: jsonEncode(body),
              headers: headers ?? defaultHeaders,
              encoding: encoding)
          .timeout(
        const Duration(seconds: Config.timeoutSeconds),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Replace 500 with your http code.
        },
      );
      log("status code: ${response.statusCode}");
      log("$body");
      log("on $url \n response: ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      }
      if (response.statusCode == 400) {
        throw Exception("Bad Request");
      }
      if (response.statusCode == 401) {
        await storeJwt(isDesktopView);
        throw Exception("Unauthorized");
      }
      if (response.statusCode == 404) {
        throw Exception("Not Found");
      }
      if (response.statusCode == 500) {
        throw Exception("Internal Server Error");
      }
      if (response.statusCode == 504) {
        throw Exception("Bad Gateway");
      }
      if (response.statusCode == 408) {
        throw Exception("Try after some time");
      }
      throw Exception("Something went wrong");
    } catch (e) {
      if (e.toString().contains("Try after some time")) {}
      if (e.toString().contains("Unauthorized")) {
      } else if (e.toString().contains("Not Found") ||
          e.toString().contains("Bad Request")) {
      } else {}

      rethrow;
    }
  }

  Future<NetworkResponse> postMultipart(String url, BuildContext context,
      {Map<String, String>? headers,
      bool isShowDialogForFailure = false,
      required List<FileDetails> filesList,
      required List<FieldDetails> fieldsList,
      bool isDesktopView = true}) async {
    try {
      await getJwt(isDesktopView);
      if (headers != null) {
        headers.addAll(defaultHeaders);
      }

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers ?? defaultHeaders);

      if (filesList.isNotEmpty) {
        for (FileDetails fileDetails in filesList) {
          request.files.add(http.MultipartFile.fromBytes(
              fileDetails.parameterName, fileDetails.file,
              filename: fileDetails.fileName));
        }
      }
      if (fieldsList.isNotEmpty) {
        for (FieldDetails fieldDetails in fieldsList) {
          request.fields[fieldDetails.parameterName] =
              fieldDetails.parameterValue;
        }
      }

      var response = await request.send();
      log("status code: ${response.statusCode}");

      response.stream.bytesToString().asStream().listen((event) async {
        var parsedJson = json.decode(event);

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('parsedJson $parsedJson');
          print('status code ${response.statusCode}');

          NetworkResponse(
              response: parsedJson, statusCode: response.statusCode);
        } else if (response.statusCode == 400) {
          CommonModel commonResponse = CommonModel.fromJson(parsedJson);
          if (commonResponse.response != null) {
            errorToast(commonResponse.response!, Get.overlayContext ?? context,
                isShortDurationText: false);
          } else {
            errorToast(somethingWentWrong, Get.overlayContext ?? context);
          }

          throw Exception("Bad Request");
        }

        if (response.statusCode == 409) {
          CommonModel commonResponse = CommonModel.fromJson(parsedJson);
          if (commonResponse.response != null) {
            throw Exception(commonResponse.response!);
          } else {
            throw Exception(somethingWentWrong);
          }
        }
        if (response.statusCode == 401 || response.statusCode == 400) {
          await storeJwt(isDesktopView);
          throw Exception("Unauthorized");
        }
        if (response.statusCode == 404) {
          CommonModel commonResponse = CommonModel.fromJson(parsedJson);
          if (commonResponse.response != null) {
            errorToast(commonResponse.response!, Get.overlayContext ?? context,
                isShortDurationText: false);
          } else {
            errorToast(somethingWentWrong, Get.overlayContext ?? context);
          }
          throw Exception("Not Found");
        }
        if (response.statusCode == 500) {
          throw Exception("Internal Server Error");
        }
        if (response.statusCode == 504) {
          throw Exception("Bad Gateway");
        }
        if (response.statusCode == 408) {
          throw Exception("Try after some time");
        }
        throw Exception("Something went wrong");
      });
      throw Exception("Something went wrong");
    } on SocketException catch (_) {
      errorToast(pleaseCheckYourInternetConnectivityAndTryAgain,
          Get.overlayContext ?? context);
      throw Exception('Not connected. Failed to load data');
    } catch (e) {
      print('exception nandish $e');

      /// If isShowDialogForFailure is true, no need to display the error toast, since will be displaying the error dialog instead.
      if (!isShowDialogForFailure) {
        if (e.toString().contains("Try after some time")) {
          errorToast('Try after some time', Get.overlayContext ?? context);
        }
        if (e.toString().contains("Unauthorized")) {
          // errorToast(reLogin, Get.overlayContext ?? context);
        } else if (e.toString().contains("Not Found") ||
            e.toString().contains("Bad Request")) {
        } else {
          errorToast(somethingWentWrong, Get.overlayContext ?? context);
        }
      }
      rethrow;
    }
  }
}

class FileDetails {
  final String parameterName;
  final List<int> file;
  final String fileName;

  FileDetails({
    required this.parameterName,
    required this.file,
    required this.fileName,
  });
}

class FieldDetails {
  final String parameterName;
  final String parameterValue;

  FieldDetails({
    required this.parameterName,
    required this.parameterValue,
  });
}

class NetworkResponse {
  final dynamic response;
  final int statusCode;

  NetworkResponse({
    required this.response,
    required this.statusCode,
  });
}
