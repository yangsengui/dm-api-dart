# dm-api-dart

Dart SDK for DistroMate `dm_api` native library.

## Install

```bash
dart pub add distromate_dm_api
```

## Quick Start (License)

```dart
import 'package:distromate_dm_api/distromate_dm_api.dart';

void main() {
  final api = DmApi();

  api.setProductData('<product-data>');
  api.setProductId('your-product-id');
  api.setLicenseKey('XXXX-XXXX-XXXX');

  if (!api.activateLicense()) {
    throw StateError(api.getLastError() ?? 'activation failed');
  }

  if (!api.isLicenseGenuine()) {
    final code = api.getLastActivationError();
    final name = api.getActivationErrorName(code);
    throw StateError('license check failed: $name, err=${api.getLastError()}');
  }

  api.dispose();
}
```

## API Groups

- License setup: `setProductData`, `setProductId`, `setDataDirectory`, `setDebugMode`, `setCustomDeviceFingerprint`
- License activation: `setLicenseKey`, `setLicenseCallback`, `activateLicense`, `getLastActivationError`
- License state: `isLicenseGenuine`, `isLicenseValid`, `getServerSyncGracePeriodExpiryDate`, `getActivationMode`
- License details: `getLicenseKey`, `getLicenseExpiryDate`, `getLicenseCreationDate`, `getLicenseActivationDate`, `getActivationCreationDate`, `getActivationLastSyncedDate`, `getActivationId`
- Update: `checkForUpdates`, `downloadUpdate`, `cancelUpdateDownload`, `getUpdateState`, `getPostUpdateInfo`, `ackPostUpdateInfo`, `waitForUpdateStateChange`, `quitAndInstall`
- General: `getLibraryVersion`, `jsonToCanonical`, `getLastError`, `reset`

## Update API Notes

- Update APIs return parsed JSON envelope (`Map<String, dynamic>`) when transport succeeds.
- If native API returns `NULL`, Dart SDK returns `null`; check `getLastError()`.
- `quitAndInstall()` returns native `int` status code directly:
  - `1`: accepted, process should exit soon
  - `-1`: business-level rejection (check `getLastError()`)
  - `-2`: transport or parse error

## Environment Variables

- `DM_API_PATH`: optional path to native library
- `DM_APP_ID`, `DM_PUBLIC_KEY`: optional defaults for app identity
- `DM_LAUNCHER_ENDPOINT`, `DM_LAUNCHER_TOKEN`: launcher IPC variables used by update APIs

## Build

```bash
dart pub get
dart analyze
```

## Release

- CI validates analysis and publish dry run.
- Tag `v*` triggers publish workflow.
- Required secret for pub.dev publish: `PUB_DEV_TOKEN`.
