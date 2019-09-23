class UpdateThermometerSensorStanding < ApplicationService
  include StandingNumbers

  pattr_initialize  :sensor,
                    :sensor_measurements,
                    :reference_value,
                    :standings_of_sensors

  def call
    normalize_inputs!
    update_sensor_standing!
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

  def update_sensor_standing!
    standings_of_sensors[sensor.name] = if minimum_sensor_standing_number(QUALITY_LEVELS, standings_of_sensors) == 0 &&
        mean <= 0.5 &&
        maximum_deviation < 3.0
      QUALITY_LEVELS[0]
    elsif minimum_sensor_standing_number(QUALITY_LEVELS, standings_of_sensors) <= 1 &&
        mean <= 0.5 && maximum_deviation <= 5.0
      QUALITY_LEVELS[1]
    else
      QUALITY_LEVELS[2]
    end
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
