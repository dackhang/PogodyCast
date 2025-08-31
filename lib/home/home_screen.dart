import 'package:flutter/material.dart';
import 'package:weatherapp_demo/services/weather_service.dart';
import 'package:weatherapp_demo/services/favorites_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:weatherapp_demo/settings/settings_screen.dart';
import 'package:weatherapp_demo/settings/settings_provider.dart';
import 'package:weatherapp_demo/localization/app_localizations.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _weatherService = WeatherService();
  final _favoritesService = FavoritesService();
  final _settingsProvider = SettingsProvider();
  
  // GlobalKey để control RefreshIndicator
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  
  String _cityName = '';
  String _actualCityName = ''; // Tên thành phố thực tế (không phụ thuộc ngôn ngữ)
  bool _isDefaultLocation = false; // Đánh dấu có phải vị trí mặc định không
  double? _currentLat; // Lưu tọa độ hiện tại
  double? _currentLon; // Lưu tọa độ hiện tại
  final TextEditingController _searchController = TextEditingController();
  
  // Timer để cập nhật thời gian thực
  Timer? _timer;
  DateTime _currentTime = DateTime.now();

  // State để theo dõi tab được chọn (0: Today, 1: Tomorrow, 2: Day after tomorrow)
  int _selectedTab = 0;

  Future<Map<String, dynamic>> _weatherFuture = Future.value({});
  Future<List<dynamic>> _hourlyForecastFuture = Future.value([]);
  Future<Map<String, List<dynamic>>> _twoDayForecastFuture = Future.value({});
  Future<Map<String, dynamic>> _aqiFuture = Future.value({});

  @override
  void initState() {
    super.initState();
    _determinePositionAndFetchWeather();
    _startTimer();
    // Đăng ký callback để lắng nghe thay đổi ngôn ngữ
    _settingsProvider.setOnLanguageChangedCallback(_onLanguageChanged);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.dispose();
    // Hủy đăng ký callback
    _settingsProvider.removeOnLanguageChangedCallback();
    super.dispose();
  }

  // Callback được gọi khi ngôn ngữ thay đổi
  void _onLanguageChanged() {
    if (mounted) {
      // Cập nhật tên thành phố hiển thị
      _updateCityNameDisplay();
      // Trigger refresh animation như pull-to-refresh / tương tự như vuốt màn hình để refresh 
      _refreshIndicatorKey.currentState?.show();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_cityName.isEmpty && _actualCityName.isEmpty) {
      _actualCityName = AppLocalizations.of(context).locationLoading;
      _updateCityNameDisplay();
    } else {
      // Cập nhật tên thành phố hiển thị khi ngôn ngữ thay đổi
      _updateCityNameDisplay();
    }
  }
  
  // Method để cập nhật tên thành phố hiển thị theo ngôn ngữ hiện tại
  void _updateCityNameDisplay() {
    if (_isDefaultLocation) {
      _cityName = AppLocalizations.of(context).defaultLocation;
    } else if (_actualCityName.isNotEmpty) {
      // Chuẩn hóa tên thành phố và lấy tên đúng ngôn ngữ
      final String normalizedName = AppLocalizations.getNormalizedCityName(_actualCityName);
      _cityName = AppLocalizations.of(context).getLocalizedCityName(normalizedName);
    }
  }
  
  // Favorites: mở danh sách và thao tác
  void _openFavoritesSheet() async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final favorites = await _favoritesService.getFavorites();
    if (!mounted) return;
    // Hiển thị bottom sheet
    // Bấm vào item: chọn địa điểm; bấm vào thùng rác: xóa ( note: sẽ thay thế bằng icon img sau)
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppLocalizations.of(context).favoriteLocations} (${favorites.length}/${_favoritesService.getMaxFavorites()})',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        await _addCurrentToFavorites();
                        if (!mounted) return;
                        Navigator.of(context).pop();
                        _openFavoritesSheet();
                      },
                      icon: const Icon(Icons.bookmark_add_outlined),
                      label: Text(AppLocalizations.of(context).addCurrent),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (favorites.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      AppLocalizations.of(context).noFavorites,
                      style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.6)),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: favorites.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = favorites[index];
                                                 final subtitle = item.hasCoordinates
                             ? 'lat: ${item.latitude?.toStringAsFixed(4)}, lon: ${item.longitude?.toStringAsFixed(4)}'
                             : AppLocalizations.of(context).cityLabel;
                         final bool isDefaultCoord = item.hasCoordinates && _isDefaultCoordinates(item.latitude!, item.longitude!);
                         final String titleText = isDefaultCoord 
                             ? AppLocalizations.of(context).defaultLocation 
                             : AppLocalizations.of(context).getLocalizedCityName(item.normalizedName);
                        return ListTile(
                          leading: const Icon(Icons.place_outlined),
                          title: Text(titleText),
                          subtitle: Text(subtitle),
                          onTap: () {
                            Navigator.of(context).pop();
                            if (item.hasCoordinates) {
                              if (_isDefaultCoordinates(item.latitude!, item.longitude!)) {
                                _fetchWeatherDataForDefaultLocation();
                              } else {
                                _isDefaultLocation = false;
                                _actualCityName = item.displayName;
                                _updateCityNameDisplay();
                                _fetchWeatherDataByCoordinates(item.latitude!, item.longitude!);
                              }
                                                         } else {
                               setState(() {
                                 _isDefaultLocation = false;
                                 _actualCityName = AppLocalizations.of(context).getLocalizedCityName(item.normalizedName);
                                 _currentLat = null;
                                 _currentLon = null;
                                 _updateCityNameDisplay();
                               });
                               _searchController.text = AppLocalizations.of(context).getLocalizedCityName(item.normalizedName);
                               _searchWeatherByCity();
                             }
                          },
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              await _favoritesService.removeFavorite(item);
                              if (!mounted) return;
                              Navigator.of(context).pop();
                              _openFavoritesSheet();
                            },
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addCurrentToFavorites() async {
    // Ưu tiên lưu theo tọa độ nếu có, nếu không lưu theo tên thành phố
    final String nameForDisplay = _cityName.isNotEmpty ? _cityName : (_actualCityName.isNotEmpty ? _actualCityName : '');
    if (nameForDisplay.isEmpty) return;
    
    // Chuẩn hóa tên thành phố tránh trùng lặp
    final String normalizedName = AppLocalizations.getNormalizedCityName(nameForDisplay);
    
    FavoriteLocation item;
    if (_currentLat != null && _currentLon != null) {
      item = FavoriteLocation(
        displayName: nameForDisplay, 
        normalizedName: normalizedName,
        latitude: _currentLat, 
        longitude: _currentLon
      );
    } else {
      item = FavoriteLocation(
        displayName: nameForDisplay,
        normalizedName: normalizedName,
      );
    }
    final existing = await _favoritesService.getFavorites();
    if (existing.length >= _favoritesService.getMaxFavorites()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).favoritesLimitReached)),
      );
      return;
    }
    final already = existing.contains(item);
    await _favoritesService.addFavorite(item);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(already
            ? AppLocalizations.of(context).favoriteExists
            : AppLocalizations.of(context).favoriteAdded),
      ),
    );
  }

    // Method để refresh dữ liệu thời tiết (cho Pull-to-refresh / vuốt xuống để load lại )
   Future<void> _refreshWeatherData() async {
     try {
       final currentLang = AppLocalizations.of(context).locale.languageCode;
       
       if (_currentLat != null && _currentLon != null) {
         // Refresh dữ liệu từ tọa độ hiện tại
         setState(() {
           _weatherFuture = _weatherService.getWeatherByCoordinates(_currentLat!, _currentLon!, lang: currentLang);
           _hourlyForecastFuture = _weatherService.getHourlyForecastByCoordinates(_currentLat!, _currentLon!, lang: currentLang);
           _twoDayForecastFuture = _weatherService.getFormattedTwoDayForecast(_currentLat!, _currentLon!, lang: currentLang);
           _aqiFuture = _weatherService.getAirQualityIndex(_currentLat!, _currentLon!);
         });
       } else if (_actualCityName.isNotEmpty && !_isDefaultLocation) {
         // Refresh dữ liệu từ tên thành phố đã tìm kiếm
         setState(() {
           _weatherFuture = _weatherService.getWeather(_actualCityName, lang: currentLang);
           _hourlyForecastFuture = _weatherService.getHourlyForecast(_actualCityName, lang: currentLang);
           _aqiFuture = _weatherService.getAirQualityIndexByCity(_actualCityName);
         });
       } else {
         // Refresh dữ liệu mặc định (Hà Nội)
         _fetchWeatherDataForDefaultLocation();
       }
       
       // Thêm delay nhỏ để user thấy animation
       await Future.delayed(const Duration(milliseconds: 500));
       
     } catch (e) {
       debugPrint('Error refreshing weather data: $e');
       // Không throw exception để tránh crash app
     }
   }

  void _startTimer() {
     _timer = Timer.periodic(const Duration(minutes: 30), (timer) {
       setState(() {
         _currentTime = DateTime.now();
       });
     });
   }

  Future<void> _determinePositionAndFetchWeather() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isDefaultLocation = false;
        _actualCityName = AppLocalizations.of(context).gpsRequired;
        _updateCityNameDisplay();
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _isDefaultLocation = false;
          _actualCityName = AppLocalizations.of(context).locationDenied;
          _updateCityNameDisplay();
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isDefaultLocation = false;
        _actualCityName = AppLocalizations.of(context).locationDeniedForever;
        _updateCityNameDisplay();
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      debugPrint('Location obtained: ${position.latitude}, ${position.longitude}');
      
      // Lấy tên thành phố để hiển thị trên màn hình
      List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      debugPrint('Placemarks found: ${placemarks.length}');
      if (placemarks.isNotEmpty) {
        debugPrint('First placemark: ${placemarks.first}');
      }

      String? city = placemarks.isNotEmpty ? placemarks.first.locality : null;
      String? subLocality = placemarks.isNotEmpty ? placemarks.first.subLocality : null;
      String? administrativeArea = placemarks.isNotEmpty ? placemarks.first.administrativeArea : null;
      String? country = placemarks.isNotEmpty ? placemarks.first.country : null;
      
      // Kiểm tra xem có phải vị trí mặc định (California/USA) không ( máy chủ GG )
      bool isDefaultLocation = (city == 'Mountain View' || 
                               city == 'San Francisco' || 
                               city == 'Palo Alto' ||
                               city == 'California' ||
                               country == 'United States' ||
                               country == 'USA') && 
                               (position.latitude >= 37.0 && position.latitude <= 38.0 && 
                                position.longitude >= -123.0 && position.longitude <= -121.0);
      
      // Kiểm tra thêm các vị trí mặc định khác
      bool isEmulatorLocation = (position.latitude == 37.4219999 && position.longitude == -122.0840575) ||
                               (position.latitude == 37.4219999 && position.longitude == -122.0840575) ||
                               (position.latitude == 0.0 && position.longitude == 0.0);
      
      if (isDefaultLocation || isEmulatorLocation) {
        debugPrint('Detected default/emulator location: $city, $country, ${position.latitude}, ${position.longitude}');
        _showLocationWarningDialog('${AppLocalizations.of(context).defaultLocationDetected}$city, $country\n${AppLocalizations.of(context).pleaseChooseManually}');
        return;
      }
      
      // Kiểm tra xem có phải đang ở Việt Nam không
      bool isInVietnam = country == 'Vietnam' || country == 'Việt Nam';
      if (!isInVietnam && country != null) {
        debugPrint('Not in Vietnam: $country, using fallback');
        _fetchWeatherDataForDefaultLocation();
        return;
      }
      
      if (city != null && city.isNotEmpty && city != 'Mountain View') {
        setState(() {
          _isDefaultLocation = false;
          _actualCityName = city;
          _updateCityNameDisplay();
        });
      } else if (subLocality != null && subLocality.isNotEmpty) {
        setState(() {
          _isDefaultLocation = false;
          _actualCityName = subLocality;
          _updateCityNameDisplay();
        });
      } else if (administrativeArea != null && administrativeArea.isNotEmpty) {
        setState(() {
          _isDefaultLocation = false;
          _actualCityName = administrativeArea;
          _updateCityNameDisplay();
        });
      } else {
        setState(() {
          _isDefaultLocation = false;
          _actualCityName = '${AppLocalizations.of(context).locationLoading} ${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';
          _updateCityNameDisplay();
        });
      }
      
      // Lấy dữ liệu thời tiết bằng tọa độ để đảm bảo chính xác
      _fetchWeatherDataByCoordinates(position.latitude, position.longitude);

    } catch (e) {
      debugPrint('Error getting location: $e');
      // Sử dụng vị trí mặc định khi không lấy được vị trí
      _fetchWeatherDataForDefaultLocation();
    }
  }

     void _fetchWeatherDataByCoordinates(double lat, double lon) {
     final currentLang = AppLocalizations.of(context).locale.languageCode;
     setState(() {
       _currentLat = lat;
       _currentLon = lon;
       _weatherFuture = _weatherService.getWeatherByCoordinates(lat, lon, lang: currentLang);
       _hourlyForecastFuture = _weatherService.getHourlyForecastByCoordinates(lat, lon, lang: currentLang);
       _twoDayForecastFuture = _weatherService.getFormattedTwoDayForecast(lat, lon, lang: currentLang);
       _aqiFuture = _weatherService.getAirQualityIndex(lat, lon);
     });
   }

     // Fallback method khi không lấy được vị trí
   void _fetchWeatherDataForDefaultLocation() {
     final currentLang = AppLocalizations.of(context).locale.languageCode;
     setState(() {
       _isDefaultLocation = true;
       _actualCityName = AppLocalizations.of(context).defaultLocation;
       _currentLat = 21.0285; // Tọa độ Hà Nội
       _currentLon = 105.8542; // Tọa độ Hà Nội
       _updateCityNameDisplay();
       _weatherFuture = _weatherService.getWeatherByCoordinates(21.0285, 105.8542, lang: currentLang);
       _hourlyForecastFuture = _weatherService.getHourlyForecastByCoordinates(21.0285, 105.8542, lang: currentLang);
       _twoDayForecastFuture = _weatherService.getFormattedTwoDayForecast(21.0285, 105.8542, lang: currentLang);
       _aqiFuture = _weatherService.getAirQualityIndex(21.0285, 105.8542);
     });
   }

     // Method để tìm kiếm thời tiết theo tên thành phố
   void _searchWeatherByCity() async {
     final cityName = _searchController.text.trim();
     if (cityName.isEmpty) return;

     setState(() {
       _cityName = AppLocalizations.of(context).searching;
     });

     try {
       final currentLang = AppLocalizations.of(context).locale.languageCode;
       final weatherData = await _weatherService.getWeather(cityName, lang: currentLang);
       final forecastData = await _weatherService.getHourlyForecast(cityName, lang: currentLang);
       final aqiData = await _weatherService.getAirQualityIndexByCity(cityName);
       
       setState(() {
         _isDefaultLocation = false;
         _actualCityName = cityName;
         // Khi tìm kiếm theo tên thành phố, không có tọa độ cụ thể
         // nên set về null để tránh refresh sai
         _currentLat = null;
         _currentLon = null;
         _updateCityNameDisplay();
         _weatherFuture = Future.value(weatherData);
         _hourlyForecastFuture = Future.value(forecastData);
         _aqiFuture = Future.value(aqiData);
       });
     } catch (e) {
       setState(() {
         _cityName = '${AppLocalizations.of(context).cityNotFound}$cityName';
       });
       debugPrint('Error searching city: $e');
     }
   }

  // Method để hiển thị tùy chọn vị trí
  void _showLocationOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).chooseLocation),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.my_location, color: Theme.of(context).colorScheme.primary),
              title: Text(AppLocalizations.of(context).useGps),
              subtitle: Text(AppLocalizations.of(context).getCurrentLocation),
              onTap: () {
                Navigator.of(context).pop();
                _determinePositionAndFetchWeather();
              },
            ),
            ListTile(
              leading: Icon(Icons.location_city, color: Theme.of(context).colorScheme.primary),
              title: Text(AppLocalizations.of(context).hanoiDefault),
              subtitle: Text(AppLocalizations.of(context).useDefaultLocation),
              onTap: () {
                Navigator.of(context).pop();
                _fetchWeatherDataForDefaultLocation();
              },
            ),
            ListTile(
              leading: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
              title: Text(AppLocalizations.of(context).searchCity),
              subtitle: Text(AppLocalizations.of(context).enterCityName),
              onTap: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (context) => _buildSearchDialog(),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).cancel),
          ),
        ],
      ),
    );
  }

  bool _isDefaultCoordinates(double lat, double lon) {
    const double defaultLat = 21.0285;
    const double defaultLon = 105.8542;
    const double epsilon = 0.0005;
    return (lat - defaultLat).abs() < epsilon && (lon - defaultLon).abs() < epsilon;
  }

  // Method để hiển thị cảnh báo vị trí
  void _showLocationWarningDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).locationWarning),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _fetchWeatherDataForDefaultLocation();
            },
            child: Text(AppLocalizations.of(context).useHanoi),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showLocationOptions();
            },
            child: Text(AppLocalizations.of(context).chooseOtherLocation),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refreshWeatherData,
          color: theme.colorScheme.primary,
          backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
                         child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
               child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).welcome,
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _cityName,
                            style: TextStyle(
                              color: theme.colorScheme.onBackground,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => _buildSearchDialog(),
                        );
                      },
                      icon: Icon(Icons.search, color: theme.colorScheme.onBackground.withOpacity(0.6)),
                    ),
                    IconButton(
                      onPressed: () {
                        _showLocationOptions();
                      },
                      icon: Icon(Icons.my_location, color: theme.colorScheme.onBackground.withOpacity(0.6)),
                    ),
                    IconButton(
                      onPressed: _openFavoritesSheet,
                      icon: Icon(Icons.bookmark_border, color: theme.colorScheme.onBackground.withOpacity(0.6)),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      icon: Icon(Icons.menu, color: theme.colorScheme.onBackground.withOpacity(0.6)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Main Weather Card / Phần card thời tiết chính
                FutureBuilder<Map<String, dynamic>>(
                  future: _weatherFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('${AppLocalizations.of(context).error}${snapshot.error}'));
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final weatherData = snapshot.data!;
                      
                      // Kiểm tra dữ liệu có hợp lệ không
                      if (weatherData['main'] == null || 
                          weatherData['weather'] == null || 
                          weatherData['weather'].isEmpty ||
                          weatherData['wind'] == null) {
                        return Center(child: Text(AppLocalizations.of(context).weatherDataInvalid));
                      }
                      
                      final temp = weatherData['main']['temp'] ?? 0.0;
                      final description = weatherData['weather'][0]['description'] ?? AppLocalizations.of(context).unknown;
                      final wind = weatherData['wind']['speed'] ?? 0.0;
                      final humidity = weatherData['main']['humidity'] ?? 0;
                      final feelsLike = weatherData['main']['feels_like']; 
                      
                      // Lấy dữ liệu lượng mưa từ API
                      double rainVolume = 0.0;
                      if (weatherData['rain'] != null) {
                        // Nếu có dữ liệu mưa trong 1 giờ qua
                        rainVolume = weatherData['rain']['1h']?.toDouble() ?? 0.0;
                      } else if (weatherData['snow'] != null) {
                        // Nếu có tuyết, chuyển đổi thành mưa (1mm tuyết ≈ 1mm mưa)
                        rainVolume = weatherData['snow']['1h']?.toDouble() ?? 0.0;
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _formatDate(_currentTime),
                                        style: TextStyle(
                                          color: isDark ? Colors.white54 : Colors.black45,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _capitalizeFirstLetter(description),
                                        style: TextStyle(
                                          color: theme.colorScheme.onBackground,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${temp.round()}ºC', //Nhiệt độ thời tiết chính to nhất ở giữa 
                                        style: TextStyle(
                                          color: theme.colorScheme.onBackground,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // Feel like . Cảm giác như về nhiệt độ 
                                      const SizedBox(height: 6),
                                      Text(
                                        '${AppLocalizations.of(context).feelsLike}: ${feelsLike.toStringAsFixed(1)}ºC',
                                        style: TextStyle(
                                          color: isDark ? Colors.white70 : Colors.black54,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(_getWeatherIcon(description), size: 60, color: isDark ? Colors.white70 : Colors.grey),
                                      Positioned(
                                        top: 10,
                                        right: 0,
                                        child: Icon(Icons.wb_sunny, size: 28, color: Colors.amber),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _WeatherDetail(
                                  icon: Icons.air, 
                                  value: '${wind.round()} ${AppLocalizations.of(context).mS}', 
                                  label: AppLocalizations.of(context).wind,
                                  isDark: isDark,
                                ),
                                _WeatherDetail(
                                  icon: Icons.water_drop, 
                                  value: '$humidity%', 
                                  label: AppLocalizations.of(context).humidity,
                                  isDark: isDark,
                                ),
                                _WeatherDetail(
                                  icon: Icons.grain, 
                                  value: rainVolume > 0 ? '${rainVolume.toStringAsFixed(1)} ${AppLocalizations.of(context).mm}' : '0 ${AppLocalizations.of(context).mm}', 
                                  label: AppLocalizations.of(context).rainfall,
                                  isDark: isDark,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(child: Text(AppLocalizations.of(context).noWeatherData));
                    }
                  },
                ),

                const SizedBox(height: 20),
                
                // Air Quality Index Card / Phần card chất lượng không khí
                FutureBuilder<Map<String, dynamic>>(
                  future: _aqiFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(child: CircularProgressIndicator(color: theme.colorScheme.primary)),
                      );
                    } else if (snapshot.hasError) {
                      return Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(child: Text('${AppLocalizations.of(context).error}${snapshot.error}')),
                      );
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final aqiData = snapshot.data!;
                      
                      if (aqiData['list'] != null && aqiData['list'].isNotEmpty) {
                        final currentAQI = aqiData['list'][0];
                        final aqiValue = currentAQI['main']['aqi'] ?? 0;
                        final aqiLevel = _getAQILevel(aqiValue);
                        
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.air, color: aqiLevel['color'], size: 24),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppLocalizations.of(context).airQuality,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onBackground,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8, // khoảng cách giữa AQI info và badge
                                runSpacing: 8, // khoảng cách khi xuống dòng
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${AppLocalizations.of(context).aqi}: $aqiValue',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: aqiLevel['color'],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: aqiLevel['color'].withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: aqiLevel['color'].withOpacity(0.3)),
                                        ),
                                        child: Text(
                                          aqiLevel['level'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: aqiLevel['color'],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Center(child: Text(AppLocalizations.of(context).noWeatherData)),
                        );
                      }
                    } else {
                      return Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(child: Text(AppLocalizations.of(context).noWeatherData)),
                      );
                    }
                  },
                ),

                const SizedBox(height: 24),
                //Tabs
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTab = 0;
                        });
                      },
                      child: Text(
                        AppLocalizations.of(context).today, 
                        style: TextStyle(
                          fontWeight: _selectedTab == 0 ? FontWeight.bold : FontWeight.normal, 
                          fontSize: 16,
                          color: _selectedTab == 0 ? theme.colorScheme.onBackground : (isDark ? Colors.white70 : Colors.black54),
                        )
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTab = 1;
                        });
                      },
                      child: Text(
                        AppLocalizations.of(context).tomorrow, 
                        style: TextStyle(
                          fontWeight: _selectedTab == 1 ? FontWeight.bold : FontWeight.normal,
                          color: _selectedTab == 1 ? theme.colorScheme.onBackground : (isDark ? Colors.white70 : Colors.black54), 
                          fontSize: 16
                        )
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTab = 2;
                        });
                      },
                      child: Text(
                        AppLocalizations.of(context).dayAfterTomorrow, 
                        style: TextStyle(
                          fontWeight: _selectedTab == 2 ? FontWeight.bold : FontWeight.normal,
                          color: _selectedTab == 2 ? theme.colorScheme.onBackground : (isDark ? Colors.white70 : Colors.black54), 
                          fontSize: 16
                        )
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Hourly Forecast (Dynamic data based on selected tab)
                _selectedTab == 0 
                  ? FutureBuilder<List<dynamic>>(
                      future: _hourlyForecastFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
                        } else if (snapshot.hasError) {
                          return Center(child: Text('${AppLocalizations.of(context).error}${snapshot.error}'));
                        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          final hourlyData = snapshot.data!;
                          print('Today tab - Using _hourlyForecastFuture, data count: ${hourlyData.length}');
                          return SizedBox(
                            height: 110,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: hourlyData.length,
                              itemBuilder: (context, index) {
                                final hour = hourlyData[index];
                                
                                // Kiểm tra dữ liệu có hợp lệ không
                                if (hour['dt'] == null || 
                                    hour['main'] == null || 
                                    hour['weather'] == null || 
                                    hour['weather'].isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                
                                final time = _formatTime(hour['dt']);
                                final temp = '${(hour['main']['temp'] ?? 0.0).round()}º';
                                final icon = _getWeatherIcon(hour['weather'][0]['description'] ?? 'clear');
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: _HourWeatherCard(
                                    time: time, 
                                    temp: temp, 
                                    icon: icon,
                                    isDark: isDark,
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return Center(child: Text(AppLocalizations.of(context).noHourlyData));
                        }
                      },
                    )
                  : FutureBuilder<Map<String, List<dynamic>>>(
                      future: _twoDayForecastFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
                        } else if (snapshot.hasError) {
                          return Center(child: Text('${AppLocalizations.of(context).error}${snapshot.error}'));
                        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          final formattedData = snapshot.data!;
                          final hourlyData = _getHourlyDataForTab(formattedData, _selectedTab);
                          
                          if (hourlyData.isNotEmpty) {
                            return SizedBox(
                              height: 110,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: hourlyData.length,
                                itemBuilder: (context, index) {
                                  final hour = hourlyData[index];
                                  
                                  final time = _formatTimeFromString(hour['time'] ?? '00:00');
                                  final temp = '${(hour['temperature'] ?? 0.0).round()}º';
                                  final icon = _getWeatherIcon(hour['description'] ?? 'clear');
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: _HourWeatherCard(
                                      time: time, 
                                      temp: temp, 
                                      icon: icon,
                                      isDark: isDark,
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return Center(child: Text(AppLocalizations.of(context).noHourlyData));
                          }
                        } else {
                          return Center(child: Text(AppLocalizations.of(context).noHourlyData));
                        }
                      },
                    ),

                const SizedBox(height: 24),
                
                // Temperature Chart with real-time data based on selected tab //  biểu đồ nhiệt độ thời gian 
                _selectedTab == 0 
                  ? FutureBuilder<List<dynamic>>(
                      future: _hourlyForecastFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return SizedBox(
                            height: 220,
                            child: Center(child: CircularProgressIndicator(color: theme.colorScheme.primary)),
                          );
                        } else if (snapshot.hasError) {
                          return SizedBox(
                            height: 220,
                            child: Center(child: Text('${AppLocalizations.of(context).error}${snapshot.error}')),
                          );
                        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          final hourlyData = snapshot.data!;
                          return SizedBox(
                            height: 220,
                            child: _TemperatureChart(
                              hourlyData: hourlyData,
                              currentTime: _currentTime,
                              isDark: isDark,
                            ),
                          );
                        } else {
                          return SizedBox(
                            height: 220,
                            child: Center(child: Text(AppLocalizations.of(context).noChartData)),
                          );
                        }
                      },
                    )
                  : FutureBuilder<Map<String, List<dynamic>>>(
                      future: _twoDayForecastFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return SizedBox(
                            height: 220,
                            child: Center(child: CircularProgressIndicator(color: theme.colorScheme.primary)),
                          );
                        } else if (snapshot.hasError) {
                          return SizedBox(
                            height: 220,
                            child: Center(child: Text('${AppLocalizations.of(context).error}${snapshot.error}')),
                          );
                        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          final formattedData = snapshot.data!;
                          final hourlyData = _getHourlyDataForTab(formattedData, _selectedTab);
                          
                          if (hourlyData.isNotEmpty) {
                            // Chuyển đổi dữ liệu format về dạng gốc để tương thích với _TemperatureChart
                            final convertedData = hourlyData.map((hour) => {
                              'dt': _parseTimeToTimestamp(hour['time']),
                              'main': {'temp': hour['temperature']},
                              'weather': [{'description': hour['description']}],
                            }).toList();
                            
                            return SizedBox(
                              height: 220,
                              child: _TemperatureChart(
                                hourlyData: convertedData,
                                currentTime: _currentTime,
                                isDark: isDark,
                              ),
                            );
                          } else {
                            return SizedBox(
                              height: 220,
                              child: Center(child: Text(AppLocalizations.of(context).noChartData)),
                            );
                          }
                        } else {
                          return SizedBox(
                            height: 220,
                            child: Center(child: Text(AppLocalizations.of(context).noChartData)),
                          );
                        }
                      },
                    ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  // Helper function to get weather icon based on description
  IconData _getWeatherIcon(String description) {
    if (description.contains('mưa') || description.contains('rain')) {
      return Icons.grain;
    } else if (description.contains('mây') || description.contains('cloud')) {
      return Icons.cloud;
    } else if (description.contains('nắng') || description.contains('clear')) {
      return Icons.wb_sunny;
    } else if (description.contains('bão') || description.contains('storm')) {
      return Icons.thunderstorm;
    }
    return Icons.wb_sunny;
  }

  // Helper function to format date
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day-$month-$year';
  }

  // Helper function to format time from Unix timestamp
  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final hour = date.hour;
    if (hour == 0) return '12 am';
    if (hour > 12) return '${hour - 12} pm';
    return '$hour am';
  }

     // Helper function to capitalize the first letter of a string
   String _capitalizeFirstLetter(String text) {
     if (text.isEmpty) return text;
     return text[0].toUpperCase() + text.substring(1);
   }

   // Helper function to get AQI level and color
   Map<String, dynamic> _getAQILevel(int aqi) {
     if (aqi <= 1) {
       return {
         'level': AppLocalizations.of(context).aqiGood,
         'color': Colors.green,
         'description': 'Chất lượng không khí tốt',
       };
     } else if (aqi <= 2) {
       return {
         'level': AppLocalizations.of(context).aqiModerate,
         'color': Colors.yellow,
         'description': 'Chất lượng không khí trung bình',
       };
     } else if (aqi <= 3) {
       return {
         'level': AppLocalizations.of(context).aqiUnhealthySensitive,
         'color': Colors.orange,
         'description': 'Không tốt cho nhóm nhạy cảm',
       };
     } else if (aqi <= 4) {
       return {
         'level': AppLocalizations.of(context).aqiUnhealthy,
         'color': Colors.red,
         'description': 'Chất lượng không khí không tốt',
       };
     } else if (aqi <= 5) {
       return {
         'level': AppLocalizations.of(context).aqiVeryUnhealthy,
         'color': Colors.purple,
         'description': 'Chất lượng không khí rất không tốt',
       };
     } else {
       return {
         'level': AppLocalizations.of(context).aqiHazardous,
         'color': const Color(0xFF800000), // Maroon color
         'description': 'Chất lượng không khí nguy hiểm',
       };
     }
   }

  // Helper function to parse time string to timestamp
  int _parseTimeToTimestamp(String timeStr) {
    try {
      final parts = timeStr.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      
      // Tạo timestamp cho ngày hiện tại với giờ được chỉ định
      final now = DateTime.now();
      final targetTime = DateTime(now.year, now.month, now.day, hour, minute);
      
      return targetTime.millisecondsSinceEpoch ~/ 1000;
    } catch (e) {
      return DateTime.now().millisecondsSinceEpoch ~/ 1000;
    }
  }

  // Helper function to format time string to AM/PM format
  String _formatTimeFromString(String timeStr) {
    try {
      final parts = timeStr.split(':');
      final hour = int.parse(parts[0]);
      
      if (hour == 0) return '12 am';
      if (hour > 12) return '${hour - 12} pm';
      return '$hour am';
    } catch (e) {
      return timeStr;
    }
  }

  // Helper function to get hourly data for specific tab
  List<dynamic> _getHourlyDataForTab(Map<String, List<dynamic>> formattedData, int selectedTab) {
    final dates = formattedData.keys.toList()..sort();
    print('Available dates: $dates, Selected tab: $selectedTab');
    
    if (selectedTab == 0) {
      // Today - return first 8 items from first date
      if (dates.isNotEmpty) {
        final todayData = formattedData[dates[0]] ?? [];
        print('Today data count: ${todayData.length}');
        return todayData.take(8).toList();
      }
    } else {
      // Tomorrow (1) or Day after tomorrow (2)
      final targetDateIndex = selectedTab - 1;
      if (targetDateIndex < dates.length) {
        final targetDate = dates[targetDateIndex];
        final hourlyData = formattedData[targetDate] ?? [];
        print('Target date: $targetDate, Data count: ${hourlyData.length}');
        return hourlyData;
      }
    }
    
    return [];
  }

  // Build search dialog
  Widget _buildSearchDialog() {
    final List<String> popularCities = [
      AppLocalizations.of(context).hanoi,
      AppLocalizations.of(context).hoChiMinh,
      AppLocalizations.of(context).daNang,
      AppLocalizations.of(context).haiPhong,
      AppLocalizations.of(context).canTho,
      AppLocalizations.of(context).nhaTrang,
      AppLocalizations.of(context).hue,
      AppLocalizations.of(context).vungTau,
      AppLocalizations.of(context).daLat,
      AppLocalizations.of(context).quyNhon,
    ];

    return AlertDialog(
      title: Text(AppLocalizations.of(context).searchCityTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).enterCityNameHint,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              Navigator.of(context).pop();
              _searchWeatherByCity();
            },
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).popularCities, 
            style: const TextStyle(fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: popularCities.map((city) => 
              ActionChip(
                label: Text(city),
                onPressed: () {
                  _searchController.text = city;
                  Navigator.of(context).pop();
                  _searchWeatherByCity();
                },
              )
            ).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context).cancel),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            _searchWeatherByCity();
          },
          child: Text(AppLocalizations.of(context).search),
        ),
      ],
    );
  }
}

