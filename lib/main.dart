import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forfaits Voyages',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: AccueilForfaitsVoyages(title: 'Forfaits Voyages'),
    );
  }
}

class AccueilForfaitsVoyages extends StatefulWidget {
  AccueilForfaitsVoyages({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  AccueilForfaitsVoyagesState createState() => AccueilForfaitsVoyagesState();
}

class AccueilForfaitsVoyagesState extends State<AccueilForfaitsVoyages> {
  late Future<List<Forfait>> futursForfaits;

  initState() {
    super.initState();
    futursForfaits = _fetchForfaits();
  }

/* Récupération des forfaits */
  Future<List<Forfait>> _fetchForfaits() async {
    final response = await http.get(Uri.https('forfaits-voyages.herokuapp.com', '/api/forfaits/da/1996400', {}));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((forfait) => new Forfait.fromJson(forfait)).toList();
    } else {
      throw Exception('Erreur de chargement des forfaits');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Forfait>>(
      future: futursForfaits,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: Text(widget.title),
              centerTitle: true,),
              body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              return Container(
                                color: Colors.teal,
                                  height: 300,
                                  margin: EdgeInsets.all(10),
                                  child: Row(
                                      children:[
                                        Expanded(
                                          flex:1,
                                          child: Wrap(
                                            children: [
                                              Image.network(
                                                'https://i.imgur.com/kTCIvjm.jpg',
                                                fit: BoxFit.cover,
                                                height: 300,
                                              ),
                                            ],
                                          ),
                                        ),
                                        /* Section expanded pour la section Hôtel */
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(17.0,0,0,0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text('Hôtel: '),
                                                    Text(snapshot.data![index].hotel.nom,
                                                      style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.2)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text('Prix: '),
                                                    Text(snapshot.data![index].prix.toString(),
                                                        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.2)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text('Rabais: '),
                                                    Text(snapshot.data![index].rabais.toString()),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text('Destination: '),
                                                    Text(snapshot.data![index].destination,
                                                    style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text (' Durée: '),
                                                    Text('14 jours',
                                                      style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text('Caractéristiques: '),
                                                    Text(snapshot.data![index].hotel.caracteristiques.toString(),
                                                        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text('Ville de départ: '),
                                                    Text(snapshot.data![index].villeDepart),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ),
                                        Expanded(
                                          /* Section expanded pour les dates,coordonnées, nombre de chambres et nombre d'étoiles  */
                                            flex: 2,
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text('Date de départ: '),
                                                      Text(snapshot.data![index].dateDepart.toString()),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text('Date de retour: '),
                                                      Text(snapshot.data![index].dateRetour.toString()),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text('Coordonnées: '),
                                                      Text(snapshot.data![index].hotel.coordonnees),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text('Nombre de chambres: '),
                                                      Text(snapshot.data?[index].hotel.nombreChambres.toString() ?? ''),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text("Nombre d'étoiles: "),
                                                      Text(snapshot.data?[index].hotel.nombreEtoiles.toString() ?? ''),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                  )
                              );
                            }
                            ),
                    ),
                  ],
                )
                ,)
          ),
          );// Cette partie a été comprimée dans les notes pour une meilleure visibilité
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}


class Forfait {
  final String id;
  final String destination;
  final String villeDepart;
  final String dateDepart;
  final String dateRetour;
  final String image;
  final int prix;
  final int rabais;
  final bool vedette;
  final Hotel hotel;

  Forfait({required this.id,required this.destination, required this.villeDepart, required this.hotel, required this.dateDepart, required this.dateRetour, required this.image, required this.prix, required this.rabais, required this.vedette});

  factory Forfait.fromJson(Map<String, dynamic> json) {
    return Forfait(
      id: json['_id'],
      destination: json['destination'],
      dateDepart: json['dateDepart'], //DateTime.parse(json['dateDepartD']),
      dateRetour: json['dateRetour'], //DateTime.parse(json['dateRetourD']),
      image: '',
      prix: json['prix'],
      rabais: json['rabais'],
      vedette: json['forfaitEnVedette'],
      hotel:Hotel.fromJson(json['hotel']),
      villeDepart: json['villeDepart'],

    );
  }

}

class Hotel {
  final String nom;
  final String coordonnees;
  final int nombreEtoiles;
  final int nombreChambres;
  final List<String> caracteristiques;

  Hotel({required this.nom, required this.coordonnees, required this.nombreEtoiles, required this.nombreChambres, required this.caracteristiques});

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
        nom:json['nom'],
        coordonnees:json['coordonnees'],
        nombreEtoiles: json['nombreEtoiles'],
        nombreChambres: json['nombreChambres'],
        caracteristiques: new List<String>.from(json['caracteristiques'])
    );
  }
}





