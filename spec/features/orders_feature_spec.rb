require 'rails_helper'

describe 'the ticket order process' do
  let(:num_tickets) { 1 }

  before do
    create(:bootcamp)

    visit '/tickets'
    expect(page).to have_content 'Choose your tickets'

    within('#orderForm') do
      fill_in 'order_cart_normal', with: num_tickets
    end

    click_button 'Continue'
  end

  describe 'Choose your tickets' do
    context 'when no tickets are selected' do
      let(:num_tickets) { 0 }

      it 'should post and not render billing details, but stay on the ticket page' do
        expect(page).to have_content 'Choose your tickets'
      end
    end

    context 'when tickets ARE selected' do
      it 'posts and renders billing details' do
        expect(page).to have_content 'Billing Details'
      end

      context 'when two tickets were selected' do
        let(:num_tickets) { 2 }

        it 'shows two "student steps" in the list at the top' do
          expect(page).to have_selector '.number[title="Student Details 1"]'
          expect(page).to have_selector '.number[title="Student Details 2"]'
        end
      end

      context 'Billing Details' do
        before do
          expect(page).to have_content 'Billing Details'

          within('#orderForm') do
            fill_in 'Full name', with: Faker::Name.name
            fill_in 'Email', with: Faker::Internet.email
            fill_in 'Address', with: Faker::Address.street_address
            fill_in 'Postal code', with: Faker::Address.zip_code
            fill_in 'City', with: Faker::Address.city
            select 'Austria', from: 'order_billing_country'
            fill_in 'Phone', with: Faker::PhoneNumber.phone_number
            fill_in 'Company name', with: Faker::Company.name
            check 'I have read and agree to the Terms and Conditions, and the Cancellation Policy'
          end

          click_button 'Continue'
        end

        it 'should post and render the "Student Details 1" step' do
          expect(page).to have_content 'Student Details'
        end

        context 'Student Details' do
          before do
            expect(page).to have_content 'Student Details'

            within('#orderForm') do
              fill_in 'First name', with: Faker::Name.first_name
              fill_in 'Last name', with: Faker::Name.last_name
              fill_in 'Email', with: Faker::Internet.email
              fill_in 'Twitter handle', with: Faker::Internet.user_name
              fill_in 'Remarks', with: Faker::Lorem.paragraph(4)
              select (1940..2000).to_a.sample, from: 'order_students_attributes_0_birth_date_1i'
              select 'January', from: 'order_students_attributes_0_birth_date_2i'
              select (1..28).to_a.sample, from: 'order_students_attributes_0_birth_date_3i'
              fill_in 'Github handle', with: Faker::Internet.user_name

              click_button 'Continue'
            end
          end

          it 'posts and renders the "confirmation" step' do
            expect(page).to have_content 'Confirmation'
          end

          describe 'Payment' do
            before do
              click_button 'Continue'
              expect(page).to have_content 'Order & Payment'
            end
          end
        end
      end
    end
  end
end
