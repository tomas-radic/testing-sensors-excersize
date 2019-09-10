require 'rails_helper'

describe UpdateTemperatureSensorStanding do
  subject(:service) do
    described_class.call(
      sensor,
      sensor_measurements,
      reference_temperature,
      standings_of_sensors
    )
  end

  let!(:sensor) { OpenStruct.new(type: 'thermometer', name: 'therm-1') }
  let!(:sensor_measurements) { [] }
  let!(:reference_temperature) { 25.8 }
  let!(:standings_of_sensors) do
    {}
  end

  describe 'Ultra precise thermometer' do
    it 'Sets "ultra-precise" value to standings_of_sensors for given sensor' do
      expect(ValuesStatistics).to receive(:call)
          .with(sensor_measurements)
          .and_return(OpenStruct.new(result: { average: 25.3, maximum_deviation: 2.9 }))

      service

      expect(standings_of_sensors[sensor.name]).to eq 'ultra-precise'
    end
  end

  describe 'Very precise thermometer' do
    it 'Sets "very-precise" value to standings_of_sensors for given sensor' do
      expect(ValuesStatistics).to receive(:call)
          .with(sensor_measurements)
          .and_return(OpenStruct.new(result: { average: 25.3, maximum_deviation: 4.9 }))

      service

      expect(standings_of_sensors[sensor.name]).to eq 'very-precise'
    end
  end

  describe 'Precise thermometer' do
    context 'When mean is too high to be very precise' do
      it 'Sets "precise" value to standings_of_sensors for given sensor' do
        expect(ValuesStatistics).to receive(:call)
            .with(sensor_measurements)
            .and_return(OpenStruct.new(result: { average: 25.2, maximum_deviation: 1.0 }))

        service

        expect(standings_of_sensors[sensor.name]).to eq 'precise'
      end
    end

    context 'When maximum_deviation is too high to be very precise' do
      it 'Sets "precise" value to standings_of_sensors for given sensor' do
        expect(ValuesStatistics).to receive(:call)
            .with(sensor_measurements)
            .and_return(OpenStruct.new(result: { average: 25.8, maximum_deviation: 5.1 }))

        service

        expect(standings_of_sensors[sensor.name]).to eq 'precise'
      end
    end
  end

  context 'When standings_of_sensors already contains higher quality record for given sensor' do
    let!(:standings_of_sensors) do
      { sensor.name => "ultra-precise" }
    end

    it 'Updates the record for the sensor in standings_of_sensors' do
      expect(ValuesStatistics).to receive(:call)
          .with(sensor_measurements)
          .and_return(OpenStruct.new(result: { average: 25.8, maximum_deviation: 4.9 }))

      service

      expect(standings_of_sensors[sensor.name]).to eq 'very-precise'
    end
  end

  context 'When standings_of_sensors already contains lower quality record for given sensor' do
    let!(:standings_of_sensors) do
      { sensor.name => "very-precise" }
    end

    it 'Does not update the record for the sensor in standings_of_sensors' do
      expect(ValuesStatistics).to receive(:call)
          .with(sensor_measurements)
          .and_return(OpenStruct.new(result: { average: 25.8, maximum_deviation: 1.9 }))

      service

      expect(standings_of_sensors[sensor.name]).to eq 'very-precise'
    end
  end
end
