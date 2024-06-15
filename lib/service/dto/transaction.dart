import 'package:uuid/uuid.dart';

class Transaction implements Comparable<Transaction> {
  final String id;
  final String accountId;
  final double amount;
  final String notes;
  final DateTime dateTime;
  final String? category;

  const Transaction(
    this.id, {
    required this.accountId,
    required this.amount,
    required this.notes,
    required this.dateTime,
    this.category,
  });

  static Transaction createTransaction({
    required String accountId,
    required double amount,
    required String notes,
    required DateTime dateTime,
    String? category,
  }) {
    return Transaction(const Uuid().v1(),
        accountId: accountId,
        amount: amount,
        notes: notes,
        dateTime: dateTime,
        category: category);
  }

  static Transaction addCategory(Transaction trx, String category) {
    return Transaction(trx.id,
        accountId: trx.accountId,
        amount: trx.amount,
        notes: trx.notes,
        dateTime: trx.dateTime,
        category: category);
  }

  @override
  int compareTo(Transaction other) {
    return dateTime.compareTo(other.dateTime);
  }
}
