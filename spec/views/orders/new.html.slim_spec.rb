require 'rails_helper'

RSpec.describe "orders/new", :type => :view do
  describe 'step:' do
    before { assign :order, order }

    describe 'tickets' do
      let(:order) { build(:order_step_tickets) }

      it "renders new order form" do
        render

        assert_select "form[action=?][method=?]", tickets_path, "post" do
          assert_select "input#order_cart_community[name=?]", "order[cart][community]"
          assert_select "input#order_cart_normal[name=?]", "order[cart][normal]"
          assert_select "input#order_cart_supporter[name=?]", "order[cart][supporter]"

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
            billing_phone billing_company_name)

          fields.each do |f|
            assert_select "input#order_#{f}[name=?]", "order[#{f}]"
          end

          assert_select "input#order_terms_and_conditions[name=?][type=?]", "order[terms_and_conditions]", 'checkbox'
          assert_select "select#order_billing_country[name=?]", "order[billing_country]"

          assert_select "input[type=text]", count: fields.size

          assert_select "input[type=submit]", count: 2
          assert_select "input[type=submit]", value: "Continue"
          assert_select "input[type=submit]", value: "Back", name: 'back_button'
        end
      end
    end

    describe 'students-0' do
      let(:order) { build(:order_step_students) }

      it "renders new order form" do
        render

        assert_select "form[action=?][method=?]", tickets_path, "post" do
          text_fields = [:first_name, :last_name, :twitter_handle, :github_handle]
          text_areas = [:remarks, :allergies]

          text_fields.each do |f|
            assert_select "input#order_students_attributes_0_#{f}[name=?]", "order[students_attributes][0][#{f}]"
          end

          assert_select "input#order_students_attributes_0_email[name=?]", "order[students_attributes][0][email]"

          text_areas.each do |f|
            assert_select "textarea#order_students_attributes_0_#{f}[name=?]", "order[students_attributes][0][#{f}]"
          end

          assert_select "select#order_students_attributes_0_preferred_level[name=?]", "order[students_attributes][0][preferred_level]"

          assert_select "select#order_students_attributes_0_birth_date_1i[name=?]", "order[students_attributes][0][birth_date(1i)]"
          assert_select "select#order_students_attributes_0_birth_date_2i[name=?]", "order[students_attributes][0][birth_date(2i)]"
          assert_select "select#order_students_attributes_0_birth_date_3i[name=?]", "order[students_attributes][0][birth_date(3i)]"

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
