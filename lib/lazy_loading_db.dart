import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:lazy_loading/person_model.dart';
import 'package:lazy_loading/sql_helper.dart';
import 'package:sqflite/sqflite.dart';

class LazyLoadingDB extends StatefulWidget {
  const LazyLoadingDB({Key? key}) : super(key: key);

  @override
  State<LazyLoadingDB> createState() => _LazyLoadingDBState();
}

class _LazyLoadingDBState extends State<LazyLoadingDB> {
  int count = 10000;
  List<PersonModel> personList = [];
  var fido = PersonModel(
    name: 'Fido',
    age: 35,
  );
  Future<void> counter() async {
    Database db = await SqlHelper.initializeDB();
    var batch = db.batch();

    for (int i = 0; i <= count; i++) {
      SqlHelper.insertData(fido);
    }
    await batch.commit();
  }

  void addData() async {
    final data = await SqlHelper.readList();
    setState(() {
      personList = data;
    });
  }

  @override
  void initState() {
    super.initState();
    addData(); // Loading the diary when the app starts
  }

  void loadMore() async {
    setState(() {
      const CircularProgressIndicator();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hey, Lazy Loader!'),
      ),
      body: LazyLoadScrollView(
        onEndOfPage: () => loadMore(),
        child: ListView.builder(
          itemCount: personList.length,
          itemBuilder: (_, i) {
            return Card(
              child: ListTile(
                trailing: Text('${personList[i].id}'),
                title: Text('${personList[i].name}'),
                subtitle: Text('${personList[i].age}'),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          counter();
          print('Pressed');
        },
        child: const Text('insert data'),
      ),
    );
  }
}
