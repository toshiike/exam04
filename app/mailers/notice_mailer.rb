class NoticeMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notice_mailer.sendmail_studysheet.subject
  #
  def sendmail_studysheet(studysheet)
    @studysheet = studysheet

    mail to: "toshiaki.ikeda.study@gmail.com",
         subject: '【Achieve】課題が投稿されました'
  end
end
