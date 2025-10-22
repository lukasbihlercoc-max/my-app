import 'package:flutter/material.dart';
import 'package:my_app/views/pages/login_page.dart';
import 'package:my_app/views/pages/register_page.dart';
import 'package:my_app/views/widgets/background_widget.dart';
import 'package:my_app/data/user_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        
        body: FutureBuilder<bool>(
          future: UserService().isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            final isLoggedIn = snapshot.data ?? false;
            
            if (isLoggedIn) {
              return _buildProfileView();
            } else {
              return _buildLoginOptions(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoginOptions(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: const Text(
              "Mitfahrgelegenheiten sicher nutzen",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Logge dich ein für volle Funktionen\nund mehr Sicherheit",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            icon: const Icon(Icons.login),
            label: const Text("Anmelden"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage()),
              );
            },
            icon: const Icon(Icons.person_add),
            label: const Text("Registrieren"),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          const SizedBox(height: 40),
          
          // Linksbündiger Text mit Sternesystem-Erklärung
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Linksbündig
              children: [
                Text(
                  "Sternesystem für mehr Sicherheit:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("⭐ ", style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Text(
                        "Basis-Verifikation (E-Mail & Telefon)",
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("⭐⭐ ", style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Text(
                        "Profilfoto hinzugefügt",
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("⭐⭐⭐ ", style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Text(
                        "Führerschein verifiziert",
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  "Je mehr Sterne, desto vertrauenswürdiger\ndas Profil für andere Nutzer.",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    // Hier zeigst du das Profil des eingeloggten Users an
    return Center(
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("assets/image/default_avatar.png"),
          ),
          const SizedBox(height: 16),
          const Text(
            "Max Mustermann",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Stern-Anzeige basierend auf Verifikations-Level
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const Icon(Icons.star_border, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Text(
                "2/3 Verifizierungen",
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Weitere Profilinformationen...
        ],
      ),
    );
  }
}