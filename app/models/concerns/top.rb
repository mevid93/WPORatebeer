module Top
  extend ActiveSupport::Concern

  def top(var_n)
    sorted_by_rating_in_desc_order = all.sort_by{ |b| -(b.average_rating || 0) }
    return [] if sorted_by_rating_in_desc_order.empty?

    result = sorted_by_rating_in_desc_order[0..var_n - 1]
    result.compact
  end
end
