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
                              _buildStatusChip(a.status),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Plätze
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
                          if (a.message != null &&
                              a.message!.trim().isNotEmpty) ...[
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

                          // 🔥 Nur anzeigen, wenn Anfrage OFFEN ist
                          if (a.status == AnfrageStatus.offen)
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

                                // ✔️ Annehmen
                                TextButton.icon(
                                  onPressed: () async {
                                    final anfrageService =
                                        Provider.of<AnfrageService>(
                                          context,
                                          listen: false,
                                        );

                                    final fahrtService =
                                        Provider.of<FahrtService>(
                                          context,
                                          listen: false,
                                        );

                                    // 1️⃣ Anfrage auf "akzeptiert" setzen
                                    await anfrageService.akzeptiereAnfrage(a);

                                    // 2️⃣ Plätze reduzieren
                                    final neuePlaetze =
                                        fahrt.freiePlaetze - a.seatsRequested;

                                    final aktualisierteFahrt = fahrt.copyWith(
                                      freiePlaetze: neuePlaetze < 0
                                          ? 0
                                          : neuePlaetze,
                                    );

                                    // 3️⃣ Fahrt speichern
                                    await fahrtService.updateFahrt(
                                      fahrt.id,
                                      aktualisierteFahrt,
                                    );

                                    // 4️⃣ Feedback
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
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(AnfrageStatus status) {
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
}
