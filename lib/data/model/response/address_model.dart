class AddressModel {
  String id;
  String addressType;
  String contactPersonNumber;
  String address;
  String latitude;
  String longitude;
  String userId;
  String contactPersonName;

  AddressModel(
      {this.id,
      this.addressType,
      this.contactPersonNumber,
      this.address,
      this.latitude,
      this.longitude,
      this.userId,
      this.contactPersonName});

  AddressModel.fromJson({Map<String, dynamic> json, String id}) {
    this.id = id;
    this.addressType = json['address_type'];
    this.contactPersonNumber = json['contact_person_number'];
    this.address = json['address'];
    this.latitude = json['latitude'];
    this.longitude = json['longitude'];
    this.userId = json['user_id'];
    this.contactPersonName = json['contact_person_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_type'] = this.addressType;
    data['contact_person_number'] = this.contactPersonNumber;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['user_id'] = this.userId;
    data['contact_person_name'] = this.contactPersonName;
    return data;
  }
}
