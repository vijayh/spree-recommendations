module Spree::RecommendationsHelper

  # grab a random list of recommendations (default = 3), augmented with (different) products from the same taxon
  # NOTE: products doesn't return products from children; but wait now for PGs
  def random_recommendations(product, count = 3)
    recs = product.recommendations.map{|r| r.recommended_product }.take(count)
    rest = []
    if (diff = count - recs.count) <= 0
      recs
    else
      unless product.taxons.empty?
        rest = product.taxons.first.products.active.
               reject {|p| p == product || recs.include?(p)}.
               take(diff)
      else
        rest = []
      end
      recs + rest
    end
  end

  def random_cart_recommendations
    recs = @order.line_items.collect do |line_item|
      random_recommendations(line_item.product, 3) 
    end
    recs.flatten
  end

end
