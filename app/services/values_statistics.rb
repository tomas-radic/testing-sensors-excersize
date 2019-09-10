class ValuesStatistics < Patterns::Service
  pattr_initialize :values

  def call
    {
      average: average,
      maximum_deviation: maximum_deviation
    }
  end

  private

  def average
    @average ||= values.sum / values.length.to_f
  end

  def maximum_deviation
    @maximum_deviation ||= values.map { |v| (v - average).abs }.max
  end
end
