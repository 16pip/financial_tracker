// import 'package:financial_tracker/models/month.dart';

// class Expense {
//   final String description;
//   final double amount;
//   final DateTime expenseDate;

//   Expense(this.description, this.amount, this.expenseDate);

//   @override
//   String toString() {
//     return "Expense($description, $amount, $expenseDate)";
//   }
// }

// void main() {
//   final List<Expense> expenses = [
//     Expense('Groceries', 50.0, DateTime(2023, 10, 15)),
//     Expense('Dinner', 30.0, DateTime(2023, 1, 20)),
//     Expense('Rent', 1000.0, DateTime(2023, 11, 1)),
//     Expense('Transportation', 20.0, DateTime(2023, 11, 10)),
//     Expense('Coffee', 5.0, DateTime(2023, 10, 25)),
//     Expense('Utilities', 80.0, DateTime(2023, 12, 25)),
//   ];
//   expenses.sort((a, b) => a.expenseDate.compareTo(b.expenseDate));

//   int? previousMonth;
//   expenses.asMap().forEach((i, expense) {
//     if (previousMonth == null) {
//       print("");
//       print(
//         "---------------- ${Months.values[expense.expenseDate.month - 1].name.toUpperCase()} ----------------",
//       );
//     } else if (previousMonth != expense.expenseDate.month) {
//       print("");
//       print(
//         "---------------- ${Months.values[expense.expenseDate.month - 1].name.toUpperCase()} ----------------",
//       );
//     }

//     print(expense);
//     previousMonth = expense.expenseDate.month;
//   });
// }
