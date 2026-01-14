import 'package:flutter/foundation.dart';
import 'package:my_app/data/fahrt_daten.dart';

class UiOverlayState extends ChangeNotifier {
  String? _activeChatConversationId;
  String? _activeChatUserName;

  bool get isChatOpen => _activeChatConversationId != null;

  String? get conversationId => _activeChatConversationId;
  String? get otherUserName => _activeChatUserName;

  void openChat({
    required String conversationId,
    required String otherUserName,
  }) {
    _activeChatConversationId = conversationId;
    _activeChatUserName = otherUserName;
    notifyListeners();
  }

  void closeChat() {
    _activeChatConversationId = null;
    _activeChatUserName = null;
    notifyListeners();
  }
  FahrtDaten? _activeFahrtAnfragen;

  bool get isFahrtAnfragenOpen => _activeFahrtAnfragen != null;
  FahrtDaten? get activeFahrt => _activeFahrtAnfragen;

  void openFahrtAnfragen(FahrtDaten fahrt) {
    _activeFahrtAnfragen = fahrt;
    notifyListeners();
  }

  void closeFahrtAnfragen() {
    _activeFahrtAnfragen = null;
    notifyListeners();
  }


}
