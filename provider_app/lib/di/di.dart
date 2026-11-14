//dio
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/features/Trends/data/datasource/trends_datasource.dart';
import 'package:provider/features/Trends/data/datasource_impl/trends_datasource_impl.dart';
import 'package:provider/features/Trends/data/repository_impl/trends_repository_impl.dart';
import 'package:provider/features/Trends/domain/repository/trends_repositary.dart';
import 'package:provider/features/Trends/domain/usecases/createtrends_usecase.dart';
import 'package:provider/features/Trends/domain/usecases/getalltrends_usecase.dart';
import 'package:provider/features/Trends/domain/usecases/updatetrends_usecase.dart';
import 'package:provider/features/Trends/domain/usecases_impl/createtrends_usecase_impl.dart';
import 'package:provider/features/Trends/domain/usecases_impl/getalltrenda_usecase_impl.dart';
import 'package:provider/features/Trends/domain/usecases_impl/updatetrends_usecase_impl.dart';
import 'package:provider/features/Trends/presentation/provider/trends_provider.dart';
import 'package:provider/features/alert/data/datasource/alert_datasource.dart';
import 'package:provider/features/alert/data/datasource_impl/alert_datasource_impl.dart';
import 'package:provider/features/alert/data/repository_impl/alert_repository_impl.dart';
import 'package:provider/features/alert/domain/repository/alert_repository.dart';
import 'package:provider/features/alert/domain/usecases/createoffer_usercase.dart';
import 'package:provider/features/alert/domain/usecases/getalloffers_usecase.dart';
import 'package:provider/features/alert/domain/usecases/getproviderservices_usecase.dart';
import 'package:provider/features/alert/domain/usecases/updateoffer_usecase.dart';
import 'package:provider/features/alert/domain/usecases_impl/createoffer_usecase_impl.dart';
import 'package:provider/features/alert/domain/usecases_impl/getalloffers_usecase_impl.dart';
import 'package:provider/features/alert/domain/usecases_impl/getproviderservices_usecase_impl.dart';
import 'package:provider/features/alert/domain/usecases_impl/updateoffer_usecase_impl.dart';
import 'package:provider/features/alert/presentation/provider/alert_provider.dart';
import 'package:provider/features/home/presentaion/provider/home_provider.dart';
import 'package:provider/features/onboarding/data/datasource/onboarding_datasource.dart';
import 'package:provider/features/onboarding/data/datasource_impl/onboarding_ds_impl.dart';
import 'package:provider/features/onboarding/data/repository_impl/onboarding_repo_impl.dart';
import 'package:provider/features/onboarding/domain/usecase/check_user_usecase.dart';
import 'package:provider/features/onboarding/domain/usecase/fileupload_usecase.dart';
import 'package:provider/features/onboarding/domain/usecase/getcategory_usecase.dart';
import 'package:provider/features/onboarding/domain/usecase/getsubcategory_usecase.dart';
import 'package:provider/features/onboarding/domain/usecase/login_usecase.dart';
import 'package:provider/features/onboarding/domain/usecase/logout_usecase.dart';
import 'package:provider/features/onboarding/domain/usecase/password_update_usecase.dart';
import 'package:provider/features/onboarding/domain/usecase/register_usecase.dart';
import 'package:provider/features/onboarding/domain/usecase_impl/check_user_usecase_impl.dart';
import 'package:provider/features/onboarding/domain/usecase_impl/fileupload_usecase_impl.dart';
import 'package:provider/features/onboarding/domain/usecase_impl/getcategory_usecase_impl.dart';
import 'package:provider/features/onboarding/domain/usecase_impl/getsubcateory_usecase_impl.dart';
import 'package:provider/features/onboarding/domain/usecase_impl/login_usecase_impl.dart';
import 'package:provider/features/onboarding/domain/usecase_impl/logout_usecase_impl.dart';
import 'package:provider/features/onboarding/domain/usecase_impl/password_update_usecase_impl.dart';
import 'package:provider/features/onboarding/domain/usecase_impl/register_usecase_impl.dart';
import 'package:provider/features/onboarding/presentation/provider/auth_provider.dart';
import 'package:provider/features/onboarding/presentation/provider/onboarding_provider.dart';
import 'package:provider/features/profile/data/datasource/profile_datasource.dart';
import 'package:provider/features/profile/data/datasource_impl/profile_datasource_impl.dart';
import 'package:provider/features/profile/data/repository_impl/profile_repository_impl.dart';
import 'package:provider/features/profile/domain/repository/profile_repository.dart';
import 'package:provider/features/profile/domain/usecase/getappointments_usecase.dart';
import 'package:provider/features/profile/domain/usecase/serviceupdate_usecase.dart';
import 'package:provider/features/profile/domain/usecase/updateprofile_usecase.dart';
import 'package:provider/features/profile/domain/usecase_impl/getappointments_usecase_impl.dart';
import 'package:provider/features/profile/domain/usecase_impl/serviceupdate_usecase_impl.dart';
import 'package:provider/features/profile/domain/usecase_impl/updateprofile_usecase_impl.dart';
import 'package:provider/features/profile/presentation/provider/appointment_provider.dart';
import 'package:provider/features/profile/presentation/provider/category_provider.dart';
import 'package:provider/features/profile/presentation/provider/profile_provider.dart';
import 'package:provider/features/subscription/data/datasource/subscription_datasource.dart';
import 'package:provider/features/subscription/data/datasource_impl/subscription_datasource_impl.dart';
import 'package:provider/features/subscription/data/repository_impl/subscription_repository_impl.dart';
import 'package:provider/features/subscription/domain/repository/subscription_repository.dart';
import 'package:provider/features/subscription/domain/usecase/addcashsubscription_usecase.dart';
import 'package:provider/features/subscription/domain/usecase/createpayment_usecase.dart';
import 'package:provider/features/subscription/domain/usecase/createsubscription_usecase.dart';
import 'package:provider/features/subscription/domain/usecase/getprovidersubscription_usecase.dart';
import 'package:provider/features/subscription/domain/usecase/getsubscriptions_usecase.dart';
import 'package:provider/features/subscription/domain/usecase/updatepayment_usecase.dart';
import 'package:provider/features/subscription/domain/usecase_impl/addcashsubscription_usecase_impl.dart';
import 'package:provider/features/subscription/domain/usecase_impl/createpayment_usecase_impl.dart';
import 'package:provider/features/subscription/domain/usecase_impl/createsubscription_usecase_impl.dart';
import 'package:provider/features/subscription/domain/usecase_impl/getprovidersubscription_usecase_impl.dart';
import 'package:provider/features/subscription/domain/usecase_impl/getsubscription_impl.dart';
import 'package:provider/features/subscription/domain/usecase_impl/updatepayment_usecase_impl.dart';
import 'package:provider/features/subscription/presentaion/provider/subscription_provider.dart';
import 'package:provider/internet_provider.dart';
import 'package:provider/utils/network/logging_interceptor.dart';

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

