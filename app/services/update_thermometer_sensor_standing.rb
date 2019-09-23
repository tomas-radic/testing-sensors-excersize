class UpdateThermometerSensorStanding < ApplicationService
  pattr_initialize  :sensor,
                    :sensor_measurements,
                    :reference_value,
                    :standings_of_sensors

  def call
    normalize_inputs!
    minimum_standing_number = current_sensor_standing_number || 0
    update_sensor_standing!(minimum_standing_number)
  end

  private

  QUALITY_LEVELS = {
    0 => 'ultra-precise',
    1 => 'very-precise',
    2 => 'precise'
  }

  def normalize_inputs!
    sensor_measurements.map!(&:to_f)
    @reference_value = reference_value.to_f
  end

  def update_sensor_standing!(previous_sensor_standing_number)
    standings_of_sensors[sensor.name] = if previous_sensor_standing_number == 0 &&
        mean <= 0.5 &&
        maximum_deviation < 3.0
      QUALITY_LEVELS[0]
    elsif previous_sensor_standing_number <= 1 &&
        mean <= 0.5 && maximum_deviation <= 5.0
      QUALITY_LEVELS[1]
    else
      QUALITY_LEVELS[2]
    end
  end

  def current_sensor_standing_number
    @sensor_standing_number ||= QUALITY_LEVELS.find do |level, level_name|
      standings_of_sensors[sensor.name] == level_name
    end&.first
  end

  def mean
    @mean ||= (statistics[:average] - reference_value).abs
  end

  def maximum_deviation
    @maximum_deviation ||= statistics[:maximum_deviation]
  end

  def statistics
    @statistics ||= ValuesStatistics.call(sensor_measurements)
  end
end
