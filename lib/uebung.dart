/*import 'package:flutter/material.dart';
import 'package:my_app/views/widgets/navbar_widget.dart';

void main() {
  runApp(const MyUebungenApp());
}

//Rezept:
//Material app (statful)
//Scaffold
//app title (bar)
//bottom navigation bar (set state) 3 glieder

//erster appaufbau mit video, danach nochmal alleine und kompakter in uebung.dart

import 'package:flutter/material.dart';

void main() {
  runApp(const MyUebungenApp());
}

class MyUebungenApp extends StatelessWidget {
  const MyUebungenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;   //wird bei notifierBuilder ersetzt
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kommende Events"), centerTitle: true),
      /*body: currentIndex == 0
          ? Center(child: Text("1"))        wenn 0, dann ...; sonst ...
          : Center(child: Text("2")),*/
      drawer: SafeArea(
        //die uhrzeit vom handy von der app ausschließen
        child: Drawer(
          child: Column(children: [ListTile(title: Text("Einstellungen"))]),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.celebration_outlined),
            label: "Events",
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_car),
            label: "Fahrten",
          ),
          NavigationDestination(icon: Icon(Icons.person), label: "Profil"),
        ],
        onDestinationSelected: (int value) {
          setState(() {
            currentIndex = value;
          });
          print("geklickt"); //ausgabeüberprüfung bei navigationsbarklick
        },
        selectedIndex:
            currentIndex, //mauell auswählen, welche seite der navigationsbar ausgewählt ist
      ),
    );
  }
}

//vereinfachte Version
class MyUebungenApp extends StatefulWidget {
  const MyUebungenApp({super.key});

  @override
  State<MyUebungenApp> createState() => _MyUebungenAppState();
}

class _MyUebungenAppState extends State<MyUebungenApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Event Übersicht"), 
          centerTitle: true,
          ),
        bottomNavigationBar: NavBarWidget(),
      ),
    );
  }
}
*/