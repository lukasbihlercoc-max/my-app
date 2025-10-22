import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_app/data/event_daten.dart';
import 'package:my_app/data/fahrt_daten.dart';
import 'package:my_app/data/fahrt_service.dart';
import 'package:my_app/data/user_service.dart';
import 'package:my_app/views/widgets/background_widget.dart';


class FahrtAnbietenPage extends StatefulWidget {
  final Event event;
  const FahrtAnbietenPage({super.key, required this.event});

  @override
  State<FahrtAnbietenPage> createState() => _FahrtAnbietenPageState();
}

class _FahrtAnbietenPageState extends State<FahrtAnbietenPage> {
  final _formKey = GlobalKey<FormState>();
  String abfahrtsort = '';
  TimeOfDay? uhrzeit;
  TimeOfDay? rueckuhrzeit;
  int freiePlaetze = 1;

  Fahrtrichtung fahrtrichtung = Fahrtrichtung.hinfahrt;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppBackground(child: Container()),

        Container(color: Colors.black.withOpacity(0.4)),

        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(color: Colors.transparent),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text("Fahrt anbieten"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Text("Event: ${widget.event.name}",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70)),

                    SizedBox(height: 16),

                    Text("Fahrtrichtung:",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    RadioListTile<Fahrtrichtung>(
                      title: Text("Nur Hinfahrt", style: TextStyle(color: Colors.amber)),
                      value: Fahrtrichtung.hinfahrt,
                      groupValue: fahrtrichtung,
                      onChanged: (value) => setState(() => fahrtrichtung = value!),
                    ),
                    RadioListTile<Fahrtrichtung>(
                      title: Text("Nur Rückfahrt", style: TextStyle(color: Colors.amber)),
                      value: Fahrtrichtung.rueckfahrt,
                      groupValue: fahrtrichtung,
                      onChanged: (value) => setState(() => fahrtrichtung = value!),
                    ),
                    RadioListTile<Fahrtrichtung>(
                      title: Text("Hin und Zurück", style: TextStyle(color: Colors.amber)),
                      value: Fahrtrichtung.hinUndZurueck,
                      groupValue: fahrtrichtung,
                      onChanged: (value) => setState(() => fahrtrichtung = value!),
                    ),

                    SizedBox(height: 24),

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: fahrtrichtung == Fahrtrichtung.rueckfahrt
                            ? "Zielort"
                            : "Abfahrtsort",
                      ),
                      style: TextStyle(color: Colors.amber),
                      onChanged: (value) => abfahrtsort = value,
                      validator: (value) => value == null || value.isEmpty
                          ? "Bitte ${fahrtrichtung == Fahrtrichtung.rueckfahrt ? "Zielort" : "Abfahrtsort"} eingeben"
                          : null,
                    ),

                    SizedBox(height: 24),

                    Row(
                      children: [
                        Text("Uhrzeit:",
                            style: TextStyle(fontSize: 20, color: Colors.white)),
                        SizedBox(width: 8),
                        Text(
                          uhrzeit != null ? uhrzeit!.format(context) : "",
                          style: TextStyle(fontSize: 24, color: Colors.amber),
                        ),
                        TextButton(
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setState(() => uhrzeit = picked);
                            }
                          },
                          child: Text("Wählen",
                              style: TextStyle(color: Colors.blueAccent)),
                        ),
                      ],
                    ),

                    if (fahrtrichtung == Fahrtrichtung.hinUndZurueck)
                      Row(
                        children: [
                          Text(
                            "Rückfahrt:",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          SizedBox(width: 8),
                          Text(
                            rueckuhrzeit != null
                                ? rueckuhrzeit!.format(context)
                                : "",
                            style: TextStyle(fontSize: 24, color: Colors.amber),
                          ),
                          TextButton(
                            onPressed: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null) {
                                setState(() => rueckuhrzeit = picked);
                              }
                            },
                            child: Text(
                              "Wählen",
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                        ],
                      ),

                    SizedBox(height: 24),

                    Row(
                      children: [
                        Text("Freie Plätze:",
                            style: TextStyle(fontSize: 20, color: Colors.white)),
                        SizedBox(width: 8),
                        DropdownButton<int>(
                          dropdownColor: Color.fromARGB(217, 9, 61, 216),
                          value: freiePlaetze,
                          items: List.generate(
                            6,
                            (i) => DropdownMenuItem(
                              value: i + 1,
                              child: Text("${i + 1}"),
                            ),
                          ),
                          style: TextStyle(color: Colors.amber, fontSize: 24),
                          onChanged: (value) =>
                              setState(() => freiePlaetze = value!),
                        ),
                      ],
                    ),

                    SizedBox(height: 32),

                    Center(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.check),
                        label: Text("Fahrt speichern"),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (uhrzeit == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Bitte wähle eine Uhrzeit"),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                              return;
                            }
                            if (fahrtrichtung == Fahrtrichtung.hinUndZurueck &&
                                rueckuhrzeit == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Bitte Rückfahrzeit wählen"),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                              return;
                            }

                            //User Daten holen:
                            final userData = UserService().getCurrentUser();

                            final neueFahrt = FahrtDaten.fromTimeOfDay(
                              eventId: widget.event.id,
                              eventName: widget.event.name,
                              standort: widget.event.standort,
                              abfahrtsort: abfahrtsort,
                              uhrzeit: uhrzeit!,
                              rueckuhrzeit:
                                  fahrtrichtung == Fahrtrichtung.hinUndZurueck
                                  ? rueckuhrzeit
                                  : null,
                              freiePlaetze: freiePlaetze,
                              richtung: fahrtrichtung,
                              ownerId: userData['id']!,
                              ownerName: userData['name']!,
                            );

                            
                            FahrtService().addFahrt(neueFahrt);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.blueAccent,
                                content: Text("Fahrt gespeichert",
                                    style: TextStyle(fontSize: 20)),
                              ),
                            );

                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
