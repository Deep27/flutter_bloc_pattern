import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_pattern/bloc/bloc.dart';
import 'package:flutter_bloc_pattern/model/weather.dart';
import 'package:logger/logger.dart';

void main() => runApp(MyApp());

final Logger _LOG = Logger();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  WeatherPage({Key key}) : super(key: key);

  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final weatherBloc = WeatherBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fake Weather App"),
      ),
      body: BlocProvider<WeatherBloc>(
        builder: (context) => weatherBloc,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: BlocBuilder<WeatherBloc, WeatherState>(
            bloc: weatherBloc,
            builder: (BuildContext context, WeatherState state) {
              if (state is WeatherInitial) {
                _LOG.i('Initial state.');
                return _buildInitialInput();
              } else if (state is WeatherLoading) {
                _LOG.i('Leading state.');
                return _buildLoading();
              } else if (state is WeatherLoaded) {
                _LOG.i('Loaded state.');
                return _buildColumnWithData(state.weather);
              } else {
                _LOG.i('Again Initial state.');
                return _buildInitialInput();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInitialInput() => Center(child: CityInputField());
  Widget _buildLoading() => Center(child: CircularProgressIndicator()); 

  Column _buildColumnWithData(Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          weather.cityName,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          "${weather.temperature.toStringAsFixed(1)} °C",
          style: TextStyle(fontSize: 80),
        ),
        CityInputField(),
      ],
    );
  }

  @override
  void dispose() {
    _LOG.i('In dispose()');
    super.dispose();
    weatherBloc.close();
  }
}

class CityInputField extends StatefulWidget {
  const CityInputField({
    Key key,
  }) : super(key: key);

  @override
  _CityInputFieldState createState() => _CityInputFieldState();
}

class _CityInputFieldState extends State<CityInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onSubmitted: _submitCityName,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Enter a city",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  void _submitCityName(String cityName) {
    _LOG.i("Handling button onclick.");
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    weatherBloc.add(GetWeather(cityName));
  }
}
