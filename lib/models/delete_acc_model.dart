class DeleteResponseModel {
  final bool isSuccess;
  final bool isFailure;

  DeleteResponseModel({required this.isSuccess, required this.isFailure});

  factory DeleteResponseModel.fromJson(Map<String, dynamic> json) {
    return DeleteResponseModel(
      isSuccess: json['isSuccess'] ?? false,
      isFailure: json['isFailure'] ?? false,
    );
  }
}
