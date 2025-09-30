import 'dart:developer';

import 'package:diyar_app/feature/news/controller/news_state.dart';
import 'package:diyar_app/core/model/news_response_model.dart';
import 'package:diyar_app/feature/news/service/news_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsController extends Cubit<NewsState> {
  NewsController() : super(NewsInitial());
  static NewsController get(BuildContext context) => BlocProvider.of(context);

  NewsResponseModel newsResponseModel = NewsResponseModel();
  //! newsScreen
  Future<void> getAllNews() async {
    emit(GetAllNewsLoadingState());
    try {
      await NewsService.getAllNews().then((newsResponse) {
        newsResponseModel = newsResponse;
        emit(GetAllNewsSuccessfullyState());
      });
    } catch (e) {
      log("Error Happen While Get All News is $e");
      emit(GetAllNewsErrorState(error: e.toString()));
    }
  }
}
