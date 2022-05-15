import 'package:hive/hive.dart';
part 'user.g.dart';
@HiveType(typeId: 0)
class User extends HiveObject{
  User({required this.name,required this.detail});
  @HiveField (0)
  String name;
  @HiveField (1)
  String detail;
}