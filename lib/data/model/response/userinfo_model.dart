class UserInfoModel {
  String id;
  String fullName;
  String email;
  String image;
  String emailVerifiedAt;
  String createdAt;
  String updatedAt;
  String emailVerificationToken;
  String phone;
  String cmFirebaseToken;

  UserInfoModel(
      {this.id,
        this.fullName,
        this.email,
        this.image,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
        this.emailVerificationToken,
        this.phone,
        this.cmFirebaseToken});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    email = json['email'];
    image = json['image'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    emailVerificationToken = json['email_verification_token'];
    phone = json['phone'];
    cmFirebaseToken = json['cm_firebase_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['image'] = this.image;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['email_verification_token'] = this.emailVerificationToken;
    data['phone'] = this.phone;
    data['cm_firebase_token'] = this.cmFirebaseToken;
    return data;
  }
}
