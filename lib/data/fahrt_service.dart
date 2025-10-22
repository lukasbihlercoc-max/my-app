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
    _loadFahrten(); // Neu laden um die ID zu aktualisieren
    print("Fahrt hinzugefügt! Gesamte Fahrten: ${_alleFahrten.length}");
  }

  List<FahrtDaten> getFahrtenByUser(String userId) {
    return _alleFahrten.where((fahrt) => fahrt.ownerId == userId).toList();
  }

  List<FahrtDaten> getFahrtenByEvent(String eventId) {
    return _alleFahrten.where((fahrt) => fahrt.eventId == eventId).toList();
  }
}