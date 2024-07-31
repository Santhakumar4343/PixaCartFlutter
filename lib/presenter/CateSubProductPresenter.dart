import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_com/model/ModelCategory.dart';
import 'package:e_com/model/ModelProduct.dart';
import 'package:e_com/model/ModelProductSingle.dart';
import 'package:e_com/model/ModelSubCategory.dart';
import 'package:e_com/utils/AppConstant.dart';

class CatePresenter {


  Future<ModelCategory> getCatList(
     String token) async {

    var formData = FormData.fromMap({
      AppConstant.start: 0,
      AppConstant.limit: 1000
    });
    CancelToken cancelToken=CancelToken();
    Dio _dio = Dio();
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.API_GET_CATEGORIES, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ),cancelToken: cancelToken);

    cancelToken.cancel();
    _dio.close(force: true);
      if (response.statusCode == 200) {

        final Map<String,dynamic> parsed = json.decode(response.data.toString());
        return ModelCategory.fromJson(parsed);
      } else {

        final Map<String,dynamic> parsed = json.decode(response.data.toString());
        return ModelCategory.fromJson(parsed);
      }

  }

  Future<ModelSubCategory> getSubCatList(
      String token,String cateId) async {

    var formData = FormData.fromMap({
      AppConstant.start: 0,
      AppConstant.limit: 1000,
      AppConstant.cate_id: cateId
    });
    CancelToken cancelToken=CancelToken();
    Dio _dio = Dio();
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.API_GETSUBCATEGORIES, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ),cancelToken: cancelToken);
    cancelToken.cancel();
    _dio.close(force: true);
    if (response.statusCode == 200) {
      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelSubCategory.fromJson(parsed);
    } else {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelSubCategory.fromJson(parsed);
    }

  }

  Future<ModelProduct> getTrendingProducts(
      String token,length) async {

    Dio dio = new Dio();

    var formData = FormData.fromMap({
      AppConstant.start: 0,
      AppConstant.limit: length,

    });
    Response<String> response = await dio.post(
        AppConstant.BaseUrl + AppConstant.API_GETTRENDINGPRODUCTS, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));


    if (response.statusCode == 200) {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelProduct.fromJson(parsed);
    } else {
      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelProduct.fromJson(parsed);;
    }

  }
  Future<ModelProduct> getRecomm(
      String token,length) async {
    await Future.delayed(Duration(seconds: 9));
    Dio dio = new Dio();

    var formData = FormData.fromMap({
      AppConstant.start: 0,
      AppConstant.limit: length,

    });
    Response<String> response = await dio.post(
        AppConstant.BaseUrl + AppConstant.API_GETRECOMMENDEDPRODUCTS, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));



    if (response.statusCode == 200) {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelProduct.fromJson(parsed);
    } else {
      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelProduct.fromJson(parsed);
    }

  }

  Future<ModelProduct> getSubCatProductList(
      String token,String cateId,String subCatId,most_viewed,int length,String brandId) async {

    Dio dio = new Dio();
    CancelToken cancelToken=CancelToken();
    var formData = FormData.fromMap({
      AppConstant.start: 0,
      AppConstant.limit: length,
      AppConstant.subcate_id: subCatId,
      AppConstant.cate_id: cateId,
      "brand_id": brandId,
      'prod_type': most_viewed
    });
    Response<String> response = await dio.post(
        AppConstant.BaseUrl + AppConstant.API_GETPRODUCTS, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ),cancelToken: cancelToken);
    cancelToken.cancel();
    dio.close(force: true);
    if (response.statusCode == 200) {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelProduct.fromJson(parsed);
    } else {
      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelProduct.fromJson(parsed);
    }

  }



  Future<ModelProductSingle> getSingleProd(
      String token,String product_id) async {

    var formData = FormData.fromMap({
      AppConstant.product_id: product_id,
    });

    Dio _dio = Dio();
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.API_GETSINGLEPRODUCT, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));
    if (response.statusCode == 200) {
      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelProductSingle.fromJson(parsed);
    } else {
      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelProductSingle.fromJson(parsed);
    }

  }


  Future<ModelProduct> getWishList(
      String token,String user_id) async {

    var formData = FormData.fromMap({
      AppConstant.start: 0,
      AppConstant.limit: 1000,
      AppConstant.user_id: user_id,
    });
    Dio _dio = Dio();
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.API_GETMYWISHLIST, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));

_dio.close(force: true);
    if (response.statusCode == 200) {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelProduct.fromJson(parsed);
    } else {
      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return ModelProduct.fromJson(parsed);
    }

  }

  Future<String> doLikeProduct(
      String token,String user_id,String product_id) async {

    var formData = FormData.fromMap({
      AppConstant.user_id: user_id,
      AppConstant.product_id: product_id
    });
    Dio _dio = Dio();
    Response<String> response = await _dio.post(
        AppConstant.BaseUrl + AppConstant.API_DOPRODUCTLIKE, data: formData,
        options: Options(headers: {
          "authorization": "" + token
        }
        ));
_dio.close(force: true);

    if (response.statusCode == 200) {

      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      if(parsed["status"].toString().contains("1")){

      return "1";}else{
        return "0";
      }
    } else {
      final Map<String,dynamic> parsed = json.decode(response.data.toString());
      return "0";
    }

  }


}


