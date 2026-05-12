import 'package:hive_flutter/hive_flutter.dart';

/// [HiveService] manages structured local storage using [Hive].
/// It provides safe box management and typed getters for entities.
class HiveService {
  HiveService._();

  static final HiveService instance = HiveService._();

  // Box names
  static const String userBoxName = 'user_box';
  static const String coursesBoxName = 'courses_box';
  static const String fleetBoxName = 'fleet_box';
  static const String contactBoxName = 'contact_box';

  /// Initializes Hive and registers adapters.
  Future<void> init() async {
    await Hive.initFlutter();
    // Adapters will be registered here after generation
    // Hive.registerAdapter(UserAdapter());
  }

  /// Safely opens a box if it's not already open.
  Future<Box<T>> openBox<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }
    return await Hive.openBox<T>(boxName);
  }

  /// Returns the user box.
  Future<Box> getUserBox() => openBox(userBoxName);

  /// Returns the courses box.
  Future<Box> getCoursesBox() => openBox(coursesBoxName);

  /// Returns the fleet box.
  Future<Box> getFleetBox() => openBox(fleetBoxName);

  /// Returns the contact box.
  Future<Box> getContactBox() => openBox(contactBoxName);

  /// Clears all data from all boxes.
  Future<void> clearAll() async {
    await Hive.deleteFromDisk();
  }
}
