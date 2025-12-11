//anfrage_service.dart
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:my_app/data/anfrage_daten.dart';
import 'package:my_app/data/fahrt_daten.dart';
import 'package:my_app/data/fahrt_service.dart';

class AnfrageService with ChangeNotifier {
  static final AnfrageService _instance = AnfrageService._internal();
  factory AnfrageService() => _instance;

  AnfrageService._internal() {
    _init();
  }

  late Box<AnfrageDaten> _anfragenBox;
  final List<AnfrageDaten> _alleAnfragen = [];

  List<AnfrageDaten> get alleAnfragen => List.unmodifiable(_alleAnfragen);

  Future<void> _init() async {
    _anfragenBox = Hive.box<AnfrageDaten>('anfragen');
    _loadAnfragen();
  }

  void _loadAnfragen() {
    _alleAnfragen
      ..clear()
      ..addAll(_anfragenBox.values);
    notifyListeners();
  }

  // -------------------------------------------------------------
  // CRUD
  // -------------------------------------------------------------

  Future<void> addAnfrage(AnfrageDaten anfrage) async {
    await _anfragenBox.add(anfrage);
    _loadAnfragen();

    if (kDebugMode) {
      print("📨 Neue Anfrage gespeichert: ${anfrage.id}");
      print("  -> Gesamtanzahl: ${_alleAnfragen.length}");
    }
  }

  Future<void> updateAnfrage(String id, AnfrageDaten updated) async {
    try {
      final map = _anfragenBox.toMap(); // key -> AnfrageDaten
      final entry = map.entries.firstWhere((e) => e.value.id == id);

      await _anfragenBox.put(entry.key, updated);
      _loadAnfragen();

      if (kDebugMode) {
        print("🔄 Anfrage mit ID $id aktualisiert");
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ updateAnfrage: Anfrage nicht gefunden ($id). Error: $e");
      }
    }
  }

  // -------------------------------------------------------------
  // FILTER-FUNKTIONEN
  // -------------------------------------------------------------

  /// Alle Anfragen zu einer bestimmten Fahrt
  List<AnfrageDaten> getAnfragenForFahrt(String fahrtId) {
    return _alleAnfragen.where((a) => a.fahrtId == fahrtId).toList();
  }

  /// Alle Anfragen, die ein bestimmter Fahrer erhalten hat
  /// (weil `fahrtOwnerId` direkt in AnfrageDaten gespeichert wird)
  List<AnfrageDaten> getAnfragenForFahrer(String fahrerId) {
    return _alleAnfragen.where((a) => a.fahrtOwnerId == fahrerId).toList();
  }

  /// Alle Anfragen, die EIN User gestellt hat
  List<AnfrageDaten> getAnfragenByRequester(String requesterId) {
    return _alleAnfragen.where((a) => a.requesterId == requesterId).toList();
  }

  // -------------------------------------------------------------
  // STATUS-HILFSMETHODEN: akzeptieren / ablehnen
  // -------------------------------------------------------------

  Future<void> akzeptiereAnfrage(AnfrageDaten anfrage, int seatsAccepted) async {
  final updated = anfrage.copyWith(
    status: AnfrageStatus.akzeptiert,
    seatsAccepted: seatsAccepted, // 🔥 hier merken wir es
  );
  await updateAnfrage(anfrage.id, updated);

  if (kDebugMode) {
    print("✅ Anfrage ${anfrage.id} akzeptiert mit $seatsAccepted Platz/Plätzen");
  }
}


  Future<void> ablehnenAnfrage(AnfrageDaten anfrage) async {
    final updated = anfrage.copyWith(status: AnfrageStatus.abgelehnt);
    await updateAnfrage(anfrage.id, updated);
  }

  // -------------------------------------------------------------
  // LÖSCHEN
  // -------------------------------------------------------------
   Future<void> cancelAnfragenForFahrt(String fahrtId) async {
    // Kopie der aktuellen Anfragen, damit wir während des Loopens gefahrlos updaten können
    final relevant = _alleAnfragen
        .where((a) => a.fahrtId == fahrtId)
        .toList();

    for (final a in relevant) {
      final updated = a.copyWith(status: AnfrageStatus.abgelehnt);
      await updateAnfrage(a.id, updated);
    }

    if (kDebugMode) {
      print("🚫 Alle Anfragen für Fahrt $fahrtId wurden auf 'abgelehnt' gesetzt");
    }
  }

}
