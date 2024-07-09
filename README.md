## How did I build it?

This application is built using SwiftUI, Combine, and modern Swift concurrency. Loading of large data files is handled asynchronously to maintain responsiveness and optimal performance. Every class is fully documented, and inline code comments have been added where relevant. No third-party frameworks were used, and the project is ready-to-run using Xcode 15.4 and iOS 17.5. No internet connection is required to run the app on the iOS simulator.

## Architecture

The application has been built using the MVVM architecture. All ViewModels for all views have been placed inside View extensions. This is particularly helpful for applications that have a large number of views and is a good practice introduced by [Paul Hudson](https://x.com/twostraws). For more information, visit his article [here](https://www.hackingwithswift.com/books/ios-swiftui/introducing-mvvm-into-your-swiftui-project).

Processing of historical workout data files and rows has been achieved using a service class that conforms to a base protocol. The service code implementation is decoupled with dependency injection, making mocking and testing the service code straightforward.

View state is handled in view model classes.

## Testing

The application includes tests for all classes, ensuring edge cases are handled gracefully.

## Localization

Strings that are not fetched from the `workoutData.txt` file are fully localized to English and Latin American Spanish. I also included a scheme to run the app in Spanish.

## Thank You!

I hope you like the way I built and structured the project. I had lots of fun working on it and look forward to hearing back from you all soon.

