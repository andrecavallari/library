module WardenConcern
  extend ActiveSupport::Concern

  delegate :authenticate!, to: :warden

  included do
    before_action :authenticate!
  end

  def current_user = @current_user ||= warden.authenticate(scope: :user)
  def user_signed_in? = !current_user.blank?
  def warden = request.env['warden']
end
