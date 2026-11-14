import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user/features/home/data/datasource/home_datasource.dart';
import 'package:user/features/home/data/datasource_impl/home_datasource_impl.dart';
import 'package:user/features/home/data/repository_impl/home_repository_impl.dart';
import 'package:user/features/home/domain/repository/home_repository.dart';
import 'package:user/features/home/domain/usecase/create_poll_usecase.dart';
import 'package:user/features/home/domain/usecase/create_trendpost_usecase.dart';
import 'package:user/features/home/domain/usecase/dashboard_usecase.dart';
import 'package:user/features/home/domain/usecase/getalloffers_usecase.dart';
import 'package:user/features/home/domain/usecase/getalltrade_usecase.dart';
import 'package:user/features/home/domain/usecase/getsubcategorylist_usecase.dart';
import 'package:user/features/home/domain/usecase/gettradebyuserId_usecae.dart';
import 'package:user/features/home/domain/usecase/poll_topics_usecase.dart';
import 'package:user/features/home/domain/usecase/polls_list_usecase.dart';
import 'package:user/features/home/domain/usecase/update_fcm_usecase.dart';
import 'package:user/features/home/domain/usecase/vote_poll_usecase.dart';
import 'package:user/features/home/domain/usecase_impl/create_poll_usecase_impl.dart';
import 'package:user/features/home/domain/usecase_impl/create_trendpost_usecae_impl.dart';
import 'package:user/features/home/domain/usecase_impl/dashboard_usecase_impl.dart';
import 'package:user/features/home/domain/usecase_impl/getalloffers_usecase_impl.dart';
import 'package:user/features/home/domain/usecase_impl/getalltrade_usecae_impl.dart';
import 'package:user/features/home/domain/usecase_impl/getsubcategorylist_uscase_impl.dart';
import 'package:user/features/home/domain/usecase_impl/gettardebyuserid_usecase_impl.dart';
import 'package:user/features/home/domain/usecase_impl/poll_topics_usecase_impl.dart';
import 'package:user/features/home/domain/usecase_impl/polls_list_usecase_impl.dart';
import 'package:user/features/home/domain/usecase_impl/update_fcm_usecase_impl.dart';
import 'package:user/features/home/domain/usecase_impl/vote_poll_usecase_impl.dart';
import 'package:user/features/home/presentation/provider/explore_provider.dart';
import 'package:user/features/home/presentation/provider/home_provider.dart';
import 'package:user/features/home/presentation/provider/maps_provider.dart';
import 'package:user/features/home/presentation/provider/poll_provider.dart';
import 'package:user/features/home/presentation/provider/trade_provider.dart';
import 'package:user/features/menu/data/datasource/profile_datasource.dart';
import 'package:user/features/menu/data/datasource_impl/profile_datasource_impl.dart';
import 'package:user/features/menu/data/respository_impl/profile_respository_impl.dart';
import 'package:user/features/menu/domain/repository/profile_repository.dart';
import 'package:user/features/menu/domain/usecase/file_upload_usecase.dart';
import 'package:user/features/menu/domain/usecase/getappointment_usecase.dart';
import 'package:user/features/menu/domain/usecase/logout_usecase.dart';
import 'package:user/features/menu/domain/usecase/notification_usecase.dart';
import 'package:user/features/menu/domain/usecase/profile_view_usecase.dart';
import 'package:user/features/menu/domain/usecase/update_profile_usecase.dart';
import 'package:user/features/menu/domain/usecase_impl/file_upload_usecase_impl.dart';
import 'package:user/features/menu/domain/usecase_impl/getappointment_usecase_impl.dart';
import 'package:user/features/menu/domain/usecase_impl/logout_usecase_impl.dart';
import 'package:user/features/menu/domain/usecase_impl/notification_usecase_impl.dart';
import 'package:user/features/menu/domain/usecase_impl/profile_view_usecase_impl.dart';
import 'package:user/features/menu/domain/usecase_impl/update_profile_usecase_impl.dart';
import 'package:user/features/menu/presentation/provider/profile_provider.dart';
import 'package:user/features/offers/data/datasource/offers_datasorce.dart';
import 'package:user/features/offers/data/datasource_impl/offers_datasource_impl.dart';
import 'package:user/features/offers/data/repository_impl/offersrepositary_impl.dart';
import 'package:user/features/offers/domain/repository/offers_repositary.dart';
import 'package:user/features/offers/domain/usecases/getalloffers_usecase.dart';
import 'package:user/features/offers/domain/usecases/selectedofferspost_usecase.dart';
import 'package:user/features/offers/domain/usecasses_impl/getalloffers_usecase_impl.dart';
import 'package:user/features/offers/domain/usecasses_impl/selectedofferspost_usecase_impl.dart';
import 'package:user/features/offers/presentation/provider/offers_provider.dart';
import 'package:user/features/onboarding/data/datasource/onboarding_datasource.dart';
import 'package:user/features/onboarding/data/datasource_impl/onboarding_ds_impl.dart';
import 'package:user/features/onboarding/data/repository_impl/onboarding_repo_impl.dart';
import 'package:user/features/onboarding/domain/repository/onboarding_repository.dart';
import 'package:user/features/onboarding/domain/usecase/check_user_usecase.dart';
import 'package:user/features/onboarding/domain/usecase/login_usecase.dart';
import 'package:user/features/onboarding/domain/usecase/password_update_usecase.dart';
import 'package:user/features/onboarding/domain/usecase/register_usecase.dart';
import 'package:user/features/onboarding/domain/usecase/splash_usecase.dart';
import 'package:user/features/onboarding/domain/usecase_impl/check_user_usecase_impl.dart';
import 'package:user/features/onboarding/domain/usecase_impl/login_usecase_impl.dart';
import 'package:user/features/onboarding/domain/usecase_impl/password_update_usecase_impl.dart';
import 'package:user/features/onboarding/domain/usecase_impl/register_usecase_impl.dart';
import 'package:user/features/onboarding/domain/usecase_impl/splash_usecase_impl.dart';
import 'package:user/features/onboarding/presentation/provider/auth_provider.dart';
import 'package:user/features/onboarding/presentation/provider/onboarding_provider.dart';
import 'package:user/features/route/presentation/provider/route_provider.dart';
import 'package:user/features/serviceProvider/data/datasource/provider_datasource.dart';
import 'package:user/features/serviceProvider/data/datasoure_impl/provider_datasource_impl.dart';
import 'package:user/features/serviceProvider/data/repository_impl/providers_repository_impl.dart';
import 'package:user/features/serviceProvider/domain/repository/providers_repository.dart';
import 'package:user/features/serviceProvider/domain/usecase/addappointmenty_usecase.dart';
import 'package:user/features/serviceProvider/domain/usecase/createreview_usecase.dart';
import 'package:user/features/serviceProvider/domain/usecase/getratings_usecase.dart';
import 'package:user/features/serviceProvider/domain/usecase/provider_details_usecase.dart';
import 'package:user/features/serviceProvider/domain/usecase/providers_list_usecase.dart';
import 'package:user/features/serviceProvider/domain/usecase_impl/addappointment_usecase_impl.dart';
import 'package:user/features/serviceProvider/domain/usecase_impl/createreview_usacase_impl.dart';
import 'package:user/features/serviceProvider/domain/usecase_impl/getratings_usecase_impl.dart';
import 'package:user/features/serviceProvider/domain/usecase_impl/provider_details_usecase_impl.dart';
import 'package:user/features/serviceProvider/domain/usecase_impl/providers_list_usecase_impl.dart';
import 'package:user/features/serviceProvider/presentation/provider/appointment_provider.dart';
import 'package:user/features/serviceProvider/presentation/provider/jobbers_provider.dart';
import 'package:user/features/subscriptions/data/datasource/subscription_datasource.dart';
import 'package:user/features/subscriptions/data/datasource_impl/subscription_datasource_impl.dart';
import 'package:user/features/subscriptions/data/repository_impl/subscription_repository_impl.dart';
import 'package:user/features/subscriptions/domain/repository/subscription_repository.dart';
import 'package:user/features/subscriptions/domain/usecases/createsubscription_usecase.dart';
import 'package:user/features/subscriptions/domain/usecases/getsubscriptions_usecase.dart';
import 'package:user/features/subscriptions/domain/usecases_impl/createsubscription_usecase_impl.dart';
import 'package:user/features/subscriptions/domain/usecases_impl/getsubscription_impl.dart';
import 'package:user/features/subscriptions/presentation/provider/subscription_provider.dart';
import 'package:user/features/trends/data/datasource/trends_datasource.dart';
import 'package:user/features/trends/data/datasource_impl/trends_datasource_impl.dart';
import 'package:user/features/trends/data/repository_impl/trends_repository_impl.dart';
import 'package:user/features/trends/domain/repository/trends_trpository.dart';
import 'package:user/features/trends/domain/usecases/getalltrends_usecase.dart';
import 'package:user/features/trends/domain/usecases/moretrends_usecase.dart';
import 'package:user/features/trends/domain/usecases_impl/getalltrends_usecase_impl.dart';
import 'package:user/features/trends/domain/usecases_impl/moretrends_usecase_impl.dart';
import 'package:user/features/trends/presentation/provider/trends_provider.dart';
import 'package:user/internet_provider.dart';
import 'package:user/network/logging_interceptor.dart';

