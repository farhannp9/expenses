import 'package:uuid/uuid.dart';

class Transaction {
  final String id;
  final String accountId;
  final double amount;
  final String notes;
  final DateTime dateTime;

  const Transaction(
    this.id, {
    required this.accountId,
    required this.amount,
    required this.notes,
    required this.dateTime,
  });

  static createTransaction({
    required String accountId,
    required double amount,
    required String notes,
    required DateTime dateTime,
  }) {
    return Transaction(const Uuid().v1(),
        accountId: accountId, amount: amount, notes: notes, dateTime: dateTime);
  }
}