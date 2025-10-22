//!gelöscht aus homepage
/*child: Card(
  color: Colors.grey.shade900,
  //color: const Color.fromARGB(191, 33, 146, 221).withOpacity(0.2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 4,
    child: ListTile(
    title: Text(
    event.name,
    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    subtitle: Text(
    "${DateFormat.yMMMd('de_DE').format(event.datum)}\n${event.info}",
    style: const TextStyle(height: 1.5, color: Colors.white70),
    ),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white,),
    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => DetailPage(event: event)),
    );
    },
    ),
    ),

//!NavBar
//! Diese Seite navigiert duch die App;

import 'package:flutter/material.dart';
import 'package:my_app/data/notifiers.dart';
import 'dart:ui';

class NavBarWidget extends StatelessWidget {
  const NavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.15),    //!FARBEN
                  //!color: Theme.of(context).colorScheme.surface -> braucht man für hell/dunkel Modus
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),   //!
                      //color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.white.withOpacity(0.4)), //!
                ),
                child: BottomNavigationBarTheme(
                  data: BottomNavigationBarThemeData(
                    selectedIconTheme: IconThemeData(size: 36),
                    unselectedIconTheme: IconThemeData(size: 30),
                    selectedLabelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: TextStyle(fontSize: 15),
                  ),
                  child: BottomNavigationBar(
                    showSelectedLabels: true,
                    showUnselectedLabels: false,
                    currentIndex: selectedPage,
                    onTap: (index) => selectedPageNotifier.value = index,
                    selectedItemColor: Colors.lightBlueAccent,        //!Farben
                    unselectedItemColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    //backgroundColor: Colors.white.withOpacity(0.1),
                    elevation: 10,
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.celebration_outlined),
                        label: "Events",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.directions_car),
                        label: "Fahrten",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: "Profil",
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
  }
}


//!suchleiste
import 'package:flutter/material.dart';

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
  decoration: BoxDecoration(
    color: Colors.black.withOpacity(0.6), // ✅ kräftiger Kontrast
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.4),
        blurRadius: 8,
        offset: Offset(0, 3),
      ),
    ],
    border: Border.all(color: Colors.white24), // ✅ feiner Rahmen
  ),
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: TextField(
    decoration: InputDecoration(
      hintText: "Event suchen...",
      prefixIcon: const Icon(Icons.search, color: Colors.white70),
      filled: true,
      fillColor: Colors.transparent, // kein doppelter Hintergrund
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: Colors.white70),
    ),
    style: const TextStyle(color: Colors.white),
    onChanged: (query) {
      // Filterlogik hier
    },
  ),
);
  }

  @override
  double get maxExtent => 60;
  @override
  double get minExtent => 60;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}



*/

//!Eventcards:
/*
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
      return 0.65;
    default:
      return 0.45;
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
        vertical: 12,    //! Abstand (8)
      ), 
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover,
                  alignment: Alignment(0.1, 0.2),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
*/
            // 🔧 Halbtransparenter Overlay für Inhalte
/*
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(hintergrundHelligkeit(event.typ)),    //!hintergrund dunkler machen
                borderRadius: BorderRadius.circular(16),
              ),

              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                title: Hero(
                  tag: event.id,
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
                    const SizedBox(height: 6),     //?Abstand titel -> Datum
*/
//                    Row(    //*Datum

/*                      children: [
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

                  const SizedBox(height: 6),      //?Abstand Datum -> Standort
*/
 //                   Row(     //*Standort
 /*                     children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.redAccent,  //! 📍 Rotes Stecknadel-Icon
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
}*/

//!settings
import 'package:flutter/material.dart';
import 'package:my_app/views/widgets/background_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key, 
    required this.title,
    });

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  bool? isCheckt = false;
  bool? isCheckt2 = false;
  bool isSwitched = false;
  double slider = 0.0;
  String? menuItem = "e1";
  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(widget.title),      //! widget. muss nur bei stateful
          leading: BackButton(                  //? manuellen zurückpfeil
            onPressed: () {
              Navigator.pop(context);           //? schließt die darüberliegende seite wieder
            },
          ),
          automaticallyImplyLeading: false,    //automatischen zurückpfeil ausblenden
        ),
        body: SingleChildScrollView(      //! um auf der Seite zu Scrollen
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, //standermäßig auf die rechte seite
              children: [
                DropdownButton(
                  value: menuItem,
                  items: [
                    DropdownMenuItem(value: "e1", child: Text("Element1")),
                    DropdownMenuItem(value: "e2", child: Text("Element2")),
                    DropdownMenuItem(value: "e3", child: Text("Element3")),
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      menuItem = value;
                    });
                  },
                ),
      
                TextField(
                  controller: controller,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                Text(controller.text),
                SizedBox(height: 40),
                TextField(
                  controller: controller2,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  onEditingComplete: () => setState(() {}),
                ),
                Text(controller2.text),
                Checkbox(
                  //tristate: true,        //alle kästchen belegen bzw 3zustände belegbar
                  value: isCheckt,
                  onChanged: (bool? value) {
                    setState(() {
                      isCheckt = value;
                    });
                  },
                ),
                CheckboxListTile.adaptive(
                  //tristate: true,         //alle kästchen belegen bzw 3zustände belegbar
                  title: Text("Hast du einen Führerschein?"),
                  value: isCheckt2,
                  onChanged: (value) {
                    setState(() {
                      isCheckt2 = value;
                    });
                  },
                ),
                Switch(
                  value: isSwitched,
                  onChanged: (bool value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                ),
                SwitchListTile.adaptive(
                  title: Text("Switch"),
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                ),
                Slider(
                  max: 10.0,
                  divisions: 10,
                  value: slider,
                  onChanged: (value) {
                    setState(() {
                      slider = value;
                    });
                    print(value);
                  },
                ),
                //GestureDetector(  oder:
                InkWell(
                  splashColor: Colors.amber,
                  onTap: () {
                    print("Image selected");
                  },
                  //child: Image.asset("assets/image/hg5.jpg"),),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    color: Colors.white12,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Drücken"),
                ),
                ElevatedButton(onPressed: () {}, child: Text("ElevatedButton")),
                FilledButton(onPressed: () {}, child: Text("FilledButton")),
                TextButton(onPressed: () {}, child: Text("TextButton")),
                OutlinedButton(onPressed: () {}, child: Text("OutlinedButton")),
                CloseButton(),
                BackButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
