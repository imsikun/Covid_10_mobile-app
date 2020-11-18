import 'dart:convert';

import 'package:covid19_app/datasource.dart';
import 'package:covid19_app/pages/country_page.dart';
import 'package:covid19_app/panels/info_panel.dart';
import 'package:covid19_app/panels/world_wide_panel.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'panels/most_affected_country.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map worldData;

  fetchWorldWideData() async {
    http.Response response = await http.get('https://corona.lmao.ninja/v2/all');
    setState(() {
      worldData = json.decode(response.body);
    });
  }

  List countryData;

  fetchCountryData() async {
    http.Response response =
        await http.get('https://corona.lmao.ninja/v2/countries?sort=cases');
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  @override
  void initState() {
    fetchWorldWideData();
    fetchCountryData();
    super.initState();
  }

  Future fetcheData() async {
    fetchWorldWideData();
    fetchCountryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Theme.of(context).brightness == Brightness.light
                  ? Icons.lightbulb_outline
                  : Icons.highlight),
              onPressed: () {
                DynamicTheme.of(context).setBrightness(
                    Theme.of(context).brightness == Brightness.light
                        ? Brightness.dark
                        : Brightness.light);
              }),
        ],
        centerTitle: false,
        title: Text(
          'Covid-19 tracker'.toUpperCase(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetcheData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10.0),
                height: 100,
                color: Colors.orange[100],
                child: Text(
                  DataSource.quote,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'WorldWide',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CountryPage(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryBlack,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Regional',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              worldData == null
                  ? Center(child: CircularProgressIndicator())
                  : WorldWidePanel(
                      worldData: worldData,
                    ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Top 5 Countries',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              countryData == null
                  ? Center(child: CircularProgressIndicator())
                  : MostAffectedPanel(
                      countryData: countryData,
                    ),
              SizedBox(
                height: 20.0,
              ),
              InfoPanel(),
              SizedBox(
                height: 20.0,
              ),
              Center(
                child: Text(
                  'We are together in the fight'.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(
                height: 35.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
