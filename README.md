# OpenAI API Chat Bot
Chat bot made using Flutter, Open AI GPT 3.5 APIs and Firebase

## Installation
1. Clone the repository
```
git clone git@github.com:AlphaArtrem/YASHVARDHAN-AWASTHI-Flutter-AnswersAi.git
```
3. Create an account on Firebase
4. Setup [Firebase Core](https://firebase.google.com/docs/flutter/setup)
5. Setup [Firebase Auth](https://firebase.google.com/docs/auth/flutter/start)
6. Setup [Cloud Firestore](https://firebase.google.com/docs/firestore/quickstart)
7. Setup [Google Sign In](https://pub.dev/packages/google_sign_in)
8. Add your SHA-256 and SHA-1 key to project seeting in firebase. To generate keys follow [these steps](https://docs.flutter.dev/deployment/android#signing-the-app)
9. Setup firebase with ```com.example.chatgpt``` project
```
flutterfire configure 
```
10. Create an account on OpenAI and get API keys [form here](https://platform.openai.com/api-keys)
11. Create an account on [Mailersend](https://app.mailersend.com/dashboard), get API kesy [from here](https://app.mailersend.com/api-tokens) and verfiy a domain or use the default free one [from here](https://app.mailersend.com/domains)
12. Make sure ```config/config.json``` exists with the following keys
   
```JSON
{
  "mailerSendBearerToken": "MAILER_SEND_BEARER_TOKEN",
  "appName" : "ChatGPT",
  "openAIAPIKey": "OPEN_AI_API_KEY",
  "mailerSendVerifiedDomain" : "MAILER_SEND_VERIFIED_DOMAIN"
}
```

13. Fetch pub dependencies for Flutter and run the app.
```
flutter pub get
flutter run --dart-define-from-file=configs/config.json
```
14. Build project
```
flutter build apk --release --dart-define-from-file=configs/config.json
flutter build ipa --release --dart-define-from-file=configs/config.json
```
