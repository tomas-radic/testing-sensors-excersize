module StandingNumbers
  extend ActiveSupport::Concern

  private

  def current_sensor_standing_number(quality_levels)
    @sensor_standing_number ||= quality_levels.find do |level, level_name|
      standings_of_sensors[sensor.name] == level_name
    end&.first
  end

  def minimum_sensor_standing_number(quality_levels)
    @minimum_sensor_standing_number ||= (current_sensor_standing_number(quality_levels) || 0)
  end
end
