import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../helper/network/network_helper.dart';
class ProfileScreenController extends GetxController {
  ApiService apiService = ApiService();

  final RxBool _isBusy = RxBool(false);

  bool get isBusy => _isBusy.value;

  setBusy(bool value) {
    _isBusy.value = value;
  }

  final RxString  _reviewerId = RxString("");

  String get reviewerId => _reviewerId.value;

  setReviewerId(String value) {
    _reviewerId.value = value;
  }

  final RxString  _phoneNumber = RxString("");

  String get phoneNumber => _phoneNumber.value;

  setPhoneNumber(String value) {
    _phoneNumber.value = value;
  }

  final RxString  _gstn = RxString("");

  String get gstn => _gstn.value;

  setGSTN(String value) {
    _gstn.value = value;
  }

  final RxString  _email = RxString("");

  String get email => _email.value;

  setEmail(String value) {
    _email.value = value;
  }

  final RxString  _clientId = RxString("");

  String get clientId => _clientId.value;

  setClientId(String value) {
    _clientId.value = value;
  }

  final RxString  _clientName = RxString("");

  String get clientName => _clientName.value;

  setClientName(String value) {
    _clientName.value = value;
  }

  final RxString  _clientAddress = RxString("");

  String get clientAddress => _clientAddress.value;

  setClientAddress(String value) {
    _clientAddress.value = value;
  }

}