import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/movie_bloc.dart';
import 'package:flutter_app/model/movie.dart';
import 'package:flutter_app/resources/strings.dart';

class MoviePage extends StatefulWidget {
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final MovieBloc movieBloc = MovieBloc();

  List<String> tagList;
  Movie movieDetails;

  @override
  void initState() {
    super.initState();
    //getting the movies from bloc
    movieBloc.getMovies();
  }

  @override
  void dispose() {
    //disposing the controller when state is no more present
    movieBloc.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: _buildBottomAppBar(),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  movieDetails != null
                      ? movieDetails.image
                      : "https://m.media-amazon.com/images/M/MV5BNTA2ZWJjNDItMTcxMi00MGEwLWEyMTUtYWQ2ZDBjMTY3MjNjXkEyXkFqcGdeQXVyNDc2NzU1MTA@._V1_SY1000_CR0,0,749,1000_AL_.jpg",
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    movieDetails != null ? movieDetails.name : "",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Description",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    maxLines: 4,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(movieDetails != null ? movieDetails.details : "",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      )),
                ),
                _getTagList(tagList),
                _getList()
              ],
            )));
  }

  Widget _placeHolderView() {
    return Container(
        height: 300,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: CircularProgressIndicator());
  }

  Widget _noDataView() {
    return Container(
      height: 300,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Text(
        Strings.NO_DATA_FOUND,
        style:
            TextStyle(fontSize: Theme.of(context).textTheme.headline4.fontSize),
      ),
    );
  }

  Widget _buildBottomAppBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.grey, spreadRadius: 3, blurRadius: 6),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        child: BottomNavigationBar(
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          unselectedItemColor: Colors.grey,
          currentIndex: 0,
          items: [
            _buildBarIcon(Icons.home),
            _buildBarIcon(Icons.add),
            _buildBarIcon(Icons.phone),
            _buildBarIcon(Icons.event),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBarIcon(IconData icon) {
    return BottomNavigationBarItem(icon: new Icon(icon), title: Text(""));
  }

  Widget _getList() {
    return StreamBuilder<List<Movie>>(
      stream: movieBloc.controller.stream,
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            {
              return _placeHolderView();
            }
          case ConnectionState.active:
            {
              if (snapshot.hasError || !snapshot.hasData) {
                return _noDataView();
              }
              List<Movie> movies = snapshot.data;
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 500,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    Movie item = movies[index];
                    movieDetails = item;
                    return _getMovieWidget(item);
                  },
                  itemCount: movies == null ? 0 : movies.length,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.2),
                ),
              );
            }
          default:
            {
              return _noDataView();
            }
        }
      },
    );
  }

  Widget _getHashTagWidget(String tagName) {
    return Container(
      padding: EdgeInsets.all(2),
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          border: Border.all(color: Colors.blueAccent)),
      child: Text(tagName),
    );
  }

  Widget _getMovieWidget(Movie movie) {
    return GestureDetector(
        onTap: () {
          setState(() {
            movieDetails = movie;
            tagList = movie.tags;
          });
        },
        child: Container(
          height: 300,
          width: 200,
          child: Column(
            children: [
              Container(
                width: 150,
                height: 200,
                padding: EdgeInsets.all(5),
                child: Image.network(movie.image),
              ),
              Text(
                movie.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              )
            ],
          ),
        ));
  }

  Widget _getTagList(List<String> tagList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      child: tagList != null && tagList.length > 0
          ? (ListView.builder(
              itemCount: tagList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                return Container(
                  width: 80,
                  height: 80,
                  child: _getHashTagWidget(tagList.elementAt(i)),
                );
              }))
          : Text("No Tag Found"),
    );
  }
}
