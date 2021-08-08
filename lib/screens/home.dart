import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/components/bottom_sheet.dart';
import 'package:expense_tracker/components/single_tile.dart';
import 'package:expense_tracker/model/transaction.dart';
import 'package:expense_tracker/components/chart.dart';
class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Transaction> transaction = [  ];

  bool showChart = false;

  List<Transaction> get _recentTransaction{
    return transaction.where((element){
      if (element.date.isAfter(DateTime.now().subtract(Duration(days: 7)))){
        return true;
      }
      else{
        return false;
      }
    }).toList();
  }
  void _updateUI(String txTitle, double txAmount , DateTime pickedDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: pickedDate,
    );
    setState(() {
      transaction.add(newTx);
    });
  }

  void _deleteTransaction(String id){
    setState(() {
      transaction.removeWhere((element) => element.id == id);
    });
  }
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final _isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar =AppBar(
      title: Center(child: Text("Expense Tracker")),
      actions: [
        IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return ModalBottomSheet(_updateUI);
                  });
            },
            icon: Icon(Icons.add))
      ],
    );
    final body = SingleChildScrollView(
      child: Column(
        children: [
          if (_isLandscape) Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Show Chart"),
              Switch.adaptive(
                value: showChart,
                onChanged: (val){
                  setState(() {
                    showChart=val;
                  });
                },
              )
            ],
          ),
          if (!_isLandscape) Container(
              height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.35,
              child: Chart(_recentTransaction)
          ),
          if (!_isLandscape) Container(
              height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.6,
              child: SingleTransaction(transaction,_deleteTransaction)
          ),
          if (_isLandscape)
            showChart == true
                ? Container(
                height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.7,
                child: Chart(_recentTransaction)
            )
                : Container(
                height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.6,
                child: SingleTransaction(transaction,_deleteTransaction)
            ),
        ],
      ),
    );
    return Platform .isIOS ? CupertinoPageScaffold(child: body) : Scaffold(
      appBar: appBar,
      floatingActionButton: Platform.isAndroid ? FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return ModalBottomSheet(_updateUI);
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        elevation: 5,
      )
      : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: body
    );
  }
}
