import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetConnectivityService {
  static bool _isConnected = true;
  static InternetConnectionChecker? _checker;
  static StreamController<bool>? _connectivityController;
  static StreamSubscription<InternetConnectionStatus>? _subscription;

  /// Public stream to listen for connectivity changes
  static Stream<bool> get onConnectivityChanged {
    if (_connectivityController == null) {
      throw StateError('InternetConnectivityService not initialized. Call initialize() first.');
    }
    return _connectivityController!.stream;
  }

  /// Get the latest connectivity status
  static bool get currentStatus => _isConnected;

  /// Initialize the service with optional custom configuration
  static void initialize({
    bool requireAllAddressesToRespond = false,
    bool enableSlowConnectionCheck = false,
    Duration slowConnectionThreshold = const Duration(seconds: 3),
    List<AddressCheckOption>? customAddresses,
  }) {
    _checker?.dispose();
    _connectivityController?.close();
    _connectivityController = StreamController<bool>.broadcast();

    _checker = InternetConnectionChecker.createInstance(
      checkTimeout: const Duration(seconds: 5),
      requireAllAddressesToRespond: requireAllAddressesToRespond,
      slowConnectionConfig: enableSlowConnectionCheck
          ? SlowConnectionConfig(
              enableToCheckForSlowConnection: true,
              slowConnectionThreshold: slowConnectionThreshold,
            )
          : null,
      addresses: customAddresses ?? [
        AddressCheckOption(uri: Uri.parse('https://www.google.com')),
        AddressCheckOption(uri: Uri.parse('https://jsonplaceholder.typicode.com')),
      ],
    );

    _subscription?.cancel();
    _subscription = _checker!.onStatusChange.listen((status) {
      final connected = status == InternetConnectionStatus.connected;
      if (_isConnected != connected) {
        _isConnected = connected;
        _connectivityController?.add(_isConnected);
      }
    });
  }

  /// Manually check connectivity with optional retries
  static Future<bool> checkConnectivity({
    int retryCount = 2,
    Duration retryDelay = const Duration(seconds: 3),
  }) async {
    if (_checker == null) {
      initialize();
    }

    for (int i = 0; i < retryCount; i++) {
      try {
        _isConnected = await _checker!.hasConnection.timeout(const Duration(seconds: 5));
        if (_isConnected) break;
      } catch (_) {
        _isConnected = false;
      }

      if (i < retryCount - 1) {
        await Future.delayed(retryDelay);
      }
    }

    _connectivityController?.add(_isConnected);
    return _isConnected;
  }

  /// Dispose resources
  static Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;

    _checker?.dispose();
    _checker = null;

    await _connectivityController?.close();
    _connectivityController = null;
  }
}
