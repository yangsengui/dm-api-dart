import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as p;

import 'constants.dart';
import 'native_bindings.dart';

typedef JsonMap = Map<String, dynamic>;

class DmApi {
  DmApi({String? libraryPath})
      : _bindings = DmNativeBindings.load(libraryPath: libraryPath);

  final DmNativeBindings _bindings;
  NativeCallable<Void Function()>? _licenseCallback;

  static bool shouldSkipCheck({String? appId, String? publicKey}) {
    final endpoint = (Platform.environment[envDmLauncherEndpoint] ?? '').trim();
    final token = (Platform.environment[envDmLauncherToken] ?? '').trim();
    if (endpoint.isNotEmpty && token.isNotEmpty) {
      return false;
    }

    final resolvedAppId =
        (appId ?? Platform.environment[envDmAppId] ?? '').trim();
    final resolvedPublicKey =
        (publicKey ?? Platform.environment[envDmPublicKey] ?? '').trim();
    if (resolvedAppId.isEmpty || resolvedPublicKey.isEmpty) {
      throw StateError(
        'App identity is required for dev-license checks. '
        'Provide appId/publicKey or set DM_APP_ID and DM_PUBLIC_KEY.',
      );
    }

    final home = (Platform.environment['USERPROFILE'] ??
            Platform.environment['HOME'] ??
            '')
        .trim();
    if (home.isEmpty) {
      throw StateError(devLicenseError);
    }

    final pubkeyPath = p.join(
      home,
      '.distromate-cli',
      'dev_licenses',
      resolvedAppId,
      'pubkey',
    );

    String devPublicKey;
    try {
      devPublicKey = File(pubkeyPath).readAsStringSync().trim();
    } catch (_) {
      throw StateError(devLicenseError);
    }

    if (devPublicKey.isEmpty || devPublicKey != resolvedPublicKey) {
      throw StateError(devLicenseError);
    }

    return true;
  }

  String? getLastError() {
    return _ownedPtrToString(_bindings.getLastError());
  }

  String? getActivationErrorName(int? code) {
    if (code == null) {
      return null;
    }
    return activationErrorNames[code] ?? 'UNKNOWN($code)';
  }

  bool setProductData(String productData) {
    return _callStatusWithString(_bindings.setProductData, productData);
  }

  bool setProductId(String productId) {
    return _callStatusWithString(_bindings.setProductId, productId);
  }

  bool setDataDirectory(String directoryPath) {
    return _callStatusWithString(_bindings.setDataDirectory, directoryPath);
  }

  bool setDebugMode(bool enable) {
    return _bindings.setDebugMode(enable ? 1 : 0) == 0;
  }

  bool setCustomDeviceFingerprint(String fingerprint) {
    return _callStatusWithString(
      _bindings.setCustomDeviceFingerprint,
      fingerprint,
    );
  }

  bool setLicenseKey(String licenseKey) {
    return _callStatusWithString(_bindings.setLicenseKey, licenseKey);
  }

  bool setLicenseCallback(void Function() callback) {
    final native = NativeCallable<Void Function()>.isolateLocal(() {
      callback();
    });

    final status = _bindings.setLicenseCallback(native.nativeFunction);
    if (status != 0) {
      native.close();
      return false;
    }

    _licenseCallback?.close();
    _licenseCallback = native;
    return true;
  }

  bool activateLicense() {
    return _bindings.activateLicense() == 0;
  }

  int? getLastActivationError() {
    return _callU32Out(_bindings.getLastActivationError);
  }

  bool isLicenseGenuine() {
    return _bindings.isLicenseGenuine() == 0;
  }

  bool isLicenseValid() {
    return _bindings.isLicenseValid() == 0;
  }

  int? getServerSyncGracePeriodExpiryDate() {
    return _callU32Out(_bindings.getServerSyncGracePeriodExpiryDate);
  }

  Map<String, String>? getActivationMode(
      {int bufferSize = defaultModeBufferSize}) {
    final safeSize = bufferSize <= 0 ? defaultModeBufferSize : bufferSize;
    final initial = calloc<Uint8>(safeSize).cast<Utf8>();
    final current = calloc<Uint8>(safeSize).cast<Utf8>();

    try {
      final status = _bindings.getActivationMode(
        initial,
        safeSize,
        current,
        safeSize,
      );
      if (status != 0) {
        return null;
      }

      return {
        'initial_mode': _readCString(initial, safeSize),
        'current_mode': _readCString(current, safeSize),
      };
    } finally {
      calloc.free(initial);
      calloc.free(current);
    }
  }

  String? getLicenseKey({int bufferSize = defaultBufferSize}) {
    return _callStringOut(_bindings.getLicenseKey, size: bufferSize);
  }

  int? getLicenseExpiryDate() {
    return _callU32Out(_bindings.getLicenseExpiryDate);
  }

  int? getLicenseCreationDate() {
    return _callU32Out(_bindings.getLicenseCreationDate);
  }

