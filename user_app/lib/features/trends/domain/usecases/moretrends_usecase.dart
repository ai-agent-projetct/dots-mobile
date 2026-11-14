import 'package:user/features/trends/data/models/getall_trends_model.dart';
import 'package:user/features/trends/data/models/moretrends_response_model.dart';
import 'package:user/network/error.dart';
import 'package:user/utils/either.dart';

abstract class MoreTrendsUsecase {
  Future<Either<Failure, ProviderTrendsResponseModel>> moreTrends(
    String mediaId,
  );
}
