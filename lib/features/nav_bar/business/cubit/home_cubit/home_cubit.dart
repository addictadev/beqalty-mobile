import 'dart:developer';

import 'package:baqalty/features/nav_bar/data/models/home_response_model.dart';
import 'package:baqalty/features/nav_bar/data/services/home_services.dart';
import 'package:baqalty/features/nav_bar/data/services/home_services_impl.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  final HomeServices _homeServices = HomeServicesImpl();

  Future<void> getHomeData() async {
    try {
      emit(HomeLoading());
      final response = await _homeServices.getHomeData();
      if (response.status && response.data != null) {
        emit(HomeLoaded(homeData: response.data!));
      } else {
        emit(
          HomeError(message: response.message ?? 'Failed to load home data'),
        );
      }
    } catch (e) {
      emit(HomeError(message: e.toString()));
      log('❌ home cubit getHomeData failed: $e');
    }
  }
}
