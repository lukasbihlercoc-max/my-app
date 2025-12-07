// anfrage_daten.dart
import 'package:hive/hive.dart';

part 'anfrage_daten.g.dart';

@HiveType(typeId: 3)
enum AnfrageStatus {
  @HiveField(0)
  offen,
  @HiveField(1)
  akzeptiert,
  @HiveField(2)
  abgelehnt,
}

@HiveType(typeId: 4)
class AnfrageDaten {
  @HiveField(0)
  final String id;          // eindeutige ID der Anfrage

  @HiveField(1)
  final String fahrtId;     // Verweis auf FahrtDaten.id

  @HiveField(2)
  final String eventId;     // optional, für schnellen Bezug

  @HiveField(3)
  final String requesterId; // User, der MITFAHREN möchte

  @HiveField(4)
  final String requesterName;

  @HiveField(5)
  final int seatsRequested;

  @HiveField(6)
  final AnfrageStatus status;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final String? message;

  @HiveField(9)
  final String fahrtOwnerId; // 🔥 Fahrer der Fahrt

  AnfrageDaten({
    required this.id,
    required this.fahrtId,
    required this.eventId,
    required this.requesterId,
    required this.requesterName,
    required this.seatsRequested,
    required this.status,
    required this.createdAt,
    required this.fahrtOwnerId,
    this.message,
  });

  factory AnfrageDaten.create({
    required String fahrtId,
    required String eventId,
    required String requesterId,
    required String requesterName,
    required int seatsRequested,
    required String fahrtOwnerId,
    String? message,
  }) {
    return AnfrageDaten(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fahrtId: fahrtId,
      eventId: eventId,
      requesterId: requesterId,
      requesterName: requesterName,
      seatsRequested: seatsRequested,
      status: AnfrageStatus.offen,
      createdAt: DateTime.now(),
      fahrtOwnerId: fahrtOwnerId,
      message: message,
    );
  }

  AnfrageDaten copyWith({
    AnfrageStatus? status,
  }) {
    return AnfrageDaten(
      id: id,
      fahrtId: fahrtId,
      eventId: eventId,
      requesterId: requesterId,
      requesterName: requesterName,
      seatsRequested: seatsRequested,
      status: status ?? this.status,
      createdAt: createdAt,
      message: message,
      fahrtOwnerId: fahrtOwnerId,
    );
  }
}
