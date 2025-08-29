import 'package:flutter/material.dart';
import 'package:financial_tracker/components/transaction_card.dart';
import 'package:financial_tracker/models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<TransactionModel> transactionList;
  final Function reloadTransactions;

  const TransactionList({
    super.key,
    required this.transactionList,
    required this.reloadTransactions,
  });

  @override
  Widget build(BuildContext context) {
    return transactionList.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.block, size: 100),
                Text("Wow it's empty"),
                Text("in here"),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transactionList.length,
            itemBuilder: (BuildContext context, int i) {
              return TransactionCard(
                transaction: transactionList[i],
                reloadTransactions: reloadTransactions,
              );
            },
          );
  }
}
