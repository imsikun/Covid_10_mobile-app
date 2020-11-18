import 'package:covid19_app/datasource.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

class Search extends SearchDelegate {
  final List countryList;

  Search(this.countryList);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor: primaryBlack,
      brightness: DynamicTheme.of(context).brightness,
    );
  }

  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? countryList
        : countryList
            .where((element) =>
                element['country'].toString().toLowerCase().startsWith(query))
            .toList();

    return ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          child: Container(
            height: 140,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 200,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        suggestionList[index]['country'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.network(
                        suggestionList[index]['countryInfo']['flag'],
                        height: 48,
                        width: 55,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'confirmed: '.toUpperCase() +
                              suggestionList[index]['cases'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          'active: '.toUpperCase() +
                              suggestionList[index]['active'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          'recovered: '.toUpperCase() +
                              suggestionList[index]['recovered'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          'deaths: '.toUpperCase() +
                              suggestionList[index]['deaths'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[100]
                                    : Colors.grey[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: suggestionList.length,
    );
  }
}
