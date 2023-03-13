import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../functions/api.dart';
import '../../models/user/user.dart';

part 'devices_event.dart';
part 'devices_state.dart';

class DevicesBloc extends HydratedBloc<DevicesEvent, DevicesState> {
  DevicesBloc() : super(const DevicesState()) {
    on<GetDevices>(_onGetDevicesDevices);
    on<DevicesInitial>(_onGetDevicesStatus);

  }
  void _onGetDevicesStatus(DevicesInitial event, Emitter<DevicesState> emit) {
    emit(state.copyWith(status: DevicesStatus.initial));
  }



  void _onGetDevicesDevices(
      GetDevices event, Emitter<DevicesState> emit) async {

    if (state.status == DevicesStatus.initial) {
      emit(state.copyWith(status: DevicesStatus.loading));
    }

    try {
      Response response = await Api().getDevices();

      List devices = response.data["devices"];
      log(response.data.toString());
      emit(state.copyWith(
          status: DevicesStatus.loaded, Devices: devices));
      log("updated device location ...................");
    } catch (e) {
      emit(state.copyWith(status: DevicesStatus.error));
    }
  }

  @override
  DevicesState fromJson(Map<String, dynamic> data) {
    return DevicesState.fromJson(json.encode(data));
  }

  @override
  Map<String, dynamic>? toJson(DevicesState state) {
    if (state.status == DevicesStatus.loaded ||
        state.status == DevicesStatus.success) {
      return state.toMap();
    }
    return null;
  }

  @override
  void onChange(Change<DevicesState> change) {
    super.onChange(change);
    debugPrint('$change');
  }
}
