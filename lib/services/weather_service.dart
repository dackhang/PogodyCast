import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class WeatherService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  
  // Phương thức lấy API key từ Remote Config
  Future<String> _getApiKey() async {
    // Lấy dữ liệu cấu hình từ Remote Config
    await _remoteConfig.fetchAndActivate();
    return _remoteConfig.getString('open_weather_api_key');
  }

  // Phương thức lấy dữ liệu thời tiết bằng tên thành phố
  Future<Map<String, dynamic>> getWeather(String cityName, {String lang = 'vi'}) async {
    final apiKey = await _getApiKey();
    final response = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric&lang=$lang'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Weather data not found for the city');
    }
  }

  // Phương thức mới: Lấy dữ liệu thời tiết bằng tọa độ
  Future<Map<String, dynamic>> getWeatherByCoordinates(double lat, double lon, {String lang = 'vi'}) async {
    try {
      final apiKey = await _getApiKey();
      final response = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=$lang'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Weather API Response: $data'); // Debug log
        return data;
      } else {
        print('Weather API Error: ${response.statusCode} - ${response.body}'); // Debug log
        throw Exception('Lỗi khi tải dữ liệu thời tiết: ${response.statusCode}');
      }
    } catch (e) {
      print('Weather API Exception: $e'); // Debug log
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // Phương thức lấy dự báo hàng giờ bằng tên thành phố
  Future<List<dynamic>> getHourlyForecast(String cityName, {String lang = 'vi'}) async {
    final apiKey = await _getApiKey();
    final response = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey&units=metric&lang=$lang'),
    );

    if (response.statusCode == 200) {
      final forecastData = json.decode(response.body);
      return forecastData['list'].sublist(0, 8);
    } else {
      throw Exception('Hourly forecast data not found');
    }
  }

  // Phương thức mới: Lấy dự báo hàng giờ bằng tọa độ
  Future<List<dynamic>> getHourlyForecastByCoordinates(double lat, double lon, {String lang = 'vi'}) async {
    try {
      final apiKey = await _getApiKey();
      final response = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=$lang'),
      );

      if (response.statusCode == 200) {
        final forecastData = json.decode(response.body);
        print('Forecast API Response: ${forecastData['list']?.length ?? 0} items'); // Debug log
        // Lấy dự báo cho 2 ngày (16 items = 2 ngày x 8 items/ngày)
        return forecastData['list']?.sublist(0, 16) ?? [];
      } else {
        print('Forecast API Error: ${response.statusCode} - ${response.body}'); // Debug log
        throw Exception('Lỗi khi tải dữ liệu dự báo hàng giờ: ${response.statusCode}');
      }
    } catch (e) {
      print('Forecast API Exception: $e'); // Debug log
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // Phương thức mới: Lấy dự báo theo giờ cho 2 ngày tiếp theo
  Future<List<dynamic>> getTwoDayHourlyForecast(double lat, double lon, {String lang = 'vi'}) async {
    try {
      final apiKey = await _getApiKey();
      final response = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=$lang'),
      );

      if (response.statusCode == 200) {
        final forecastData = json.decode(response.body);
        final allForecasts = forecastData['list'] ?? [];
        
        // Lấy dự báo cho 2 ngày (48 giờ)
        return allForecasts.sublist(0, 16);
      } else {
        print('Two Day Forecast API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Lỗi khi tải dữ liệu dự báo 2 ngày: ${response.statusCode}');
      }
    } catch (e) {
      print('Two Day Forecast API Exception: $e');
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // Phương thức mới: Lấy Air Quality Index bằng tọa độ
  Future<Map<String, dynamic>> getAirQualityIndex(double lat, double lon) async {
    try {
      final apiKey = await _getApiKey();
      final response = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=$apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('AQI API Response: $data'); // Debug log
        return data;
      } else {
        print('AQI API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Lỗi khi tải dữ liệu AQI: ${response.statusCode}');
      }
    } catch (e) {
      print('AQI API Exception: $e');
      throw Exception('Lỗi kết nối AQI: $e');
    }
  }

  // Phương thức mới: Lấy Air Quality Index bằng tên thành phố
  Future<Map<String, dynamic>> getAirQualityIndexByCity(String cityName) async {
    try {
      // Đầu tiên lấy tọa độ của thành phố
      final apiKey = await _getApiKey();
      final geoResponse = await http.get(
        Uri.parse('https://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=1&appid=$apiKey'),
      );

      if (geoResponse.statusCode == 200) {
        final geoData = json.decode(geoResponse.body);
        if (geoData.isNotEmpty) {
          final lat = geoData[0]['lat'];
          final lon = geoData[0]['lon'];
          // Sau đó lấy AQI bằng tọa độ
          return await getAirQualityIndex(lat, lon);
        } else {
          throw Exception('Không tìm thấy tọa độ cho thành phố: $cityName');
        }
      } else {
        throw Exception('Lỗi khi tìm tọa độ thành phố: ${geoResponse.statusCode}');
      }
    } catch (e) {
      print('AQI City API Exception: $e');
      throw Exception('Lỗi kết nối AQI: $e');
    }
  }

  // Phương thức helper: Format dữ liệu dự báo 2 ngày theo ngày
  Map<String, List<dynamic>> formatTwoDayForecast(List<dynamic> forecasts) {
    final Map<String, List<dynamic>> dailyForecasts = {};
    
    print('Formatting ${forecasts.length} forecasts...');
    
    for (var forecast in forecasts) {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
      final dateKey = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
      
      print('Processing forecast for date: $dateKey, time: ${dateTime.hour}:${dateTime.minute}');
      
      if (!dailyForecasts.containsKey(dateKey)) {
        dailyForecasts[dateKey] = [];
      }
      
      dailyForecasts[dateKey]!.add({
        'time': '${dateTime.hour.toString().padLeft(2, '0')}:00',
        'temperature': forecast['main']['temp'],
        'description': forecast['weather'][0]['description'],
        'icon': forecast['weather'][0]['icon'],
        'humidity': forecast['main']['humidity'],
        'wind_speed': forecast['wind']['speed'],
      });
    }
    
    print('Formatted data keys: ${dailyForecasts.keys.toList()}');
    dailyForecasts.forEach((date, data) {
      print('Date $date has ${data.length} hourly forecasts');
    });
    
    return dailyForecasts;
  }

  // Phương thức helper: Lấy dự báo 2 ngày đã được format
  Future<Map<String, List<dynamic>>> getFormattedTwoDayForecast(double lat, double lon, {String lang = 'vi'}) async {
    final forecasts = await getTwoDayHourlyForecast(lat, lon, lang: lang);
    return formatTwoDayForecast(forecasts);
  }
}