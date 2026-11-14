# Dots – Mobile Apps

Two Flutter apps that talk to the Dots backend API:

| Folder | App | Package |
|---|---|---|
| `user_app/` | Customer app: find providers, book appointments, polls, trends, subscriptions | `com.dots.user` |
| `provider_app/` | Service-provider app: profile and services, alerts/offers, trends, work gallery, subscriptions | `com.dots.provider` |

## Requirements

- Flutter 3.29+ (Dart ^3.7.2). Tested on Flutter 3.47.3.
- Android SDK with platform 36, build-tools 35 and NDK 27.0.12077973. Java 21.

## API endpoint

By default the apps call the hosted dev API `http://15.207.56.61:8080`. To use another server, pass it at build time:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080            # Android emulator -> backend on your PC
flutter run --dart-define=API_BASE_URL=http://<your PC LAN IP>:8080     # real phone on the same Wi-Fi
```

## Build

```bash
cd user_app        # or provider_app
flutter pub get
flutter build apk --release --dart-define=API_BASE_URL=http://15.207.56.61:8080
```

Release builds are signed with the debug key; add a `key.properties` keystore before publishing.

If Gradle fails with `PKIX path building failed` or `Connect timed out` (e.g. behind antivirus HTTPS scanning), set this first:

```powershell
$env:JAVA_TOOL_OPTIONS = "-Djavax.net.ssl.trustStoreType=Windows-ROOT -Djava.net.preferIPv4Stack=true"
```

## Notes

- Each app has an `AssetManifest.json` listing `assets/i18n/*.json`. `flutter_translate` reads it, and current Flutter no longer generates it. When you add a language file, add it there too.
- The provider app allows cleartext HTTP (`usesCleartextTraffic`) because the API is served over plain `http`.
