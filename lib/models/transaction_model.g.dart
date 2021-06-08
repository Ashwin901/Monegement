// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 0;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      transactionAmount: fields[0] as double,
      transactionCategory: fields[1] as String,
      transactionDate: fields[2] as String,
      transactionDescription: fields[3] as String,
      transactionColor: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.transactionAmount)
      ..writeByte(1)
      ..write(obj.transactionCategory)
      ..writeByte(2)
      ..write(obj.transactionDate)
      ..writeByte(3)
      ..write(obj.transactionDescription)
      ..writeByte(4)
      ..write(obj.transactionColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
