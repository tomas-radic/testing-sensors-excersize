require 'rails_helper'

shared_examples 'printing expected output' do
  it 'Outputs expected results' do
    expect { print(expected_output) }.to output.to_stdout

    evaluator
  end
end

describe SensorEvaluator do
  subject(:evaluator) { described_class.new(input).call }

  context 'Input file with standard measurements (excersize example)' do
    let!(:input) { file_fixture("standard_measurements.txt").read }
    let!(:expected_output) do
      {
        "temp-1" => "precise",
        "temp-2" => "ultra-precise",
        "hum-1" => "keep",
        "hum-2" => "discard",
        "mon-1" => "keep",
        "mon-2" => "discard"
      }
    end

    it_behaves_like 'printing expected output'
  end

  context 'Input file with "reference" line contained multiple times' do
    let!(:input) { file_fixture("multiple_reference_lines.txt").read }
    let!(:expected_output) do
      {
        "temp-1" => "precise",
        "temp-2" => "precise",
        "hum-1" => "keep",
        "hum-2" => "discard",
        "mon-1" => "keep",
        "mon-2" => "discard"
      }
    end

    it_behaves_like 'printing expected output'
  end

  context 'Input file with multiple groups of measurements of particular sensor' do
    let!(:input) { file_fixture("multiple_measurement_groups_of_particular_sensor.txt").read }
    let!(:expected_output) do
      {
        "temp-1" => "precise",
        "temp-2" => "precise",
        "hum-1" => "keep",
        "hum-2" => "discard",
        "mon-1" => "discard",
        "mon-2" => "discard"
      }
    end

    it_behaves_like 'printing expected output'
  end

  context 'Invalid input file' do
    let!(:input) { file_fixture("invalid_content.txt").read }

    it 'Outputs "Input is invalid."' do
      expect { print('Input is invalid.') }.to output.to_stdout

      evaluator
    end
  end

  # TODO: expect InvalidInput
end
