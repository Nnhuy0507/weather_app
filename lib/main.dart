import 'package:flutter/material.dart';
import 'weather_model.dart';
import 'weather_service.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService weatherService = WeatherService();
  final TextEditingController cityController = TextEditingController();

  WeatherModel? weather;
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<void> getCurrentWeather() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      WeatherModel result =
      await weatherService.getWeatherByLocation();

      setState(() {
        weather = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Không thể lấy vị trí hiện tại.';
        isLoading = false;
      });
    }
  }

  Future<void> searchCity() async {
    String city = cityController.text.trim();

    if (city.isEmpty) {
      setState(() {
        errorMessage = 'Vui lòng nhập tên thành phố.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      WeatherModel result =
      await weatherService.getWeatherByCity(city);

      setState(() {
        weather = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Không tìm thấy thành phố.';
        isLoading = false;
      });
    }
  }

  IconData getWeatherIcon(String iconCode) {
    if (iconCode.startsWith('01')) {
      return Icons.wb_sunny;
    }

    if (iconCode.startsWith('02')) {
      return Icons.cloud_queue;
    }

    if (iconCode.startsWith('03') ||
        iconCode.startsWith('04')) {
      return Icons.cloud;
    }

    if (iconCode.startsWith('09') ||
        iconCode.startsWith('10')) {
      return Icons.water_drop;
    }

    if (iconCode.startsWith('11')) {
      return Icons.thunderstorm;
    }

    if (iconCode.startsWith('13')) {
      return Icons.ac_unit;
    }

    if (iconCode.startsWith('50')) {
      return Icons.blur_on;
    }

    return Icons.cloud;
  }

  String getWeatherDescription(String description) {
    if (description.isEmpty) {
      return 'Không có mô tả';
    }

    return description[0].toUpperCase() + description.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WEATHER APP',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: cityController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Nhập tên thành phố',
                  prefixIcon: const Icon(
                    Icons.location_city,
                  ),
                  suffixIcon: IconButton(
                    onPressed: searchCity,
                    icon: const Icon(Icons.search),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) {
                  searchCity();
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: getCurrentWeather,
                  icon: const Icon(Icons.my_location),
                  label: const Text(
                    'Lấy thời tiết vị trí hiện tại',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.blue,
                  )
                      : errorMessage != null
                      ? Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: getCurrentWeather,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  )
                      : weather == null
                      ? const Text(
                    'Chưa có dữ liệu thời tiết',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  )
                      : buildWeatherContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWeatherContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            getWeatherIcon(weather!.iconCode),
            size: 110,
            color: Colors.orange,
          ),
          const SizedBox(height: 20),
          Text(
            '${weather!.temperature.toStringAsFixed(1)}°C',
            style: const TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            getWeatherDescription(weather!.description),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.red,
              ),
              const SizedBox(width: 5),
              Text(
                weather!.cityName,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  'THỜI TIẾT HIỆN TẠI',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Nhiệt độ: ${weather!.temperature.toStringAsFixed(1)}°C',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  getWeatherDescription(weather!.description),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }
}