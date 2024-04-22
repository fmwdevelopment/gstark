class ActivateUserSuccessResponseModel {
  final Response? response;
  final bool? status;

  ActivateUserSuccessResponseModel({
    this.response,
    this.status,
  });

  ActivateUserSuccessResponseModel.fromJson(Map<String, dynamic> json)
      : response = (json['response'] as Map<String,dynamic>?) != null ? Response.fromJson(json['response'] as Map<String,dynamic>) : null,
        status = json['status'] as bool?;

  Map<String, dynamic> toJson() => {
    'response' : response?.toJson(),
    'status' : status
  };
}

class Response {
  final String? activate;

  Response({
    this.activate,
  });

  Response.fromJson(Map<String, dynamic> json)
      : activate = json['activate'] as String?;

  Map<String, dynamic> toJson() => {
    'activate' : activate
  };
}