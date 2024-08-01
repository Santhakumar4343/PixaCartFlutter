import 'package:floor/floor.dart';

@entity
class ListEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String variant_id;
  final String sellerId;
  String prod_unitprice;
  final String prod_discount_type;
  final String selectedSize;
  final String selectedPrice;
  final String prod_quantity;
  final String order_quantity;
  final String prod_image;
  final String prod_name;
  final String prod_discount;
  final String prod_strikeout_price;
  final int isLiked;

  ListEntity({
    this.id,
    required this.variant_id,
    required this.sellerId,
    required this.prod_unitprice,
    required this.prod_discount_type,
    required this.selectedSize,
    required this.selectedPrice,
    required this.order_quantity,
    required this.prod_quantity,
    required this.prod_image,
    required this.prod_name,
    required this.prod_discount,
    required this.prod_strikeout_price,
    required this.isLiked,
  });
}
