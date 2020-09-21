import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_app/model/movie.dart';

class HttpService {
  //Singleton to have only one instance of this class in whole app)
  static final HttpService _singleton = HttpService._internal();

  factory HttpService() => _singleton;

  HttpService._internal();

  static HttpService get httpService => _singleton;

  final String url =
      "https://raw.githubusercontent.com/sharmadeepesh/movies-json/master/data.json";

  Future<List<Movie>> getMovies() async {
    Response res = await get(url);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<Movie> movies = List();

      for (int i = 0; i < (body.length > 20 ? 20 : body.length); i++) {
        Movie movie = Movie.fromJson(body.elementAt(i)[i.toString()]);
        movies.add(movie);
      }

      return movies;
    } else {
      throw "Can't get movies.";
    }
  }
}
