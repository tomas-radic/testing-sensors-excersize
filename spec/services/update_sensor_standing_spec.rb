require 'rails_helper'

describe UpdateSensorStanding do
  subject(:service) do
    described_class.call(
      sensor,
      sensor_measurements,
      reference_values,
      standings_of_sensors
    )
  end

  let!(:sensor_measurements) { [] }

  let!(:reference_values) do
    {
      temperature: 25.7,
      humidity: 58.3,
      ppm: 4
    }
  end

  let!(:standings_of_sensors) do
    {}
  end

  context 'With temperature sensor' do
    let!(:sensor) { OpenStruct.new(type: 'thermometer', name: 'therm-1') }

    it 'Calls specific updater' do
      expect(UpdateTemperatureSensorStanding).to receive(:call)
          .with(
            sensor,
            sensor_measurements,
            reference_values[:temperature],
            standings_of_sensors
          )

      service
    end
  end

  context 'With humidity sensor' do
    let!(:sensor) { OpenStruct.new(type: 'humidity', name: 'hum-1') }

    it 'Calls specific updater' do
      expect(UpdateHumiditySensorStanding).to receive(:call)
          .with(
            sensor,
            sensor_measurements,
            reference_values[:humidity],
            standings_of_sensors
          )

      service
    end
  end

  context 'With monoxide sensor' do
    let!(:sensor) { OpenStruct.new(type: 'monoxide', name: 'mon-1') }

    it 'Calls specific updater' do
      expect(UpdateMonoxideSensorStanding).to receive(:call)
          .with(
            sensor,
            sensor_measurements,
            reference_values[:ppm],
            standings_of_sensors
          )

      service
    end
  end
end
