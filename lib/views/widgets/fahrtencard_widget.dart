import 'package:flutter/material.dart';
import 'package:my_app/data/fahrt_daten.dart';
import 'package:my_app/data/event_daten.dart';
import 'package:my_app/views/pages/fahrt_anbieten_page.dart';
import 'package:my_app/views/widgets/sizehelper_widget.dart';

String getBackgroundImage(Fahrtrichtung richtung) {
  switch (richtung) {
    case Fahrtrichtung.hinfahrt:
      return "assets/image/hinfahrt3.png";
    case Fahrtrichtung.rueckfahrt:
      return "assets/image/rueckfahrt3.png";
    case Fahrtrichtung.hinUndZurueck:
      return "assets/image/hinundrueck2.png";
  }
}

class FahrtenCard extends StatelessWidget {
  final FahrtDaten fahrt;
  final bool isEditable; // 🆕 Flag, ob die Karte bearbeitbar ist

  const FahrtenCard({
    super.key,
    required this.fahrt,
    this.isEditable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(getBackgroundImage(fahrt.richtung)),
                    fit: BoxFit.cover,
                    alignment: const Alignment(0.1, 0.1),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Container(
              constraints: const BoxConstraints(minHeight: 260),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha((0.35 * 255).round()),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Benutzername
                    Row(
                      children: [
                        Text(
                          "Günther Hiden",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Sterne anzeigen basierend auf user.verificationStars
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                      ],
                    ),
                    const Divider(color: Colors.amber),

                    // ✅ Fahrtrichtung
                    Row(
                      children: [
                        const Icon(
                          Icons.directions,
                          color: Colors.greenAccent,
                          size: 24,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          () {
                            switch (fahrt.richtung) {
                              case Fahrtrichtung.hinfahrt:
                                return "Nur Hinfahrt";
                              case Fahrtrichtung.rueckfahrt:
                                return "Nur Rückfahrt";
                              case Fahrtrichtung.hinUndZurueck:
                                return "Hin und Zurück";
                            }
                          }(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // ✅ Strecke
                    Text(
                      () {
                        switch (fahrt.richtung) {
                          case Fahrtrichtung.hinfahrt:
                            return "${fahrt.abfahrtsort} → ${fahrt.standort}";
                          case Fahrtrichtung.rueckfahrt:
                            return "${fahrt.standort} → ${fahrt.abfahrtsort}";
                          case Fahrtrichtung.hinUndZurueck:
                            return "${fahrt.abfahrtsort} → ${fahrt.standort}";
                        }
                      }(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // ✅ Uhrzeit(en)
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Colors.amberAccent,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          fahrt.uhrzeit.format(context),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        if (fahrt.richtung == Fahrtrichtung.hinUndZurueck) ...[
                          const SizedBox(width: 20),
                          const Icon(
                            Icons.access_time,
                            color: Colors.amberAccent,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            fahrt.rueckuhrzeit?.format(context) ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),

                    // ✅ Freie Plätze
                    Row(
                      children: [
                        const Icon(
                          Icons.event_seat,
                          color: Colors.redAccent,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "${fahrt.freiePlaetze} freie Plätze",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ✅ Button (Bearbeiten oder Mitfahren)
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isEditable 
                              ? Colors.blueAccent // 🔥 Blau für Bearbeiten
                              : Colors.greenAccent.shade700, // Grün für Mitfahren
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (isEditable) {
                            debugPrint('Bearbeiten wurde geklickt');
                            _handleEdit(context);
                          } else {
                            debugPrint('Mitfahren wurde geklickt');
                            _handleMitfahren(context);
                          }
                        },
                        child: Text(
                          isEditable ? "Bearbeiten" : "Mitfahren",
                          style: TextStyle(
                            fontSize: SizeHelper.w(context, 0.04),
                          ),
                        ),
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
  }

  void _handleEdit(BuildContext context) {
    // Erstelle ein simples Event-Objekt aus den Fahrtdaten; passe Felder falls nötig
    final event = Event(
      name: fahrt.eventName,
      standort: fahrt.standort,
      // wenn Event ein Datum erwartet, setze temporär DateTime.now()
      datum: DateTime.now(), beschreibung: '', typ: '', adresse: '',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FahrtAnbietenPage(
          event: event,
          existingFahrt: fahrt,
        ),
      ),
    );
  }

  void _handleMitfahren(BuildContext context) {
    // TODO: Implementiere die Mitfahren-Logik
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Anfrage gesendet')),
    );
  }
}