///Singleton class to store api paths
class APIConstants {
  ///factory constructor to always return the same instance of [APIConstants]
  factory APIConstants() => _apiConstants;
  APIConstants._();

  static final APIConstants _apiConstants = APIConstants._();

  ///Mail send API URL
  static const String sendMail = 'https://api.mailersend.com/v1/email';

  ///Mail send API URL
  static const String chatCompletion =
      'https://api.openai.com/v1/chat/completions';
}
