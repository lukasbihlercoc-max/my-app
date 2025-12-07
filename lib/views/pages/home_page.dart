import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_app/data/event_daten.dart';
import 'package:my_app/data/notifiers.dart';
import 'package:my_app/views/widgets/background_widget.dart';
import 'package:my_app/views/widgets/sizehelper_widget.dart';
import 'package:my_app/views/widgets/suchleiste_widget.dart';
import 'package:my_app/views/widgets/eventcard_widget.dart';
import 'package:my_app/data/user_service.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = TextEditingController();
  String? _homeTown; // 🔹 gespeicherter Wohnort

  @override
  void initState() {
    super.initState();
    ladeEventsAusHive(); //!Events beim Start laden
    _loadHomeTown(); // 🔹 Wohnort laden
  }

  Future<void> _loadHomeTown() async {
    final town = await UserService().getHomeTown();
    if (!mounted) return;
    setState(() {
      _homeTown = town;
    });
  }

  Future<void> ladeEventsAusHive() async {
    final box = Hive.box<Event>("events");
    final alleEvents = box.values.toList();
    alleEvents.sort((a, b) => a.datum.compareTo(b.datum));
    eventListNotifier.value = alleEvents;
  }

  Future<void> reloadEvents() async {
    final box = Hive.box<Event>('events');
    final aktualisiert = box.values.toList();
    aktualisiert.sort((a, b) => a.datum.compareTo(b.datum));
    eventListNotifier.value = aktualisiert;
  }

  Widget _buildRadiusFilterRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: SizeHelper.h(context, 0.01),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildRadiusChip(context, null, "Alle"),
            SizedBox(width: 8),
            _buildRadiusChip(context, 10, "10 km"),
            SizedBox(width: 8),
            _buildRadiusChip(context, 20, "20 km"),
            SizedBox(width: 8),
            _buildRadiusChip(context, 50, "50 km"),
          ],
        ),
      ),
    );
  }

  Widget _buildRadiusChip(BuildContext context, int? value, String label) {
    final selected = selectedRadiusNotifier.value == value;

    return ChoiceChip(
      label: Text(label, style: const TextStyle(color: Colors.white)),
      selected: selected,
      onSelected: (_) {
        selectedRadiusNotifier.value = value;
      },
      selectedColor: Colors.blueAccent.withOpacity(0.8),
      backgroundColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: selected ? Colors.blueAccent : Colors.white24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: RefreshIndicator(
          onRefresh: () async {
            await reloadEvents(); // ✅ Jetzt wird sie wirklich aufgerufen
            controller.clear(); // ✅ Textfeld leeren
            searchTextNotifier.value = ''; // ✅ Filter zurücksetzen
          },
          child: ValueListenableBuilder<String>(
            valueListenable: searchTextNotifier,
            builder: (context, searchText, _) {
              return ValueListenableBuilder<List<Event>>(
                valueListenable: eventListNotifier,
                builder: (context, events, _) {
                  return ValueListenableBuilder<int?>(
                    valueListenable: selectedRadiusNotifier,
                    builder: (context, selectedRadius, _) {
                      final query = searchText.toLowerCase();

                      // 🔹 Textsuche
                      var filteredEvents = events.where((event) {
                        return event.name.toLowerCase().contains(query) ||
                            event.standort.toLowerCase().contains(query) ||
                            event.typ.toLowerCase().contains(query);
                      }).toList();

                      // 🔹 Radius-Filter (Platzhalter: gleicher Ort = "im Umkreis")
                      if (selectedRadius != null &&
                          _homeTown != null &&
                          _homeTown!.trim().isNotEmpty) {
                        final townLower = _homeTown!.toLowerCase().trim();
                        filteredEvents = filteredEvents.where((event) {
                          return event.standort.toLowerCase().trim() ==
                              townLower;
                        }).toList();
                      }

                      return CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: SizeHelper.h(context, 0.015),
                            ), // *12
                          ),
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: SearchBarDelegate(controller: controller),
                          ),
                          // 🔹 NEU: Radius-Filter-Row
                          SliverToBoxAdapter(
                            child: _buildRadiusFilterRow(context),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) =>
                                  EventCard(event: filteredEvents[index]),
                              childCount: filteredEvents.length,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: SizeHelper.h(context, 0.13),
                            ), // *100
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
