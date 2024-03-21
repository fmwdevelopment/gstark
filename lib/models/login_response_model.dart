class LoginResponseModel {
  final Response? response;
  final bool? status;

  LoginResponseModel({
    this.response,
    this.status,
  });

  LoginResponseModel.fromJson(Map<String, dynamic> json)
      : response = (json['response'] as Map<String,dynamic>?) != null ? Response.fromJson(json['response'] as Map<String,dynamic>) : null,
        status = json['status'] as bool?;

  Map<String, dynamic> toJson() => {
    'response' : response?.toJson(),
    'status' : status
  };
}

class Response {
  final String? reviewerId;
  final String? phone;
  final String? gstn;
  final List<Permissions>? permissions;
  final String? name;
  final String? createdAt;
  final String? id;
  final String? type;
  final String? email;
  final String? password;
  final String? securityAnswer;
  final String? updatedAt;
  final bool? active;
  final String? jwt;

  Response({
    this.reviewerId,
    this.phone,
    this.gstn,
    this.permissions,
    this.name,
    this.createdAt,
    this.id,
    this.type,
    this.email,
    this.password,
    this.securityAnswer,
    this.updatedAt,
    this.active,
    this.jwt,
  });

  Response.fromJson(Map<String, dynamic> json)
      : reviewerId = json['reviewerId'] as String?,
        phone = json['phone'] as String?,
        gstn = json['gstn'] as String?,
        permissions = (json['permissions'] as List?)?.map((dynamic e) => Permissions.fromJson(e as Map<String,dynamic>)).toList(),
        name = json['name'] as String?,
        createdAt = json['created_at'] as String?,
        id = json['id'] as String?,
        type = json['type'] as String?,
        email = json['email'] as String?,
        password = json['password'] as String?,
        securityAnswer = json['security_answer'] as String?,
        updatedAt = json['updated_at'] as String?,
        active = json['active'] as bool?,
        jwt = json['jwt'] as String?;

  Map<String, dynamic> toJson() => {
    'reviewerId' : reviewerId,
    'phone' : phone,
    'gstn' : gstn,
    'permissions' : permissions?.map((e) => e.toJson()).toList(),
    'name' : name,
    'created_at' : createdAt,
    'id' : id,
    'type' : type,
    'email' : email,
    'password' : password,
    'security_answer' : securityAnswer,
    'updated_at' : updatedAt,
    'active' : active,
    'jwt' : jwt
  };
}

class Permissions {
  final String? type;
  final String? target;

  Permissions({
    this.type,
    this.target,
  });

  Permissions.fromJson(Map<String, dynamic> json)
      : type = json['type'] as String?,
        target = json['target'] as String?;

  Map<String, dynamic> toJson() => {
    'type' : type,
    'target' : target
  };
}