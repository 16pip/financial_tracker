import 'package:financial_tracker/models/transaction.dart';

bool isExpense(TransactionModel transaction) {
  return transaction.cashFlow == Cashflow.expense.value;
}

Cashflow? stringToCashflow(String value) {
  try {
    return Cashflow.values.firstWhere(
      (flow) => flow.value == value.toUpperCase(),
    );
  } catch (_) {
    return null;
  }
}
