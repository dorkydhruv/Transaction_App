// ignore: unused_import
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  //TransactionList({super.key});
  final List<Transaction> transactions;
  final Function deletetx;

  TransactionList(this.transactions, this.deletetx);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 440,
      child: transactions.isEmpty
          ? LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Text(
                    'No Transaction !',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(
                    height: 30,
                    width: double.infinity,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.7,
                    child: Image.asset(
                      'assets/images/cheems.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              );
            })
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    elevation: 3,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(
                              child: Text('\$${transactions[index].amount}')),
                        ),
                      ),
                      title: Text(
                        transactions[index].title,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      subtitle: Text(
                        DateFormat.MMMEd().format(transactions[index].date),
                      ),
                      trailing: MediaQuery.of(context).size.width > 460
                          ? TextButton.icon(
                              onPressed: () => deletetx(transactions[index].id),
                              icon: Icon(Icons.delete),
                              label: Text('Delete'),
                              style: TextButton.styleFrom(
                                  primary: Theme.of(context).errorColor),
                            )
                          : IconButton(
                              // ignore: prefer_const_constructors
                              icon: Icon(
                                Icons.delete,
                              ),
                              onPressed: () => deletetx(transactions[index].id),
                              color: Theme.of(context).colorScheme.error,
                            ),
                    ));
              },
              itemCount: transactions.length,
              //children: transactions.map((tx) {
            ),
    );
  }
}
