import 'package:user/features/home/data/models/dashboard_model.dart';
import 'package:user/features/home/data/models/poll_list_model.dart';
import 'package:user/features/home/data/models/poll_topics_model.dart';
import 'package:user/features/home/data/models/subactegorytlist_response_model.dart';
import 'package:user/features/home/data/models/trade_model.dart';
import 'package:user/features/offers/data/models/getalloffers_model.dart';
import 'package:user/features/onboarding/data/models/common_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class HomeRepository {
  Future<Either<Failure, CommonResponseModel>> deviceUpdate(
    Map<String, dynamic> body,
  );
  Future<Either<Failure, DashboardResponseModel>> getDashboard();
  Future<Either<Failure, PollsListResponseModel>> getPollsList();
  Future<Either<Failure, PollTopicsResponseModel>> getPollTopics();
  Future<Either<Failure, CommonResponseModel>> createPoll(
    Map<String, dynamic> body,
  );
  Future<Either<Failure, CommonResponseModel>> votePoll(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, CommonResponseModel>> createTradePost(
    Map<String, dynamic> body,
  );
  Future<Either<Failure, List<TradeData>>> getAllTrades();
  Future<Either<Failure, List<TradeData>>> getTradesByUserId();
  Future<Either<Failure, GetAllOfferResponseModel>> getAllOffers(
    double lat,
    double lon,
  );

  Future<Either<Failure, SubCategoryListResponseModel>> getsubCategoryList();
}
