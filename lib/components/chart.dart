import 'package:expense_tracker/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  Chart(this.recentTransactions);
  List<Map<String, Object>> get groupedTransactionsValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get spendPct {
    return groupedTransactionsValues.fold(
        0.0, (sum, data) => sum + (data['amount'] as num));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      width: double.infinity,
      child: Card(
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionsValues.map((e) {
              return  ChartBar(
                  label: e['day'].toString(),
                  amount: (e['amount'] as double),
                  spendPercent:
                      spendPct == 0 ? 0.0 : (e['amount'] as double) / spendPct);
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class ChartBar extends StatelessWidget {
  final String label;
  final double amount;
  final double spendPercent; // To get how many part should be covered

  ChartBar(
      {required this.label, required this.amount, required this.spendPercent});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx,constraints){
      return  Column(
        children: [
          Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                  child: Text("\u{20B9} ${amount.toStringAsFixed(0)}"))),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.6,
            width: 15,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(15.0)),
                ),
                FractionallySizedBox(
                  heightFactor: spendPercent,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(child: Text(label))
          ),
        ],
      );
    });
  }
}
