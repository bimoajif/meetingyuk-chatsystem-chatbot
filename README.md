# Flutter Chat System and Chatbot App

This is a sample chat system and chatbot app that uses Flutter to create a conversational interface. 

## Getting Started

To get started with this app, you'll need to have the Flutter SDK installed on your local machine. You can find installation instructions on the [Flutter website](https://flutter.dev/docs/get-started/install).

clone this repo by following this command:
```
git clone https://github.com/bimoajif/meetingyuk-chatsystem-chatbot.git
```

### Dependencies

This app has the following dependencies:

- [firebase_auth](https://pub.dev/packages/firebase_auth) for user authentication
- [firebase_storage](https://pub.dev/packages/firebase_storage) for cloud storage
- [uuid](https://pub.dev/packages/uuid) for generating unique IDs
- [intl](https://pub.dev/packages/intl) for internationalization
- [image_picker](https://pub.dev/packages/image_picker) for selecting images
- [flutter_image](https://pub.dev/packages/flutter_image) for image manipulation
- [dio](https://pub.dev/packages/dio) for network requests
- [logger](https://pub.dev/packages/logger) for log debugging

You can install these dependencies by running `flutter pub get` in your terminal in the project's root directory.

### Configuration

Before you start the app, you'll need to configure it with your Dialogflow project ID and credentials. 

1. Create a Google Cloud project and enable the Dialogflow API.
2. Create a Dialogflow agent and configure intents and entities as necessary.
3. Create a service account key in JSON format and download it.
4. Save the JSON file in the `android/app/` directory of your project.
5. Set the environment variable `GOOGLE_APPLICATION_CREDENTIALS` to the path of your JSON file. 

### Running the app

To run the app on your local machine, connect your device or start a virtual device and run `flutter run` in your terminal in the project's root directory.

## Contributing

Contributions are welcome! Please submit any issues or pull requests on the repository.

## License