//dio
var dioProvider = Provider<Dio>((_) {
  var options = BaseOptions(
    baseUrl: '',
    connectTimeout: Duration(milliseconds: 10000),
    receiveTimeout: Duration(milliseconds: 10000),
  );
  var dio = Dio(options);
  dio.interceptors.add(LoggerInterceptor());
  return dio;
});

var internetProvider = ChangeNotifierProvider.autoDispose(
  (ref) => InternetProvider(),
);

//OnBoarding
var onBoardingDataSource = Provider.autoDispose<OnboardingDatasource>(
  (ref) => OnboardingDatasourceImpl(ref.watch(dioProvider)),
);

var onBoardingRepository = Provider.autoDispose<OnboardingRepository>(
  (ref) => OnboardingRepoImpl(ref.watch(onBoardingDataSource)),
);

var onBoardingUsecase = Provider.autoDispose<SplashUsecase>(
  (ref) => SplashUsecaseImpl(ref.watch(onBoardingRepository)),
);

var onBoardingProvider = ChangeNotifierProvider.autoDispose(
  (ref) => OnboardingProvider(ref.watch(onBoardingUsecase)),
);

var loginUsecase = Provider.autoDispose<LoginUsecase>(
  (ref) => LoginUsecaseImpl(ref.watch(onBoardingRepository)),
);

