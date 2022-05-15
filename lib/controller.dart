import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:notes_getx/database/user.dart';

class Controller extends GetxController{
  final currentDatabase=Hive.box<User>('database').obs;
  void add(User data){
    currentDatabase.update((val) {
      val!.add(data);
    });
  }
  void delete(int index){
    currentDatabase.update((val) {
      val!.deleteAt(index);
    });
  }
  void upadte(int index ,User data){
    currentDatabase.update((val) {
      val!.putAt(index, data);
    });
  }
  Box<User> get()=>currentDatabase.value;
}