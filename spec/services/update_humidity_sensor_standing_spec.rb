require 'rails_helper'

describe UpdateHumiditySensorStanding do
  subject(:service) do
    described_class.call(
      sensor,
      sensor_measurements,
      reference_humidity,
      standings_of_sensors
    )
  end

  let!(:sensor) { OpenStruct.new(type: 'humidity', name: 'hum-1') }
  let!(:reference_humidity) { 1.0 }
  let!(:standings_of_sensors) do
    {}
  end

  describe 'Humidity sensor to keep' do
    let!(:sensor_measurements) { [1.01, 0.99] }

    it 'Sets "keep" value to standings_of_sensors for given sensor' do
      service

      expect(standings_of_sensors[sensor.name]).to eq 'keep'
    end
  end

  describe 'Humidity sensor to discard' do
    let!(:sensor_measurements) { [1.01, 1.011] }

    it 'Sets "discard" value to standings_of_sensors for given sensor' do
      service

      expect(standings_of_sensors[sensor.name]).to eq 'discard'
    end
  end

  context 'When standings_of_sensors already contains "keep" record for sensor to be discarded' do
    let!(:sensor_measurements) { [1.01, 1.011] }
    let!(:standings_of_sensors) do
      { sensor.name => "keep" }
    end

    it 'Updates the record for the sensor in standings_of_sensors' do
      service

      expect(standings_of_sensors[sensor.name]).to eq 'discard'
    end
  end

  context 'When standings_of_sensors already contains "discard" record for sensor to be kept' do
    let!(:sensor_measurements) { [1.01, 0.99] }
    let!(:standings_of_sensors) do
      { sensor.name => "discard" }
    end

    it 'Does not update the record for the sensor in standings_of_sensors' do
      service

      expect(standings_of_sensors[sensor.name]).to eq 'discard'
    end
  end
end
