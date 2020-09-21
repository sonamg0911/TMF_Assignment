import 'dart:async';

import 'package:flutter_app/model/movie.dart';
import 'package:flutter_app/network/http_service.dart';

class DataRepository {

  //Singleton to have only one instance of this class in whole app)
  static final DataRepository _singleton = DataRepository._internal();
  factory DataRepository() => _singleton;
  DataRepository._internal();
  static DataRepository get dataRepository => _singleton;

  final httpService = HttpService.httpService;

  Future<List<Movie>> getMovies() async {
    return await httpService.getMovies();
  }


}
