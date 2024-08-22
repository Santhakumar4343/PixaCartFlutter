class ModelProductSingle {
  int status;
  String message;
  ProducSingleData data;

  ModelProductSingle(this.status, this.message, this.data);
  factory ModelProductSingle.fromJson(Map<dynamic, dynamic> json) {
    return ModelProductSingle(json['status'], json['message'], ProducSingleData.fromJson(json['data']));
  }
}

class ProducSingleData {
  String prod_sellerid;
  String prod_cate;
  String prod_name;
  int count_views;
  int status;
  int isLiked;
  String rating_average;
  int rating_user_count;
  int featured;
  String id;
  String prod_description;
  List<ProdVarient> prod_variants;
  String prod_discount_type;
  String prod_discount;
  String prod_brand;

  ProducSingleData({
    required this.prod_sellerid,
    required this.prod_cate,
    required this.prod_name,
    required this.count_views,
    required this.status,
    required this.isLiked,
    required this.rating_average,
    required this.rating_user_count,
    required this.featured,
    required this.id,
    required this.prod_description,
    required this.prod_variants,
    required this.prod_discount_type,
    required this.prod_discount,
    required this.prod_brand,
  });

  factory ProducSingleData.fromJson(Map<String, dynamic> json) {
    return ProducSingleData(
      prod_sellerid: json['prod_sellerid'] ?? '',
      prod_cate: json['prod_cate'] ?? '',
      prod_name: json['prod_name'] ?? '',
      count_views: json['count_views'] ?? 0,
      status: json['status'] ?? 0,
      isLiked: json['isLiked'] ?? 0,
      rating_average: json['rating_average'] ?? '0.0',
      rating_user_count: json['rating_user_count'] ?? 0,
      featured: json['featured'] ?? 0,
      id: json['_id'] ?? '',
      prod_description: json['prod_description'] ?? '',
      prod_variants: List<ProdVarient>.from(json['prod_variants'].map((x) => ProdVarient.fromJson(x))),
      prod_discount_type: json['prod_discount_type'] ?? '',
      prod_discount: json['prod_discount'] ?? '',
      prod_brand: json['prod_brand'] ?? '',
    );
  }
}

class ProdVarient {
  String variant_id;
  String pro_subtitle;
  String prod_attributes;
  String prod_unitprice;
  String prod_purchase_price;
  String prod_strikeout_price;
  String prod_discount_type;
  String prod_discount;
  int prod_quantity;
  List<String> prod_image;
  List<String> thumb_image;
  List<ProdSize> prod_sizes;

  ProdVarient({
    required this.variant_id,
    required this.pro_subtitle,
    required this.prod_attributes,
    required this.prod_unitprice,
    required this.prod_purchase_price,
    required this.prod_strikeout_price,
    required this.prod_quantity,
    required this.prod_image,
    required this.thumb_image,
    required this.prod_discount,
    required this.prod_discount_type,
    required this.prod_sizes,
  });

  factory ProdVarient.fromJson(Map<String, dynamic> json) {
    return ProdVarient(
      variant_id: json['variant_id'] ?? '',
      pro_subtitle: json['pro_subtitle'] ?? '',
      prod_attributes: json['prod_attributes'] ?? '',
      prod_unitprice: json['prod_unitprice'] ?? '',
      prod_purchase_price: json['prod_purchase_price'] ?? '',
      prod_strikeout_price: json['prod_strikeout_price'] ?? '',
      prod_quantity: json['prod_quantity'] ?? 0,
      prod_image: List<String>.from(json['prod_image'] ?? []),
      thumb_image: List<String>.from(json['thumb_image'] ?? []),
      prod_discount: json['prod_discount'] ?? '0',
      prod_discount_type: json['prod_discount_type'] ?? '',
      prod_sizes: List<ProdSize>.from(json['prod_sizes'].map((x) => ProdSize.fromJson(x))),
    );
  }
}

class ProdSize {
  String size;
  int quantity;
  int strikePrice;
  String discountType;
  int discount;
  int price;

  ProdSize({required this.size, required this.quantity,required this.strikePrice,required this.discountType,required this.discount, required this.price});

  factory ProdSize.fromJson(Map<String, dynamic> json) {
    return ProdSize(
      size: json['size'] ?? '',
      quantity: json['quantity'] ?? 0,
      strikePrice:json['strikePrice'] ?? 0,
      discountType:json['discountType'] ?? '',
      discount:json['discount'] ?? '',
      price: json['price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'quantity': quantity,
      'strikePrice':strikePrice,
      'discountType':discountType,
      'discount':discount,
        'price': price,
    };
  }
}
