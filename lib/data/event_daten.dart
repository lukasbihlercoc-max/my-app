import 'package:intl/intl.dart';
import 'package:hive/hive.dart';

part 'event_daten.g.dart'; // wird automatisch generiert

@HiveType(typeId: 0)
class Event extends HiveObject {
  @HiveField(0)
  String get stabileId => _generateStabileId();

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime datum;

  @HiveField(3)
  String standort;

  @HiveField(4)
  String typ;

  @HiveField(5)
  String beschreibung;

  @HiveField(6)
  String adresse;
  
  Event({
    required this.name,
    required this.datum,
    required this.standort,
    required this.beschreibung,
    required this.typ,
    required this.adresse,
  });

  String _generateStabileId() {
    final nameNormalized = name.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '-');
    final datumFormatiert = DateFormat('yyyyMMdd').format(datum);
    return '$nameNormalized-$datumFormatiert';
  }
}

  