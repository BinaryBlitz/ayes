class Notifier
  def initialize(user, message, options = {})
    return unless user.device_token.present?

    @user = user
    @device_token = user.device_token
    @message = message
    @options = options
    push
  end

  def push
    return if @message.blank? && @device_token.blank?

    Rails.logger.debug "#{Time.zone.now} Notifying #{@user} with message: #{@message}"
    push_ios_notification(@device_token)
  end

  private

  def push_ios_notification(token)
    n = Rpush::Apns::Notification.new
    n.app = Rpush::Apns::App.find_by_name('ios_app')
    n.device_token = token
    n.alert = @message
    n.data = @options
    n.save!

    Rails.logger.debug "#{Time.zone.now} iOS notification: #{@message}, options: #{@options}"
  end
end
