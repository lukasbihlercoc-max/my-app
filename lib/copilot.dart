import 'package:flutter/material.dart';
import "event-detail_screen.dart";

//import 'package:flutter/material.dart';
//import 'package:my_app/uebung.dart';

//void main() => runApp(MyUebungenApp());

// 📦 Klasse mit Event Informationen
class Event {
  final String titel;
  final String ort;
  final DateTime datum;
  final String kategorie;
  final int entfernung;

  Event({
    required this.titel,
    required this.ort,
    required this.datum,
    required this.kategorie,
    required this.entfernung,
  });
}

// 📋 Beispiel-Events
List<Event> alleEvents = [
  Event(
    titel: "Feuerwehrbewerb",
    ort: "Paternion",
    datum: DateTime(2025, 9, 2, 14, 0),
    kategorie: "Feuerwehrbewerb",
    entfernung: 15,
  ),
  Event(
    titel: "Kirchtag Radenthein",
    ort: "Radenthein",
    datum: DateTime(2025, 9, 13, 20, 0),
    kategorie: "Kirchtag",
    entfernung: 5,
  ),
  Event(
    titel: "Nockis",
    ort: "Millstatt",
    datum: DateTime(2025, 8, 31, 18, 0),
    kategorie: "Konzert",
    entfernung: 10,
  ),
];
/*
// 🚀 Einstiegspunkt
void main() {
  runApp(const MyApp());
}
*/
// 🧱 Haupt-App
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Eventliste",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const EventListeScreen(),
    );
  }
}

// 📦 StatefulWidget für die Eventliste
class EventListeScreen extends StatefulWidget {
  const EventListeScreen({super.key});

  @override
  State<EventListeScreen> createState() => _EventListeScreenState();
}

// 🔧 State-Klasse
class _EventListeScreenState extends State<EventListeScreen> {
  String? ausgewaehlteKategorie;
  int? maxEntfernung;
//  bool naechstesEvent = false; // ✅ Standardwert gesetzt, nicht nullable

  List<String> kategorien = alleEvents.map((e) => e.kategorie).toSet().toList();

  @override
  Widget build(BuildContext context) {
    List<Event> gefilterteEvents = alleEvents.where((event) {
      /*if (naechstesEvent) {
        DateTime jetzt = DateTime.now();
      if (!event.datum.isAfter(jetzt)) return false;
      }*/
      if (ausgewaehlteKategorie != null && event.kategorie != ausgewaehlteKategorie) return false;
      if (maxEntfernung != null && event.entfernung > maxEntfernung!) return false;
      return true;
    }).toList();

    gefilterteEvents.sort((a, b) => a.datum.compareTo(b.datum));

    return Scaffold(
      appBar: AppBar(title: const Text("Veranstaltungen")),
      body: Column(
        children: [
          DropdownButton<String>(
            hint: const Text("Kategorie wählen"),
            value: ausgewaehlteKategorie,
            items: kategorien.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
            onChanged: (value) => setState(() => ausgewaehlteKategorie = value),
          ),
          DropdownButton<int>(
            hint: const Text("Entfernung auswählen"),
            value: maxEntfernung,
            items: [5, 10, 15].map((km) => DropdownMenuItem(value: km, child: Text("$km km"))).toList(),
            onChanged: (value) => setState(() => maxEntfernung = value),
          ),
        /*  CheckboxListTile(
            title: const Text("Nur nächstes Fest anzeigen"),
            value: naechstesEvent,
            onChanged: (value) => setState(() => naechstesEvent = value ?? false),
          ),*/
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: gefilterteEvents.length,
              itemBuilder: (context, index) {
                final event = gefilterteEvents[index];
                return ListTile(
                  title: Text(event.titel),
                  subtitle: Text("${event.ort} - ${event.datum.day}.${event.datum.month}.${event.datum.year}"),
                  trailing: Text(event.kategorie),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventdetailScreen(event: event),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
