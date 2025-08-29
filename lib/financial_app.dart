import 'package:flutter/material.dart';
import 'package:financial_tracker/constants/colors.dart';
import 'package:financial_tracker/database/database.dart';
import 'package:financial_tracker/modals/transaction_modal.dart';
import 'package:financial_tracker/models/transaction.dart';
import 'package:financial_tracker/components/transaction_list.dart';

class FinancialTrackerApp extends StatefulWidget {
  const FinancialTrackerApp({super.key});

  @override
  State<FinancialTrackerApp> createState() => _FinancialTrackerAppState();
}

class _FinancialTrackerAppState extends State<FinancialTrackerApp> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<TransactionModel> transactionList = [];
  double totalMoney = 0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final transactions = await _databaseHelper.getTransactions();

    setState(() {
      transactionList = transactions;
      totalMoney = transactionList.fold(0, (sum, transaction) {
        if (transaction.cashFlow == Cashflow.expense.name.toUpperCase()) {
          return sum -= transaction.amount;
        }

        return sum += transaction.amount;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.wallet, size: 40),
            SizedBox(width: 8),
            Text(
              "Nancie",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 32),
            ),
          ],
        ),
        backgroundColor: AppColors.teal,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Balance",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "₱${totalMoney.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: totalMoney >= 0
                            ? Colors.green[700]
                            : Colors.red[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: TransactionList(
              transactionList: transactionList,
              reloadTransactions: _loadTransactions,
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => AddTransactionModal(
            isEdit: false,
            onSubmit: (transaction) async {
              await _databaseHelper.insertTransaction(
                TransactionModel(
                  description: transaction.description,
                  amount: transaction.amount,
                  cashFlow: transaction.cashFlow,
                ),
              );
              _loadTransactions();
            },
          ),
        ),
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: CircleBorder(),
        child: Icon(Icons.add, size: 30),
      ),
    );
  }
}
