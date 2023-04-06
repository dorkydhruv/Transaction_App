import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:learning/widget/chart.dart';
import 'package:learning/widget/newTransaction.dart';
import 'package:learning/widget/tarnsaction_list.dart';
//import 'package:learning/widget/userTransaction.dart';
import './models/transaction.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      theme: ThemeData(
          fontFamily: 'OpenSans',
          textTheme: ThemeData.light().textTheme.copyWith(
              titleMedium: const TextStyle(
                  fontFamily: 'EduNSWAC',
                  fontWeight: FontWeight.w600,
                  fontSize: 18)),
          appBarTheme: AppBarTheme(
              toolbarTextStyle: ThemeData.light()
                  .textTheme
                  .copyWith(
                      titleLarge: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ))
                  .bodyMedium,
              titleTextStyle: ThemeData.light()
                  .textTheme
                  .copyWith(
                      titleLarge: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ))
                  .titleLarge),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber)
              .copyWith(secondary: Colors.teal)
              .copyWith(error: Colors.red)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
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

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // ignore: todo
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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
    // ignore: prefer_const_constructors
    final PreferredSizeWidget appbar = (Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: const Icon(CupertinoIcons.add),
                  onTap: () => _startNewTx(context),
                )
              ],
            ),
          )
        : AppBar(
            title: const Text('Personal Expenses'),
            actions: [
              IconButton(
                  onPressed: () => _startNewTx(context),
                  icon: const Icon(Icons.add))
            ],
          )) as PreferredSizeWidget;
    final txlistwidget = SizedBox(
        height: (mediaquery.size.height -
                appbar.preferredSize.height -
                mediaquery.padding.top) *
            0.6,
        child: TransactionList(_userTransaction, _deleteTransaction));

    List<Widget> buildLandscapeContent() {
      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Show Chart',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Switch.adaptive(
                activeColor: Theme.of(context).colorScheme.secondary,
                value: _showChart,
                onChanged: (val) {
                  setState(() {
                    _showChart = val;
                  });
                })
          ],
        ),
        _showChart == true
            ? SizedBox(
                height: (mediaquery.size.height -
                        appbar.preferredSize.height -
                        mediaquery.padding.top) *
                    0.7,
                child: Chart(_recentTransactions))
            : txlistwidget,
      ];
    }

    List<Widget> buildPotraitContent() {
      return [
        SizedBox(
            height: (mediaquery.size.height -
                    appbar.preferredSize.height -
                    mediaquery.padding.top) *
                0.3,
            child: Chart(_recentTransactions)),
        txlistwidget
      ];
    }

    final body = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape) ...buildLandscapeContent(),
            if (!isLandscape) ...buildPotraitContent(),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(child: body)
        : Scaffold(
            appBar: appbar,
            body: body,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Platform.isIOS
                ? null
                : FloatingActionButton(
                    onPressed: () => _startNewTx(context),
                    child: const Icon(Icons.add_circle_outline_sharp),
                  ),
          );
  }
}
