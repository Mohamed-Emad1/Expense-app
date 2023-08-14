import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense/expense_data/expense_data.dart';

final formmater = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.addNewExpense});

  final void Function(Expense e) addNewExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  DateTime? _selectedDate;
  Categorty _selectedCategory = Categorty.work;

  void _datePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  final _titleCobtroller = TextEditingController();
  final _number = TextEditingController();
  @override
  void dispose() {
    _titleCobtroller.dispose();
    _number.dispose();
    super.dispose();
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
                title: const Text('Invalid Input'),
                content: const Text(
                    'Please make sure you entered a valid date, title, amont and Category.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text('Okay'))
                ],
              ));
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'Please make sure you entered a valid date, title, amont and Category.'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'))
          ],
        ),
      );
    }
  }

  void _submittedData() {
    final _amountDigits = double.tryParse(_number.text);
    final _amountInvalid = _amountDigits == null || _amountDigits <= 0;
    if (_titleCobtroller.text.trim().isEmpty ||
        _amountInvalid ||
        _selectedDate == null) {
      _showDialog();

      return;
    } else {
      final Expense expense = Expense(
          title: _titleCobtroller.text,
          amount: _amountDigits,
          date: _selectedDate!,
          caegory: _selectedCategory);
      Navigator.pop(context);
      widget.addNewExpense(expense);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget titleInput = TextField(
      controller: _titleCobtroller,
      maxLength: 50,
      decoration: const InputDecoration(
        label: Text('Title'),
      ),
    );

    Widget droppedButton = DropdownButton(
      value: _selectedCategory,
      items: Categorty.values
          .map(
            (category) => DropdownMenuItem(
              value: category,
              child: Text(
                category.name.toUpperCase(),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value == null) return;
        setState(() {
          _selectedCategory = value;
        });
      },
    );

    Widget rowCancel = Row(
      children: [
        const Spacer(),
        ElevatedButton(
          onPressed: _submittedData,
          child: const Text("Save Expense"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );

    Widget amount = Expanded(
      child: TextField(
        controller: _number,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(
          label: Text('Amount'),
          prefixText: '\$ ',
        ),
      ),
    );

    final keySpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constrains) {
      final width = constrains.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 50, 16, keySpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: titleInput),
                      const SizedBox(
                        width: 24,
                      ),
                      amount
                    ],
                  )
                else
                  titleInput,
                if (width >= 600)
                  Row(
                    children: [
                      droppedButton,
                      const SizedBox(
                        width: 24,
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      amount,
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'No Selected Date'
                                  : formmater.format(_selectedDate!),
                              // style: const TextStyle(decorationColor: Colors.white),
                            ),
                            IconButton(
                              onPressed: _datePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 15),
                if (width >= 600) rowCancel else rowCancel
              ],
            ),
          ),
        ),
      );
    });
  }
}
