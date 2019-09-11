class UpdateHumiditySensorStanding < ApplicationService
  pattr_initialize  :sensor,
                    :sensor_measurements,
                    :reference_humidity,
                    :standings_of_sensors

  def call
    normalize_inputs!
    update_sensor_standing!
  end

  private

  def normalize_inputs!
    sensor_measurements.map!(&:to_f)
    @reference_humidity = reference_humidity.to_f
  end

  def update_sensor_standing!
    if discard_sensor?
      standings_of_sensors[sensor.name] = 'discard'
    else
      standings_of_sensors[sensor.name] = 'keep' unless standings_of_sensors[sensor.name] == 'discard'
    end
  end

  def discard_sensor?
    sensor_measurements.select do |m|
      m > max_accepted_value || m < min_accepted_value
    end.any?
  end

  def max_accepted_value
    @max_accepted_value ||= reference_humidity + acceptable_difference
  end

  def min_accepted_value
    @min_accepted_value ||= reference_humidity - acceptable_difference
  end

  def acceptable_difference
    @acceptable_difference ||= reference_humidity * 0.01
  end
end