var registerUsecase = Provider.autoDispose<RegisterUsecase>(
  (ref) => RegisterUsecaseImpl(ref.watch(onBoardingRepository)),
);

var checkUsercase = Provider.autoDispose<CheckUserUsecase>(
  (ref) => CheckUserUsecaseImpl(ref.watch(onBoardingRepository)),
);

var passwordUpdateUsecase = Provider.autoDispose<PasswordUpdateUsecase>(
  (ref) => PasswordUpdateUsecaseImpl(ref.watch(onBoardingRepository)),
);

var authProvider = ChangeNotifierProvider.autoDispose(((ref) {
  return AuthProvider(
    ref.watch(loginUsecase),
    ref.watch(registerUsecase),
    ref.watch(checkUsercase),
    ref.watch(passwordUpdateUsecase),
  );
}));

// home and map
var homeDataSource = Provider.autoDispose<HomeDatasource>(
  (ref) => HomeDatasourceImpl(ref.watch(dioProvider)),
);

var homeRepository = Provider.autoDispose<HomeRepository>(
  (ref) => HomeRepositoryImpl(ref.watch(homeDataSource)),
);

var deviceUpdateUsecase = Provider.autoDispose<UpdateFcmUsecase>(
  (ref) => UpdateFcmUsecaseImpl(ref.watch(homeRepository)),
);

