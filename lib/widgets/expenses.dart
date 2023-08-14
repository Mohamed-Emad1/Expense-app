import 'package:expense/widgets/chart.dart';
import 'package:expense/widgets/expenses_list/expenses_list.dart';
import 'package:expense/widgets/new_expense_userinput.dart';
import 'package:flutter/material.dart';
import '../expense_data/expense_data.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Flutter course',
        amount: 19.9,
        date: DateTime.now(),
        caegory: Categorty.work),
    Expense(
        title: 'Cienema',
        amount: 25.5,
        date: DateTime.now(),
        caegory: Categorty.liesure),
  ];

  void addNewExpense(Expense ex) {
    setState(() {
      _registeredExpenses.add(ex);
    });
  }

  void _deleteExpense(Expense ex) {
    final deletedElement = ex;
    final indexElemet = _registeredExpenses.indexOf(ex);
    setState(() {
      _registeredExpenses.remove(ex);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: const Text('Expense deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(indexElemet, deletedElement);
            });
          },
        ),
      ),
    );
  }

  void _addExpense() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      constraints: const BoxConstraints(maxWidth: double.infinity), //to take all screen
      builder: (ctx) => NewExpense(
        addNewExpense: addNewExpense,
      ),
    );
  }

  @override
  Widget build(context) {
    final width = MediaQuery.of(context).size.width;
    // print(MediaQuery.of(context).size.width);

    Widget mainContent =
        const Center(child: Text('There is no Expenses Try to add one!'));
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
          expenses: _registeredExpenses, removeExpense: _deleteExpense);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutterb ExpensesTracker'),
        actions: [
          IconButton(
            onPressed: _addExpense,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(child: mainContent),
              ],
            )
          : Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)),
                Expanded(child: mainContent),
              ],
              
            ),
    );
  }
}
