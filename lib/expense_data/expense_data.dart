import "package:flutter/material.dart";
import "package:uuid/uuid.dart";
import 'package:intl/intl.dart';

const uuid = Uuid();

final formmater = DateFormat.yMd();

enum Categorty { food, travel, liesure, work }

const categortyIcon = {
  Categorty.food: Icons.lunch_dining,
  Categorty.liesure: Icons.movie,
  Categorty.work: Icons.work,
  Categorty.travel: Icons.flight_takeoff,
};

class Expense {
  Expense(
      {required this.title,
      required this.amount,
      required this.date,
      required this.caegory})
      : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Categorty caegory;

  String get formattedDate {
    return formmater.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.expenses, required this.category});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
  :expenses =allExpenses.where((expense) => expense.caegory == category).toList();

  final Categorty category;
  final List<Expense> expenses;

  double get ExpensesSum {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
