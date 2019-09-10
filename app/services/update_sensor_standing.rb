class UpdateSensorStanding < Patterns::Service
  pattr_initialize  :sensor,
                    :sensor_measurements,
                    :reference_values,
                    :standings_of_sensors

  def call
    case sensor.type
    when 'thermometer'
      UpdateTemperatureSensorStanding.call(
        sensor,
        sensor_measurements,
        reference_values[:temperature],
        standings_of_sensors
      )
    when 'humidity'
      UpdateHumiditySensorStanding.call(
        sensor,
        sensor_measurements,
        reference_values[:humidity],
        standings_of_sensors
      )
    when 'monoxide'
      UpdateMonoxideSensorStanding.call(
        sensor,
        sensor_measurements,
        reference_values[:ppm],
        standings_of_sensors
      )
    end
  end
end
