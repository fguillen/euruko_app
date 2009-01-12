class ShoppingCart
  def self.paypal_url(events, return_url, notify_url)
    values = {
      :business => 'seller_1231200230_biz@gmail.com',
      :cmd => '_cart',
      :upload => 1,
      :return => return_url,
      :invoice => Time.now.to_i, # TODO this is not correct, it has to be unique
      :notify_url => notify_url
    }
    events.each_with_index do |event, index|
      values.merge!({
        "amount_#{index+1}" => event.price_cents,
        "item_name_#{index+1}" => event.name,
        "item_number_#{index+1}" => event.id,
        "quantity_#{index+1}" => 1
      })
    end
    "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
  end
end