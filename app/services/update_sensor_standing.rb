class UpdateSensorStanding < ApplicationService
  pattr_initialize  :sensor,
                    :sensor_measurements,
                    :reference_values,
                    :standings_of_sensors

  def call
    "Update#{sensor.type.capitalize}SensorStanding".constantize.call(
      sensor,
      sensor_measurements,
      reference_values[sensor.type.to_sym],
      standings_of_sensors
    )
  end
end
