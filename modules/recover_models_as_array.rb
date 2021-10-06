module RecoverModelsAsArray
  def recover_available_cs_sorted_by_score
    @available_customer_successes = []
    @customer_successes.each do |cs|
      unless @customer_successes_away.include?(cs[:id])
        @available_customer_successes.push(CustomerSuccess.new(id: cs[:id], score: cs[:score]))
      end
    end
    @available_customer_successes.sort_by(&:score)
  end

  def recover_customers_sorted_by_score
    @customers_objects = []
    @customers.each do |customer|
      @customers_objects.push(Customer.new(id: customer[:id], score: customer[:score]))
    end
    @customers_objects.sort_by(&:score)
  end
end
