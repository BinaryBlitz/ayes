class Notifier
  def initialize(user, message, options = {})
    @user = user
    @device_tokens = user.device_tokens
    @message = message
    @options = options
    push
  end

  def push
    return if @message.blank?

    Rails.logger.debug "#{Time.zone.now} Notifying #{@user} with message: #{@message}"

    android_tokens = @device_tokens.where(platform: 'android')
    push_android_notifications(android_tokens)
    ios_tokens = @device_tokens.where(platform: 'ios')
    push_ios_notifications(ios_tokens)
  end

  private

  def push_ios_notifications(tokens)
    return if tokens.blank?

    tokens.each do |token|
      n = Rpush::Apns::Notification.new
      n.app = Rpush::Apns::App.find_by_name('ios_app')
      n.device_token = token.token
      n.alert = @message
      n.data = @options
      n.save!

      Rails.logger.debug "#{Time.zone.now} Apple notification: #{@message}, options: #{@options}"
    end
  end
end
