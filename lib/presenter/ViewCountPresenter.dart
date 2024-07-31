
import 'package:e_com/utils/AppConstant.dart';

import 'package:dio/dio.dart';

class ViewCountPresenter{

  late Dio _dio = Dio();
  Future<String> getList(
      String token,pid,uid) async {

    var formData = FormData.fromMap({
      AppConstant.view_pid: pid,
      AppConstant.view_uid: uid
    });
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.API_ADDVIEWCOUNT, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));




    if (response.statusCode == 200) {


      return '';
    } else {


      return '';;
    }

  }
}