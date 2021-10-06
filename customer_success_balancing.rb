require_relative 'models/customer_success'
require_relative 'models/customer'
require_relative 'modules/recover_models_as_array'
require_relative 'modules/conditions_customer_success_balancing'
require 'minitest/autorun'
require 'timeout'

class CustomerSuccessBalancing
  include RecoverModelsAsArray
  include ConditionsCustomerSuccessBalancing

  attr_accessor :customers, :customer_successes, :customer_successes_away, :available_customer_successes

  def initialize(customer_success, customers, away_customer_success)
    @customer_successes = customer_success
    @customers = customers
    @customer_successes_away = away_customer_success
    @available_customer_successes = []
  end

  # Returns the ID of the customer success with most customers
  def execute
    if number_available_customer_successes && max_number_customers
      @available_customer_successes = recover_available_cs_sorted_by_score
      @customers = recover_customers_sorted_by_score
      @available_customer_successes = match_customers_to_customer_successes.sort_by(&:number_of_customers).reverse!
      return winning_customer_success_id
    end
    0
  end

  private

  def match_customers_to_customer_successes
    @customers.each do |customer|
      @available_customer_successes.each do |available_customer_success|
        if customer.score > available_customer_success.score
          next
        end
        customer.customer_success.nil? ? available_customer_success.add_customer(customer) : next
      end
    end
    @available_customer_successes
  end

  def winning_customer_success_id
    @available_customer_successes.size.zero? ? 0 : available_customer_successes_not_empty
  end
end

class CustomerSuccessBalancingTests < Minitest::Test
  def test_scenario_one
    balancer = CustomerSuccessBalancing.new(
      build_scores([60, 20, 95, 75]),
      build_scores([90, 20, 70, 40, 60, 10]),
      [2, 4]
    )
    assert_equal 1, balancer.execute
  end

  def test_scenario_two
    balancer = CustomerSuccessBalancing.new(
      build_scores([11, 21, 31, 3, 4, 5]),
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_scenario_three
    balancer = CustomerSuccessBalancing.new(
      build_scores(Array(1..999)),
      build_scores(Array.new(10000, 998)),
      [999]
    )
    result = Timeout.timeout(1.0) { balancer.execute }
    assert_equal 998, result
  end

  def test_scenario_four
    balancer = CustomerSuccessBalancing.new(
      build_scores([1, 2, 3, 4, 5, 6]),
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      []
    )
    assert_equal 0, balancer.execute
  end

  def test_scenario_five
    balancer = CustomerSuccessBalancing.new(
      build_scores([100, 2, 3, 3, 4, 5]),
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      []
    )
    assert_equal 1, balancer.execute
  end

  def test_scenario_six
    balancer = CustomerSuccessBalancing.new(
      build_scores([100, 99, 88, 3, 4, 5]),
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      [1, 3, 2]
    )
    assert_equal 0, balancer.execute
  end

  def test_scenario_seven
    balancer = CustomerSuccessBalancing.new(
      build_scores([100, 99, 88, 3, 4, 5]),
      build_scores([10, 10, 10, 20, 20, 30, 30, 30, 20, 60]),
      [4, 5, 6]
    )
    assert_equal 3, balancer.execute
  end

  private

  def build_scores(scores)
    scores.map.with_index do |score, index|
      { id: index + 1, score: score }
    end
  end
end