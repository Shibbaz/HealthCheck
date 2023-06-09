class UpdateUserMailer < ApplicationMailer
  def afterwards
    @mail = params[:receiver]
    @password = params[:password]

    mail(to: @mail, subject: 'Update Account') do |format|
      format.text do
        render html: "#{@name}, You have updated the account! #{@mail}, #{@password}"
      end
    end
  end
end
