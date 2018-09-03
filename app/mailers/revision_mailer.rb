class RevisionMailer < ActionMailer::Base
  TO_ADDRESS = 'welsh.editors@moneyadviceservice.org.uk'.freeze
  SUBJECT    = 'Content updated by External Editor'.freeze

  default from: ENV['MAILJET_DEFAULT_FROM_ADDRESS']

  def external_editor_change(user:, page:)
    @page = page
    @user = user
    mail(to: TO_ADDRESS, subject: SUBJECT)
  end
end
