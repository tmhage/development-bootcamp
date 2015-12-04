$ ->
  DBC.Orders.init()

DBC = DBC || {}

DBC.Orders = {
  init: ->
    $('#order_promo_code').change (e) ->
      DBC.Orders.validate_promo_code()

    $('#select_bootcamp .ticket').bind 'click', (e) ->
      ticket = $('#select_bootcamp .ticket:hover')
      return if ticket.hasClass 'ticket-selected'

      $('#select_bootcamp .ticket').removeClass('ticket-selected')
      $('#select_bootcamp input[type=number]').val(1)

      $.each($('#select_bootcamp .ticket'), (i,t) ->
        DBC.Orders.recalculate_price($(t))
      )

      DBC.Orders.select_bootcamp(ticket)

    $('#select_bootcamp input[type=number]').bind 'keyup blur', (e) ->
      ticket = $('#select_bootcamp .ticket:hover')
      DBC.Orders.recalculate_price(ticket)

    if $('#orderForm').find('.alert').length > 0
      $('html, body').animate({
        scrollTop: $("#orderForm h2").offset().top
      }, 600)

  validate_promo_code: ->
    form = $('form#new_order')
    form.find('#order_validate_promo_code').val(1)
    form.submit()

  select_bootcamp: (ticket) ->
    $(ticket).addClass('ticket-selected')
    $(ticket).find('input[type=number]').val(1)
    DBC.Orders.recalculate_price($(ticket))
    bootcamp_id = $(ticket).data('bootcamp-id')
    form = $('form#new_order')
    form.find('#order_bootcamp_id').val bootcamp_id

  recalculate_price: (ticket) ->
    price_tag = $(ticket.find('p.price'))
    amount = ticket.find('input[type=number]').val() || 1
    price = price_tag.data('price') * amount
    price_tag.html(DBC.Orders.formatted_price(price))

    old_price_tag = $(ticket.find('.old-price'))
    return if old_price_tag.length == 0

    old_price = old_price_tag.data('old-price') * amount
    old_price_tag.html(DBC.Orders.formatted_price(old_price))

  formatted_price: (price) ->
    parts = Math.round(price).toFixed(2).toString().split('.')
    root = parts[0]
    decimals = parts[1]
    regex = /(\d+)(\d{3})/
    root = root.replace(regex, '$1' + ',' + '$2') while root.match(regex)
    "€#{root}.#{decimals}";
}
