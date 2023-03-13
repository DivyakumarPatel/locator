// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../functions/api.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends HydratedBloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationState()) {
    on<GetLocation>(_onGetLocation);
    on<UpdateLocation>(_onUpdateLocation);

  }



  void _onUpdateLocation(
      UpdateLocation event, Emitter<LocationState> emit) async {
    if (state.status == LocationStatus.initial) {
      emit(state.copyWith(status: LocationStatus.loading));
    }

    try {
      Response response = await Api().updateLocation(
          current_latitude: event.current_latitude,
          current_longitude: event.current_longitude,
          max_distance: event.max_distance,
          origin_longitude: event.origin_longitude,
          origin_latitude: event.origin_latitude);
      log(response.data.toString());
      if (response.statusCode != 200) {
        emit(state.copyWith(status: LocationStatus.error));
      } else {
        emit(state.copyWith(status: LocationStatus.loaded));
      }
    } catch (e) {
      emit(state.copyWith(status: LocationStatus.error));
    }
  }

  void _onGetLocation(GetLocation event, Emitter<LocationState> emit) async {
    if (state.status == LocationStatus.initial) {
      emit(state.copyWith(status: LocationStatus.loading));
    }

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      log(permission.name);

      if (permission.name == "denied") {
        LocationPermission permissionRequest =
            await Geolocator.requestPermission();
        log(permissionRequest.name);
        if (permissionRequest.name == "denied") {
          emit(state.copyWith(status: LocationStatus.error));
          return;
        }
      }

      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      log(position.latitude.toString());

      emit(state.copyWith(
          latitude: position.latitude.toString(),
          longitude: position.longitude.toString(),
          status: LocationStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: LocationStatus.error));
    }
  }

  @override
  LocationState fromJson(Map<String, dynamic> data) {
    return LocationState.fromJson(json.encode(data));
  }

  @override
  Map<String, dynamic>? toJson(LocationState state) {
    if (state.status == LocationStatus.loaded) {
      return state.toMap();
    }
    return null;
  }

  @override
  void onChange(Change<LocationState> change) {
    super.onChange(change);
    debugPrint('$change');
  }
}
