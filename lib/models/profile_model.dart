class ProfileModel {
  final String? id;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? imageUrl;
  final String? address;
  final String? buildingNumber;
  final String? floorNumber;

  ProfileModel({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.imageUrl,
    this.address,
    this.buildingNumber,
    this.floorNumber,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final value = json['value'];
    return ProfileModel(
      id: value['id'],
      fullName: value['fullName'],
      email: value['email'],
      phoneNumber: value['phoneNumber'],
      imageUrl: value['imageUrl'],
      address: value['address'],
      buildingNumber: value['buildingNumber'],
      floorNumber: value['floorNumber'],
    );
  }
}
