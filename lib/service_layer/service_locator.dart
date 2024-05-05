import 'package:chatgpt/business_layer/common/auth_bloc.dart';
import 'package:chatgpt/business_layer/post_auth/chat_screen/chat_screen_bloc.dart';
import 'package:chatgpt/business_layer/post_auth/conversation/conversation_bloc.dart';
import 'package:chatgpt/business_layer/pre_auth/auth/auth_screen_bloc.dart';
import 'package:chatgpt/business_layer/pre_auth/otp/otp_bloc.dart';
import 'package:chatgpt/business_layer/theme/theme_cubit.dart';
import 'package:chatgpt/repository_layer/auth_repository/auth_repository.dart';
import 'package:chatgpt/repository_layer/chat_repository/chat_repository.dart';
import 'package:chatgpt/service_layer/api_service/api_service.dart';
import 'package:chatgpt/service_layer/app_config/app_config_service_impl.dart';
import 'package:chatgpt/service_layer/database_service/database_sevice_implementation.dart';
import 'package:chatgpt/service_layer/navigation/navigation_sevice.dart';
import 'package:chatgpt/service_layer/routes/app_router_service.dart';
import 'package:get_it/get_it.dart';

///Service locator to get dependencies
GetIt serviceLocator = GetIt.instance;

///Service to manage in app navigation
final navigationService = serviceLocator.get<NavigationService>();

///Service to manage app theme
final themeService = serviceLocator.get<ThemeCubit>();

///Service to manage API calls
final apiService = serviceLocator.get<ApiService>();

///Service to manage app configurations
final appConfig = serviceLocator.get<AppConfigService>();

///Bloc to manage user auth
final authService = serviceLocator.get<AuthBloc>();

///Function to setup app services. Should be called before running the app.
Future<void> setupServiceLocator() async {
  serviceLocator
    ..registerSingleton(AppRoutersService())
    ..registerSingleton(AppConfigService())
    ..registerSingleton(DatabaseService())
    ..registerSingleton(ApiService(appConfig))
    ..registerSingleton(
      AuthRepository(serviceLocator.get<DatabaseService>()),
    )
    ..registerSingleton(
      ChatRepository(serviceLocator.get<DatabaseService>()),
    )
    ..registerSingleton(
      NavigationService(serviceLocator.get<AppRoutersService>()),
    )
    ..registerSingleton(
      ThemeCubit(ThemeState(isLight: true)),
    )
    ..registerSingleton(
      AuthBloc(serviceLocator.get<AuthRepository>()),
    )
    ..registerLazySingleton<AuthScreenBloc>(
      () => AuthScreenBloc(serviceLocator.get<AuthRepository>()),
    )
    ..registerLazySingleton<OTPBloc>(
      () => OTPBloc(serviceLocator.get<AuthRepository>()),
    )
    ..registerLazySingleton<ChatScreenBloc>(
      () => ChatScreenBloc(serviceLocator.get<ChatRepository>()),
    )
    ..registerLazySingleton<ConversationBloc>(
      () => ConversationBloc(serviceLocator.get<ChatRepository>()),
    );
}
