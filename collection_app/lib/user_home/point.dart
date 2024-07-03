import 'package:flutter/material.dart';

class Transaction {
  final String title;
  final double amount;
  final DateTime date;
  final DateTime time;

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.time,
  });
}

class Point extends StatelessWidget {
  final List<Transaction> transactions = [
    Transaction(
      title: 'Transaction 1',
      amount: 25.0,
      date: DateTime(2023, 2, 15),
      time: DateTime(2023, 2, 15, 8, 30, 0),
    ),
    Transaction(
      title: 'Transaction 2',
      amount: 50.0,
      date: DateTime(2023, 2, 14),
      time: DateTime(2023, 2, 14, 10, 45, 0),
    ),
    Transaction(
      title: 'Transaction 3',
      amount: -30.0,
      date: DateTime(2023, 2, 13),
      time: DateTime(2023, 2, 13, 12, 0, 0),
    ),
    Transaction(
      title: 'Transaction 4',
      amount: 70.0,
      date: DateTime(2023, 2, 12),
      time: DateTime(2023, 2, 12, 14, 30, 0),
    ),
    Transaction(
      title: 'Transaction 5',
      amount: -20.0,
      date: DateTime(2023, 2, 11),
      time: DateTime(2023, 2, 11, 16, 15, 0),
    ),
    Transaction(
      title: 'Transaction 6',
      amount: 60.0,
      date: DateTime(2023, 2, 10),
      time: DateTime(2023, 2, 10, 18, 0, 0),
    ),
    Transaction(
      title: 'Transaction 7',
      amount: 40.0,
      date: DateTime(2023, 2, 9),
      time: DateTime(2023, 2, 9, 20, 45, 0),
    ),
    Transaction(
      title: 'Transaction 8',
      amount: -15.0,
      date: DateTime(2023, 2, 8),
      time: DateTime(2023, 2, 8, 22, 30, 0),
    ),
    Transaction(
      title: 'Transaction 9',
      amount: 80.0,
      date: DateTime(2023, 2, 7),
      time: DateTime(2023, 2, 7, 8, 0, 0),
    ),
    Transaction(
      title: 'Transaction 10',
      amount: 55.0,
      date: DateTime(2023, 2, 6),
      time: DateTime(2023, 2, 6, 10, 15, 0),
    ),
    Transaction(
      title: 'Transaction 11',
      amount: -35.0,
      date: DateTime(2023, 2, 5),
      time: DateTime(2023, 2, 5, 12, 30, 0),
    ),
    Transaction(
      title: 'Transaction 12',
      amount: 90.0,
      date: DateTime(2023, 2, 4),
      time: DateTime(2023, 2, 4, 14, 45, 0),
    ),
    Transaction(
      title: 'Transaction 13',
      amount: 65.0,
      date: DateTime(2023, 2, 3),
      time: DateTime(2023, 2, 3, 16, 0, 0),
    ),
    Transaction(
      title: 'Transaction 14',
      amount: -25.0,
      date: DateTime(2023, 2, 2),
      time: DateTime(2023, 2, 2, 18, 15, 0),
    ),
    Transaction(
      title: 'Transaction 15',
      amount: 75.0,
      date: DateTime(2023, 2, 1),
      time: DateTime(2023, 2, 1, 20, 30, 0),
    ),
    Transaction(
      title: 'Transaction 16',
      amount: 85.0,
      date: DateTime(2023, 1, 31),
      time: DateTime(2023, 1, 31, 22, 45, 0),
    ),
    Transaction(
      title: 'Transaction 17',
      amount: -45.0,
      date: DateTime(2023, 1, 30),
      time: DateTime(2023, 1, 30, 8, 0, 0),
    ),
    Transaction(
      title: 'Transaction 18',
      amount: 95.0,
      date: DateTime(2023, 1, 29),
      time: DateTime(2023, 1, 29, 10, 15, 0),
    ),
    Transaction(
      title: 'Transaction 19',
      amount: -55.0,
      date: DateTime(2023, 1, 28),
      time: DateTime(2023, 1, 28, 12, 30, 0),
    ),
    Transaction(
      title: 'Transaction 20',
      amount: 105.0,
      date: DateTime(2023, 1, 27),
      time: DateTime(2023, 1, 27, 14, 45, 0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Transaction History',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white60,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 10, 4, 37),
      body: TransactionHistory(transactions: transactions),
    );
  }
}

class TransactionHistory extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionHistory({Key? key, required this.transactions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? const Center(
            child: Text(
              'No Data Found',
              style: TextStyle(fontSize: 18, color: Colors.white60),
            ),
          )
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              final amountColor =
                  transaction.amount > 0 ? Colors.blue : Colors.red;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                    color: Colors.blueGrey.shade50,
                  ),
                  child: ListTile(
                    title: Text(transaction.title),
                    subtitle: Text(
                      '${transaction.amount.toStringAsFixed(2)} coins',
                      style: TextStyle(color: amountColor),
                    ),
                    trailing: Text(
                      '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
