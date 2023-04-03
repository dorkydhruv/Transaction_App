import 'package:flutter/material.dart';
import 'package:learning/widget/chart.dart';
import 'package:learning/widget/newTransaction.dart';
import 'package:learning/widget/tarnsaction_list.dart';
//import 'package:learning/widget/userTransaction.dart';
import './models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.amber,
          accentColor: Colors.teal,
          errorColor: Colors.red,
          fontFamily: 'OpenSans',
          textTheme: ThemeData.light().textTheme.copyWith(
              subtitle1: const TextStyle(
                  fontFamily: 'EduNSWAC',
                  fontWeight: FontWeight.w600,
                  fontSize: 18)),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                      titleLarge: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransaction = [
    Transaction(
        id: 't1', title: 'New Shoe', amount: 69.99, date: DateTime.now()),
    //Transaction(
    //  id: 't2', title: 'Grocery', amount: 16.53, date: DateTime.now()),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransaction
        .where(
          (tx) =>
              tx.date.isAfter(DateTime.now().subtract(const Duration(days: 7))),
        )
        .toList();
  }

  bool _showChart = false;

  void _newTransaction(String txtitle, double txamount, DateTime chosenDate) {
    final newTx = Transaction(
        title: txtitle,
        amount: txamount,
        date: chosenDate,
        id: DateTime.now().toString());

    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _startNewTx(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bctx) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(_newTransaction),
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    final isLandscape = mediaquery.orientation == Orientation.landscape;
    final appbar = AppBar(
      title: const Text('Personal Expenses'),
      actions: [
        IconButton(
            onPressed: () => _startNewTx(context), icon: const Icon(Icons.add))
      ],
    );
    final txlistwidget = Container(
        height: (mediaquery.size.height -
                appbar.preferredSize.height -
                mediaquery.padding.top) *
            0.6,
        child: TransactionList(_userTransaction, _deleteTransaction));
    return Scaffold(
      appBar: appbar,
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Switch.adaptive(
                    activeColor: Theme.of(context).accentColor,
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    })
              ],
            ),
          if (isLandscape)
            _showChart == true
                ? Container(
                    height: (mediaquery.size.height -
                            appbar.preferredSize.height -
                            mediaquery.padding.top) *
                        0.7,
                    child: Chart(_recentTransactions))
                : txlistwidget,
          if (!isLandscape)
            Container(
                height: (mediaquery.size.height -
                        appbar.preferredSize.height -
                        mediaquery.padding.top) *
                    0.3,
                child: Chart(_recentTransactions)),
          if (!isLandscape) txlistwidget,
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startNewTx(context),
        child: const Icon(Icons.add_circle_outline_sharp),
      ),
    );
  }
}
