class UserModel {
  int status;
  String message;
  UserData data;

  UserModel(this.status, this.message, this.data);


  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(json['status'], json['message'],new UserData.fromJson(json['data']));
  }

}

class UserData {

  int role ;
  String fullname = "";
  String email = "";
  String mobile = "";
  String profile_image = "";
  String createdAt ="";
  String updatedAt ="";
  int status;
  String _id ="";
  String id ="";
  String verify_otp ="";

  UserData(this.role, this.fullname, this.email,this.mobile, this.profile_image, this._id,this.id, this.createdAt,this.status,this.updatedAt,this.verify_otp);




  factory UserData.fromJson(Map<String, dynamic> json) {

    return UserData(json['role'] ?? 0,json['fullname'] ?? '',json['email'] ?? '',json['mobile'] ?? '',json['profile_image']??''
        ,json['_id']??'',json['_id']??'',json['createdAt'] ?? '',json['status'] ?? 0,json['updatedAt'] ?? '',json['verify_otp'] ?? '');
  }

}



