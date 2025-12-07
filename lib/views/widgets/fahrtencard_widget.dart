// fahrtencard_widget.dart
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

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data/event_daten.dart';

import 'dart:ui'; // 🔥 NEU für BackdropFilter / Blur


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
    // 🆕 Anzahl offener Anfragen für diese Fahrt
    final offeneAnfragenCount = context
        .watch<AnfrageService>()
        .getAnfragenForFahrt(fahrt.id)
        .where((a) => a.status == AnfrageStatus.offen)
        .length;
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
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.chat_bubble_outline,
                                  color: Colors.white,
                                  size: 30,
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

                              // 🆕 Badge nur anzeigen, wenn es offene Anfragen gibt
                              if (offeneAnfragenCount > 0)
                                Positioned(
                                  right: 4,
                                  top: 4,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.4),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: Center(
                                      child: Text(
                                        offeneAnfragenCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),

                      ],
                    ),
                    // 🔹 Eventname + Datum (anklickbar)
// 🔹 Eventname + Datum (anklickbar, Datum wird über Event geladen)
GestureDetector(
  onTap: () => _showEventDetailsPopup(context),
  child: Padding(
    padding: const EdgeInsets.only(top: 6, bottom: 6),
    child: Row(
      children: [
        const Icon(
          Icons.event,
          color: Colors.white70,
          size: 18,
        ),
        const SizedBox(width: 6),

        Expanded(
          child: Builder(
            builder: (context) {
              // 🔥 Event über die eventId aus Hive laden
              final eventBox = Hive.box<Event>("events");
              final event = eventBox.values.firstWhere(
                (e) => e.id == fahrt.eventId,
                orElse: () => Event(
                  name: fahrt.eventName,
                  datum: DateTime(2000),
                  standort: fahrt.standort,
                  beschreibung: "",
                  typ: "",
                  adresse: "",
                ),
              );

              final dateText = event.datum.year == 2000
                  ? ""
                  : " (${DateFormat('dd.MM.yy').format(event.datum)})";

              return Text(
                "${fahrt.eventName}$dateText",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
        ),
      ],
    ),
  ),
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

  void _showEventDetailsPopup(BuildContext context) {
  final eventBox = Hive.box<Event>("events");
  final event = eventBox.values.firstWhere(
    (e) => e.id == fahrt.eventId,
    orElse: () => Event(
      name: fahrt.eventName,
      datum: DateTime(2000),
      standort: fahrt.standort,
      beschreibung: "",
      typ: "",
      adresse: "",
    ),
  );

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      final size = MediaQuery.of(ctx).size;

      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
            child: Container(
              width: size.width * 0.85,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      const Icon(Icons.event, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Datum
                  if (event.datum.year != 2000)
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            color: Colors.white70, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          DateFormat("dd.MM.yyyy").format(event.datum),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 12),

                  // Standort
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.place,
                          color: Colors.white70, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event.standort,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(
                            color: Colors.white70,
                            thickness: 1,
                            height: 12, // 32px
                          ),

                  const SizedBox(height: 12),

                  // Beschreibung
                  if (event.beschreibung.trim().isNotEmpty)
                    Text(
                      event.beschreibung,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Schließen",
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}


  //! Mitfahr-Fenster

 void _handleMitfahren(BuildContext context) async {
  final user = UserService().getCurrentUser();
  final seatsController = TextEditingController(text: '1');
  final messageController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final maxSeats = fahrt.freiePlaetze;

  final confirmed = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      final size = MediaQuery.of(ctx).size;

      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
            child: Container(
              width: size.width * 0.85,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              constraints: BoxConstraints(
                minHeight: size.height * 0.40,
                maxHeight: size.height * 0.75,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Header mit Eventname & Standort
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Mitfahranfrage senden",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                fahrt.eventName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                fahrt.standort,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white38,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // 🔹 Plätze
                    const Text(
                      "Plätze",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextFormField(
                      controller: seatsController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Anzahl der Plätze",
                        hintStyle: TextStyle(color: Colors.white38),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlueAccent),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Bitte Anzahl der Plätze eingeben';
                        }
                        final n = int.tryParse(value.trim());
                        if (n == null || n <= 0) {
                          return 'Bitte eine gültige Zahl eingeben';
                        }
                        if (n > maxSeats) {
                          return 'Nur $maxSeats Platz'
                              '${maxSeats == 1 ? "" : "e"} verfügbar';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Max. $maxSeats Plätze verfügbar",
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 🔹 Nachricht (optional)
                    const Text(
                      "Nachricht (optional)",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: messageController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 3,
                      minLines: 3,
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        hintText: "z. B. Treffpunkt oder Wunschzeit",
                        hintStyle: TextStyle(color: Colors.white38),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlueAccent),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔹 Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text(
                            "Abbrechen",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              Navigator.pop(ctx, true);
                            }
                          },
                          child: const Text(
                            "Senden",
                            style: TextStyle(
                              color: Colors.lightBlueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  if (confirmed != true) return;

  final seats = int.parse(seatsController.text.trim());

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

  await AnfrageService().addAnfrage(anfrage);

  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Anfrage wurde gesendet")),
  );
}
  


}
