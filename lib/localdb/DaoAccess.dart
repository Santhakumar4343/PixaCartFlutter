


import 'package:floor/floor.dart';

import 'ListEntity.dart';


@dao
abstract class DaoAccess {



  @Query('SELECT * FROM ListEntity')
  Future<List<ListEntity>> getAll();

  @insert
  Future<void> insertInList(ListEntity list);

  @Query('DELETE FROM ListEntity WHERE variant_id = :variant_id')
  Future<void> delete(String variant_id);

  @Query('UPDATE ListEntity SET order_quantity = :order_quantity WHERE variant_id = :variant_id')
  Future<void> updateList(String order_quantity,String variant_id);


}

//flutter packages pub run build_runner build
//dart run build_runner watch