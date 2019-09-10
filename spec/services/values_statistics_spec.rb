require 'rails_helper'

describe ValuesStatistics do
  subject(:service_result) { described_class.call(values).result }

  let!(:values) { [25.0, 25.5, 25.3, 25.2] }

  it 'Returns mean and maximum deviation of given values' do
    expect(service_result[:average]).to eq 25.25
    expect(service_result[:maximum_deviation]).to eq 0.25
  end
end
