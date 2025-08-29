import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:financial_tracker/models/transaction.dart';
import 'package:financial_tracker/utils/utils.dart';

class AddTransactionModal extends StatefulWidget {
  final bool isEdit;
  final TransactionModel? transaction;
  final Function(TransactionModel) onSubmit;

  const AddTransactionModal({
    super.key,
    this.transaction,
    required this.isEdit,
    required this.onSubmit,
  });

  @override
  State<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<AddTransactionModal> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController cashflowController = TextEditingController();

  @override
  void initState() {
    // Pre-fill for editing
    if (widget.isEdit) {
      descriptionController.text = widget.transaction?.description ?? "";
      amountController.text =
          widget.transaction?.amount.toStringAsFixed(2) ?? "";
      cashflowController.text = widget.transaction?.cashFlow ?? "";
    }

    super.initState();
  }

  @override
  void dispose() {
    descriptionController.clear();
    amountController.clear();

    super.dispose();
  }

  void submit() {
    final description = descriptionController.text;
    final amount = double.tryParse(amountController.text) ?? 0;
    final cashflow = cashflowController.text;

    // return if invalid
    if (!_formKey.currentState!.validate()) return;

    widget.onSubmit(
      TransactionModel(
        description: description,
        amount: amount,
        cashFlow: cashflow,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "${widget.isEdit ? "Edit" : "Add"} Transaction",
                style: TextStyle(fontSize: 24.0),
              ),

              SizedBox(height: 16.0),

              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                controller: descriptionController,
                decoration: InputDecoration(
                  label: Text("Description"),
                  border: OutlineInputBorder(),
                  hintText: 'Enter Description',
                ),
              ),

              SizedBox(height: 8.0),

              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  } else if (double.tryParse(value) == null) {
                    return 'Invalid number';
                  }

                  return null;
                },
                controller: amountController,
                decoration: InputDecoration(
                  label: Text("Amount"),
                  border: OutlineInputBorder(),
                  hintText: 'Enter Amount',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+(\.\d*)?')),
                ],
              ),

              SizedBox(height: 8.0),

              DropdownButtonFormField<Cashflow>(
                initialValue: stringToCashflow(cashflowController.text),
                decoration: InputDecoration(
                  labelText: "Cash Flow", // same as label in TextFormField
                  border: OutlineInputBorder(), // adds the outlined border
                  hintText: "Select Cash Flow", // same as hint in TextFormField
                ),
                items: Cashflow.values.map((flow) {
                  return DropdownMenuItem<Cashflow>(
                    value: flow,
                    child: Text(flow.value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    cashflowController.text = value!.value;
                  });
                },

                validator: (value) {
                  if (value == null || value.value == "") {
                    return "Please select an item";
                  }
                  return null;
                },
              ),

              SizedBox(height: 16.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                    },
                    child: Text('Cancel'),
                  ),

                  ElevatedButton(
                    onPressed: submit,
                    child: Text(widget.isEdit ? "Edit" : "Add"),
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
