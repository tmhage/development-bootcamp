class Admin::SupportController < Admin::AdminController
  before_filter :load_helpscout_customers

  def index
  end

  def mailchimp
    if params[:helpscout] &&
      params[:helpscout][:ids].present?
      params[:helpscout][:ids].each do |id|
        HelpscoutToMailchimpWorker.perform_async(id)
      end
      redirect_to admin_support_path, notice: "#{params[:helpscout][:ids].size} Customers will be imported shortly"
    else
      redirect_to admin_support_path, error: "Please select customers to import first"
    end
  end

  private

  def load_helpscout_customers
    @helpscout ||= HelpScout::Client.new(ENV["HELPSCOUT_API_KEY"])
    @helpscout_customers ||= @helpscout.customers
  end

  def helpscout_params
    params.require(:helpscout).permit(:ids)
  end
end
