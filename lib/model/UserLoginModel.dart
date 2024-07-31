class UserLoginModel {
  int status;
  String message;

  UserLoginData data;

  UserLoginModel(this.status, this.message, this.data);

  factory UserLoginModel.fromJson(Map<dynamic, dynamic> json) {
    return UserLoginModel(json['status'], json['message'],new UserLoginData.fromJson(json['data']));

  }

}

class UserLoginData {

  int role ;
  String fullname = "";
  String email = "";
  String country = "";
  String state = "";
  String city = "";
  String postal_code = "";
  String mobile = "";
  String profile_image = "";
  String id ="";
  String token ="";
  String address ="";
  int status;


  UserLoginData(this.role, this.fullname, this.email,
      this.mobile,
      this.country,
      this.state,
      this.city,
      this.postal_code,
      this.profile_image, this.id, this.token,this.address,this.status);

  factory UserLoginData.fromJson(Map<String, dynamic> json) {
    return UserLoginData(json['role'] ?? 0,json['fullname'] ?? '',json['email'] ?? ''
        ,json['mobile'] ?? ''
        ,json['country'] ?? ''
        ,json['state'] ?? ''
        ,json['city'] ?? ''
        ,json['postal_code'] ?? ''
        ,json['profile_image']??''
        ,json['id']??'',json['token'] ?? '',json['address'] ?? '',json['status'] ?? 0);
  }

}



