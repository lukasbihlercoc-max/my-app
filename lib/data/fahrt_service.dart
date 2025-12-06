// ...existing imports...
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:my_app/data/fahrt_daten.dart';

class FahrtService with ChangeNotifier {
  static final FahrtService _instance = FahrtService._internal();
  factory FahrtService() => _instance;

  FahrtService._internal() {
    _init();
  }

  late Box<FahrtDaten> _fahrtenBox;
  final List<FahrtDaten> _alleFahrten = [];

  List<FahrtDaten> get alleFahrten => List.from(_alleFahrten);

  Future<void> _init() async {
    _fahrtenBox = Hive.box<FahrtDaten>('fahrten');
    _loadFahrten();
  }

  void _loadFahrten() {
    _alleFahrten.clear();
    _alleFahrten.addAll(_fahrtenBox.values);
    notifyListeners();
  }

  Future<void> addFahrt(FahrtDaten fahrt) async {
    await _fahrtenBox.add(fahrt);
    _loadFahrten();
    if (kDebugMode) print("Fahrt hinzugefügt! Gesamte Fahrten: ${_alleFahrten.length}");
  }

  Future<void> updateFahrt(String id, FahrtDaten updated) async {
    try {
      final map = _fahrtenBox.toMap();
      final entry = map.entries.firstWhere((e) => e.value.id == id);
      await _fahrtenBox.put(entry.key, updated);
      _loadFahrten();
      if (kDebugMode) print('Fahrt mit id=$id aktualisiert');
    } catch (e) {
      if (kDebugMode) print('updateFahrt: Eintrag mit id=$id nicht gefunden: $e');
      // optional: fallback - kein throw, nur log
    }
  }

  List<FahrtDaten> getFahrtenByUser(String userId) => _alleFahrten.where((f) => f.ownerId == userId).toList();
  List<FahrtDaten> getFahrtenByEvent(String eventId) => _alleFahrten.where((f) => f.eventId == eventId).toList();
}