import 'package:mobx/mobx.dart';
part 'mobxStateManagement.g.dart';
class Counter = MobxStateManagementBase with _$Counter;

abstract class MobxStateManagementBase with Store {

  @observable
  ObservableList<String> likedIndex=ObservableList();

  @observable
  int val=0;

  @action
  void like(String itemId){
    likedIndex.add(itemId);
  }



  @action
  void disliked(String itemId){
    likedIndex.remove(itemId);
  }

}
//mobx_demo_counter run this command
//1dart run build_runner watch