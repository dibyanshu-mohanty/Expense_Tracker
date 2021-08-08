import 'package:expense_tracker/model/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleTransaction extends StatelessWidget {
  final List<Transaction> _userTransactions;
  final Function deleteTransaction;
  SingleTransaction(this._userTransactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _userTransactions.length == 0
          ? LayoutBuilder(builder: (ctx, constraints) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "No Transactions Added",
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Quicksand'),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset(
                        "assets/images/waiting.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              );
            })
          : ListView.builder(
              itemCount: _userTransactions.length,
              itemBuilder: (context, index) => Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: EdgeInsets.all(30.0),
                          decoration: BoxDecoration(
                              color: Colors.purple, shape: BoxShape.circle),
                          child: Center(
                            child: FittedBox(
                              child: Text(
                                "\u{20B9} ${_userTransactions[index].amount}",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                    fontFamily: 'Quicksand',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userTransactions[index].title,
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              DateFormat.yMMMd()
                                  .format(_userTransactions[index].date),
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.0),
                            )
                          ],
                        ),
                        IconButton(
                            onPressed: (() =>
                                deleteTransaction(_userTransactions[index].id)),
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
