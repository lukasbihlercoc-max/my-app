// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_app/data/fahrt_daten.dart';
import 'package:my_app/data/notifiers.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_fonts/google_fonts.dart';
// Hive
import 'package:my_app/data/event_daten.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_app/views/widget_tree.dart';
import 'package:my_app/data/anfrage_daten.dart';
import 'package:my_app/data/anfrage_service.dart';


// 🆕 NEUE IMPORTS FÜR PROVIDER
import 'package:provider/provider.dart'; // 🆕 Provider Package
import 'package:my_app/data/fahrt_service.dart'; // 🆕 Unser FahrtService

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // wichtig für async init
  await initializeDateFormatting('de_DE', null); // ✅ Locale-Daten laden

  // 🔧 Hive initialisieren
  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  Hive.registerAdapter(EventAdapter()); // oder EventAdapter, je nach Name
  Hive.registerAdapter(FahrtDatenAdapter());
  Hive.registerAdapter(FahrtrichtungAdapter());
  Hive.registerAdapter(AnfrageStatusAdapter());
  Hive.registerAdapter(AnfrageDatenAdapter());
  
  //await Hive.deleteBoxFromDisk("events"); //! gespeicherte Events LÖSCHEN
  //await Hive.deleteBoxFromDisk("fahrten"); //! gespeicherte Fahrten LÖSCHEN

  await Hive.openBox<Event>('events');
  await Hive.openBox<FahrtDaten>('fahrten');
  await Hive.openBox<AnfrageDaten>('anfragen');

  runApp(const MyApp());
}

Future<void> speichereEvent(Event event) async {
  final box = Hive.box<Event>('events');
  await box.add(event);
}

Future<List<Event>> ladeAlleEvents() async {
  final box = Hive.box<Event>('events');
  return box.values.toList();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // 🆕 MULTIPROVIDER - ERSTER GROSSER ÄNDERUNGSPUNKT
    // Statt direkt ValueListenableBuilder verwenden wir jetzt MultiProvider
    // um mehrere Provider zu verwalten
    return MultiProvider(
      providers: [
        // 🟡 BEREITS EXISTIEREND: Dark Mode Provider (wird umgewandelt)
        // Vorher: ValueListenableBuilder direkt um MaterialApp
        // Jetzt: Als ValueListenableProvider in MultiProvider
        ValueListenableProvider<bool>.value(
          value: isDarkModeNotifier, // Ihr bestehender Dark Mode Notifier
        ),
        
        // 🆕 NEU: FahrtService Provider - ZWEITER GROSSER ÄNDERUNGSPUNKT
        // Dieser Provider macht den FahrtService im gesamten App verfügbar
        ChangeNotifierProvider<FahrtService>(
          create: (context) => FahrtService(), // Erstellt eine Instanz des FahrtService
        ),

        ChangeNotifierProvider<AnfrageService>(
      create: (context) => AnfrageService(),
        ),
        // 🆕 Sie können hier später weitere Provider hinzufügen z.B.:
        // ChangeNotifierProvider<UserService>(create: (context) => UserService()),
        // ChangeNotifierProvider<EventService>(create: (context) => EventService()),
      ],
      
      // 🆕 BUILDER - DRITTER ÄNDERUNGSPUNKT
      // Wir verwenden Builder um auf den Context der Provider zuzugreifen
      child: Builder(
        builder: (context) {
          // 🆕 CONTEXT.WATCH() - VIERTER ÄNDERUNGSPUNKT
          // Statt ValueListenableBuilder verwenden wir jetzt context.watch()
          // um auf Dark Mode Änderungen zu reagieren
          final isDarkMode = context.watch<bool>(); // Überwacht den Dark Mode Provider
          
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              textTheme: GoogleFonts.poppinsTextTheme(
                Theme.of(context).textTheme,
              ),
              colorSchemeSeed: Colors.blueAccent,
              // 🟡 UNVERÄNDERT: Theme basiert weiterhin auf isDarkMode
              brightness: isDarkMode ? Brightness.dark : Brightness.light,
            ),
            home: const WidgetTree(),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('de', 'DE'),
            ],
          );
        },
      ),
    );
  }
}