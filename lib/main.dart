import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_getx/controller.dart';
import 'package:notes_getx/database/user.dart';
import 'package:hive_flutter/hive_flutter.dart';
Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('database');
  runApp(
      GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData(
          backgroundColor: Colors.black,
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.black
        ),
        home: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);
  Controller databaseController=Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Notes",),
        leading: const Icon(Icons.note_add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          customDialog();
        },
      ),
      body:Obx((){
          if(databaseController.get().isEmpty)
            {
              return const Center(
                child: Text("Empty",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),),
              );
            }
            return ListView.builder(
              itemCount: databaseController.get().length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: ListTile(
                      textColor: Colors.white,
                        tileColor: Colors.blueGrey,
                        title: Text(databaseController.get().getAt(index)!.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        ),),
                        subtitle: Text(databaseController.get().getAt(index)!.detail+'\n'+DateTime.now().toString()),
                        onTap: (){
                        updateDialog(index);
                        },
                        trailing: IconButton(
                          onPressed: (){
                            databaseController.delete(index);
                          },
                          icon: const Icon(Icons.delete,color: Colors.red,),
                        ),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            side: BorderSide(
                                color: Colors.white
                            )
                        )
                    ),
                  );
                })
            );
        }),
    );
  }
}


dynamic customDialog(){
  Controller databaseController=Get.find();
  TextEditingController _nameController=TextEditingController();
  TextEditingController _detailController=TextEditingController();
  return Get.defaultDialog(
    title: "Add User Data",
    content: Container(
      padding: const EdgeInsets.all(7),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller:_nameController ,
            autofocus: true,
            decoration:const InputDecoration(
                label: Text("Enter User Name"),
                border:OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))
                )
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          TextField(
            controller:_detailController ,
            maxLines: 6,
            autofocus: true,
            decoration:const InputDecoration(
                label: Text("Enter Details About User"),
                border:OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))
                )
            ),
          ),
        ],
      ),
    ),
      actions: [
        ElevatedButton(
            onPressed: (){
              databaseController.add(
                  User(
                      name: _nameController.text,
                      detail: _detailController.text
                  ));
              Get.back();
              },
            child: const Text("Submit")),
      ]
  );
}

dynamic updateDialog(int index){
  Controller databaseController=Get.find();
  String name=databaseController.get().getAt(index)!.name;
  String detail=databaseController.get().getAt(index)!.detail;
  return Get.defaultDialog(
      title: "Update User Data",
      content: Container(
        padding: const EdgeInsets.all(7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
             initialValue: name,
              onChanged: (value)=>name=value,
              autofocus: true,
              decoration:const InputDecoration(
                  label: Text("Enter User Name"),
                  border:OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))
                  )
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              initialValue: detail,
              onChanged: (value)=>detail=value,
              maxLines: 6,
              autofocus: true,
              decoration:const InputDecoration(
                  label: Text("Enter Details About User"),
                  border:OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))
                  )
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: (){
              databaseController.upadte(index, User(name: name, detail: detail));
              Get.back();
            },
            child: const Text("Update")),
      ]
  );
}