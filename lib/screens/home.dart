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
    final appBar = AppBar(
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
    return Scaffold(
      appBar: appBar,
      floatingActionButton: FloatingActionButton(
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.35,
                child: Chart(_recentTransaction)
            ),
            Container(
              height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.6,
                child: SingleTransaction(transaction,_deleteTransaction)
            ),
          ],
        ),
      ),
    );
  }
}
