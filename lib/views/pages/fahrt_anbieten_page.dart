// fahrt_anbieten_page.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_app/data/event_daten.dart';
import 'package:my_app/data/fahrt_daten.dart';
import 'package:my_app/data/fahrt_service.dart';
import 'package:my_app/data/user_service.dart';
import 'package:my_app/views/widgets/background_widget.dart';

class FahrtAnbietenPage extends StatefulWidget {
  final Event event;
  final FahrtDaten?
  existingFahrt; // 🆕 Optional: Vorhandene Fahrt zum Bearbeiten

  const FahrtAnbietenPage({super.key, required this.event, this.existingFahrt});

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

  static const int maxPlaetze = 20; //! Maximale Anzahl freier Plätze

  @override
  void initState() {
    super.initState();
    // Wenn eine vorhandene Fahrt übergeben wurde, Formularfelder vorfüllen
    final f = widget.existingFahrt;
    if (f != null) {
      abfahrtsort = f.abfahrtsort;
      uhrzeit = TimeOfDay(hour: f.uhrzeit.hour, minute: f.uhrzeit.minute);
      if (f.rueckuhrzeit != null) {
        rueckuhrzeit = TimeOfDay(
          hour: f.rueckuhrzeit!.hour,
          minute: f.rueckuhrzeit!.minute,
        );
      }
      // freie Plätze korrigieren falls Wert außerhalb des Dropdown-Bereichs liegt
      if (f.freiePlaetze < 1) {
  freiePlaetze = 1;
} else if (f.freiePlaetze > maxPlaetze) {
  freiePlaetze = maxPlaetze;
} else {
  freiePlaetze = f.freiePlaetze;
}

      fahrtrichtung = f.richtung;
    }
  }

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
                    Text(
                      "Event: ${widget.event.name}",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),

                    SizedBox(height: 16),

                    Text(
                      "Fahrtrichtung:",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    RadioListTile<Fahrtrichtung>(
                      title: Text(
                        "Nur Hinfahrt",
                        style: TextStyle(color: Colors.amber),
                      ),
                      value: Fahrtrichtung.hinfahrt,
                      groupValue: fahrtrichtung,
                      onChanged: (value) =>
                          setState(() => fahrtrichtung = value!),
                    ),
                    RadioListTile<Fahrtrichtung>(
                      title: Text(
                        "Nur Rückfahrt",
                        style: TextStyle(color: Colors.amber),
                      ),
                      value: Fahrtrichtung.rueckfahrt,
                      groupValue: fahrtrichtung,
                      onChanged: (value) =>
                          setState(() => fahrtrichtung = value!),
                    ),
                    RadioListTile<Fahrtrichtung>(
                      title: Text(
                        "Hin und Zurück",
                        style: TextStyle(color: Colors.amber),
                      ),
                      value: Fahrtrichtung.hinUndZurueck,
                      groupValue: fahrtrichtung,
                      onChanged: (value) =>
                          setState(() => fahrtrichtung = value!),
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
                        Text(
                          "Uhrzeit:",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
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
                          child: Text(
                            "Wählen",
                            style: TextStyle(color: Colors.blueAccent),
                          ),
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
                        Text(
                          "Freie Plätze:",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        const SizedBox(width: 16),

                        // ➖ Minus Button (NEU, skalierbar)
                        SizedBox(
                          width: 34, // << Größe kannst du hier anpassen
                          height: 34, // << Größe anpassen
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              padding: EdgeInsets
                                  .zero, // << Wichtig für korrekte Größe
                              iconSize: 20, // << Icon-Größe einstellen
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (freiePlaetze > 1) freiePlaetze--;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Zahl in der Mitte
                        Text(
                          "$freiePlaetze",
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // ➕ Plus Button (NEU, skalierbar)
                        SizedBox(
                          width: 34, // << Größe anpassen
                          height: 34, // << Größe anpassen
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero, // << wichtig!
                              iconSize: 20, // << Icon-Größe einstellen
                              icon: const Icon(Icons.add, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  if (freiePlaetze < maxPlaetze) freiePlaetze++;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),



                    SizedBox(height: 32),

                    Center(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.check),
                        label: Text("Fahrt speichern"),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (uhrzeit == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Bitte wähle eine Uhrzeit"),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                              return;
                            }

                            if (fahrtrichtung == Fahrtrichtung.hinUndZurueck &&
                                rueckuhrzeit == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Bitte Rückfahrzeit wählen"),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                              return;
                            }

                            final userData = UserService().getCurrentUser();

                            // 🔑 Wenn wir bearbeiten, übernehmen wir eventId/eventName/standort
                            final eventId =
                                widget.existingFahrt?.eventId ??
                                widget.event.stabileId;
                            final eventName =
                                widget.existingFahrt?.eventName ??
                                widget.event.name;
                            final standort =
                                widget.existingFahrt?.standort ??
                                widget.event.standort;

                            final neueFahrt = FahrtDaten.fromTimeOfDay(
                              eventId: eventId,
                              eventName: eventName,
                              standort: standort,
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
                              id: widget
                                  .existingFahrt
                                  ?.id, // gleiche Fahrt-ID beim Bearbeiten
                            );

                            if (widget.existingFahrt != null) {
                              await FahrtService().updateFahrt(
                                widget.existingFahrt!.id,
                                neueFahrt,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Fahrt aktualisiert"),
                                ),
                              );
                            } else {
                              await FahrtService().addFahrt(neueFahrt);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Fahrt gespeichert"),
                                ),
                              );
                            }

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
