class UpdateMonoxideSensorStanding < ApplicationService
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

  ACCEPTABLE_DIFFERENCE = 3
  QUALITY_LEVELS = {
    0 => 'keep',
    1 => 'discard'
  }

  def normalize_inputs!
    sensor_measurements.map!(&:to_i)
    @reference_value = reference_value.to_i
  end

  def update_sensor_standing!
    if discard_sensor?
      standings_of_sensors[sensor.name] = 'discard'
    elsif minimum_sensor_standing_number(QUALITY_LEVELS, standings_of_sensors) == 0
      standings_of_sensors[sensor.name] = 'keep'
    end
  end

  def discard_sensor?
    sensor_measurements.select do |m|
      m > max_accepted_value || m < min_accepted_value
    end.any?
  end

  def max_accepted_value
    @max_accepted_value ||= reference_value + ACCEPTABLE_DIFFERENCE
  end

  def min_accepted_value
    @min_accepted_value ||= reference_value - ACCEPTABLE_DIFFERENCE
  end
end
