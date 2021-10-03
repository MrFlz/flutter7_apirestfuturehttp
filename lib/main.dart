import 'dart:convert';

import 'package:apirest_futurehttp/Models/Gif.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http; //encapsula paquete importado en un objeto para ser fácil su acceso y manipulación

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late Future<List<Gif>> _listadoGifs;
  String apiurl="https://api.giphy.com/v1/gifs/trending?api_key=8yZ1ZKmKmPhbEbh6RwqQEqUbE8TpFa0O&limit=25&rating=g";
  var item;

  Future<List<Gif>> _getGifs() async {
    final response = await http.get(Uri.parse(apiurl));
  
    List<Gif> gifs = [];

    if(response.statusCode == 200){
      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);

      // print(jsonData["data"][0]["id"]); // ejemplo sobre la obtención de un dato a lo largo del json

      //agregar objetos de tipo gif en la lista creada anteriormente
      for ( item in jsonData["data"]){
        gifs.add(
          Gif(item["title"], item["images"]["downsized"]["url"])
        );
      }
      return gifs;

    }else{
      throw Exception ("Algo falló en la conexión (creeeo xd )");
    }  
  }

  @override
  void initState() { // función propia de Flutter que se ejecuta al abrirse una ventana, es lo primero que se ejecuta
    super.initState();   
    _listadoGifs = _getGifs() ;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'apirest_futurehttp',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('API REST Future HTTP'),
        ),
        body: FutureBuilder (
          future: _listadoGifs,
          builder: (context, snapshot) {
            if (snapshot.hasData){
              print(snapshot.data);
              return ListView(
                children: _listGifs(snapshot.data)
              );

            }else if(snapshot.hasError){
              print(snapshot.error);
              return const Text("errorzaso");
            }
            return const Center(
              child: CircularProgressIndicator()                
            );
          },        
        )
        
        /*Center(
          // ignore: deprecated_member_use
          child: RaisedButton(
            child: const Text("Get API"),
              onPressed: ()=>{ //para que funcione, el Center no debe ser CONST
                // ignore: avoid_print
                print("Presionaste get api"),
                _listadoGifs = _getGifs(),
                _listGifs( item["images"]["downsized"]["url"])
              }
          )
        )*/
      ),
    );
  }

  List<Widget> _listGifs(data){
    List<Widget> gifs = [];

    for (var gif in data){
      gifs.add(
        Card(
          child: Column(
            children: [
              Image.network(gif.url),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(gif.name),
              )
            ]
          )
        )
      );
    }

    return gifs;    
  }
  
  // PARA UNA MEJOR VISUALIZACION o algo así jejep... (NOTA: código incompleto)
  /*List<Widget> _listGifs(List<Gif> data){
    List<Widget> gifs = [];

    for (var gif in data){
      gifs.add(
        Card(
          child: Column(
            children: [
              Expanded(child: Image.network(gif.url, fit: BoxFit.fill))
            ]
          )
        )
      );
    }

    return gifs;    
  }*/

}



