import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:financial_tracker/database/database.dart';
import 'package:financial_tracker/modals/confirmation_modal.dart';
import 'package:financial_tracker/modals/transaction_modal.dart';
import 'package:financial_tracker/models/transaction.dart';
import 'package:financial_tracker/utils/utils.dart';

class TransactionCard extends StatefulWidget {
  final TransactionModel transaction;
  final Function reloadTransactions;
  const TransactionCard({
    super.key,
    required this.transaction,
    required this.reloadTransactions,
  });

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    final isExpenseTx = isExpense(widget.transaction);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: isExpenseTx ? Colors.deepOrange : Colors.green,
              width: 6,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // LEFT SIDE (Description + Date)
              SizedBox(
                width: MediaQuery.widthOf(context) * 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.transaction.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      DateFormat(
                        'MMM dd, yyyy',
                      ).format(widget.transaction.dateTime),
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),

              // RIGHT SIDE (Amount + Actions)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₱${widget.transaction.amount.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isExpenseTx ? Colors.deepOrange : Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit_outlined,
                          color: Colors.lightGreen,
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              AddTransactionModal(
                                isEdit: true,
                                transaction: widget.transaction,
                                onSubmit: (transaction) async {
                                  await _databaseHelper.updateTransaction(
                                    TransactionModel(
                                      id: widget.transaction.id,
                                      description: transaction.description,
                                      amount: transaction.amount,
                                      cashFlow: transaction.cashFlow,
                                    ),
                                  );
                                  widget.reloadTransactions();
                                },
                              ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) => ConfirmationModal(
                            title:
                                "Are you sure you want to delete this transaction?",
                            cancelText: "Cancel",
                            confirmText: "Confirm",
                            onSubmit: () {
                              _databaseHelper.deleteTransaction(
                                widget.transaction,
                              );
                              widget.reloadTransactions();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