// var onBoardingRepository = Provider.autoDispose<OnboardingRepository>(
//   (ref) => OnboardingRepoImpl(ref.watch(onBoardingDataSource)),
// );

final onBoardingRepository = Provider.autoDispose<OnboardingRepoImpl>(
  (ref) => OnboardingRepoImpl(ref.watch(onBoardingDataSource)),
);
var getCategoryUsecase = Provider.autoDispose<GetcategoryUsecase>(
  (ref) => GetcategoryUsecaseImpl(ref.watch(onBoardingRepository)),
);
var getSubCategoryUsecase = Provider.autoDispose<GetSubCategoryUsecase>(
  (ref) => GetSubCategoryUsecaseImpl(ref.watch(onBoardingRepository)),
);

final fileUploadUsecase = Provider.autoDispose<FileUploadUsecase>(
  (ref) => FileUploadUsecaseImpl(ref.watch(onBoardingRepository)),
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

var logutUsecase = Provider.autoDispose<LogoutUsecase>(
  (ref) => LogoutUsecaseImpl(ref.watch(onBoardingRepository)),
);

var authProvider = ChangeNotifierProvider.autoDispose(((ref) {
  return AuthProvider(
    ref.watch(loginUsecase),
    ref.watch(registerUsecase),
    ref.watch(checkUsercase),
    ref.watch(passwordUpdateUsecase),
    ref.watch(logutUsecase),
  );
}));

var onboardingProvider = ChangeNotifierProvider.autoDispose(((ref) {
  return OnboardingProvider(
    ref.watch(getCategoryUsecase),
    ref.watch(getSubCategoryUsecase),
    ref.watch(fileUploadUsecase),
  );
}));

//Home

final homeProvider = ChangeNotifierProvider<HomeProvider>((ref) {
  return HomeProvider();
});

//Trends
var trendsDataSource = Provider.autoDispose<TrendsDatasource>(
  (ref) => TrendsDatasourceImpl(ref.watch(dioProvider)),
);

var trendsRepository = Provider.autoDispose<TrendsRepository>(
  (ref) => TrendsRepositoryImpl(ref.watch(trendsDataSource)),
);

var createTrendsUsecase = Provider.autoDispose<CreateTrendsUsecase>(
  (ref) => CreateTrendsUsecaseImpl(ref.watch(trendsRepository)),
);

var getAllTrendsUsecase = Provider.autoDispose<GetAllTrendsUsecase>(
  (ref) => GetAllTrendsUsecaseImpl(ref.watch(trendsRepository)),
);

var updateTrendsUsecase = Provider.autoDispose<UpdatetrendsUsecase>(
  (ref) => UpdatetrendsUsecaseImpl(ref.watch(trendsRepository)),
);

final trendsProvider = ChangeNotifierProvider<TrendsProvider>((ref) {
  return TrendsProvider(
    ref.watch(createTrendsUsecase),
    ref.watch(fileUploadUsecase),
    ref.watch(getAllTrendsUsecase),
    ref.watch(updateTrendsUsecase),
  );
});

//Alert

var alertDataSource = Provider.autoDispose<AlertDatasource>(
  (ref) => AlertDatasourceImpl(ref.watch(dioProvider)),
);

var alertRepository = Provider.autoDispose<AlertRepository>(
  (ref) => AlertRepositoryImpl(ref.watch(alertDataSource)),
);
var getAllOffersusecase = Provider.autoDispose<GetAllOffersUsecase>(
  (ref) => GetAllOffersUsecaseImpl(ref.watch(alertRepository)),
);

var offerUpdateUsecase = Provider.autoDispose<UpdateofferUsecase>(
  (ref) => UpdateofferUsecaseImpl(ref.watch(alertRepository)),
);
var offerCreateUsecase = Provider.autoDispose<CreateOfferUsercase>(
  (ref) => CreateofferUsecaseImpl(ref.watch(alertRepository)),
);
var getProviderserviceUsecase =
    Provider.autoDispose<GetProviderServicesUsecase>(
      (ref) => GetproviderservicesUsecaseImpl(ref.watch(alertRepository)),
    );

final alertProvider = ChangeNotifierProvider<AlertProvider>((ref) {
  return AlertProvider(
    ref.watch(getAllOffersusecase),
    ref.watch(offerUpdateUsecase),
    ref.watch(getProviderserviceUsecase),
    ref.watch(offerCreateUsecase),
  );
});

// profile
var profileDataSource = Provider.autoDispose<ProfileDatasource>(
  (ref) => ProfileDatasourceImpl(ref.watch(dioProvider)),
);

var profileRepository = Provider.autoDispose<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(ref.watch(profileDataSource)),
);