// var homeProvider = ChangeNotifierProvider.autoDispose((ref) {
//   ref.keepAlive();
//   return HomeProvider(ref.watch(deviceUpdateUsecase));
// });

final homeProvider = ChangeNotifierProvider.autoDispose<HomeProvider>((ref) {
  //ref.keepAlive();

  return HomeProvider(
    ref,
    ref.watch(deviceUpdateUsecase),
    ref.watch(getAllOffersUsecase),
  );
});

// var homeProvider = ChangeNotifierProvider.autoDispose((ref) {

var dashboardUsecase = Provider.autoDispose<DashboardUsecase>(
  (ref) => DashboardUsecaseImpl(ref.watch(homeRepository)),
);
var subcategorylistusecase = Provider.autoDispose<GetsubcategorylistUsecase>(
  (ref) => GetsubcategorylistUscaseImpl(ref.watch(homeRepository)),
);
var exploreProvider = ChangeNotifierProvider.autoDispose(
  (ref) => ExploreProvider(
    ref.watch(dashboardUsecase),
    ref.watch(subcategorylistusecase),
    ref.watch(providersListUsecase),
    ref,
  ),
);

var mapsProvider = ChangeNotifierProvider.autoDispose((ref) {
  ref.keepAlive();
  return MapsProvider();
});

// profile
var profileDataSource = Provider.autoDispose<ProfileDatasource>(
  (ref) => ProfileDatasourceImpl(ref.watch(dioProvider)),
);

var profileRepository = Provider.autoDispose<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(ref.watch(profileDataSource)),
);

var profileViewUsecase = Provider.autoDispose<ProfileViewUsecase>(
  (ref) => ProfileViewUsecaseImpl(ref.watch(profileRepository)),
);

var fileUploadUsecase = Provider.autoDispose<FileUploadUsecase>(
  (ref) => FileUploadUsecaseImpl(ref.watch(profileRepository)),
);

var profileUpdateUsecase = Provider.autoDispose<UpdateProfileUsecase>(
  (ref) => UpdateProfileUsecaseImpl(ref.watch(profileRepository)),
);

var logoutUsecase = Provider.autoDispose<LogoutUsecase>(
  (ref) => LogoutUsecaseImpl(ref.watch(profileRepository)),
);
var getAppointmentUsecase = Provider.autoDispose<GetAppointmentsUseacse>(
  (ref) => GetAppointmentsUseacseImpl(ref.watch(profileRepository)),
);

var getUserNotificationUseacse =
    Provider.autoDispose<GetUserNotificationUseacse>(
      (ref) => GetUserNotificationsUseacseImpl(ref.watch(profileRepository)),
    );

var profileProvider = ChangeNotifierProvider.autoDispose(
  (ref) => ProfileProvider(
    ref.watch(profileViewUsecase),
    ref.watch(fileUploadUsecase),
    ref.watch(profileUpdateUsecase),
    ref.watch(logoutUsecase),
    ref.watch(checkUsercase),
    ref.watch(getAppointmentUsecase),
    ref.watch(getUserNotificationUseacse),
  ),
);

// poll

var pollsListUseCase = Provider.autoDispose<PollsListUsecase>(
  (ref) => PollsListUsecaseImpl(ref.watch(homeRepository)),
);

var pollTopicsUsecase = Provider.autoDispose<PollTopicsUsecase>(
  (ref) => PollTopicsUsecaseImpl(ref.watch(homeRepository)),
);

var createPollUsecase = Provider.autoDispose<CreatePollUsecase>(
  (ref) => CreatePollUsecaseImpl(ref.watch(homeRepository)),
);

