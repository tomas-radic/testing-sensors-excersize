class UpdateMonoxideSensorStanding < ApplicationService
  pattr_initialize  :sensor,
                    :sensor_measurements,
                    :reference_ppm,
                    :standings_of_sensors

  def call
    normalize_inputs!
    update_sensor_standing!
  end

  private

  ACCEPTABLE_DIFFERENCE = 3

  def normalize_inputs!
    sensor_measurements.map!(&:to_i)
    @reference_ppm = reference_ppm.to_i
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
    @max_accepted_value ||= reference_ppm + ACCEPTABLE_DIFFERENCE
  end

  def min_accepted_value
    @min_accepted_value ||= reference_ppm - ACCEPTABLE_DIFFERENCE
  end
end
