import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as p;

import 'constants.dart';

typedef LicenseCallbackNative = Void Function();

typedef _StatusNoArgNative = Int32 Function();
typedef StatusNoArg = int Function();

typedef _StatusStrArgNative = Int32 Function(Pointer<Utf8>);
typedef StatusStrArg = int Function(Pointer<Utf8>);

typedef _StatusU32ArgNative = Int32 Function(Uint32);
typedef StatusU32Arg = int Function(int);

typedef _SetLicenseCallbackNative = Int32 Function(
  Pointer<NativeFunction<LicenseCallbackNative>>,
);
typedef SetLicenseCallbackCall = int Function(
  Pointer<NativeFunction<LicenseCallbackNative>>,
);

typedef _U32OutNative = Int32 Function(Pointer<Uint32>);
typedef U32Out = int Function(Pointer<Uint32>);

typedef _StringOutNative = Int32 Function(Pointer<Utf8>, Uint32);
typedef StringOut = int Function(Pointer<Utf8>, int);

typedef _ActivationModeNative = Int32 Function(
  Pointer<Utf8>,
  Uint32,
  Pointer<Utf8>,
  Uint32,
);
typedef ActivationModeCall = int Function(
  Pointer<Utf8>,
  int,
  Pointer<Utf8>,
  int,
);

typedef _OwnedStringNoArgNative = Pointer<Utf8> Function();
typedef OwnedStringNoArg = Pointer<Utf8> Function();

typedef _OwnedStringStrArgNative = Pointer<Utf8> Function(Pointer<Utf8>);
typedef OwnedStringStrArg = Pointer<Utf8> Function(Pointer<Utf8>);

typedef _OwnedStringWaitNative = Pointer<Utf8> Function(Uint64, Uint32);
typedef OwnedStringWait = Pointer<Utf8> Function(int, int);

typedef _StaticStringNoArgNative = Pointer<Utf8> Function();
typedef StaticStringNoArg = Pointer<Utf8> Function();

typedef _QuitAndInstallNative = Int32 Function(Pointer<Utf8>);
typedef QuitAndInstallCall = int Function(Pointer<Utf8>);

typedef _FreeStringNative = Void Function(Pointer<Void>);
typedef FreeStringCall = void Function(Pointer<Void>);

final class DmNativeBindings {
  DmNativeBindings._(this.library)
      : dmFreeString =
            library.lookupFunction<_FreeStringNative, FreeStringCall>(
          'DM_FreeString',
        ),
        getLastError =
            library.lookupFunction<_OwnedStringNoArgNative, OwnedStringNoArg>(
          'DM_GetLastError',
        ),
        checkForUpdates =
            library.lookupFunction<_OwnedStringStrArgNative, OwnedStringStrArg>(
          'DM_CheckForUpdates',
        ),
        downloadUpdate =
            library.lookupFunction<_OwnedStringStrArgNative, OwnedStringStrArg>(
          'DM_DownloadUpdate',
        ),
        cancelUpdateDownload =
            library.lookupFunction<_OwnedStringStrArgNative, OwnedStringStrArg>(
          'DM_CancelUpdateDownload',
        ),
        getUpdateState =
            library.lookupFunction<_OwnedStringNoArgNative, OwnedStringNoArg>(
          'DM_GetUpdateState',
        ),
        getPostUpdateInfo =
            library.lookupFunction<_OwnedStringNoArgNative, OwnedStringNoArg>(
          'DM_GetPostUpdateInfo',
        ),
        ackPostUpdateInfo =
            library.lookupFunction<_OwnedStringStrArgNative, OwnedStringStrArg>(
          'DM_AckPostUpdateInfo',
        ),
        waitForUpdateStateChange =
            library.lookupFunction<_OwnedStringWaitNative, OwnedStringWait>(
          'DM_WaitForUpdateStateChange',
        ),
        quitAndInstall =
            library.lookupFunction<_QuitAndInstallNative, QuitAndInstallCall>(
          'DM_QuitAndInstall',
        ),
        jsonToCanonical =
            library.lookupFunction<_OwnedStringStrArgNative, OwnedStringStrArg>(
          'DM_JsonToCanonical',
        ),
        setProductData =
            library.lookupFunction<_StatusStrArgNative, StatusStrArg>(
          'SetProductData',
        ),
        setProductId =
            library.lookupFunction<_StatusStrArgNative, StatusStrArg>(
          'SetProductId',
        ),
        setDataDirectory =
            library.lookupFunction<_StatusStrArgNative, StatusStrArg>(
          'SetDataDirectory',
        ),
        setDebugMode =
            library.lookupFunction<_StatusU32ArgNative, StatusU32Arg>(
          'SetDebugMode',
        ),
        setCustomDeviceFingerprint =
            library.lookupFunction<_StatusStrArgNative, StatusStrArg>(
          'SetCustomDeviceFingerprint',
        ),
        setLicenseKey =
            library.lookupFunction<_StatusStrArgNative, StatusStrArg>(
          'SetLicenseKey',
        ),
        setLicenseCallback = library
            .lookupFunction<_SetLicenseCallbackNative, SetLicenseCallbackCall>(
          'SetLicenseCallback',
        ),
        activateLicense =
            library.lookupFunction<_StatusNoArgNative, StatusNoArg>(
          'ActivateLicense',
        ),
        getLastActivationError = library.lookupFunction<_U32OutNative, U32Out>(
          'GetLastActivationError',
        ),
        isLicenseGenuine =
            library.lookupFunction<_StatusNoArgNative, StatusNoArg>(
          'IsLicenseGenuine',
        ),
        isLicenseValid =
            library.lookupFunction<_StatusNoArgNative, StatusNoArg>(
          'IsLicenseValid',
        ),
        getServerSyncGracePeriodExpiryDate =
            library.lookupFunction<_U32OutNative, U32Out>(
          'GetServerSyncGracePeriodExpiryDate',
        ),
        getActivationMode =
            library.lookupFunction<_ActivationModeNative, ActivationModeCall>(
          'GetActivationMode',
        ),
        getLicenseKey = library.lookupFunction<_StringOutNative, StringOut>(
          'GetLicenseKey',
        ),
        getLicenseExpiryDate = library.lookupFunction<_U32OutNative, U32Out>(
          'GetLicenseExpiryDate',
        ),
        getLicenseCreationDate = library.lookupFunction<_U32OutNative, U32Out>(
          'GetLicenseCreationDate',
        ),
        getLicenseActivationDate =
            library.lookupFunction<_U32OutNative, U32Out>(
          'GetLicenseActivationDate',
        ),
        getActivationCreationDate =
            library.lookupFunction<_U32OutNative, U32Out>(
          'GetActivationCreationDate',
        ),
        getActivationLastSyncedDate =
            library.lookupFunction<_U32OutNative, U32Out>(
          'GetActivationLastSyncedDate',
        ),
        getActivationId = library.lookupFunction<_StringOutNative, StringOut>(
          'GetActivationId',
        ),
        getLibraryVersion =
            library.lookupFunction<_StaticStringNoArgNative, StaticStringNoArg>(
          'GetLibraryVersion',
        ),
        reset =
            library.lookupFunction<_StatusNoArgNative, StatusNoArg>('Reset');

