require 'rails_helper'

describe SensorEvaluator do
  subject(:service_result) { described_class.call(input).result }

  let!(:input) { file_fixture("measurements.txt").read }
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

  it 'Returns expected results' do
    result = service_result

    expect(result).to be_a(Hash)
    expect(result).to eq(expected_output)
  end

  # TODO: expect InvalidInput
end
