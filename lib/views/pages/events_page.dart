import 'package:flutter/material.dart';
import 'package:my_app/data/event_daten.dart';
import 'package:my_app/data/notifiers.dart';
import 'package:intl/intl.dart';
import 'package:my_app/main.dart';
import 'package:my_app/views/widgets/background_widget.dart';

//! Eingabefelder anpassen
InputDecoration getInputStyle(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(
      color: Colors.white70,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white70,
        width: 2, // ✅ normale Linienstärke
      ),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.deepPurpleAccent,
        width: 4, // ✅ dickere Linie beim Fokus
      ),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    contentPadding: const EdgeInsets.symmetric(
      vertical: 20,
      horizontal: 16,
    ), // ✅ mehr Platz im Feld
    hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
  );
}

//! Eingabeschrift anpassen
const inputTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 20,
  fontWeight: FontWeight.w600,
);

class EventsPage extends StatefulWidget {
  
  final Event? event;             //!optionales Event bearbeiten
  const EventsPage({super.key, required this.event});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final NameController = TextEditingController();
  final standortController = TextEditingController();
  final datumController = TextEditingController();
  String? typ = "e0";
  final beschreibungController = TextEditingController();
  final adresseController = TextEditingController();


  @override
  void initState()  {
    super.initState();

    if(widget.event  != null) {
      NameController.text = widget.event!.name;
      standortController.text = widget.event!.standort;
      datumController.text = DateFormat("dd.MM.yyyy").format(widget.event!.datum);
      typ = widget.event!.typ;
      beschreibungController.text = widget.event!.beschreibung;
      adresseController.text = widget.event!.adresse;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Neues Event erstellen"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // ✅ Korrigiert: const EdgeInsets.all(16.0)
            child: Column(
              children: [
                TextField(
                  controller: NameController,
                  style: inputTextStyle,
                  decoration: getInputStyle("Eventname"),
                ),
          
                const SizedBox(height: 16),
          
                // Ersetze das TextField für das Datum durch:
TextFormField(
                  controller: datumController,
                  style: inputTextStyle,
                  decoration: getInputStyle("Datum"),
                  readOnly: true, // Verhindert Tastatureingabe
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      locale: const Locale('de', 'DE'),
                    );
                    if (pickedDate != null) {
                      String formattedDate = DateFormat(
                        'dd.MM.yyyy',
                      ).format(pickedDate);
                      setState(() {
                        datumController.text = formattedDate;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitte ein Datum auswählen';
                    }
                    return null;
                  },
                ),
          
                const SizedBox(height: 16),
          
                TextField(
                  controller: standortController,
                  style: inputTextStyle,
                  decoration: getInputStyle("Standort"),
                ),
          
                const SizedBox(height: 16),

                TextField(
                  controller: adresseController,
                  style: inputTextStyle,
                  decoration: getInputStyle("genaue Adresse"),
                ),
          
                const SizedBox(height: 16),
          
                DropdownButton(
                  dropdownColor: Color.fromARGB(164, 9, 61, 216),
                  style: inputTextStyle,
                  value: typ,
                  items: [
                    DropdownMenuItem(value: "e0", child: Text("Standart")),
                    DropdownMenuItem(value: "e1", child: Text("Kirchtag")),
                    DropdownMenuItem(value: "e2", child: Text("Feuerwehrfest")),
                    DropdownMenuItem(value: "e3", child: Text("Disco")),
                    DropdownMenuItem(value: "e4", child: Text("Ball")),
                    DropdownMenuItem(value: "e5", child: Text("Krampuslauf")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      typ = value;
                    });
                  },
                ),
          
                const SizedBox(height: 16),
          
                TextField(
                  controller: beschreibungController,
                  style: inputTextStyle,
                  decoration: getInputStyle("Beschreibung"),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                ),
          
                const SizedBox(height: 20),
          
                FilledButton(
                  onPressed: () async {
                    // Datum validieren BEVOR du versuchst es zu parsen
                    if (datumController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Bitte ein Datum auswählen")),
                      );
                      return; // ✅ Wichtig: Hier returnen!
                    }

                    try {
                      final parsedDate = DateFormat("dd.MM.yyyy").parseStrict(datumController.text);

                      if (widget.event == null) {
                        // ✅ Neues Event erstellen
                        final newEvent = Event(
                          name: NameController.text,
                          datum: parsedDate,
                          standort: standortController.text.isNotEmpty
                            ? standortController.text 
                            : "Unbekannt",
                          typ: typ.toString(),
                          beschreibung: beschreibungController.text,
                          adresse: adresseController.text.trim().isNotEmpty
                            ? adresseController.text.trim()
                            : "Adresse nicht angegeben",
                        );
                    
                        await speichereEvent(newEvent);
                    
                        eventListNotifier.value = [
                          ...eventListNotifier.value,
                          newEvent,
                        ]..sort((a, b) => a.datum.compareTo(b.datum));
                      } else {
                        // ✅ Bestehendes Event bearbeiten
                        widget.event!
                          ..name = NameController.text
                          ..datum = parsedDate
                          ..standort = standortController.text
                          ..typ = typ.toString()
                          ..beschreibung = beschreibungController.text
                          ..adresse = adresseController.text;
                    
                        await widget.event!.save(); // Hive aktualisieren
                    
                        eventListNotifier.value = [
                          ...eventListNotifier.value,
                        ]..sort((a, b) => a.datum.compareTo(b.datum));
                      }
                    
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Ungültiges Datumsformat")),
                      );
                    }
                  },
                  child: Text(widget.event == null ? "Event abspeichern" : "Änderungen speichern"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}