class _WeatherDetail extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool isDark;

  const _WeatherDetail({
    required this.icon,
    required this.value,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: isDark ? Colors.white70 : Colors.black54, size: 28),
        const SizedBox(height: 6),
        Text(
          value, 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 15,
            color: Theme.of(context).colorScheme.onBackground,
          )
        ),
        const SizedBox(height: 2),
        Text(
          label, 
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54, 
            fontSize: 13
          )
        ),
      ],
    );
  }
}

class _HourWeatherCard extends StatelessWidget {
  final String time;
  final String temp;
  final IconData icon;
  final bool isDark;

  const _HourWeatherCard({
    required this.time,
    required this.temp,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isDark ? Colors.white70 : Colors.black54, size: 28),
          const SizedBox(height: 6),
          Text(
            time, 
            style: TextStyle(
              fontSize: 13, 
              color: isDark ? Colors.white70 : Colors.black87
            )
          ),
          const SizedBox(height: 4),
          Text(
            temp, 
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 15,
              color: Theme.of(context).colorScheme.onBackground,
            )
          ),
        ],
      ),
    );
  }
}

class _TemperatureChart extends StatelessWidget {
  final List<dynamic> hourlyData;
  final DateTime currentTime;
  final bool isDark;

  const _TemperatureChart({
    required this.hourlyData,
    required this.currentTime,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (hourlyData.isEmpty) {
      //return Center(child: Text('Không có dữ liệu nhiệt độ'));
      return Center(
        child: Text(AppLocalizations.of(context)!.noTemperatureData),
      );
    }

         // Lọc dữ liệu cho 24 giờ tới từ thời điểm hiện tại
     final List<Map<String, dynamic>> temperatureData = [];
     
     for (int i = 0; i < hourlyData.length && i < 24; i++) {
       final hour = hourlyData[i];
       if (hour['dt'] != null && hour['main'] != null) {
         final timestamp = DateTime.fromMillisecondsSinceEpoch(hour['dt'] * 1000);
         final temp = hour['main']['temp'] ?? 0.0;
         
         // Thêm tất cả dữ liệu để có đủ điểm cho biểu đồ
         temperatureData.add({
           'time': timestamp,
           'temp': temp,
           'formattedTime': _formatTimeForChart(timestamp),
         });
       }
     }

    if (temperatureData.isEmpty) {
      //return const Center(child: Text('Không có dữ liệu nhiệt độ'));
      return Center(
        child: Text(AppLocalizations.of(context)!.noTemperatureData),
      );
    }

     // Tính toán vị trí hiện tại trên biểu đồ dựa trên thời gian trong ngày
     double currentTemp = temperatureData.first['temp'];
     double currentPosition = 0.0;
     
     // Tính vị trí dựa trên thời gian trong ngày (0-24 giờ)
     final currentHour = currentTime.hour + (currentTime.minute / 60.0);
     currentPosition = currentHour / 24.0; // Chia cho 24 giờ
     
     // Giới hạn vị trí trong khoảng 0-1
     currentPosition = currentPosition.clamp(0.0, 1.0);
     
     // Debug log để kiểm tra
     debugPrint('Chart Debug: currentTime=$currentTime, currentHour=$currentHour, currentPosition=$currentPosition');
     
     // Tìm nhiệt độ tương ứng với thời gian hiện tại
     // Sử dụng nội suy tuyến tính để tìm nhiệt độ chính xác
     final targetHour = currentHour;
     double interpolatedTemp = temperatureData.first['temp'];
     
     for (int i = 0; i < temperatureData.length - 1; i++) {
       final currentData = temperatureData[i];
       final nextData = temperatureData[i + 1];
       
       final currentDataHour = currentData['time'].hour + (currentData['time'].minute / 60.0);
       final nextDataHour = nextData['time'].hour + (nextData['time'].minute / 60.0);
       
       if (targetHour >= currentDataHour && targetHour <= nextDataHour) {
         // Tính tỷ lệ giữa 2 điểm dữ liệu
         final hourRange = nextDataHour - currentDataHour;
         final hourProgress = targetHour - currentDataHour;
         final ratio = hourRange > 0 ? hourProgress / hourRange : 0.0;
         
         // Nội suy nhiệt độ
         interpolatedTemp = currentData['temp'] + (nextData['temp'] - currentData['temp']) * ratio;
         break;
       }
     }
     
     currentTemp = interpolatedTemp;

    // Tính toán min/max nhiệt độ
    final temps = temperatureData.map((d) => d['temp'] as double).toList();
    final minTemp = temps.reduce((a, b) => a < b ? a : b);
    final maxTemp = temps.reduce((a, b) => a > b ? a : b);
    final tempRange = maxTemp - minTemp;

    // Debug log để kiểm tra
    debugPrint('Chart Debug: minTemp=$minTemp, maxTemp=$maxTemp, tempRange=$tempRange, currentTemp=$currentTemp');
    
    // Debug log cho dấu chấm hiện tại
    if (temperatureData.isNotEmpty) {
      debugPrint('Showing current time dot: currentPosition=$currentPosition, currentTemp=$currentTemp');
    } else {
      debugPrint('NOT showing current time dot: dataCount=${temperatureData.length}');
    }

    return Stack(
      children: [
        // Biểu đồ nhiệt độ
        CustomPaint(
          size: const Size(double.infinity, 160),
          painter: _SimpleTemperaturePainter(
            temperatureData: temperatureData,
            minTemp: minTemp,
            maxTemp: maxTemp,
            tempRange: tempRange,
            isDark: isDark,
          ),
        ),
        
        // Điểm hiện tại - LUÔN hiển thị khi có dữ liệu
        if (temperatureData.isNotEmpty)
          Positioned(
            left: (currentPosition * (MediaQuery.of(context).size.width - 40)).clamp(0.0, MediaQuery.of(context).size.width - 60),
            top: _calculateDotPosition(currentTemp, minTemp, maxTemp, tempRange),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black26 : Colors.black12,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '${_formatTimeForChart(currentTime)}\n${currentTemp.round()}º',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white : Colors.black,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? Colors.white70 : Colors.white,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black54 : Colors.black26,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        

      ],
    );
  }

     String _formatTimeForChart(DateTime time) {
     final hour = time.hour;
     final minute = time.minute.toString().padLeft(2, '0');
     
     // Hiển thị thời gian theo định dạng 24h cho biểu đồ
     return '$hour:$minute';
   }

  double _calculateDotPosition(double temp, double minTemp, double maxTemp, double tempRange) {
    // Tính toán vị trí Y của chấm dựa trên nhiệt độ
    // Sử dụng CHÍNH XÁC cùng logic với CustomPainter
    const double chartHeight = 160.0;
    const double chartPadding = 0.7; // Giống với CustomPainter
    
    // Xử lý trường hợp tempRange = 0 (khi minTemp = maxTemp)
    if (tempRange <= 0) {
      // Đặt dấu chấm ở giữa biểu đồ
      final centerY = (chartHeight * chartPadding) / 2 - 6;
      debugPrint('Dot position (tempRange=0): $centerY');
      return centerY;
    }
    
    // Công thức giống hệt CustomPainter
    final y = chartHeight - ((temp - minTemp) / tempRange) * (chartHeight * chartPadding);
    final finalY = y - 6; // 12/2 = 6
    
    debugPrint('Dot position: temp=$temp, minTemp=$minTemp, maxTemp=$maxTemp, tempRange=$tempRange, y=$y, finalY=$finalY');
    
    // Đảm bảo vị trí không vượt quá giới hạn
    return finalY.clamp(0.0, chartHeight - 12.0);
  }
}

class _SimpleTemperaturePainter extends CustomPainter {
  final List<Map<String, dynamic>> temperatureData;
  final double minTemp;
  final double maxTemp;
  final double tempRange;
  final bool isDark;

  _SimpleTemperaturePainter({
    required this.temperatureData,
    required this.minTemp,
    required this.maxTemp,
    required this.tempRange,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (temperatureData.length < 2) return;

    // Vẽ đường cong đơn giản màu xám
    final paint = Paint()
      ..color = isDark ? Colors.white70 : Colors.grey[400]!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Vẽ fill màu xám nhạt
    final fillPaint = Paint()
      ..color = isDark ? Colors.white24 : Colors.grey[200]!
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    // Vẽ đường cong đơn giản
    for (int i = 0; i < temperatureData.length; i++) {
      final data = temperatureData[i];
      final temp = data['temp'] as double;
      final x = (i / (temperatureData.length - 1)) * size.width;
      final y = size.height - ((temp - minTemp) / tempRange) * (size.height * 0.7);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height + 50); // Kéo dài xuống dưới
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    // Hoàn thành fill path - kéo dài xuống dưới màn hình
    fillPath.lineTo(size.width, size.height + 50);
    fillPath.close();

    // Vẽ fill trước
    canvas.drawPath(fillPath, fillPaint);
    
    // Vẽ đường viền sau
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}