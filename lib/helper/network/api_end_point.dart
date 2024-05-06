class ApiEndPoint {
  /// API Base URL.
  static const String baseUrl = 'https://dev-api.gstark.co';
  static const String loginApi = '/api/user/login';
  static const String validateApi = '/api/user/validate';
  static const String activateApi = '/api/user/activate';
  static const String resetPasswordApi = '/api/user/reset-password';
  static const String salesInvoiceListApi = '/api/document/list';
  static const String purchaseInvoiceListApi = '/api/document/list';

  static const String purchaseInvoiceImageUploadApi = 'https://dev-api.gstark.co/api/document';
  static const String salesInvoiceImageUploadApi = 'https://dev-api.gstark.co/api/document';
  //Reconciliation list
  static const String reconciliationListApi = 'https://dev-api.gstark.co/api/document';


  static const String updateUserDataApi = 'https://dev-api.gstark.co/api/user';


}