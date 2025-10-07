import 'dart:developer';

import 'package:diyar_app/feature/news/controller/news_state.dart';
import 'package:diyar_app/core/model/news_response_model.dart';
import 'package:diyar_app/feature/news/model/news_details_response_model.dart';
import 'package:diyar_app/feature/news/service/news_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsController extends Cubit<NewsState> {
  NewsController() : super(NewsInitial());
  static NewsController get(BuildContext context) => BlocProvider.of(context);

  NewsResponseModel newsResponseModel = NewsResponseModel();
  NewsDetailsResponseModel newsDetailsResponseModel = NewsDetailsResponseModel();
  //! newsScreen
  Future<void> getAllNews() async {
    emit(GetAllNewsLoadingState());
    try {
      await NewsService.getAllNews().then((newsResponse) {
        newsResponseModel = newsResponse;
        if (newsResponseModel.success == true) {
          emit(GetAllNewsSuccessfullyState());
        } else {
          emit(GetAllNewsErrorState(error: newsResponseModel.message));
        }
      });
    } catch (e) {
      log("Error Happen While Get All News is $e");
      emit(GetAllNewsErrorState(error: e.toString()));
    }
  }
   Future<void> getNewsDetails({required String id}) async {
    emit(GetNewsDetailsLoadingState());
    try {
      await NewsService.getNewsDetails(id:id ).then((newsDetailsResponse) {
        newsDetailsResponseModel = newsDetailsResponse;
        if (newsDetailsResponseModel.success == true) {
          emit(GetNewsDetailsSuccessfullyState());
        } else {
          emit(GetNewsDetailsErrorState(error: newsDetailsResponseModel.message));
        }
      });
    } catch (e) {
      log("Error Happen While Get News Details is $e");
      emit(GetNewsDetailsErrorState(error: e.toString()));
    }
  }
  int currentIndex = 0;

  void changeCarouselIndex(int index) {
    currentIndex = index;
    emit(ChangeCarouselIndexState());
  }

}
