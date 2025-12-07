// meine_fahrten_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/data/fahrt_service.dart';
import 'package:my_app/data/user_service.dart';
import 'package:my_app/views/widgets/background_widget.dart';
import 'package:my_app/views/widgets/fahrtencard_widget.dart';
import 'dart:ui'; // Für ImageFilter.blur

class MeineFahrtenPage extends StatelessWidget {
  const MeineFahrtenPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = UserService().getCurrentUser();
    final userId = userData['id']!;

    return Stack(
      children: [
        // 🔧 Hintergrundverlauf (EXAKT wie in FahrtFindenPage)
        AppBackground(child: Container()),
        Container(color: Colors.black.withOpacity(0.4)),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(color: Colors.transparent),
        ),

        // 🔧 Scaffold OHNE AppBar (EXAKT wie in FahrtFindenPage)
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Consumer<FahrtService>(
            builder: (context, fahrtService, child) {
              final meineFahrten = fahrtService.getFahrtenByUser(userId);

              return meineFahrten.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_car_filled_outlined,
                            size: 64,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Noch keine Fahrten erstellt",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      // 🟡 URSPRÜNGLICHES PADDING WIE IN FAHRTFINDENPAGE
                      padding: const EdgeInsets.only(bottom: 120), // 🆕 Genug Platz für NavBar
                      itemCount: meineFahrten.length,
                      itemBuilder: (context, index) {
                        final fahrt = meineFahrten[index];
                        return FahrtenCard(
                          fahrt: fahrt,
                          isEditable: true, // Zeigt "Bearbeiten" Button
                          ); 
                      },
                    );
            },
          ),
        ),
      ],
    );
  }
}