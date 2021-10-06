module ConditionsCustomerSuccessBalancing
  ## Checking the condition t=n/2 rounded down
  def number_available_customer_successes
    @customer_successes_away.size <= (@customer_successes.size / 2).floor
  end

  def available_customer_successes_not_empty
    @available_customer_successes.size < 2 ? @available_customer_successes[0].id : maximum_number_of_customer_successes
  end

  def tie_between_two_customer_successes
    @available_customer_successes[0].customers.count == @available_customer_successes[1].customers.count ? 0 : @available_customer_successes[0].id
  end

  def maximum_number_of_customer_successes
    @customer_successes.size < 1000 ? tie_between_two_customer_successes : 0
  end

  def max_number_customers
    @customers.size < 1_000_000
  end
end
