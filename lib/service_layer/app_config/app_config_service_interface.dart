///Interface for app config service
abstract class IAppConfigService {
  ///App display name
  late final String appName;

  ///App backend base URL for API calls
  late final String baseUrl;

  ///Bearer token for mailer send
  late final String mailerSendBearerToken;

  ///API key for OpenAI
  late final String openAIAPIKey;

  ///Verified domain for mailer send
  late final String mailerSendVerifiedDomain;

  ///Function to setup app config
  void configApp() {
    throw UnimplementedError();
  }
}
