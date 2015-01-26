require 'rails_helper'

RSpec.describe "orders/new", :type => :view do
  describe 'step:' do
    before { assign :order, order }

    describe 'tickets' do
      let(:order) { build(:order_step_tickets) }

      it "renders new order form" do
        render

        assert_select "form[action=?][method=?]", tickets_path, "post" do
          assert_select "input#order_cart_early_bird[name=?]", "order[cart][early_bird]"
          assert_select "input#order_cart_normal[name=?]", "order[cart][normal]"
          assert_select "input#order_cart_supporter[name=?]", "order[cart][supporter]"

          assert_select "label[for=?]", "order_cart_early_bird", text: "Early Bird Ticket (€ #{Order.new.ticket_prices[:early_bird]}.-)*"
          assert_select "label[for=?]", "order_cart_normal", text: "Normal Ticket (€ #{Order.new.ticket_prices[:normal]}.-)*"
          assert_select "label[for=?]", "order_cart_supporter", text: "Supporter Ticket (€ #{Order.new.ticket_prices[:supporter]}.-)*"

          assert_select "input[type=submit]", count: 1 # No back button in this step
          assert_select "input[type=submit]", value: "Continue"
        end
      end
    end

    describe 'details' do
      let(:order) { build(:order_step_details) }

      it "renders new order form" do
        render

        assert_select "form[action=?][method=?]", tickets_path, "post" do
          fields = %w(billing_name billing_email billing_address billing_postal billing_city
            billing_country billing_phone billing_company_name)

          fields.each do |f|
            assert_select "input#order_#{f}[name=?]", "order[#{f}]"
          end

          assert_select "input[type=text]", count: fields.size

          assert_select "input[type=submit]", count: 2
          assert_select "input[type=submit]", value: "Continue"
          assert_select "input[type=submit]", value: "Back", name: 'back_button'
        end
      end
    end

    describe 'students-1' do
      let(:order) { build(:order_step_students) }

      it "renders new order form" do
        render

        assert_select "form[action=?][method=?]", tickets_path, "post" do
          text_fields = [:first_name, :last_name, :twitter_handle, :github_handle]
          text_areas = [:remarks, :allergies]

          text_fields.each do |f|
            assert_select "input#order_students_attributes_1_#{f}[name=?]", "order[students_attributes][1][#{f}]"
          end

          assert_select "input#order_students_attributes_1_email[name=?]", "order[students_attributes][1][email]"

          text_areas.each do |f|
            assert_select "textarea#order_students_attributes_1_#{f}[name=?]", "order[students_attributes][1][#{f}]"
          end

          assert_select "select#order_students_attributes_1_preferred_level[name=?]", "order[students_attributes][1][preferred_level]"

          assert_select "select#order_students_attributes_1_birth_date_1i[name=?]", "order[students_attributes][1][birth_date(1i)]"
          assert_select "select#order_students_attributes_1_birth_date_2i[name=?]", "order[students_attributes][1][birth_date(2i)]"
          assert_select "select#order_students_attributes_1_birth_date_3i[name=?]", "order[students_attributes][1][birth_date(3i)]"

          assert_select "input[type=text]", count: text_fields.size
          assert_select "input[type=email]", count: 1
          assert_select "textarea", count: text_areas.size
          assert_select "select", count: 4

          assert_select "input[type=submit]", count: 2
          assert_select "input[type=submit]", value: "Continue"
          assert_select "input[type=submit]", value: "Back", name: 'back_button'
        end
      end
    end
  end
end