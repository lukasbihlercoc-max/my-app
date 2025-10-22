import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_app/data/event_daten.dart';
import 'package:my_app/data/notifiers.dart';
import 'package:my_app/views/widgets/background_widget.dart';
import 'package:my_app/views/widgets/sizehelper_widget.dart';
import 'package:my_app/views/widgets/suchleiste_widget.dart';
import 'package:my_app/views/widgets/eventcard_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = TextEditingController();

  @override
  void initState()  {
    super.initState();
    ladeEventsAusHive();    //!Events beim Start laden
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

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: RefreshIndicator(
          onRefresh: () async {
            await reloadEvents(); // ✅ Jetzt wird sie wirklich aufgerufen
            controller.clear();   // ✅ Textfeld leeren
            searchTextNotifier.value = ''; // ✅ Filter zurücksetzen
          },
          child: ValueListenableBuilder(
            valueListenable: searchTextNotifier,
            builder: (context, searchText, _) {
              return ValueListenableBuilder(
                valueListenable: eventListNotifier,
                builder: (context, events, _) {
                  final filteredEvents = events.where((event) {
                    final query = searchText.toLowerCase();
                    return event.name.toLowerCase().contains(query) ||
                           event.standort.toLowerCase().contains(query) ||
                           event.typ.toLowerCase().contains(query);
                  }).toList();

                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(child: SizedBox(height: SizeHelper.h(context, 0.015))),    //*12
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: SearchBarDelegate(controller: controller),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              EventCard(event: filteredEvents[index]),
                          childCount: filteredEvents.length,
                        ),
                      ),
                      SliverToBoxAdapter(child: SizedBox(height: SizeHelper.h(context, 0.13))),   //*100
                    ],
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