  factory DmNativeBindings.load({String? libraryPath}) {
    final resolvedPath = resolveLibraryPath(libraryPath);
    final library = DynamicLibrary.open(resolvedPath);
    return DmNativeBindings._(library);
  }

  final DynamicLibrary library;

  final FreeStringCall dmFreeString;

  final OwnedStringNoArg getLastError;

  final OwnedStringStrArg checkForUpdates;
  final OwnedStringStrArg downloadUpdate;
  final OwnedStringStrArg cancelUpdateDownload;
  final OwnedStringNoArg getUpdateState;
  final OwnedStringNoArg getPostUpdateInfo;
  final OwnedStringStrArg ackPostUpdateInfo;
  final OwnedStringWait waitForUpdateStateChange;
  final QuitAndInstallCall quitAndInstall;
  final OwnedStringStrArg jsonToCanonical;

  final StatusStrArg setProductData;
  final StatusStrArg setProductId;
  final StatusStrArg setDataDirectory;
  final StatusU32Arg setDebugMode;
  final StatusStrArg setCustomDeviceFingerprint;

  final StatusStrArg setLicenseKey;
  final SetLicenseCallbackCall setLicenseCallback;
  final StatusNoArg activateLicense;
  final U32Out getLastActivationError;

  final StatusNoArg isLicenseGenuine;
  final StatusNoArg isLicenseValid;
  final U32Out getServerSyncGracePeriodExpiryDate;
  final ActivationModeCall getActivationMode;

  final StringOut getLicenseKey;
  final U32Out getLicenseExpiryDate;
  final U32Out getLicenseCreationDate;
  final U32Out getLicenseActivationDate;
  final U32Out getActivationCreationDate;
  final U32Out getActivationLastSyncedDate;
  final StringOut getActivationId;

  final StaticStringNoArg getLibraryVersion;
  final StatusNoArg reset;
}

String resolveLibraryPath(String? explicitPath) {
  final configured = _trimToNull(explicitPath) ??
      _trimToNull(Platform.environment[envDmApiPath]);
  if (configured != null) {
    return _resolveConfiguredPath(configured);
  }

  final candidates = <String>{};
  for (final fileName in _defaultLibraryNames()) {
    candidates.addAll(_relativeCandidates(fileName));
    candidates.add(fileName);
  }

  for (final candidate in candidates) {
    if (File(candidate).existsSync()) {
      return candidate;
    }
  }

  return _defaultLibraryNames().first;
}

String _resolveConfiguredPath(String configuredPath) {
  if (_isAbsolutePath(configuredPath)) {
    return configuredPath;
  }

  for (final candidate in _relativeCandidates(configuredPath)) {
    if (File(candidate).existsSync()) {
      return candidate;
    }
  }

  return configuredPath;
}

List<String> _relativeCandidates(String pathValue) {
  final executableDir = File(Platform.resolvedExecutable).parent.path;
  final executableParent = Directory(executableDir).parent.path;
  return [
    p.join(executableDir, pathValue),
    p.join(executableParent, pathValue),
    p.join(Directory.current.path, pathValue),
    pathValue,
  ];
}

List<String> _defaultLibraryNames() {
  if (Platform.isWindows) {
    return [defaultDllName];
  }

  if (Platform.isMacOS) {
    return ['dm_api.dylib', 'libdm_api.dylib'];
  }

  if (Platform.isLinux) {
    return ['libdm_api.so'];
  }

  return [defaultDllName];
}

bool _isAbsolutePath(String pathValue) {
  if (p.isAbsolute(pathValue)) {
    return true;
  }

  final winAbsolute = RegExp(r'^[a-zA-Z]:[\\/]');
  return winAbsolute.hasMatch(pathValue) || pathValue.startsWith(r'\\');
}

String? _trimToNull(String? value) {
  final trimmed = value?.trim() ?? '';
  if (trimmed.isEmpty) {
    return null;
  }
  return trimmed;
}
