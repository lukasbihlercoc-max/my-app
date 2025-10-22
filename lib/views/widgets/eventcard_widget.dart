import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data/event_daten.dart';
import 'package:my_app/views/pages/detail_page.dart';

String? getBackgroundImage(String typ) {
  switch (typ) {
    case "e1":
      return "assets/image/kirchtag2.jpg";
    case "e2":
      return "assets/image/feuerwehr.png";
    case "e3":
      return "assets/image/disco.png";
    case "e4":
      return "assets/image/Ball.png";
    case "e5":
      return "assets/image/krampus.jpg";
    default:
      return "assets/image/leer.jpg";
  }
}

//? Hintergrundhelligkeit anpassen
double hintergrundHelligkeit(String typ)  {
  switch (typ)  {
    case "e5":
      return 0.69;
    default:
      return 0.5;
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final backgroundImage =
        getBackgroundImage(event.typ) ?? "assets/image/default.jpg";

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ), 
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Hintergrundbild-Container
            Positioned.fill( // Füllt den gesamten verfügbaren Raum
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(backgroundImage),
                    fit: BoxFit.cover,
                    alignment: Alignment(0.1, 0.2),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            // 🔧 Halbtransparenter Overlay für Inhalte
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(hintergrundHelligkeit(event.typ)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12, // Mehr vertikales Padding für besseren Abstand
                ),
                title: Hero(
                  tag: event.stabileId,
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      event.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.date_range,
                          color: Colors.amberAccent,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            DateFormat('E dd.MM.yyyy', 'de_DE').format(event.datum),
                            style: const TextStyle(
                              color: Color.fromARGB(232, 255, 255, 255),
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.redAccent,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            event.standort,
                            style: const TextStyle(
                              color: Color.fromARGB(232, 255, 255, 255),
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.white70,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailPage(event: event)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}