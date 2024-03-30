class ActivateUserRequestModel {
  final String? phone;
  final String? gstn;
  final String? securityAnswer;
  final String? password;
  final String? confirmPassword;

  ActivateUserRequestModel({
    this.phone,
    this.gstn,
    this.securityAnswer,
    this.password,
    this.confirmPassword,
  });

  ActivateUserRequestModel.fromJson(Map<String, dynamic> json)
      : phone = json['phone'] as String?,
        gstn = json['gstn'] as String?,
        securityAnswer = json['securityAnswer'] as String?,
        password = json['password'] as String?,
        confirmPassword = json['confirmPassword'] as String?;

  Map<String, dynamic> toJson() => {
    'phone' : phone,
    'gstn' : gstn,
    'securityAnswer' : securityAnswer,
    'password' : password,
    'confirmPassword' : confirmPassword
  };
}