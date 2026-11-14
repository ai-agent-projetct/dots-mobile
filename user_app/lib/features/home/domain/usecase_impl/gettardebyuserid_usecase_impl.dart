import 'package:user/features/home/data/models/trade_model.dart';
import 'package:user/features/home/domain/repository/home_repository.dart';
import 'package:user/features/home/domain/usecase/gettradebyuserId_usecae.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class GetTradeByUserIdUsecaseImpl implements GetTradeByUserIdUsecae {
  final HomeRepository _repository;

  GetTradeByUserIdUsecaseImpl(this._repository);

  @override
  Future<Either<Failure, List<TradeData>>> getTradeByUserId() async {
    return await _repository.getTradesByUserId();
  }
}
