import 'package:chatgpt/service_layer/app_config/app_config_service_interface.dart';

/// A class that provides app configuration settings and allows for easy
/// switching between different configurations based on the environment.
class AppConfigService extends IAppConfigService {
  ///Default constructor for [AppConfigService]
  AppConfigService() {
    configApp();
  }

  @override
  void configApp() {
    appName = const String.fromEnvironment('appName');
    baseUrl = const String.fromEnvironment('baseUrl');
    mailerSendBearerToken =
        const String.fromEnvironment('mailerSendBearerToken');
    openAIAPIKey = const String.fromEnvironment('openAIAPIKey');
    mailerSendVerifiedDomain =
        const String.fromEnvironment('mailerSendVerifiedDomain');
  }
}
