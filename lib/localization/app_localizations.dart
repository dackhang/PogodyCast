import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'vi': { //Bản dịch tiếng việt
      // Home Screen Begin
      "noTemperatureData": "Không có dữ liệu nhiệt độ",

      // Home Screen
      'welcome': 'Chào mừng,',
      'location_loading': 'Đang lấy vị trí...',
      'gps_required': 'Vui lòng bật GPS',
      'location_denied': 'Từ chối quyền truy cập vị trí',
      'location_denied_forever': 'Quyền truy cập vị trí bị từ chối vĩnh viễn',
      'default_location': 'Hà Nội (Vị trí mặc định)',
      'searching': 'Đang tìm kiếm...',
      'city_not_found': 'Không tìm thấy thành phố: ',
      'weather_data_invalid': 'Dữ liệu thời tiết không hợp lệ',
      'no_weather_data': 'Không có dữ liệu thời tiết.',
      'unknown': 'Không xác định',
      
      // Weather Details
      'wind': 'Gió',
      'humidity': 'Độ ẩm',
      'rainfall': 'Lượng mưa',
      'm_s': 'm/s',
      'mm': 'mm',
      "feelsLike":"Cảm giác như",
      
      // Tabs
      'today': 'Hôm nay',
      'tomorrow': 'Ngày mai',
      'day_after_tomorrow': 'Ngày kia',
      
      // Forecast
      'no_hourly_data': 'Không có dữ liệu dự báo hàng giờ.',
      'no_chart_data': 'Không có dữ liệu biểu đồ.',
      
       // Settings
       'settings': 'Cài đặt',
       'language': 'Ngôn ngữ',
       'display_mode': 'Chế độ hiển thị',
       'help_support': 'Trợ giúp & Hỗ trợ',
       'contact': 'Liên hệ',
       'privacy_policy': 'Chính sách bảo mật',
       'light': 'Sáng',
       'dark': 'Tối',
       'select_language': 'Chọn ngôn ngữ',
       'select_display_mode': 'Chế độ hiển thị',
       'select_language_for_app': 'Chọn ngôn ngữ cho ứng dụng',
       'select_display_mode_for_app': 'Chọn chế độ hiển thị cho ứng dụng',
       'vietnamese': 'Tiếng Việt',
       'english': 'Tiếng Anh',
       'light_mode': 'Light Mode',
       'dark_mode': 'Dark Mode',
       'light_mode_desc': 'Chế độ sáng',
       'dark_mode_desc': 'Chế độ tối',
       'language_selected': 'Đã chọn ngôn ngữ: ',
       'mode_selected': 'Đã chọn chế độ: ',
       
       // Contact Screen
       'contact_us': 'Liên hệ với chúng tôi',
       'we_are_ready_to_help': 'Chúng tôi luôn sẵn sàng hỗ trợ bạn!',
       'contact_information': 'Thông tin liên hệ:',
       'phone': 'Điện thoại',
       'website': 'Website',
       'email_copied': 'Email: support@pogodycast.com',
       'phone_copied': 'Điện thoại: +84 123 456 789',
       'website_copied': 'Website: www.pogodycast.com',
       
       // Help & Support Screen
       'help_support_title': 'Trợ giúp & Hỗ trợ',
       'help_support_subtitle': 'Chúng tôi luôn sẵn sàng hỗ trợ bạn!',
       'contact_us_section': 'Liên hệ với chúng tôi',
       'privacy_policy_section': 'Chính sách bảo mật thông tin',
       
       // Privacy Policy Screen
       'privacy_policy_title': 'Chính sách bảo mật',
       'privacy_policy_content_1': 'Chúng tôi cam kết bảo vệ quyền riêng tư và thông tin cá nhân của bạn.',
       'privacy_policy_content_2': 'Ứng dụng có thể sử dụng cookie và công nghệ tương tự để:\n• Ghi nhớ cài đặt người dùng\n• Phân tích hiệu suất ứng dụng\n• Cải thiện trải nghiệm người dùng',
       'privacy_policy_content_3': 'Chúng tôi có thể cập nhật chính sách bảo mật này theo thời gian. Những thay đổi quan trọng sẽ được thông báo qua ứng dụng hoặc email.',
       'privacy_policy_content_4': 'Nếu bạn có câu hỏi về chính sách bảo mật này, vui lòng liên hệ:\n• Email: privacy@pogodycast.com\n• Điện thoại: +84 123 456 789\n• Địa chỉ: Bắc Ninh, Việt Nam',
       
       // Contact Screen Additional
       'address': 'Địa chỉ',
       'address_value': 'Bắc Ninh, Việt Nam',
       'address_copied': 'Địa chỉ: Bắc Ninh, Việt Nam',
       'working_hours': 'Giờ làm việc',
       'working_hours_value': 'Thứ 2 - Thứ 6: 8:00 - 17:30\nThứ 7: 8:00 - 12:00\nChủ nhật: Nghỉ',
       
       // Privacy Policy Additional
       'last_updated': 'Cập nhật lần cuối: 04/06/2025',
       'info_collection_title': '1. Thông tin chúng tôi thu thập',
       'info_collection_content': 'Chúng tôi thu thập thông tin vị trí của bạn để cung cấp dự báo thời tiết chính xác. Thông tin này bao gồm:\n• Tọa độ GPS (kinh độ, vĩ độ)\n• Tên thành phố/địa điểm\n• Thông tin thiết bị cơ bản',
       'info_usage_title': '2. Cách chúng tôi sử dụng thông tin',
       'info_usage_content': 'Thông tin thu thập được sử dụng để:\n• Cung cấp dự báo thời tiết chính xác\n• Cải thiện trải nghiệm người dùng\n• Phân tích và tối ưu hóa ứng dụng\n• Gửi thông báo quan trọng về thời tiết',
       'info_sharing_title': '3. Chia sẻ thông tin',
       'info_sharing_content': 'Chúng tôi KHÔNG bán, trao đổi hoặc chuyển giao thông tin cá nhân của bạn cho bên thứ ba. Thông tin chỉ được sử dụng nội bộ để cung cấp dịch vụ.',
       'security_title': '4. Bảo mật thông tin',
       'security_content': 'Chúng tôi thực hiện các biện pháp bảo mật phù hợp để bảo vệ thông tin của bạn:\n• Mã hóa dữ liệu truyền tải\n• Kiểm soát truy cập nghiêm ngặt\n• Cập nhật bảo mật thường xuyên\n• Tuân thủ các tiêu chuẩn bảo mật quốc tế',
       'user_rights_title': '5. Quyền của người dùng',
       'user_rights_content': 'Bạn có quyền:\n• Truy cập thông tin cá nhân của mình\n• Yêu cầu chỉnh sửa hoặc xóa thông tin\n• Từ chối cung cấp thông tin vị trí\n• Rút lại sự đồng ý bất cứ lúc nào',
       'cookie_title': '6. Cookie và công nghệ theo dõi',
       'policy_changes_title': '7. Thay đổi chính sách',
       'contact_info_title': '8. Liên hệ',
       'security_priority': 'Bảo mật thông tin của bạn là ưu tiên hàng đầu của chúng tôi',
      
      // Location Dialog
      'choose_location': 'Chọn vị trí',
      'use_gps': 'Sử dụng GPS',
      'get_current_location': 'Lấy vị trí hiện tại',
      'hanoi_default': 'Hà Nội (Mặc định)',
      'use_default_location': 'Sử dụng vị trí mặc định',
      'search_city': 'Tìm kiếm thành phố',
      'enter_city_name': 'Nhập tên thành phố',
      'cancel': 'Hủy',
      'search': 'Tìm kiếm',
      
      // Search Dialog
      'search_city_title': 'Tìm kiếm thành phố',
      'enter_city_name_hint': 'Nhập tên thành phố ',
      'popular_cities': 'Thành phố phổ biến:',

      // Favorites
      'favorite_locations': 'Địa điểm yêu thích',
      'add_current': 'Thêm hiện tại',
      'no_favorites': 'Chưa có mục yêu thích',
      'city_label': 'Tên thành phố',
      'favorites_limit_reached': 'Đã đạt tối đa 5 mục yêu thích',
      'favorite_added': 'Đã thêm vào yêu thích',
      'favorite_exists': 'Đã có trong danh sách yêu thích',
      
      // Location Warning
      'location_warning': '⚠️ Cảnh báo vị trí',
      'default_location_detected': 'Phát hiện vị trí mặc định: ',
      'please_choose_manually': 'Vui lòng chọn vị trí thủ công.',
      'use_hanoi': 'Dùng Hà Nội',
      'choose_other_location': 'Chọn vị trí khác',
      
      // Errors
             'error': 'Lỗi: ',
       'error_getting_location': 'Lỗi khi lấy vị trí: ',
       'error_searching_city': 'Lỗi tìm kiếm thành phố: ',
       
       // Popular Cities
       'hanoi': 'Hà Nội',
       'ho_chi_minh': 'Thành phố Hồ Chí Minh',
       'da_nang': 'Đà Nẵng',
       'hai_phong': 'Hải Phòng',
       'can_tho': 'Cần Thơ',
       'nha_trang': 'Nha Trang',
       'hue': 'Huế',
       'vung_tau': 'Vũng Tàu',
       'da_lat': 'Đà Lạt',
       'quy_nhon': 'Quy Nhơn',
       
       // Air Quality Index
       'air_quality': 'Chất lượng không khí',
       'air_quality_index': 'Chỉ số chất lượng không khí',
       'aqi': 'AQI',
       'aqi_good': 'Tốt',
       'aqi_moderate': 'Trung bình',
       'aqi_unhealthy_sensitive': 'Không tốt cho nhóm nhạy cảm',
       'aqi_unhealthy': 'Không tốt',
       'aqi_very_unhealthy': 'Rất không tốt',
       'aqi_hazardous': 'Nguy hiểm',
       'aqi_unknown': 'Không xác định',
       'pm25': 'PM2.5',
       'pm10': 'PM10',
       'no2': 'NO₂',
       'so2': 'SO₂',
       'o3': 'O₃',
       'co': 'CO',
     },
     'en': { //Bản dịch tiếng anh
      //Home Screen Begin
      "noTemperatureData": "No temperature data",

      // Home Screen
      'welcome': 'Welcome,',
      'location_loading': 'Getting location...',
      'gps_required': 'Please enable GPS',
      'location_denied': 'Location access denied',
      'location_denied_forever': 'Location access permanently denied',
      'default_location': 'Hanoi (Default Location)',
      'searching': 'Searching...',
      'city_not_found': 'City not found: ',
      'weather_data_invalid': 'Invalid weather data',
      'no_weather_data': 'No weather data available.',
      'unknown': 'Unknown',
      
      // Weather Details
      'wind': 'Wind',
      'humidity': 'Humidity',
      'rainfall': 'Rainfall',
      'm_s': 'm/s',
      'mm': 'mm',
      "feelsLike":"Feel like",
      
      // Tabs
      'today': 'Today',
      'tomorrow': 'Tomorrow',
      'day_after_tomorrow': 'Day after tomorrow',
      
      // Forecast
      'no_hourly_data': 'No hourly forecast data available.',
      'no_chart_data': 'No chart data available.',
      
      // Settings
      'settings': 'Settings',
      'language': 'Language',
      'display_mode': 'Display Mode',
      'help_support': 'Help & Support',
      'contact': 'Contact',
      'privacy_policy': 'Privacy Policy',
      'light': 'Light',
      'dark': 'Dark',
      'select_language': 'Select Language',
      'select_display_mode': 'Display Mode',
      'select_language_for_app': 'Select language for the app',
      'select_display_mode_for_app': 'Select display mode for the app',
      'vietnamese': 'Vietnamese',
      'english': 'English',
      'light_mode': 'Light Mode',
      'dark_mode': 'Dark Mode',
      'light_mode_desc': 'Light mode',
      'dark_mode_desc': 'Dark mode',
      'language_selected': 'Language selected: ',
      'mode_selected': 'Mode selected: ',
       
      // Contact Screen
      'contact_us': 'Contact Us',
      'we_are_ready_to_help': 'We are always ready to help you!',
      'contact_information': 'Contact Information:',
      'phone': 'Phone',
      'website': 'Website',
      'email_copied': 'Email: support@pogodycast.com',
      'phone_copied': 'Phone: +84 123 456 789',
      'website_copied': 'Website: www.pogodycast.com',
      
      // Help & Support Screen
      'help_support_title': 'Help & Support',
      'help_support_subtitle': 'We are always ready to help you!',
      'contact_us_section': 'Contact Us',
      'privacy_policy_section': 'Privacy Policy Information',
      
      // Privacy Policy Screen
      'privacy_policy_title': 'Privacy Policy',
      'privacy_policy_content_1': 'We are committed to protecting your privacy and personal information.',
      'privacy_policy_content_2': 'The app may use cookies and similar technologies to:\n• Remember user settings\n• Analyze app performance\n• Improve user experience',
      'privacy_policy_content_3': 'We may update this privacy policy from time to time. Important changes will be notified through the app or email.',
      'privacy_policy_content_4': 'If you have questions about this privacy policy, please contact:\n• Email: privacy@pogodycast.com\n• Phone: +84 123 456 789\n• Address: Bac Ninh, Vietnam',
      
      // Contact Screen Additional
      'address': 'Address',
      'address_value': 'Bac Ninh, Vietnam',
      'address_copied': 'Address: Bac Ninh, Vietnam',
      'working_hours': 'Working Hours',
      'working_hours_value': 'Monday - Friday: 8:00 - 17:30\nSaturday: 8:00 - 12:00\nSunday: Closed',
      
      // Privacy Policy Additional
      'last_updated': 'Last updated: 04/06/2025',
      'info_collection_title': '1. Information We Collect',
      'info_collection_content': 'We collect your location information to provide accurate weather forecasts. This information includes:\n• GPS coordinates (longitude, latitude)\n• City/location name\n• Basic device information',
      'info_usage_title': '2. How We Use Information',
      'info_usage_content': 'Collected information is used to:\n• Provide accurate weather forecasts\n• Improve user experience\n• Analyze and optimize the app\n• Send important weather notifications',
      'info_sharing_title': '3. Information Sharing',
      'info_sharing_content': 'We do NOT sell, exchange, or transfer your personal information to third parties. Information is only used internally to provide services.',
      'security_title': '4. Information Security',
      'security_content': 'We implement appropriate security measures to protect your information:\n• Data transmission encryption\n• Strict access control\n• Regular security updates\n• Compliance with international security standards',
      'user_rights_title': '5. User Rights',
      'user_rights_content': 'You have the right to:\n• Access your personal information\n• Request modification or deletion of information\n• Refuse to provide location information\n• Withdraw consent at any time',
      'cookie_title': '6. Cookies and Tracking Technology',
      'policy_changes_title': '7. Policy Changes',
      'contact_info_title': '8. Contact',
      'security_priority': 'Your information security is our top priority',
      
      // Location Dialog
      'choose_location': 'Choose Location',
      'use_gps': 'Use GPS',
      'get_current_location': 'Get current location',
      'hanoi_default': 'Hanoi (Default)',
      'use_default_location': 'Use default location',
      'search_city': 'Search City',
      'enter_city_name': 'Enter city name',
      'cancel': 'Cancel',
      'search': 'Search',
      
      // Search Dialog
      'search_city_title': 'Search City',
      'enter_city_name_hint': 'Enter city name ',
      'popular_cities': 'Popular cities:',

      // Favorites
      'favorite_locations': 'Favorite locations',
      'add_current': 'Add current',
      'no_favorites': 'No favorites yet',
      'city_label': 'City name',
      'favorites_limit_reached': 'Reached the limit of 5 favorites',
      'favorite_added': 'Added to favorites',
      'favorite_exists': 'Already in favorites',
      
      // Location Warning
      'location_warning': '⚠️ Location Warning',
      'default_location_detected': 'Default location detected: ',
      'please_choose_manually': 'Please choose location manually.',
      'use_hanoi': 'Use Hanoi',
      'choose_other_location': 'Choose other location',
      
      // Errors
       'error': 'Error: ',
       'error_getting_location': 'Error getting location: ',
       'error_searching_city': 'Error searching city: ',
       
       // Popular Cities
       'hanoi': 'Hanoi',
       'ho_chi_minh': 'Ho Chi Minh City',
       'da_nang': 'Da Nang',
       'hai_phong': 'Hai Phong',
       'can_tho': 'Can Tho',
       'nha_trang': 'Nha Trang',
       'hue': 'Hue',
       'vung_tau': 'Vung Tau',
       'da_lat': 'Da Lat',
       'quy_nhon': 'Quy Nhon',
       
       // Air Quality Index
       'air_quality': 'Air Quality',
       'air_quality_index': 'Air Quality Index',
       'aqi': 'AQI',
       'aqi_good': 'Good',
       'aqi_moderate': 'Moderate',
       'aqi_unhealthy_sensitive': 'Unhealthy for Sensitive Groups',
       'aqi_unhealthy': 'Unhealthy',
       'aqi_very_unhealthy': 'Very Unhealthy',
       'aqi_hazardous': 'Hazardous',
       'aqi_unknown': 'Unknown',
       'pm25': 'PM2.5',
       'pm10': 'PM10',
       'no2': 'NO₂',
       'so2': 'SO₂',
       'o3': 'O₃',
       'co': 'CO',
     },
   };
  //Home 
  String get noTemperatureData => _localizedValues[locale.languageCode]?['noTemperatureData'] ?? 'No TemperatureData';
  String get welcome => _localizedValues[locale.languageCode]?['welcome'] ?? 'Welcome,';
  String get locationLoading => _localizedValues[locale.languageCode]?['location_loading'] ?? 'Getting location...';
  String get gpsRequired => _localizedValues[locale.languageCode]?['gps_required'] ?? 'Please enable GPS';
  String get locationDenied => _localizedValues[locale.languageCode]?['location_denied'] ?? 'Location access denied';
  String get locationDeniedForever => _localizedValues[locale.languageCode]?['location_denied_forever'] ?? 'Location access permanently denied';
  String get defaultLocation => _localizedValues[locale.languageCode]?['default_location'] ?? 'Hanoi (Default Location)';
  String get searching => _localizedValues[locale.languageCode]?['searching'] ?? 'Searching...';
  String get cityNotFound => _localizedValues[locale.languageCode]?['city_not_found'] ?? 'City not found: ';
  String get weatherDataInvalid => _localizedValues[locale.languageCode]?['weather_data_invalid'] ?? 'Invalid weather data';
  String get noWeatherData => _localizedValues[locale.languageCode]?['no_weather_data'] ?? 'No weather data available.';
  String get unknown => _localizedValues[locale.languageCode]?['unknown'] ?? 'Unknown';
  
  // Weather Details
  String get wind => _localizedValues[locale.languageCode]?['wind'] ?? 'Wind';
  String get humidity => _localizedValues[locale.languageCode]?['humidity'] ?? 'Humidity';
  String get rainfall => _localizedValues[locale.languageCode]?['rainfall'] ?? 'Rainfall';
  String get mS => _localizedValues[locale.languageCode]?['m_s'] ?? 'm/s';
  String get mm => _localizedValues[locale.languageCode]?['mm'] ?? 'mm';
  String get feelsLike => _localizedValues[locale.languageCode]?["feelsLike"] ?? "feelsLike";
  
  // Tabs
  String get today => _localizedValues[locale.languageCode]?['today'] ?? 'Today';
  String get tomorrow => _localizedValues[locale.languageCode]?['tomorrow'] ?? 'Tomorrow';
  String get dayAfterTomorrow => _localizedValues[locale.languageCode]?['day_after_tomorrow'] ?? 'Day after tomorrow';
  
  // Forecast
  String get noHourlyData => _localizedValues[locale.languageCode]?['no_hourly_data'] ?? 'No hourly forecast data available.';
  String get noChartData => _localizedValues[locale.languageCode]?['no_chart_data'] ?? 'No chart data available.';
  
     // Settings
   String get settings => _localizedValues[locale.languageCode]?['settings'] ?? 'Settings';
   String get language => _localizedValues[locale.languageCode]?['language'] ?? 'Language';
   String get displayMode => _localizedValues[locale.languageCode]?['display_mode'] ?? 'Display Mode';
   String get helpSupport => _localizedValues[locale.languageCode]?['help_support'] ?? 'Help & Support';
   String get contact => _localizedValues[locale.languageCode]?['contact'] ?? 'Contact';
   String get privacyPolicy => _localizedValues[locale.languageCode]?['privacy_policy'] ?? 'Privacy Policy';
   String get light => _localizedValues[locale.languageCode]?['light'] ?? 'Light';
   String get dark => _localizedValues[locale.languageCode]?['dark'] ?? 'Dark';
   String get selectLanguage => _localizedValues[locale.languageCode]?['select_language'] ?? 'Select Language';
   String get selectDisplayMode => _localizedValues[locale.languageCode]?['select_display_mode'] ?? 'Display Mode';
   String get selectLanguageForApp => _localizedValues[locale.languageCode]?['select_language_for_app'] ?? 'Select language for the app';
   String get selectDisplayModeForApp => _localizedValues[locale.languageCode]?['select_display_mode_for_app'] ?? 'Select display mode for the app';
   String get vietnamese => _localizedValues[locale.languageCode]?['vietnamese'] ?? 'Vietnamese';
   String get english => _localizedValues[locale.languageCode]?['english'] ?? 'English';
   String get lightMode => _localizedValues[locale.languageCode]?['light_mode'] ?? 'Light Mode';
   String get darkMode => _localizedValues[locale.languageCode]?['dark_mode'] ?? 'Dark Mode';
   String get lightModeDesc => _localizedValues[locale.languageCode]?['light_mode_desc'] ?? 'Light mode';
   String get darkModeDesc => _localizedValues[locale.languageCode]?['dark_mode_desc'] ?? 'Dark mode';
   String get languageSelected => _localizedValues[locale.languageCode]?['language_selected'] ?? 'Language selected: ';
   String get modeSelected => _localizedValues[locale.languageCode]?['mode_selected'] ?? 'Mode selected: ';
   
   // Contact Screen
   String get contactUs => _localizedValues[locale.languageCode]?['contact_us'] ?? 'Contact Us';
   String get weAreReadyToHelp => _localizedValues[locale.languageCode]?['we_are_ready_to_help'] ?? 'We are always ready to help you!';
   String get contactInformation => _localizedValues[locale.languageCode]?['contact_information'] ?? 'Contact Information:';
   String get phone => _localizedValues[locale.languageCode]?['phone'] ?? 'Phone';
   String get website => _localizedValues[locale.languageCode]?['website'] ?? 'Website';
   String get emailCopied => _localizedValues[locale.languageCode]?['email_copied'] ?? 'Email: support@pogodycast.com';
   String get phoneCopied => _localizedValues[locale.languageCode]?['phone_copied'] ?? 'Phone: +84 123 456 789';
   String get websiteCopied => _localizedValues[locale.languageCode]?['website_copied'] ?? 'Website: www.pogodycast.com';
   
   // Help & Support Screen
   String get helpSupportTitle => _localizedValues[locale.languageCode]?['help_support_title'] ?? 'Help & Support';
   String get helpSupportSubtitle => _localizedValues[locale.languageCode]?['help_support_subtitle'] ?? 'We are always ready to help you!';
   String get contactUsSection => _localizedValues[locale.languageCode]?['contact_us_section'] ?? 'Contact Us';
   String get privacyPolicySection => _localizedValues[locale.languageCode]?['privacy_policy_section'] ?? 'Privacy Policy Information';
   
   // Privacy Policy Screen
   String get privacyPolicyTitle => _localizedValues[locale.languageCode]?['privacy_policy_title'] ?? 'Privacy Policy';
   String get privacyPolicyContent1 => _localizedValues[locale.languageCode]?['privacy_policy_content_1'] ?? 'We are committed to protecting your privacy and personal information.';
   String get privacyPolicyContent2 => _localizedValues[locale.languageCode]?['privacy_policy_content_2'] ?? 'The app may use cookies and similar technologies to:\n• Remember user settings\n• Analyze app performance\n• Improve user experience';
   String get privacyPolicyContent3 => _localizedValues[locale.languageCode]?['privacy_policy_content_3'] ?? 'We may update this privacy policy from time to time. Important changes will be notified through the app or email.';
   String get privacyPolicyContent4 => _localizedValues[locale.languageCode]?['privacy_policy_content_4'] ?? 'If you have questions about this privacy policy, please contact:\n• Email: privacy@pogodycast.com\n• Phone: +84 123 456 789\n• Address: Hanoi, Vietnam';
   
   // Contact Screen Additional
   String get address => _localizedValues[locale.languageCode]?['address'] ?? 'Address';
   String get addressValue => _localizedValues[locale.languageCode]?['address_value'] ?? 'Bac Ninh, Vietnam';
   String get addressCopied => _localizedValues[locale.languageCode]?['address_copied'] ?? 'Address: Bac Ninh, Vietnam';
   String get workingHours => _localizedValues[locale.languageCode]?['working_hours'] ?? 'Working Hours';
   String get workingHoursValue => _localizedValues[locale.languageCode]?['working_hours_value'] ?? 'Monday - Friday: 8:00 - 18:00\nSaturday: 8:00 - 12:00\nSunday: Closed';
   
   // Privacy Policy Additional
   String get lastUpdated => _localizedValues[locale.languageCode]?['last_updated'] ?? 'Last updated: 01/01/2024';
   String get infoCollectionTitle => _localizedValues[locale.languageCode]?['info_collection_title'] ?? '1. Information We Collect';
   String get infoCollectionContent => _localizedValues[locale.languageCode]?['info_collection_content'] ?? 'We collect your location information to provide accurate weather forecasts. This information includes:\n• GPS coordinates (longitude, latitude)\n• City/location name\n• Basic device information';
   String get infoUsageTitle => _localizedValues[locale.languageCode]?['info_usage_title'] ?? '2. How We Use Information';
   String get infoUsageContent => _localizedValues[locale.languageCode]?['info_usage_content'] ?? 'Collected information is used to:\n• Provide accurate weather forecasts\n• Improve user experience\n• Analyze and optimize the app\n• Send important weather notifications';
   String get infoSharingTitle => _localizedValues[locale.languageCode]?['info_sharing_title'] ?? '3. Information Sharing';
   String get infoSharingContent => _localizedValues[locale.languageCode]?['info_sharing_content'] ?? 'We do NOT sell, exchange, or transfer your personal information to third parties. Information is only used internally to provide services.';
   String get securityTitle => _localizedValues[locale.languageCode]?['security_title'] ?? '4. Information Security';
   String get securityContent => _localizedValues[locale.languageCode]?['security_content'] ?? 'We implement appropriate security measures to protect your information:\n• Data transmission encryption\n• Strict access control\n• Regular security updates\n• Compliance with international security standards';
   String get userRightsTitle => _localizedValues[locale.languageCode]?['user_rights_title'] ?? '5. User Rights';
   String get userRightsContent => _localizedValues[locale.languageCode]?['user_rights_content'] ?? 'You have the right to:\n• Access your personal information\n• Request modification or deletion of information\n• Refuse to provide location information\n• Withdraw consent at any time';
   String get cookieTitle => _localizedValues[locale.languageCode]?['cookie_title'] ?? '6. Cookies and Tracking Technology';
   String get policyChangesTitle => _localizedValues[locale.languageCode]?['policy_changes_title'] ?? '7. Policy Changes';
   String get contactInfoTitle => _localizedValues[locale.languageCode]?['contact_info_title'] ?? '8. Contact';
   String get securityPriority => _localizedValues[locale.languageCode]?['security_priority'] ?? 'Your information security is our top priority';
  
  // Location Dialog
  String get chooseLocation => _localizedValues[locale.languageCode]?['choose_location'] ?? 'Choose Location';
  String get useGps => _localizedValues[locale.languageCode]?['use_gps'] ?? 'Use GPS';
  String get getCurrentLocation => _localizedValues[locale.languageCode]?['get_current_location'] ?? 'Get current location';
  String get hanoiDefault => _localizedValues[locale.languageCode]?['hanoi_default'] ?? 'Hanoi (Default)';
  String get useDefaultLocation => _localizedValues[locale.languageCode]?['use_default_location'] ?? 'Use default location';
  String get searchCity => _localizedValues[locale.languageCode]?['search_city'] ?? 'Search City';
  String get enterCityName => _localizedValues[locale.languageCode]?['enter_city_name'] ?? 'Enter city name';
  String get cancel => _localizedValues[locale.languageCode]?['cancel'] ?? 'Cancel';
  String get search => _localizedValues[locale.languageCode]?['search'] ?? 'Search';
  
  // Search Dialog
  String get searchCityTitle => _localizedValues[locale.languageCode]?['search_city_title'] ?? 'Search City';
  String get enterCityNameHint => _localizedValues[locale.languageCode]?['enter_city_name_hint'] ?? 'Enter city name ';
  String get popularCities => _localizedValues[locale.languageCode]?['popular_cities'] ?? 'Popular cities:';
  
  // Favorites
  String get favoriteLocations => _localizedValues[locale.languageCode]?['favorite_locations'] ?? 'Favorite locations';
  String get addCurrent => _localizedValues[locale.languageCode]?['add_current'] ?? 'Add current';
  String get noFavorites => _localizedValues[locale.languageCode]?['no_favorites'] ?? 'No favorites yet';
  String get cityLabel => _localizedValues[locale.languageCode]?['city_label'] ?? 'City name';
  String get favoritesLimitReached => _localizedValues[locale.languageCode]?['favorites_limit_reached'] ?? 'Reached the limit of 5 favorites';
  String get favoriteAdded => _localizedValues[locale.languageCode]?['favorite_added'] ?? 'Added to favorites';
  String get favoriteExists => _localizedValues[locale.languageCode]?['favorite_exists'] ?? 'Already in favorites';
  
  // Location Warning
  String get locationWarning => _localizedValues[locale.languageCode]?['location_warning'] ?? '⚠️ Location Warning';
  String get defaultLocationDetected => _localizedValues[locale.languageCode]?['default_location_detected'] ?? 'Default location detected: ';
  String get pleaseChooseManually => _localizedValues[locale.languageCode]?['please_choose_manually'] ?? 'Please choose location manually.';
  String get useHanoi => _localizedValues[locale.languageCode]?['use_hanoi'] ?? 'Use Hanoi';
  String get chooseOtherLocation => _localizedValues[locale.languageCode]?['choose_other_location'] ?? 'Choose other location';
  
  // Errors
     String get error => _localizedValues[locale.languageCode]?['error'] ?? 'Error: ';
   String get errorGettingLocation => _localizedValues[locale.languageCode]?['error_getting_location'] ?? 'Error getting location: ';
   String get errorSearchingCity => _localizedValues[locale.languageCode]?['error_searching_city'] ?? 'Error searching city: ';
   
   // Popular Cities
   String get hanoi => _localizedValues[locale.languageCode]?['hanoi'] ?? 'Hanoi';
   String get hoChiMinh => _localizedValues[locale.languageCode]?['ho_chi_minh'] ?? 'Ho Chi Minh City';
   String get daNang => _localizedValues[locale.languageCode]?['da_nang'] ?? 'Da Nang';
   String get haiPhong => _localizedValues[locale.languageCode]?['hai_phong'] ?? 'Hai Phong';
   String get canTho => _localizedValues[locale.languageCode]?['can_tho'] ?? 'Can Tho';
   String get nhaTrang => _localizedValues[locale.languageCode]?['nha_trang'] ?? 'Nha Trang';
   String get hue => _localizedValues[locale.languageCode]?['hue'] ?? 'Hue';
   String get vungTau => _localizedValues[locale.languageCode]?['vung_tau'] ?? 'Vung Tau';
   String get daLat => _localizedValues[locale.languageCode]?['da_lat'] ?? 'Da Lat';
   String get quyNhon => _localizedValues[locale.languageCode]?['quy_nhon'] ?? 'Quy Nhon';

   // Air Quality Index
   String get airQuality => _localizedValues[locale.languageCode]?['air_quality'] ?? 'Air Quality';
   String get airQualityIndex => _localizedValues[locale.languageCode]?['air_quality_index'] ?? 'Air Quality Index';
   String get aqi => _localizedValues[locale.languageCode]?['aqi'] ?? 'AQI';
   String get aqiGood => _localizedValues[locale.languageCode]?['aqi_good'] ?? 'Good';
   String get aqiModerate => _localizedValues[locale.languageCode]?['aqi_moderate'] ?? 'Moderate';
   String get aqiUnhealthySensitive => _localizedValues[locale.languageCode]?['aqi_unhealthy_sensitive'] ?? 'Unhealthy for Sensitive Groups';
   String get aqiUnhealthy => _localizedValues[locale.languageCode]?['aqi_unhealthy'] ?? 'Unhealthy';
   String get aqiVeryUnhealthy => _localizedValues[locale.languageCode]?['aqi_very_unhealthy'] ?? 'Very Unhealthy';
   String get aqiHazardous => _localizedValues[locale.languageCode]?['aqi_hazardous'] ?? 'Hazardous';
   String get aqiUnknown => _localizedValues[locale.languageCode]?['aqi_unknown'] ?? 'Unknown';
   String get pm25 => _localizedValues[locale.languageCode]?['pm25'] ?? 'PM2.5';
   String get pm10 => _localizedValues[locale.languageCode]?['pm10'] ?? 'PM10';
   String get no2 => _localizedValues[locale.languageCode]?['no2'] ?? 'NO₂';
   String get so2 => _localizedValues[locale.languageCode]?['so2'] ?? 'SO₂';
   String get o3 => _localizedValues[locale.languageCode]?['o3'] ?? 'O₃';
   String get co => _localizedValues[locale.languageCode]?['co'] ?? 'CO';

  // City name mapping for favorites (normalized names)
  static const Map<String, String> _cityNameMapping = {
    // Vietnamese names -> Normalized names
    'Hà Nội': 'hanoi',
    'Thành phố Hồ Chí Minh': 'ho_chi_minh',
    'Đà Nẵng': 'da_nang',
    'Hải Phòng': 'hai_phong',
    'Cần Thơ': 'can_tho',
    'Huế': 'hue',
    'Vũng Tàu': 'vung_tau',
    'Đà Lạt': 'da_lat',
    'Quy Nhơn': 'quy_nhon',
    
    // English names -> Normalized names
    'Hanoi': 'hanoi',
    'Ho Chi Minh City': 'ho_chi_minh',
    'Da Nang': 'da_nang',
    'Hai Phong': 'hai_phong',
    'Can Tho': 'can_tho',
    'Nha Trang': 'nha_trang',
    'Hue': 'hue',
    'Vung Tau': 'vung_tau',
    'Da Lat': 'da_lat',
    'Quy Nhon': 'quy_nhon',
  };

  // Get normalized city name for favorites
  static String getNormalizedCityName(String cityName) {
    return _cityNameMapping[cityName] ?? cityName;
  }

  // Get localized city name from normalized name
  String getLocalizedCityName(String normalizedName) {
    switch (normalizedName) {
      case 'hanoi':
        return hanoi;
      case 'ho_chi_minh':
        return hoChiMinh;
      case 'da_nang':
        return daNang;
      case 'hai_phong':
        return haiPhong;
      case 'can_tho':
        return canTho;
      case 'nha_trang':
        return nhaTrang;
      case 'hue':
        return hue;
      case 'vung_tau':
        return vungTau;
      case 'da_lat':
        return daLat;
      case 'quy_nhon':
        return quyNhon;
      default:
        return normalizedName; // Return original if not found
    }
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['vi', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