  int? getLicenseActivationDate() {
    return _callU32Out(_bindings.getLicenseActivationDate);
  }

  int? getActivationCreationDate() {
    return _callU32Out(_bindings.getActivationCreationDate);
  }

  int? getActivationLastSyncedDate() {
    return _callU32Out(_bindings.getActivationLastSyncedDate);
  }

  String? getActivationId({int bufferSize = defaultBufferSize}) {
    return _callStringOut(_bindings.getActivationId, size: bufferSize);
  }

  bool reset() {
    return _bindings.reset() == 0;
  }

  JsonMap? checkForUpdates([JsonMap? options]) {
    return _callJsonEnvelopeWithOptions(_bindings.checkForUpdates, options);
  }

  JsonMap? downloadUpdate([JsonMap? options]) {
    return _callJsonEnvelopeWithOptions(_bindings.downloadUpdate, options);
  }

  JsonMap? cancelUpdateDownload([JsonMap? options]) {
    return _callJsonEnvelopeWithOptions(
        _bindings.cancelUpdateDownload, options);
  }

  JsonMap? getUpdateState() {
    return _callJsonEnvelope(_bindings.getUpdateState);
  }

  JsonMap? getPostUpdateInfo() {
    return _callJsonEnvelope(_bindings.getPostUpdateInfo);
  }

  JsonMap? ackPostUpdateInfo([JsonMap? options]) {
    return _callJsonEnvelopeWithOptions(_bindings.ackPostUpdateInfo, options);
  }

  JsonMap? waitForUpdateStateChange(int lastSequence, {int timeoutMs = 30000}) {
    final sequence = lastSequence < 0 ? 0 : lastSequence;
    final timeout = timeoutMs < 0 ? 0 : timeoutMs;
    final raw = _ownedPtrToString(
      _bindings.waitForUpdateStateChange(sequence, timeout),
    );
    return _parseEnvelope(raw);
  }

  int quitAndInstall([JsonMap? options]) {
    Pointer<Utf8> encoded = nullptr;
    try {
      if (options != null) {
        encoded = jsonEncode(options).toNativeUtf8();
      }
      return _bindings.quitAndInstall(encoded);
    } finally {
      if (encoded != nullptr) {
        calloc.free(encoded);
      }
    }
  }

  String getLibraryVersion() {
    final ptr = _bindings.getLibraryVersion();
    if (ptr == nullptr) {
      return '';
    }
    return ptr.toDartString();
  }

  String? jsonToCanonical(String jsonStr) {
    final encoded = jsonStr.toNativeUtf8();
    try {
      return _ownedPtrToString(_bindings.jsonToCanonical(encoded));
    } finally {
      calloc.free(encoded);
    }
  }

  void dispose() {
    _licenseCallback?.close();
    _licenseCallback = null;
  }

  bool _callStatusWithString(StatusStrArg call, String value) {
    final encoded = value.toNativeUtf8();
    try {
      return call(encoded) == 0;
    } finally {
      calloc.free(encoded);
    }
  }

  int? _callU32Out(U32Out call) {
    final out = calloc<Uint32>();
    try {
      if (call(out) != 0) {
        return null;
      }
      return out.value;
    } finally {
      calloc.free(out);
    }
  }

  String? _callStringOut(StringOut call, {required int size}) {
    final safeSize = size <= 0 ? defaultBufferSize : size;
    final buffer = calloc<Uint8>(safeSize).cast<Utf8>();
    try {
      if (call(buffer, safeSize) != 0) {
        return null;
      }
      return _readCString(buffer, safeSize);
    } finally {
      calloc.free(buffer);
    }
  }

  JsonMap? _callJsonEnvelope(OwnedStringNoArg call) {
    final raw = _ownedPtrToString(call());
    return _parseEnvelope(raw);
  }

  JsonMap? _callJsonEnvelopeWithOptions(
      OwnedStringStrArg call, JsonMap? options) {
    Pointer<Utf8> encoded = nullptr;
    try {
      if (options != null) {
        encoded = jsonEncode(options).toNativeUtf8();
      }
      final raw = _ownedPtrToString(call(encoded));
      return _parseEnvelope(raw);
    } finally {
      if (encoded != nullptr) {
        calloc.free(encoded);
      }
    }
  }

  String? _ownedPtrToString(Pointer<Utf8> ptr) {
    if (ptr == nullptr) {
      return null;
    }

    try {
      return ptr.toDartString();
    } finally {
      _bindings.dmFreeString(ptr.cast<Void>());
    }
  }

  JsonMap? _parseEnvelope(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return decoded.map(
          (key, value) => MapEntry(key.toString(), value),
        );
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  String _readCString(Pointer<Utf8> ptr, int maxBytes) {
    final bytes = ptr.cast<Uint8>().asTypedList(maxBytes);
    var end = 0;
    while (end < bytes.length && bytes[end] != 0) {
      end++;
    }
    return utf8.decode(bytes.sublist(0, end), allowMalformed: true);
  }
}
