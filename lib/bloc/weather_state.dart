import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_pattern/model/weather.dart';
import 'package:logger/logger.dart';

final Logger _LOG = Logger();

abstract class WeatherState extends Equatable {
  const WeatherState();
}

class WeatherInitial extends WeatherState {
  @override
  List<Object> get props => [];
}

class WeatherLoading extends WeatherState {
  @override
  List<Object> get props => [];
}

class WeatherLoaded extends WeatherState {

  final Weather weather;

  WeatherLoaded(this.weather);

  @override
  List<Object> get props {
    _LOG.i('Getting "weather" prop: ${weather.toString()}');
    return [weather];
  }
}
