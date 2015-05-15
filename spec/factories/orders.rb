FactoryGirl.define do
  factory :order do
    payed_at { Time.now - 5.minutes }
    mollie_payment_id { 'tr_WDqYK6vllg' }
    refunded_at { Time.now - 2.minutes }
    mollie_refund_id { 'tr_WDqYK6aarb' }
    billing_name { Faker::Name.name }
    billing_email { Faker::Internet.email }
    billing_address { Faker::Address.street_address }
    billing_postal { Faker::Address.zip_code }
    billing_city { Faker::Address.city }
    billing_country { Faker::Address.country }
    billing_phone { Faker::PhoneNumber.phone_number }
    billing_company_name { Faker::Company.name }
    terms_and_conditions true
    confirmed_at { Time.now - 6.minutes }
    cart { { community: 1, normal: 0, supporter: 0 } }

    after(:build) do |order, evaluator|
      if order.cart_sum_tickets > 0
        order.students = build_list(:student, order.cart_sum_tickets)
      end
    end
  end

  factory :order_step_tickets, class: 'Order' do
    current_step 'tickets'
    cart { { community: 0, normal: 1, supporter: 0 } }

    factory :order_step_details, class: 'Order' do
      current_step 'details'
      billing_name { Faker::Name.name }
      billing_email { Faker::Internet.email }
      billing_address { Faker::Address.street_address }
      billing_postal { Faker::Address.zip_code }
      billing_city { Faker::Address.city }
      billing_country { Faker::Address.country }
      billing_phone { Faker::PhoneNumber.phone_number }
      billing_company_name { Faker::Company.name }
      terms_and_conditions true

      factory :order_step_students, class: 'Order' do
        cart { { community: 0, normal: 1, supporter: 0 } }

        after(:build) do |order, evaluator|
          if order.cart_sum_tickets > 0
            order.students = build_list(:student, order.cart_sum_tickets)
          end
          order.current_step = 'students-0'
        end

        factory :order_step_confirmation, class: 'Order' do
          current_step 'confirmation'
          confirmed_at { Time.now - 6.minutes }

          factory :order_step_payment, class: 'Order' do
            current_step nil
            mollie_payment_id { 'tr_WDqYK6vllg' }

            factory :order_step_paid, class: 'Order' do
              price { cart_sum_total }
              payed_at { Time.now - 5.minutes }

              factory :order_step_refund, class: 'Order' do
                mollie_refund_id { 'tr_WDqYK6aarb' }

                factory :order_step_refunded, class: 'Order' do
                  refunded_at { Time.now - 2.minutes }
                end
              end
            end
          end
        end
      end
    end
  end
end
