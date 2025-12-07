import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:my_app/data/fahrt_daten.dart';
import 'package:my_app/data/event_daten.dart';
import 'package:my_app/data/anfrage_daten.dart';
import 'package:my_app/data/anfrage_service.dart';
import 'package:my_app/data/user_service.dart';
import 'package:my_app/views/pages/fahrt_anbieten_page.dart';
import 'package:my_app/views/widgets/sizehelper_widget.dart';
import 'package:my_app/views/pages/fahrt_anfragen_page.dart';

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

  const FahrtenCard({super.key, required this.fahrt, this.isEditable = false});

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
                        // Linker Teil: Name + Sterne
                        Expanded(
                          child: Row(
                            children: const [
                              Text(
                                "Günther Hiden",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(Icons.star, color: Colors.amber, size: 20),
                              Icon(Icons.star, color: Colors.amber, size: 20),
                              Icon(Icons.star, color: Colors.amber, size: 20),
                            ],
                          ),
                        ),

                        // Rechter Teil: Chat-Icon NUR wenn isEditable = true
                        if (isEditable)
                          IconButton(
                            icon: const Icon(
                              Icons.chat_bubble_outline,
                              color: Colors.white,
                              size: 22,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      FahrtAnfragenPage(fahrt: fahrt),
                                ),
                              );
                            },
                          ),
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
                              ? Colors
                                    .blueAccent // 🔥 Blau für Bearbeiten
                              : Colors
                                    .greenAccent
                                    .shade700, // Grün für Mitfahren
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
                            _handleEdit(context);
                          } else {
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
    final event = Event(
      name: fahrt.eventName,
      standort: fahrt.standort,
      datum: DateTime.now(), // TODO: echtes Event-Datum, wenn vorhanden
      beschreibung: '',
      typ: '',
      adresse: '',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FahrtAnbietenPage(event: event, existingFahrt: fahrt),
      ),
    );
  }

  void _handleMitfahren(BuildContext context) async {
    // 1️⃣ Aktuellen User holen
    final user = UserService().getCurrentUser();

    // 2️⃣ Dialog-Controller
    final seatsController = TextEditingController(text: '1');
    final messageController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(230, 30, 30, 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Mitfahranfrage senden",
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: seatsController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Plätze",
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white38),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: messageController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Nachricht (optional)",
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white38),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Abbrechen"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text("Senden"),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final seats = int.tryParse(seatsController.text.trim()) ?? 1;

    // 3️⃣ Anfrage-Objekt bauen
    final anfrage = AnfrageDaten.create(
      fahrtId: fahrt.id,
      eventId: fahrt.eventId,
      requesterId: user['id']!,
      requesterName: user['name']!,
      seatsRequested: seats,
      fahrtOwnerId: fahrt.ownerId,
      message: messageController.text.trim().isEmpty
          ? null
          : messageController.text.trim(),
    );

    // 4️⃣ Über Provider speichern
    final anfrageService = Provider.of<AnfrageService>(context, listen: false);
    await anfrageService.addAnfrage(anfrage);

    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Anfrage wurde gesendet")));
  }
}
