require_relative 'customer'

class CustomerSuccess
  attr_accessor :id, :score, :customers
  attr_reader :customers_size

  def initialize(id: 0, score: 0)
    @id = id
    @score = score
    @customers = []

    validate!
  end

  def add_customer(customer)
    customer.add_customer_success(self)
    @customers << customer
  end

  def number_of_customers
    @customers.size
  end

  def to_hash
    instance_variables.map do |attribute|
      [attribute[1..-1].to_sym, instance_variable_get(attribute)]
    end.to_h
  end

  private

  def validate!
    raise ArgumentError.new(message: 'ID must be between 0 and 1000') unless @id.positive? && @id < 1_000
    raise ArgumentError.new(message: 'Score must be between 0 and 10000') unless @score.positive? && @score < 10_000
  end
end
