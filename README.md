# Flutter Routing Demo

This project recreates the basic routing behavior shown in the reference image:

- Home page
- Sample page
- Profile page
- Details page
- Bottom navigation
- "View Details" button
- Named routes in `lib/routes/app_routes.dart`

## Important files

```text
lib/
├── main.dart
├── pages/
│   ├── detail_page.dart
│   ├── home_page.dart
│   ├── profile_page.dart
│   └── sample_page.dart
├── routes/
│   └── app_routes.dart
└── widgets/
    └── app_bottom_nav.dart
```

## Routes

```text
/          Home
/sample    Sample
/profile   Profile
/details   Details
```

## Run

Open a terminal in this folder:

```powershell
flutter create .
flutter pub get
flutter devices
flutter run -d chrome
```

You can also run on Windows if Windows desktop is enabled:

```powershell
flutter run -d windows
```
