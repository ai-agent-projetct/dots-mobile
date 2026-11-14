import 'package:user/features/home/data/models/trade_model.dart';
import 'package:user/features/home/domain/repository/home_repository.dart';
import 'package:user/features/home/domain/usecase/getalltrade_usecase.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class GetAllTradeUsecaseImpl implements GetAllTradePostUsecae {
  final HomeRepository _repository;

  GetAllTradeUsecaseImpl(this._repository);

  @override
  Future<Either<Failure, List<TradeData>>> getAllTradePost() async {
    return await _repository.getAllTrades();
  }
}
