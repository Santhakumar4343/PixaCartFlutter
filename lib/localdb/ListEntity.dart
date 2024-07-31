

import 'package:floor/floor.dart';

@entity
class ListEntity {



  @primaryKey
  final String variant_id;

  final String id;
  final String sellerId;
   String prod_unitprice;
  final String prod_discount_type;
  final String prod_quantity ;
  final String order_quantity ;
  final String prod_image;
  final String prod_name;
  final String prod_discount;
  final String prod_strikeout_price;
  final int isLiked;

  ListEntity(
      this.id,
      this.variant_id,
      this.sellerId,
      this.prod_unitprice,
      this.prod_discount_type,
      this.order_quantity,
      this.prod_quantity,
      this.prod_image,
      this.prod_name,
      this.prod_discount,
      this.prod_strikeout_price,this.isLiked);
}