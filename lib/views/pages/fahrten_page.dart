// fahrten_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import 'package:my_app/data/fahrt_service.dart';
import 'package:my_app/data/anfrage_service.dart';
import 'package:my_app/data/anfrage_daten.dart';
import 'package:my_app/data/user_service.dart';
import 'package:my_app/views/widgets/background_widget.dart';
import 'package:my_app/views/widgets/fahrtencard_widget.dart';
import 'package:my_app/data/fahrt_daten.dart';

class MeineFahrtenPage extends StatelessWidget {
  const MeineFahrtenPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = UserService().getCurrentUser();
    final userId = userData['id']!;

    return DefaultTabController(
      length: 2,
      child: Stack(
        children: [
          AppBackground(child: Container()),
          Container(color: Colors.black.withOpacity(0.4)),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.transparent),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                const SizedBox(height: 8),
                const TabBar(
                  indicatorColor: Colors.amber,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: [
                    Tab(text: "Angeboten"),
                    Tab(text: "Angefragt"),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: TabBarView(
                    children: [
                      _AngeboteneFahrtenTab(userId: userId),
                      _AngefragteFahrtenTab(userId: userId),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// TAB 1 – deine angebotenen Fahrten
class _AngeboteneFahrtenTab extends StatelessWidget {
  final String userId;

  const _AngeboteneFahrtenTab({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Consumer<FahrtService>(
      builder: (context, fahrtService, child) {
        final meineFahrten = fahrtService.getFahrtenByUser(userId);

        if (meineFahrten.isEmpty) {
          return _EmptyState(
            icon: Icons.directions_car_filled_outlined,
            title: "Noch keine Fahrten erstellt",
            subtitle: "Erstelle eine Fahrt,\num Mitfahrende zu finden.",
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 120),
          itemCount: meineFahrten.length,
          itemBuilder: (context, index) {
            final fahrt = meineFahrten[index];
            return FahrtenCard(
              fahrt: fahrt,
              isEditable: true,
            );
          },
        );
      },
    );
  }
}

/// Hilfsklasse: Anfrage + (ggf.) zugehörige Fahrt
class _RequestedRideItem {
  final AnfrageDaten anfrage;
  final FahrtDaten? fahrt; // null = Fahrt gelöscht

  _RequestedRideItem(this.anfrage, this.fahrt);
}

/// TAB 2 – Fahrten, bei denen du MITFAHRER bist
class _AngefragteFahrtenTab extends StatelessWidget {
  final String userId;

  const _AngefragteFahrtenTab({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AnfrageService, FahrtService>(
      builder: (context, anfrageService, fahrtService, child) {
        final anfragen = anfrageService.getAnfragenByRequester(userId);

        final List<_RequestedRideItem> items = anfragen.map((a) {
          FahrtDaten? fahrt;
          try {
            fahrt = fahrtService.alleFahrten.firstWhere(
              (f) => f.id == a.fahrtId,
            );
          } catch (_) {
            fahrt = null;
          }
          return _RequestedRideItem(a, fahrt);
        }).toList();

        if (items.isEmpty) {
          return _EmptyState(
            icon: Icons.chat_bubble_outline,
            title: "Noch keine Mitfahranfragen",
            subtitle: "Suche dir eine Fahrt aus\nund sende eine Anfrage.",
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 120),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            if (item.fahrt == null) {
              return _RequestedRideDeletedCard(anfrage: item.anfrage);
            }

            return _RequestedRideCard(
              fahrt: item.fahrt!,
              anfrage: item.anfrage,
            );
          },
        );
      },
    );
  }
}

/// Card für "angefragte" Fahrten (Fahrt existiert noch)
class _RequestedRideCard extends StatelessWidget {
  final FahrtDaten fahrt;
  final AnfrageDaten anfrage;

  const _RequestedRideCard({
    required this.fahrt,
    required this.anfrage,
  });

  Color _statusColor(AnfrageStatus status) {
    switch (status) {
      case AnfrageStatus.offen:
        return Colors.blueAccent;
      case AnfrageStatus.akzeptiert:
        return Colors.greenAccent;
      case AnfrageStatus.abgelehnt:
        return Colors.redAccent;
    }
  }

  String _statusText(AnfrageStatus status) {
    switch (status) {
      case AnfrageStatus.offen:
        return "Offen";
      case AnfrageStatus.akzeptiert:
        return "Akzeptiert";
      case AnfrageStatus.abgelehnt:
        return "Abgelehnt";
    }
  }

  // --- Helper: baut die Strecken-Zeile mit schönem Pfeil ---
  Widget _buildRouteRow(BuildContext context) {
  // Start/Ziel abhängig von Richtung
  final left = fahrt.richtung == Fahrtrichtung.rueckfahrt
      ? fahrt.standort
      : fahrt.abfahrtsort;

  final right = fahrt.richtung == Fahrtrichtung.rueckfahrt
      ? fahrt.abfahrtsort
      : fahrt.standort;

  // EXAKT DIESE ICONS WIE BEI ANGEBOTENEN FAHRTEN
  final IconData arrowIcon;
  switch (fahrt.richtung) {
    case Fahrtrichtung.hinfahrt:
      arrowIcon = Icons.arrow_right_alt_rounded;
      break;
    case Fahrtrichtung.rueckfahrt:
      arrowIcon = Icons.arrow_right_alt_rounded;
      break;
    case Fahrtrichtung.hinUndZurueck:
      arrowIcon = Icons.compare_arrows_rounded;
      break;
  }

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Flexible(
        child: Text(
          left,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),

      const SizedBox(width: 6),

      Icon(
        arrowIcon,
        color: Colors.white70,
        size: 22, // gleiche Größe wie in der FahrtenCard
      ),

      const SizedBox(width: 6),

      Flexible(
        child: Text(
          right,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}



  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titel + Status Badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    fahrt.eventName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(anfrage.status).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _statusText(anfrage.status),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Strecke (neuer schöner Pfeil zwischen Start/Ziel)
            _buildRouteRow(context),

            const SizedBox(height: 6),

            // Zeit rechts (bleibt wie gehabt) — in einer Row mit Icon
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.amberAccent),
                const SizedBox(width: 6),
                Text(
                  fahrt.uhrzeit.format(context),
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Deine angefragten / akzeptierten Plätze
            Row(
              children: [
                const Icon(Icons.event_seat, size: 16, color: Colors.redAccent),
                const SizedBox(width: 6),

                Builder(
                  builder: (context) {
                    final accepted = anfrage.seatsAccepted;

                    if (anfrage.status == AnfrageStatus.akzeptiert) {
                      if (accepted != null) {
                        // z. B. "2 von 3 Plätzen akzeptiert"
                        return Text(
                          "$accepted von ${anfrage.seatsRequested} Platz"
                          "${anfrage.seatsRequested > 1 ? "en" : ""} akzeptiert",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      } else {
                        // Fallback für alte Daten ohne seatsAccepted
                        return Text(
                          "${anfrage.seatsRequested} Platz"
                          "${anfrage.seatsRequested > 1 ? "e" : ""} akzeptiert",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }
                    }

                    // Status: offen oder abgelehnt → nur "angefragt"
                    return Text(
                      "${anfrage.seatsRequested} Platz"
                      "${anfrage.seatsRequested > 1 ? "e" : ""} angefragt",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    );
                  },
                ),
              ],
            ),

            if (anfrage.message != null &&
                anfrage.message!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                "Deine Nachricht:",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                anfrage.message!,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Card für Anfragen, deren Fahrt gelöscht wurde
class _RequestedRideDeletedCard extends StatelessWidget {
  final AnfrageDaten anfrage;

  const _RequestedRideDeletedCard({required this.anfrage});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.report_gmailerrorred,
                  color: Colors.redAccent,
                  size: 22,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Fahrt wurde gelöscht",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "Der Fahrer hat diese Fahrt entfernt. "
              "Deine Mitfahranfrage ist damit nicht mehr gültig.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.event_seat,
                  size: 16,
                  color: Colors.redAccent,
                ),
                const SizedBox(width: 6),
                Text(
                  "${anfrage.seatsRequested} Platz"
                  "${anfrage.seatsRequested > 1 ? "e" : ""} waren angefragt",
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
