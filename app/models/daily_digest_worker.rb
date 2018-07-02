class DailyDigestWorker
  include Sidekiq::Worker
  include Sidetiq::Schendulable

  reccurrence { daily(1) }

  def perform
    User.find_each.each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end
end
