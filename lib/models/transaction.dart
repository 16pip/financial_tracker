enum Cashflow {
  expense("EXPENSE"),
  income("INCOME");

  const Cashflow(this.value);
  final String value;
}

class TransactionModel {
  int? id;
  final String description;
  final double amount;
  final String cashFlow;
  final DateTime dateTime = DateTime.now();

  TransactionModel({
    this.id,
    required this.description,
    required this.amount,
    required this.cashFlow,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      "amount": amount,
      "cashflow": cashFlow,
      "dateTime": dateTime.toLocal().toString(),
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json["id"],
      description: json["description"],
      amount: json["amount"],
      cashFlow: json["cashflow"],
    );
  }

  @override
  String toString() {
    return "Transaction($id ,$description, $amount, $cashFlow, $dateTime)";
  }
}
