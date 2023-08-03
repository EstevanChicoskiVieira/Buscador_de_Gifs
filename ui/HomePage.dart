import 'dart:convert';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'dart:async';

import 'GifPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String? _search;
  int _offSet = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if(_search == null){
      response = await http.get(
          Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=hYA52KdlVCGFNc3SVVQKRRbShBoi0PLm&limit=20&offset=0&rating=g&bundle=messaging_non_clips")
      );
    } else {
      response = await http.get(
          Uri.parse("https://api.giphy.com/v1/gifs/search?api_key=hYA52KdlVCGFNc3SVVQKRRbShBoi0PLm&q=$_search&limit=19&offset=$_offSet&rating=g&lang=pt&bundle=messaging_non_clips")
      );
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: "Pesquise aqui",
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
                onSubmitted: (text) {
                  setState(() {
                    _search = text;
                    _offSet = 0;
                  });
                },
              ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return _createGitTable(context, snapshot);
                    }
                }
              },
            ),
          )
        ],
      ),
    );
  }
  
  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGitTable(BuildContext context, AsyncSnapshot snapshot) {
    final dataList = snapshot.hasData ? snapshot.data["data"] as List<dynamic> : [];

    return GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index) {
          if (_search == null || index < snapshot.data["data"].length) {
            return GestureDetector(
              child: Image.network(
                snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                height: 300,
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => GifPage(
                    snapshot.data["data"][index]
                )));
              },
              onLongPress: () {
                Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
              },
            );
            } else {
            return Container(
              child: GestureDetector(
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 70,),
                    Text(
                      "Carregar mais...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    _offSet += 19;
                  });
                },
              ),
            );
          }
        },
    );
  }
}