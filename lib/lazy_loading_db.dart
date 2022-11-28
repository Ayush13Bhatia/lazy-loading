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
  String message = "";

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

  _scrollLister() {
    _scrollController.addListener(
      () {
        if (_scrollController.position.maxScrollExtent >= _scrollController.offset && !_scrollController.position.outOfRange) {
          addData(_currentMaxIndex++);
          print("Max");

          // setState(() {});
        }
        if (_scrollController.position.minScrollExtent >= _scrollController.offset && !_scrollController.position.outOfRange) {
          addData(_currentMaxIndex--);
          print('Min');
          // setState(() {});
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();

    addData(0);
    _scrollLister();

    print("Person List ${personList}");
  }

  void addData(int offsetValue) async {
    var data = await SqlHelper.readList(offsetValue);

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
