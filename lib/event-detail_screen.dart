//mit Copilot
import "package:flutter/material.dart";
//import 'main.dart';
import "package:my_app/copilot.dart";

class EventdetailScreen extends StatelessWidget{
  final Event event;

  const EventdetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.titel)),
      body:   Padding(padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ort: ${event.ort}", style: TextStyle(fontSize: 18)),
          Text("Datum: ${event.datum}", style: TextStyle(fontSize: 18)),
          Text("Kategorie: ${event.kategorie}", style: TextStyle(fontSize: 18)),
          SizedBox(height: 24),
          ElevatedButton(onPressed: ()  { 
            //hier später: Fahrt anbieten oder finden
          },
           child: Text("Fahrt finden"),
           ),
        ],
      ),
      ),
    );
  }
}

