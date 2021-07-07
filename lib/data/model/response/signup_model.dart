class SignUpModel {
  String fName;
  String phone;
  String email;
  String password;

  SignUpModel({this.fName, this.phone, this.email='', this.password,});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    fName = json['f_name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    password = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['f_name'] = this.fName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }

  String getFullName(){
    return this.fName+' ';
  }
}
