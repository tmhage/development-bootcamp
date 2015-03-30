$ ->
  DBC.Orders.init()

DBC = DBC || {}

DBC.Orders = {
  init: ->
    $('#order_promo_code').change (e) ->
      DBC.Orders.validate_promo_code()

    if $('#orderForm').find('.alert').length > 0
      $('html, body').animate({
        scrollTop: $("#orderForm h2").offset().top
      }, 600)

  validate_promo_code: ->
    form = $('form#new_order')
    form.find('#order_validate_promo_code').val(1)
    form.submit()
}
