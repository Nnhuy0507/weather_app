class WeatherModel {
  final double temperature;
  final String cityName;
  final String description;
  final String iconCode;

  WeatherModel({
    required this.temperature,
    required this.cityName,
    required this.description,
    required this.iconCode,
  });

  factory WeatherModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return WeatherModel(
      temperature:
      (json['main']['temp'] as num).toDouble(),
      cityName: json['name'] ?? '',
      description:
      json['weather'][0]['description'] ?? '',
      iconCode:
      json['weather'][0]['icon'] ?? '',
    );
  }
}