import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FavoriteLocation {
  final String displayName;
  final String normalizedName; // Thêm normalized name
  final double? latitude;
  final double? longitude;

  const FavoriteLocation({
    required this.displayName,
    required this.normalizedName,
    this.latitude,
    this.longitude,
  });

  bool get hasCoordinates => latitude != null && longitude != null;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'displayName': displayName,
      'normalizedName': normalizedName,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static FavoriteLocation fromMap(Map<String, dynamic> map) {
    return FavoriteLocation(
      displayName: map['displayName'] as String? ?? '',
      normalizedName: map['normalizedName'] as String? ?? map['displayName'] as String? ?? '',
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FavoriteLocation) return false;
    // If coordinates exist, compare by coordinates; otherwise compare by normalizedName
    if (hasCoordinates && other.hasCoordinates) {
      return latitude == other.latitude && longitude == other.longitude;
    }
    return normalizedName.toLowerCase() == other.normalizedName.toLowerCase();
  }

  @override
  int get hashCode => hasCoordinates
      ? Object.hash(latitude, longitude)
      : normalizedName.toLowerCase().hashCode;
}

class FavoritesService {
  static const String _storageKey = 'favorites_locations_v1';
  static const int maxFavorites = 5;

  int getMaxFavorites() => maxFavorites;

  Future<List<FavoriteLocation>> getFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String raw = prefs.getString(_storageKey) ?? '[]';
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list
          .whereType<Map<String, dynamic>>()
          .map(FavoriteLocation.fromMap)
          .toList();
    } catch (_) {
      return <FavoriteLocation>[];
    }
  }

  Future<void> _saveFavorites(List<FavoriteLocation> items) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String raw = jsonEncode(items.map((e) => e.toMap()).toList());
    await prefs.setString(_storageKey, raw);
  }

  Future<List<FavoriteLocation>> addFavorite(FavoriteLocation item) async {
    final List<FavoriteLocation> items = await getFavorites();
    if (!items.contains(item) && items.length < maxFavorites) {
      items.add(item);
      await _saveFavorites(items);
    }
    return items;
  }

  Future<List<FavoriteLocation>> removeFavorite(FavoriteLocation item) async {
    final List<FavoriteLocation> items = await getFavorites();
    items.remove(item);
    await _saveFavorites(items);
    return items;
  }

  Future<bool> isFavorite(FavoriteLocation item) async {
    final List<FavoriteLocation> items = await getFavorites();
    return items.contains(item);
  }
}


