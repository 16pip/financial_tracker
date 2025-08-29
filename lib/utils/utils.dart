import 'package:financial_tracker/models/transaction.dart';

bool isExpense(TransactionModel transaction) {
  return transaction.cashFlow == Cashflow.expense.name.toString().toUpperCase();
}

Cashflow stringToCashflow(String value) {
  return Cashflow.values.firstWhere(
    (flow) => flow.name.toUpperCase() == value.toUpperCase(),
    orElse: () => Cashflow.income, // default if nothing matches
  );
}
