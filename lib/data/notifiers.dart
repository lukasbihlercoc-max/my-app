//ValueNotifier: hold the data
//ValueListenableBuilder: listen to the date (dont need the setState)

import 'package:flutter/material.dart';
import "package:my_app/data/event_daten.dart";

ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);     //? 2.) wir zu 1
ValueNotifier<bool> isDarkModeNotifier = ValueNotifier(true);   //! 2.) wird zu false
ValueNotifier<List<Event>> eventListNotifier = ValueNotifier([]);
final searchTextNotifier = ValueNotifier<String>("");