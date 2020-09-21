import 'dart:async';

import 'package:flutter_app/model/movie.dart';
import 'package:flutter_app/repository/data_repository.dart';

class MovieBloc{
  StreamController controller = StreamController<List<Movie>>();

  final dataRepository = DataRepository.dataRepository;

  void getMovies() async {
    List<Movie> movies;
    movies = await dataRepository.getMovies();
    //adding the latest data in controller to update the stream and refresh UI
    controller.add(movies);
  }

  void dispose() {
    controller.close();
  }
}