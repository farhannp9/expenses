import 'package:expenses/service/dto/transaction.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'transactiondto.g.dart';

@HiveType(typeId: 2)
class TransactionDto implements Comparable<TransactionDto> {
  @HiveField(1)
  final String id;
  @HiveField(2)
  final String accountId;
  @HiveField(3)
  final double amount;
  @HiveField(4)
  final String notes;
  @HiveField(5)
  final int timestamp;

  TransactionDto(
      this.id, this.accountId, this.amount, this.notes, this.timestamp);

  @override
  int compareTo(TransactionDto other) {
    return timestamp.compareTo(other.timestamp);
  }

  static TransactionDto fromTransaction(Transaction trx) {
    return TransactionDto(trx.id, trx.accountId, trx.amount, trx.notes,
        trx.dateTime.millisecondsSinceEpoch);
  }

  Transaction toTransaction() {
    return Transaction(id,
        accountId: accountId,
        amount: amount,
        notes: notes,
        dateTime: DateTime.fromMillisecondsSinceEpoch(timestamp));
  }
}
