import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

enum TemperatureUnit { celcius, fahrenheit }

class SettingsState extends Equatable {
  final TemperatureUnit temperatureUnit;

  SettingsState({@required this.temperatureUnit})
      : assert(temperatureUnit != null);

  SettingsState copyWith({TemperatureUnit temperatureUnit}) {
    return SettingsState(
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
    );
  }

  @override
  List<Object> get props => [temperatureUnit];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(
          SettingsState(
            temperatureUnit: TemperatureUnit.celcius,
          ),
        );

  void toggleTempUnit() {
    final newState = state.copyWith(
      temperatureUnit: state.temperatureUnit == TemperatureUnit.celcius
          ? TemperatureUnit.fahrenheit
          : TemperatureUnit.celcius,
    );
    print('toggleState: $newState');
    emit(newState);
  }
}
