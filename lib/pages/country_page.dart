import 'dart:convert';

import 'package:covid19_app/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CountryPage extends StatefulWidget {
  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  List countryData;

  fetchCountryWideData() async {
    http.Response response =
        await http.get('https://corona.lmao.ninja/v2/countries');
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  @override
  void initState() {
    fetchCountryWideData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: () {
              showSearch(context: context, delegate: Search(countryData));
            },
          ),
        ],
        title: Text(
          'Country Stats',
        ),
      ),
      body: countryData == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              shrinkWrap: true,
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
                                countryData[index]['country'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Image.network(
                                countryData[index]['countryInfo']['flag'],
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
                                      countryData[index]['cases'].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                Text(
                                  'active: '.toUpperCase() +
                                      countryData[index]['active'].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  'recovered: '.toUpperCase() +
                                      countryData[index]['recovered']
                                          .toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  'deaths: '.toUpperCase() +
                                      countryData[index]['deaths'].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
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
              itemCount: countryData == null ? 0 : countryData.length,
            ),
    );
  }
}
