import 'package:flutter/material.dart';

class LazyLoading extends StatefulWidget {
  const LazyLoading({Key? key}) : super(key: key);

  @override
  State<LazyLoading> createState() => _LazyLoadingState();
}

class _LazyLoadingState extends State<LazyLoading> {
  List lazyList = [];
  ScrollController _scrollController = ScrollController();
  int _currentMaxIndex = 10;
  @override
  void initState() {
    lazyList = List.generate(15, (i) => "Lazy Data: ${i + 1}");
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  _getMoreData() {
    for (int i = _currentMaxIndex; i < _currentMaxIndex + 10; i++) {
      lazyList.add("Items: ${i + 1}");
    }
    _currentMaxIndex = _currentMaxIndex + 10;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lazy loading"),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemExtent: 80,
        itemBuilder: (_, i) {
          return Card(
            child: ListTile(
              title: Text(lazyList[i]),
            ),
          );
        },
        itemCount: lazyList.length,
      ),
    );
  }
}
