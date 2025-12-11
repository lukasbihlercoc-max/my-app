// fahrt_anfragen_page.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:my_app/data/fahrt_daten.dart';
import 'package:my_app/data/anfrage_daten.dart';
import 'package:my_app/data/anfrage_service.dart';
import 'package:my_app/views/widgets/background_widget.dart';
import 'package:my_app/data/fahrt_service.dart';

class FahrtAnfragenPage extends StatelessWidget {
  final FahrtDaten fahrt;

  const FahrtAnfragenPage({super.key, required this.fahrt});

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
            elevation: 0,
            title: const Text("Anfragen zu deiner Fahrt"),
          ),
          body: Consumer<AnfrageService>(
            builder: (context, anfrageService, child) {
              final anfragen = anfrageService.getAnfragenForFahrt(fahrt.id);

              if (anfragen.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 64,
                        color: Colors.white.withOpacity(0.6),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Noch keine Anfragen für diese Fahrt",
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: anfragen.length,
                itemBuilder: (context, index) {
                  final AnfrageDaten a = anfragen[index];

                  return _AnfrageCard(
                    anfrage: a,
                    fahrt: fahrt,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Einzelne Anfrage-Karte mit + / – Steuerung für die anzunehmenden Plätze
class _AnfrageCard extends StatefulWidget {
  final AnfrageDaten anfrage;
  final FahrtDaten fahrt;

  const _AnfrageCard({
    super.key,
    required this.anfrage,
    required this.fahrt,
  });

  @override
  State<_AnfrageCard> createState() => _AnfrageCardState();
}

class _AnfrageCardState extends State<_AnfrageCard> {
  late int _acceptedSeats;

  @override
  void initState() {
    super.initState();
    // Standard: alle angefragten Plätze annehmen (mindestens 1)
    _acceptedSeats = widget.anfrage.seatsRequested.clamp(1, widget.anfrage.seatsRequested);
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.anfrage;

    return Card(
      color: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name + Status
            Row(
              children: [
                Text(
                  a.requesterName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                buildStatusChip(a.status),
              ],
            ),
            const SizedBox(height: 8),

            // Angefragte Plätze
            Row(
              children: [
                const Icon(
                  Icons.event_seat,
                  color: Colors.amber,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  "${a.seatsRequested} Platz${a.seatsRequested > 1 ? 'e' : ''} angefragt",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Nachricht anzeigen (falls vorhanden)
            if (a.message != null && a.message!.trim().isNotEmpty) ...[
              const Text(
                "Nachricht:",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                a.message!,
                style: const TextStyle(color: Colors.white),
              ),
            ],

            const SizedBox(height: 12),

            // Nur bei offenen Anfragen: + / – und Buttons
            if (a.status == AnfrageStatus.offen) ...[
              // 🔹 Auswahl, wie viele Plätze angenommen werden
              const Text(
                "Plätze annehmen",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  // ➖ Minus
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.remove, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          if (_acceptedSeats > 1) {
                            _acceptedSeats--;
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Zahl
                  Text(
                    "$_acceptedSeats",
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // ➕ Plus (max. seatsRequested)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          if (_acceptedSeats < a.seatsRequested) {
                            _acceptedSeats++;
                          }
                        });
                      },
                    ),
                  ),

                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "von insgesamt ${a.seatsRequested} angefragten Plätzen",
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 🔥 Buttons Ablehnen / Annehmen
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // ❌ Ablehnen
                  TextButton.icon(
                    onPressed: () async {
                      final service = Provider.of<AnfrageService>(
                        context,
                        listen: false,
                      );

                      await service.ablehnenAnfrage(a);

                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Anfrage abgelehnt"),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.redAccent,
                    ),
                    label: const Text(
                      "Ablehnen",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // ✔️ Annehmen (mit _acceptedSeats)
                  TextButton.icon(
                    onPressed: () async {
                      final anfrageService =
                          Provider.of<AnfrageService>(context, listen: false);
                      final fahrtService =
                          Provider.of<FahrtService>(context, listen: false);

                      // 0) Aktuelle Fahrt aus Service holen
                      final aktuelleFahrt =
                          fahrtService.alleFahrten.firstWhere(
                        (f) => f.id == widget.fahrt.id,
                        orElse: () => widget.fahrt,
                      );

                      // tatsächliche freie Plätze
                      final freie = aktuelleFahrt.freiePlaetze;

                      if (freie <= 0) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Fahrt ist bereits voll – keine Plätze mehr frei."),
                          ),
                        );
                        return;
                      }

                      // Sicherstellen, dass wir keine ungültige Zahl verwenden
                      int seatsToAccept = _acceptedSeats;

                      // nicht mehr als angefragt, nicht mehr als frei
                      if (seatsToAccept > a.seatsRequested) {
                        seatsToAccept = a.seatsRequested;
                      }
                      if (seatsToAccept > freie) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Nur noch $freie Platz${freie == 1 ? '' : 'e'} frei – bitte weniger Plätze annehmen.",
                            ),
                          ),
                        );
                        setState(() {
                          _acceptedSeats = freie.clamp(1, a.seatsRequested);
                        });
                        return;
                      }

                      // 1) Anfrage auf "akzeptiert" setzen
                      await anfrageService.akzeptiereAnfrage(a, seatsToAccept);

                      // 2) Plätze neu berechnen
                      final neuePlaetze = freie - seatsToAccept;

                      final aktualisierteFahrt = aktuelleFahrt.copyWith(
                        freiePlaetze: neuePlaetze < 0 ? 0 : neuePlaetze,
                      );

                      // 3) Fahrt speichern
                      await fahrtService.updateFahrt(
                        aktuelleFahrt.id,
                        aktualisierteFahrt,
                      );

                      if (!mounted) return;
                      // 4) Feedback
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            neuePlaetze > 0
                                ? "Anfrage angenommen – verbleibende Plätze: $neuePlaetze"
                                : "Anfrage angenommen – Fahrt ist jetzt voll",
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.check,
                      color: Colors.greenAccent,
                    ),
                    label: const Text(
                      "Annehmen",
                      style: TextStyle(color: Colors.greenAccent),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Ausgelagerte Helfer-Funktion für den Status-Chip
Widget buildStatusChip(AnfrageStatus status) {
  Color bg;
  String text;

  switch (status) {
    case AnfrageStatus.offen:
      bg = Colors.blueAccent.withOpacity(0.7);
      text = "Offen";
      break;
    case AnfrageStatus.akzeptiert:
      bg = Colors.green.withOpacity(0.7);
      text = "Akzeptiert";
      break;
    case AnfrageStatus.abgelehnt:
      bg = Colors.red.withOpacity(0.7);
      text = "Abgelehnt";
      break;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 12),
    ),
  );
}
