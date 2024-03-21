class CommonModel {
  final String? response;

  CommonModel({
    this.response,
  });

  CommonModel.fromJson(Map<String, dynamic> json)
      : response = json['response'] as String?;

  Map<String, dynamic> toJson() => {'response': response};
}
