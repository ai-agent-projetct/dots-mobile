import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:user/features/trends/data/models/getall_trends_model.dart';
import 'package:user/features/trends/data/models/moretrends_response_model.dart';
import 'package:user/features/trends/domain/usecases/getalltrends_usecase.dart';
import 'package:user/features/trends/domain/usecases/moretrends_usecase.dart';

class TrendsProvider extends ChangeNotifier {
  final GetAllTrendsUsecae _getAllTrendsUsecase;
  final MoreTrendsUsecase _moreTrendsUsecase;

  TrendsProvider(this._getAllTrendsUsecase, this._moreTrendsUsecase);
  final searchController = TextEditingController();

  List<TrendsModel> _trends = [];
  bool _isLoading = false;
  String? _error;

  List<TrendsModel> get trends => _trends;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getAllTrends(double lat, double lon) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _getAllTrendsUsecase.getAllTrends(lat, lon);

    if (result.isLeft()) {
      final failure = result.getLeft();
      _error = failure.toString();
      log("Trends Error---: $_error");
    } else {
      final success = result.getRight();
      _trends = success.data;
      log("Trends Success---: ${_trends.length} items loaded");
    }

    _isLoading = false;
    notifyListeners();
  }

  List<ProviderTrendsData> _moretrends = [];
  List<ProviderTrendsData> get moretrends => _moretrends;
  Future<void> getMoreTrends(String mediaId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _moreTrendsUsecase.moreTrends(mediaId);

    if (result.isLeft()) {
      final failure = result.getLeft();
      _error = failure.toString();
      log("Trends Error---: $_error");
    } else {
      final success = result.getRight();
      _moretrends = success.data;
      log("Trends Success---: ${_trends.length} items loaded");
    }

    _isLoading = false;
    notifyListeners();
  }
}