var profileUpdateUsecase = Provider.autoDispose<UpdateProfileUsecase>(
  (ref) => UpdateProfileUsecaseImpl(ref.watch(profileRepository)),
);

var getAppointmentUsecase = Provider.autoDispose<GetAppointmentUsecase>(
  (ref) => GetAppointmentsUsecaseImpl(ref.watch(profileRepository)),
);

var serviceUpdateUsecase = Provider.autoDispose<ServiceUpdateUsecase>(
  (ref) => ServiceupdateUsecaseImpl(ref.watch(profileRepository)),
);

final profileProvider = ChangeNotifierProvider<ProfileProvider>((ref) {
  return ProfileProvider(
    ref.watch(profileUpdateUsecase),
    ref.watch(checkUsercase),
  );
});

//Category
final categoryProvider = ChangeNotifierProvider<CategoryProvider>((ref) {
  return CategoryProvider(ref.watch(serviceUpdateUsecase));
});
//Appointments

final appointmentProvider = ChangeNotifierProvider<AppointmentProvider>((ref) {
  return AppointmentProvider(ref.watch(getAppointmentUsecase));
});
//subscription
final subscriptionDataSource = Provider.autoDispose<SubscriptionDatasource>(
  (ref) => SubscriptionDatasourceImpl(ref.watch(dioProvider)),
);

final subscriptionRepository = Provider.autoDispose<SubscriptionRepository>(
  (ref) => SubscriptionRepositoryImpl(ref.watch(subscriptionDataSource)),
);

final getProviderSubscriptionUsecase =
    Provider.autoDispose<GetProviderSubscriptionUsecase>(
      (ref) => GetProviderSubscriUsecaseImpl(ref.watch(subscriptionRepository)),
    );

final createProviderSubscriptionUsecase =
    Provider.autoDispose<CreatesubscriptionUsecase>(
      (ref) => CreatesubscriptionUsecaseImpl(ref.watch(subscriptionRepository)),
    );

final createpaymentusecase = Provider.autoDispose<CreatepaymentUsecase>(
  (ref) => CreatepaymentUsecaseImpl(ref.watch(subscriptionRepository)),
);

final updatepaymentusecase = Provider.autoDispose<UpdatepaymentUsecase>(
  (ref) => UpdatepaymentUsecaseImpl(ref.watch(subscriptionRepository)),
);

final addcashsubscriptionUsecase = Provider.autoDispose<
  AddcashsubscriptionUsecase
>((ref) => AddcashsubscriptionUsecaseImpl(ref.watch(subscriptionRepository)));

final getSubscriptionsUsecase = Provider.autoDispose<GetSubscriptionsUsecase>(
  (ref) => GetSubscriptionsUsecaseImpl(ref.watch(subscriptionRepository)),
);

final subscriptionProvider = ChangeNotifierProvider<SubscriptionProvider>((
  ref,
) {
  return SubscriptionProvider(
    ref.watch(getProviderSubscriptionUsecase),
    ref.watch(createProviderSubscriptionUsecase),
    ref.watch(createpaymentusecase),
    ref.watch(updatepaymentusecase),
    ref.watch(addcashsubscriptionUsecase),
    ref.watch(getSubscriptionsUsecase),
  );
});
