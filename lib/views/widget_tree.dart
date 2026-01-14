// widget_tree.dart
import 'package:flutter/material.dart';
import 'package:my_app/data/notifiers.dart';
import 'package:my_app/views/pages/events_page.dart';
import 'package:my_app/views/pages/fahrt_anfragen_page.dart';
import 'package:my_app/views/pages/fahrten_page.dart';
import 'package:my_app/views/pages/home_page.dart';
import 'package:my_app/views/pages/profile_page.dart';
import 'package:my_app/views/pages/settings_page.dart';
import 'package:my_app/views/widgets/appbar_widget.dart';
import 'package:my_app/views/widgets/background_widget.dart';
import 'package:my_app/views/widgets/chat_overlay.dart';
import 'package:my_app/views/widgets/navbar_widget.dart';
import 'package:my_app/views/widgets/ui_overlay_state.dart';

// 🆕 PROVIDER IMPORT HINZUFÜGEN
import 'package:provider/provider.dart';
import 'package:my_app/data/fahrt_service.dart';

class PageInfo {
  final Widget page;
  final String title;

  PageInfo({required this.page, required this.title});
}

final List<PageInfo> pages = [
  PageInfo(page: HomePage(), title: "Veranstaltungen"),
  PageInfo(page: MeineFahrtenPage(), title: "Fahrten"),
  PageInfo(page: ProfilePage(), title: "Profil"),
];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    // 🆕 MULTIPROVIDER FÜR FAHRTSERVICE HINZUFÜGEN
    return MultiProvider(
      providers: [
        // 🟡 BEREITS EXISTIEREND: selectedPageNotifier als ValueListenableProvider
        ValueListenableProvider<int>.value(
          value: selectedPageNotifier,
        ),
      ],
      child: Builder(
        builder: (context) {
          // 🆕 CONTEXT.WATCH FÜR SELECTED PAGE VERWENDEN
          final selectedPage = context.watch<int>();
          
          return Stack(
            children: [
              AppBackground(
                child: Scaffold(
                  extendBody: true,
                  backgroundColor: Colors.transparent,
                  appBar: _buildAppBar(context, selectedPage),
                  body: pages[selectedPage].page,
                ),
              ),

              // 🔥 CHAT OVERLAY
              Consumer<UiOverlayState>(
                builder: (context, ui, _) {
                  if (!ui.isFahrtAnfragenOpen) return const SizedBox.shrink();

                  return Material(
                    color: Colors.black.withOpacity(0.4),
                    child: SafeArea(
                      child: Column(
                        children: [
                          AppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            leading: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => context
                                  .read<UiOverlayState>()
                                  .closeFahrtAnfragen(),
                            ),
                            title: const Text("Anfragen"),
                          ),
                          Expanded(
                            child: FahrtAnfragenPage(fahrt: ui.activeFahrt!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),


              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: NavBarWidget(),
              ),
            ],
          );

        },
      ),
    );
  }

  // 🔥 AppBar-Konfiguration - 🟡 UNVERÄNDERT
  AppBarWidget _buildAppBar(BuildContext context, int selectedPage) {
    switch (selectedPage) {
      case 0: // HomePage
      case 1: // FahrtenPage
        return AppBarWidget(
          title: pages[selectedPage].title,
        );
      
      case 2: // ProfilePage
        return AppBarWidget(
          title: pages[selectedPage].title,
          rightWidget: _buildSettingsButton(context),
        );
      
      default:
        return AppBarWidget(title: pages[selectedPage].title);
    }
  }

  // 🔥 Settings-Button - 🟡 UNVERÄNDERT
  Widget _buildSettingsButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings, size: 20, color: Colors.white),
      onPressed: () {
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => SettingsPage(title: "Einstellungen"),
          ),
        );
      },
    );
  }
}
