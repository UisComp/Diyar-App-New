import 'dart:async';

import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/feature/internet/controller/internet_state.dart';
import 'package:diyar_app/feature/internet/service/internet_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InternetConnectionController extends Cubit<InternetConnectionStates> {
  InternetConnectionController() : super(InternetConnectionInitialStates()) {
    _initializeConnectionCheck();
  }

  static InternetConnectionController get(BuildContext context) =>
      BlocProvider.of(context);

  bool isConnected = true;
  StreamSubscription<bool>? _connectivitySubscription;

  void _initializeConnectionCheck() {
    InternetConnectivityService.initialize(
      enableSlowConnectionCheck: true,
      slowConnectionThreshold: const Duration(seconds: 3),
      requireAllAddressesToRespond: false,
    );

    _checkInitialConnection();
    _listenToConnectionChanges();
  }

  Future<void> _checkInitialConnection() async {
    try {
      isConnected = await InternetConnectivityService.checkConnectivity();
      _emitIfChanged();

      if (!isConnected) {
        await Future.delayed(const Duration(seconds: 3));
        isConnected = await InternetConnectivityService.checkConnectivity();
        _emitIfChanged();
      }
    } catch (e) {
     AppLogger.error("[InternetConnectionController] Error: $e");
      isConnected = false;
      _emitIfChanged();
    }
  }

  void _listenToConnectionChanges() {
    _connectivitySubscription = InternetConnectivityService
        .onConnectivityChanged
        .listen((status) {
          if (isConnected != status) {
            isConnected = status;
            _emitIfChanged();
          }
        });
  }

  void _emitIfChanged() {
    final newState =
        isConnected
            ? InternetConnectionHaveConnectionStates()
            : InternetConnectionNOConnectionStates();

    if (state.runtimeType != newState.runtimeType) {
      emit(newState);
     AppLogger.log("[InternetConnectionController] State: $newState");
    }
  }

  @override
  Future<void> close() async {
    await _connectivitySubscription?.cancel();
    await InternetConnectivityService.dispose();
    return super.close();
  }
}
