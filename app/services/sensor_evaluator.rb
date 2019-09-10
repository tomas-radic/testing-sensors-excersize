class SensorEvaluator < Patterns::Service
  pattr_initialize :input

  def call
    process_input
    standings_of_sensors
  end

  private

  attr_reader :reference_values,
              :current_sensor,
              :current_measurements,
              :standings_of_sensors

  def process_input
    input_lines.each do |input_line|
      process_line(input_line)
    end

    update_current_sensor_standing
  end

  def process_line(line)
    line_values = line.split(' ')

    begin
      add_measurement_to_current_sensor(
        timestamp: line_values[0],
        measurement_value: line_values[1]
      )
    rescue ArgumentError
      update_current_sensor_standing

      if line_values.first == 'reference'
        change_reference_values(line_values[1..-1])
      else
        change_current_sensor(type: line_values[0], name: line_values[1])
      end
    end
  end

  def add_measurement_to_current_sensor(timestamp:, measurement_value:)
    Time.parse timestamp
    raise InvalidInput unless (current_sensor && current_measurements)

    current_measurements << measurement_value
  end

  def change_reference_values(values)
    @reference_values = {}

    values.each.with_index do |value, index|
      case index
      when 0
        reference_values[:temperature] = value
      when 1
        reference_values[:humidity] = value
      when 2
        reference_values[:ppm] = value
      end
    end
  end

  def change_current_sensor(type:, name:)
    @current_sensor = OpenStruct.new(
      type: type,
      name: name
    )

    @current_measurements = []
  end

  def update_current_sensor_standing
    return unless current_sensor
    return if current_measurements.blank?
    return unless reference_values

    UpdateSensorStanding.call(
      current_sensor,
      current_measurements,
      reference_values,
      standings_of_sensors
    )
  end

  def input_lines
    @input_lines ||= input.split("\n")
  end

  def standings_of_sensors
    @standings_of_sensors ||= {}
  end

  class InvalidInput < StandardError
  end
end
