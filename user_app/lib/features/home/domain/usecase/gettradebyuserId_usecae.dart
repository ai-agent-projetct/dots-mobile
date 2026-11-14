// ignore: file_names
import 'package:user/features/home/data/models/trade_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class GetTradeByUserIdUsecae {
  Future<Either<Failure, List<TradeData>>> getTradeByUserId();
}
