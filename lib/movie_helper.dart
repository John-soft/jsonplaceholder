import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jsonplaceholder/movie.dart';

class MovieHelper {
  final String urlKey = "api_key=2bfcdd4ea119e267702526b8da2ded6c";
  final String urlBase = "https://api.themoviedb.org/3/movie";
  final String urlUpcoming = "/upcoming?";
  final String urlLanguage = "&language=en-US";
  final String urlSearchBase =
      'https://api.themoviedb.org/3/search/movie?api_key=[2bfcdd4ea119e267702526b8da2ded6c]&query=';

  Future<List> findMovies(String title) async {
    http.Response result = await http.get(Uri.parse(urlSearchBase + title));
    if (result.statusCode == 200) {
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['results'];
      List movies = moviesMap.map((item) => Movie.fromJson(item)).toList();
      return movies;
    } else {
      throw "Exception";
    }
  }

  Future<List> getUpcoming() async {
    final String upcoming = urlBase + urlUpcoming + urlKey + urlLanguage;
    http.Response result = await http.get(Uri.parse(upcoming));
    if (result.statusCode == 200) {
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['results'];
      List movies = moviesMap.map((item) => Movie.fromJson(item)).toList();
      return movies;
    } else {
      throw "Exception";
    }
  }
}
