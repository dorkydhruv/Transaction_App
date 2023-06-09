// ignore: file_names
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning/widget/adaptiveFlatbutton.dart';
//  import 'package:learning/widget/userTransaction.dart';

class NewTransaction extends StatefulWidget {
// NewTransaction({super.key});
  final Function addtx;

  const NewTransaction(this.addtx, {super.key});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();
  DateTime? selectedDate;
  void submittx() {
    final enteredTitle = titleController.text;
    final entereAmount = double.parse(amountController.text);
    if (entereAmount.isNaN || enteredTitle.isEmpty || selectedDate == null) {
      return;
    }
    widget.addtx(enteredTitle, entereAmount, selectedDate);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {});
      selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 9,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                  //onChanged: (val) => titleInput = val,
                  controller: titleController,
                  onSubmitted: (_) => submittx(),
                  decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20))))),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 20,
              ),
              TextField(
                  controller: amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: (_) => submittx(),
                  //onChanged: (val) => amountInput = val,
                  decoration: const InputDecoration(
                      labelText: 'Amount Of Money Spent',
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20))))),
              SizedBox(
                height: 80,
                child: Row(
                  children: [
                    Text(selectedDate == null
                        ? 'No date chosen!'
                        : 'Picked Date : ${DateFormat.MMMMEEEEd().format(selectedDate!)}'),
                    AdaptiveTextbutton('Choose date -', _presentDatePicker)
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: submittx,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  // ignore: prefer_const_constructors
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontStyle: FontStyle.italic),
                ),
                child: const Text('Add Transaction'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
