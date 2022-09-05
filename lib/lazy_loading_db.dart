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
  int count = 1000;
  List<PersonModel> personList = [];
  late int _currentMaxIndex = 10;

  final ScrollController _scrollController = ScrollController();
  var fido = PersonModel(
    name: 'Fido',
    age: 35,
  );
  Future<void> insertDataInDB() async {
    Database db = await SqlHelper.initializeDB();
    var batch = db.batch();

    for (int i = 0; i <= count; i++) {
      SqlHelper.insertData(fido);
    }
    await batch.commit();
  }

  @override
  void initState() {
    super.initState();
    addData();
    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          addData();
        }
      },
    );

    print("Person List ${personList}");
  }

  void addData() async {
    var data = await SqlHelper.readList(_currentMaxIndex++);

    setState(() {
      personList = data;
    });
    print(personList.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hey, Lazy Loader!'),
      ),
      body: ListView.builder(
        controller: _scrollController,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          insertDataInDB();
          print('Pressed');
        },
        child: const Text('insert data'),
      ),
    );
  }
}
