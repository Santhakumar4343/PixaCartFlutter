


import 'package:floor/floor.dart';

import 'ListEntity.dart';


@dao
abstract class DaoAccess {



  @Query('SELECT * FROM ListEntity')
  Future<List<ListEntity>> getAll();

  @insert
  Future<void> insertInList(ListEntity list);

  @Query('DELETE FROM ListEntity WHERE regno = :regno')
  Future<void> delete(String regno);

  @Query('UPDATE ListEntity SET order_quantity = :order_quantity WHERE regno = :regno')
  Future<void> updateList(String order_quantity, String regno);



}

//flutter packages pub run build_runner build
//dart run build_runner watch