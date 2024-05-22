class ReconciliationResponseModel {
  final Response? response;
  final bool? status;

  ReconciliationResponseModel({
    this.response,
    this.status,
  });

  ReconciliationResponseModel.fromJson(Map<String, dynamic> json)
      : response = (json['response'] as Map<String,dynamic>?) != null ? Response.fromJson(json['response'] as Map<String,dynamic>) : null,
        status = json['status'] as bool?;

  Map<String, dynamic> toJson() => {
    'response' : response?.toJson(),
    'status' : status
  };
}

class Response {
  final List<ReconciliationDocuments>? documents;
  final int? month;
  final int? year;

  Response({
    this.documents,
    this.month,
    this.year,
  });

  Response.fromJson(Map<String, dynamic> json)
      : documents = (json['documents'] as List?)?.map((dynamic e) => ReconciliationDocuments.fromJson(e as Map<String,dynamic>)).toList(),
        month = json['month'] as int?,
        year = json['year'] as int?;

  Map<String, dynamic> toJson() => {
    'documents' : documents?.map((e) => e.toJson()).toList(),
    'month' : month,
    'year' : year
  };
}

class ReconciliationDocuments {
  final String? thumbnail;
  final String? updatedAt;
  final int? month;
  final String? cratedAt;
  final String? name;
  final String? description;
  final bool? reviewed;
  final String? mimetype;
  final String? id;
  final String? type;
  final String? uploadName;
  final String? userId;
  final int? year;
  final String? file;

  ReconciliationDocuments({
    this.thumbnail,
    this.updatedAt,
    this.month,
    this.cratedAt,
    this.name,
    this.description,
    this.reviewed,
    this.mimetype,
    this.id,
    this.type,
    this.uploadName,
    this.userId,
    this.year,
    this.file,
  });

  ReconciliationDocuments.fromJson(Map<String, dynamic> json)
      : thumbnail = json['thumbnail'] as String?,
        updatedAt = json['updated_at'] as String?,
        month = json['month'] as int?,
        cratedAt = json['crated_at'] as String?,
        name = json['name'] as String?,
        description = json['description'] as String?,
        reviewed = json['reviewed'] as bool?,
        mimetype = json['mimetype'] as String?,
        id = json['id'] as String?,
        type = json['type'] as String?,
        uploadName = json['uploadName'] as String?,
        userId = json['userId'] as String?,
        year = json['year'] as int?,
        file = json['file'] as String?;

  Map<String, dynamic> toJson() => {
    'thumbnail' : thumbnail,
    'updated_at' : updatedAt,
    'month' : month,
    'crated_at' : cratedAt,
    'name' : name,
    'description' : description,
    'reviewed' : reviewed,
    'mimetype' : mimetype,
    'id' : id,
    'type' : type,
    'uploadName' : uploadName,
    'userId' : userId,
    'year' : year,
    'file' : file
  };
}