class ApiEndPoint {
  /// API Base URL.
  //static const String baseUrl = 'https://dev-api.gstark.co';
  static const String baseUrl = 'https://gstark-service-prod-77msy75epq-uc.a.run.app';

  static const String loginApi = '/api/user/login';
  static const String validateApi = '/api/user/validate';
  static const String activateApi = '/api/user/activate';
  static const String resetPasswordApi = '/api/user/reset-password';
  static const String salesInvoiceListApi = '/api/document/list';
  static const String purchaseInvoiceListApi = '/api/document/list';
  static const String gstReturnsListApi = '/api/document/list';
  static const String reconciliationListApi = '/api/document/list';

  static const String purchaseInvoiceImageUploadApi = '/api/document';
  static const String salesInvoiceImageUploadApi = '/api/document';
  static const String updateUserDataApi = '/api/user';

  static const String sendInvoiceData = '/api/invoice';
  static const String uploadInvoicePdf = '/api/document';

}