require_relative 'customer_success'

class Customer
  attr_accessor :id, :score, :customer_success

  def initialize(id: 0, score: 0)
    @id = id
    @score = score
    @customer_success = nil

    validate!
  end

  def add_customer_success(customer_success)
    @customer_success = customer_success
  end

  def to_hash
    instance_variables.map do |attribute|
      [attribute[1..-1].to_sym, instance_variable_get(attribute)]
    end.to_h
  end

  private

  def validate!
    raise ArgumentError.new(message: 'ID must be between 0 and 1000000') unless @id.positive? && @id < 1_000_000
    raise ArgumentError.new(message: 'Score must be between 0 and 10000') unless @score.positive? && @score < 100_000
  end
end