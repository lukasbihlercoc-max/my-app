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

  // 🆕 KONSTRUKTOR OHNE TIMEOFDAY PARAMETER - für Hive
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
  });

  // 🆕 FACTORY KONSTRUKTOR FÜR DIE UI - mit TimeOfDay Parametern
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
    );
  }

  // Getter für TimeOfDay (für die UI)
  TimeOfDay get uhrzeit {
    return TimeOfDay(hour: uhrzeitHour, minute: uhrzeitMinute);
  }

  TimeOfDay? get rueckuhrzeit {
    if (rueckuhrzeitHour == null || rueckuhrzeitMinute == null) return null;
    return TimeOfDay(hour: rueckuhrzeitHour!, minute: rueckuhrzeitMinute!);
  }
}