import 'package:user/features/home/data/datasource/home_datasource.dart';
import 'package:user/features/home/data/models/dashboard_model.dart';
import 'package:user/features/home/data/models/poll_list_model.dart';
import 'package:user/features/home/data/models/poll_topics_model.dart';
import 'package:user/features/home/data/models/subactegorytlist_response_model.dart';
import 'package:user/features/home/data/models/trade_model.dart';
import 'package:user/features/home/domain/repository/home_repository.dart';
import 'package:user/features/offers/data/models/getalloffers_model.dart';
import 'package:user/features/onboarding/data/models/common_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDatasource _datasource;
  HomeRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, CommonResponseModel>> deviceUpdate(
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, CommonResponseModel>();
    var data = await _datasource.deviceUpdate(body);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, DashboardResponseModel>> getDashboard() async {
    var result = Either<Failure, DashboardResponseModel>();
    var data = await _datasource.getDashboard();
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, PollsListResponseModel>> getPollsList() async {
    var result = Either<Failure, PollsListResponseModel>();
    var data = await _datasource.getPollsList();
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, PollTopicsResponseModel>> getPollTopics() async {
    var result = Either<Failure, PollTopicsResponseModel>();
    var data = await _datasource.getPollTopics();
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, CommonResponseModel>> createPoll(
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, CommonResponseModel>();
    var data = await _datasource.createPoll(body);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, CommonResponseModel>> votePoll(
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, CommonResponseModel>();
    var data = await _datasource.votePoll(body);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, CommonResponseModel>> createTradePost(
    Map<String, dynamic> body,
  ) async {
    var result = Either<Failure, CommonResponseModel>();
    var data = await _datasource.createTrendPost(body);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, List<TradeData>>> getAllTrades() async {
    final result = Either<Failure, List<TradeData>>();
    final response = await _datasource.getAllTrendPost();

    if (response.isLeft()) {
      result.setLeft(response.getLeft());
    } else {
      result.setRight(response.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, List<TradeData>>> getTradesByUserId() async {
    final result = Either<Failure, List<TradeData>>();
    final response = await _datasource.getTrendByUserId();

    if (response.isLeft()) {
      result.setLeft(response.getLeft());
    } else {
      result.setRight(response.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, GetAllOfferResponseModel>> getAllOffers(
    double lat,
    double lon,
  ) async {
    var result = Either<Failure, GetAllOfferResponseModel>();
    var data = await _datasource.getAllOffers(lat, lon);
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }

  @override
  Future<Either<Failure, SubCategoryListResponseModel>>
  getsubCategoryList() async {
    var result = Either<Failure, SubCategoryListResponseModel>();
    var data = await _datasource.getsubCategoryList();
    if (data.isLeft()) {
      result.setLeft(data.getLeft());
    } else {
      result.setRight(data.getRight());
    }
    return result;
  }
}
