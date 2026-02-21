import 'package:flutter/foundation.dart';

class UserProfile {
  static final ValueNotifier<String> name = ValueNotifier<String>('Guest');

  static void setName(String newName) {
    name.value = newName.trim().isEmpty ? 'Guest' : newName.trim();
  }
}