var getAllTrendPostUsecase = Provider.autoDispose<GetAllTradePostUsecae>(
  (ref) => GetAllTradeUsecaseImpl(ref.watch(homeRepository)),
);

var getTradeByUserIdUsecase = Provider.autoDispose<GetTradeByUserIdUsecae>(
  (ref) => GetTradeByUserIdUsecaseImpl(ref.watch(homeRepository)),
);

var createTrendPostUsecase = Provider.autoDispose<CreateTrendPostUsecase>(
  (ref) => CreateTrendpostUsecaeImpl(ref.watch(homeRepository)),
);

var votePollCase = Provider.autoDispose<VotePollUsecase>(
  (ref) => VotePollUsecaseImpl(ref.watch(homeRepository)),
);

var pollProvider = ChangeNotifierProvider.autoDispose((ref) {
  return PollProvider(
    ref.watch(pollsListUseCase),
    ref.watch(pollTopicsUsecase),
    ref.watch(fileUploadUsecase),
    ref.watch(createPollUsecase),
    ref.watch(votePollCase),
  );
});

var tradeProvider = ChangeNotifierProvider.autoDispose((ref) {
  return TradeProvider(
    ref.watch(getAllTrendPostUsecase),
    ref.watch(getTradeByUserIdUsecase),

    ref.watch(fileUploadUsecase),
    ref.watch(createTrendPostUsecase),
  );
});

//trends
var trendsDataSource = Provider.autoDispose<TrendsDatasource>(
  (ref) => TrendsDatasourceImpl(ref.watch(dioProvider)),
);

var trendsRepository = Provider.autoDispose<TrendsRepository>(
  (ref) => TrendsRepositoryImpl(ref.watch(trendsDataSource)),
);

final getAllTrendsUsecase = Provider<GetAllTrendsUsecae>(
  (ref) => GetAllTrendsUsecaseImpl(ref.watch(trendsRepository)),
);

final getMoreTrendsUsecase = Provider<MoreTrendsUsecase>(
  (ref) => MoreTrendsUsecasempl(ref.watch(trendsRepository)),
);

// var trendsProvider = ChangeNotifierProvider.autoDispose((ref) {
//   return TrendsProvider(ref.watch(getAllTrendsUsecase));
// });
var trendsProvider = ChangeNotifierProvider((ref) {
  return TrendsProvider(
    ref.watch(getAllTrendsUsecase),
    ref.watch(getMoreTrendsUsecase),
  );
});

// final trendsProvider = ChangeNotifierProvider.autoDispose<TrendsProvider>((
//   ref,
// ) {
//   final link = ref.keepAlive(); // Keeps alive temporarily for async operations

//   final provider = TrendsProvider(ref.watch(getAllTrendsUsecase));

//   // Optional: close link after some delay if not used
//   Future.delayed(const Duration(seconds: 60), () => link.close());

//   return provider;
// });

//route
var routeProvider = ChangeNotifierProvider.autoDispose((ref) {
  return RouteProvider();
});

// offers

var offersDataSource = Provider.autoDispose<OffersDatasource>(
  (ref) => OffersDatasourceImpl(ref.watch(dioProvider)),
);

var offersRepository = Provider.autoDispose<OffersRepository>(
  (ref) => OffersRepositoryImpl(ref.watch(offersDataSource)),
);

final getAllOffersUsecase = Provider<GetAllOffersUsecae>(
  (ref) => GetAllOffersUsecaseImpl(ref.watch(offersRepository)),
);

final selectedOffersUsecase = Provider<SelectedOffersPostUsecase>(
  (ref) => SelectedOffersPostUsecaseImpl(ref.watch(offersRepository)),
);

var offersProvider = ChangeNotifierProvider((ref) {
  return OffersProvider(
    ref.watch(getAllOffersUsecase),
    ref.watch(selectedOffersUsecase),
  );
});

