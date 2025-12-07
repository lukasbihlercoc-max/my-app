// fahrt_daten.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'fahrt_daten.g.dart';

@HiveType(typeId: 1)
enum Fahrtrichtung {
  @HiveField(0)
  hinfahrt,
  @HiveField(1)
  rueckfahrt,
  @HiveField(2)
  hinUndZurueck,
}

@HiveType(typeId: 2)
class FahrtDaten {
  @HiveField(0)
  final String eventId;

  @HiveField(1)
  final String eventName;

  @HiveField(2)
  final String standort;

  @HiveField(3)
  final String abfahrtsort;

  @HiveField(4)
  final int uhrzeitHour;

  @HiveField(5)
  final int uhrzeitMinute;

  @HiveField(6)
  final int? rueckuhrzeitHour;

  @HiveField(7)
  final int? rueckuhrzeitMinute;

  @HiveField(8)
  final int freiePlaetze;

  @HiveField(9)
  final Fahrtrichtung richtung;

  @HiveField(10)
  final String ownerId;

  @HiveField(11)
  final String ownerName;

  // Neu: eindeutige ID für Update/Lookup
  @HiveField(12)
  final String id;

  FahrtDaten({
    required this.eventId,
    required this.eventName,
    required this.standort,
    required this.abfahrtsort,
    required this.uhrzeitHour,
    required this.uhrzeitMinute,
    required this.rueckuhrzeitHour,
    required this.rueckuhrzeitMinute,
    required this.freiePlaetze,
    required this.richtung,
    required this.ownerId,
    required this.ownerName,
    required this.id,
  });

  factory FahrtDaten.fromTimeOfDay({
    required String eventId,
    required String eventName,
    required String standort,
    required String abfahrtsort,
    required TimeOfDay uhrzeit,
    TimeOfDay? rueckuhrzeit,
    required int freiePlaetze,
    required Fahrtrichtung richtung,
    required String ownerId,
    required String ownerName,
    String? id,
  }) {
    return FahrtDaten(
      eventId: eventId,
      eventName: eventName,
      standort: standort,
      abfahrtsort: abfahrtsort,
      uhrzeitHour: uhrzeit.hour,
      uhrzeitMinute: uhrzeit.minute,
      rueckuhrzeitHour: rueckuhrzeit?.hour,
      rueckuhrzeitMinute: rueckuhrzeit?.minute,
      freiePlaetze: freiePlaetze,
      richtung: richtung,
      ownerId: ownerId,
      ownerName: ownerName,
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
    );
    
  }

  TimeOfDay get uhrzeit => TimeOfDay(hour: uhrzeitHour, minute: uhrzeitMinute);

  TimeOfDay? get rueckuhrzeit {
    if (rueckuhrzeitHour == null || rueckuhrzeitMinute == null) return null;
    return TimeOfDay(hour: rueckuhrzeitHour!, minute: rueckuhrzeitMinute!);
  }

  // kompatible Getter (falls im Projekt ältere Namen genutzt werden)
  String get startOrt => abfahrtsort;
  String get zielOrt => standort;
  int get plaetze => freiePlaetze;
  String get anbieter => ownerName;
  String get stabileId => eventId;
    FahrtDaten copyWith({
    String? eventId,
    String? eventName,
    String? standort,
    String? abfahrtsort,
    int? uhrzeitHour,
    int? uhrzeitMinute,
    int? rueckuhrzeitHour,
    int? rueckuhrzeitMinute,
    int? freiePlaetze,
    Fahrtrichtung? richtung,
    String? ownerId,
    String? ownerName,
    String? id,
  }) {
    return FahrtDaten(
      eventId: eventId ?? this.eventId,
      eventName: eventName ?? this.eventName,
      standort: standort ?? this.standort,
      abfahrtsort: abfahrtsort ?? this.abfahrtsort,
      uhrzeitHour: uhrzeitHour ?? this.uhrzeitHour,
      uhrzeitMinute: uhrzeitMinute ?? this.uhrzeitMinute,
      rueckuhrzeitHour: rueckuhrzeitHour ?? this.rueckuhrzeitHour,
      rueckuhrzeitMinute: rueckuhrzeitMinute ?? this.rueckuhrzeitMinute,
      freiePlaetze: freiePlaetze ?? this.freiePlaetze,
      richtung: richtung ?? this.richtung,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      id: id ?? this.id,
    );
  }

}