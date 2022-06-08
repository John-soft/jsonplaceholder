import 'package:flutter/material.dart';

import 'movie_helper.dart';
import 'movie_detail.dart';

class MovieList extends StatefulWidget {
  const MovieList({Key? key}) : super(key: key);

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  int? moviesCount;
  List? movies;
  Icon visibleIcon = const Icon(Icons.search);
  Widget searchBar = const Text('Movies');

  MovieHelper? helper;
  final String iconBase = 'https://image.tmdb.org/t/p/w92/';

  final String defaultImage =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';

  Future initialize() async {
    movies = [];
    movies = await helper!.getUpcoming();
    setState(() {
      moviesCount = movies!.length;
      movies = movies;
    });
  }

  Future search(text) async {
    movies = await helper!.findMovies(text);
    setState(() {
      moviesCount = movies!.length;
      movies = movies;
    });
  }

  @override
  void initState() {
    helper = MovieHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // helper!.getUpcoming().then((value) {
    //   setState(() {
    //     result = value;
    //   });
    // });

    NetworkImage image;
    return Scaffold(
      appBar: AppBar(
        title: searchBar,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (visibleIcon == const Icon(Icons.search)) {
                  visibleIcon = const Icon(Icons.cancel);
                  searchBar = TextField(
                    textInputAction: TextInputAction.search,
                    onSubmitted: (String text) {
                      search(text);
                    },
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  );
                } else {
                  setState(() {
                    visibleIcon = const Icon(Icons.search);
                    searchBar = const Text('Movies');
                  });
                }
              });
            },
            icon: visibleIcon,
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: (moviesCount == null) ? 0 : moviesCount,
          itemBuilder: (context, int index) {
            if (movies![index].posterPath != null) {
              image = NetworkImage(iconBase + movies![index].posterPath);
            } else {
              image = NetworkImage(defaultImage);
            }
            return Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MovieDetail(movie: movies![index]);
                  }));
                },
                leading: CircleAvatar(
                  backgroundImage: image,
                ),
                title: Text(movies![index].title),
                subtitle: Text('Released : ' +
                    movies![index].releaseDate +
                    ' - Vote: ' +
                    movies![index].voteAverage.toString()),
              ),
            );
          }),
    );
  }
}