// jobbers
var serviceProviderDataSource = Provider.autoDispose<ProviderDatasource>(
  (ref) => ProviderDatasourceImpl(ref.watch(dioProvider)),
);

var serviceProviderRepository = Provider.autoDispose<ProvidersRepository>(
  (ref) => ProvidersRepositoryImpl(ref.watch(serviceProviderDataSource)),
);

var providersListUsecase = Provider.autoDispose<ProvidersListUsecase>(
  (ref) => ProvidersListUsecaseImpl(ref.watch(serviceProviderRepository)),
);

var providerDetailsUsecase = Provider.autoDispose<ProviderDetailsUsecase>(
  (ref) => ProviderDetailsUsecaseImpl(ref.watch(serviceProviderRepository)),
);

var createReviewUsecase = Provider.autoDispose<CreateReviewUsecase>(
  (ref) => CreatReviewUsecaseImpl(ref.watch(serviceProviderRepository)),
);

var getratingsUsecase = Provider.autoDispose<GetRatingsUsecase>(
  (ref) => GetRatingsUsecaseImpl(ref.watch(serviceProviderRepository)),
);

var jobbersProvider = ChangeNotifierProvider.autoDispose((ref) {
  return JobbersProvider(
    ref.watch(providersListUsecase),
    ref.watch(providerDetailsUsecase),
    ref.watch(createReviewUsecase),
    ref.watch(getratingsUsecase),
  );
});

var addappointmentUsecase = Provider.autoDispose<AddAppointmentUsecase>(
  (ref) => AddappointmentUsecaseImpl(ref.watch(serviceProviderRepository)),
);

var appointmentProvider = ChangeNotifierProvider.autoDispose((ref) {
  return AppointmentProvider(ref.watch(addappointmentUsecase));
});

//subscription

final subscriptionDataSource = Provider.autoDispose<SubscriptionDatasource>(
  (ref) => SubscriptionDatasourceImpl(ref.watch(dioProvider)),
);

final subscriptionRepository = Provider.autoDispose<SubscriptionRepository>(
  (ref) => SubscriptionRepositoryImpl(ref.watch(subscriptionDataSource)),
);

final getUserSubscriptionUsecase = Provider.autoDispose<
  GetUserSubscriptionsUsecase
>((ref) => GetUserSubscriptionsUsecaseImpl(ref.watch(subscriptionRepository)));

final createUserSubscriptionUsecase =
    Provider.autoDispose<CreatesubscriptionUsecase>(
      (ref) => CreatesubscriptionUsecaseImpl(ref.watch(subscriptionRepository)),
    );

// final createpaymentusecase = Provider.autoDispose<CreatepaymentUsecase>(
//   (ref) => CreatepaymentUsecaseImpl(ref.watch(subscriptionRepository)),
// );

// final updatepaymentusecase = Provider.autoDispose<UpdatepaymentUsecase>(
//   (ref) => UpdatepaymentUsecaseImpl(ref.watch(subscriptionRepository)),
// );

// final addcashsubscriptionUsecase = Provider.autoDispose<
//   AddcashsubscriptionUsecase
// >((ref) => AddcashsubscriptionUsecaseImpl(ref.watch(subscriptionRepository)));

// final getSubscriptionsUsecase = Provider.autoDispose<GetSubscriptionsUsecase>(
//   (ref) => GetSubscriptionsUsecaseImpl(ref.watch(subscriptionRepository)),
// );

final subscriptionProvider = ChangeNotifierProvider<SubscriptionProvider>((
  ref,
) {
  return SubscriptionProvider(
    ref.watch(getUserSubscriptionUsecase),
    ref.watch(createUserSubscriptionUsecase),
    // ref.watch(createpaymentusecase),
    // ref.watch(updatepaymentusecase),
    // ref.watch(addcashsubscriptionUsecase),
    // ref.watch(getSubscriptionsUsecase),
  );
});
