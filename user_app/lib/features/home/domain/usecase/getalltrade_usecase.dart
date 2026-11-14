import 'package:user/features/home/data/models/trade_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class GetAllTradePostUsecae {
  Future<Either<Failure, List<TradeData>>> getAllTradePost();
}
