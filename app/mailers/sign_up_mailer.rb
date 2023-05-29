class SignUpMailer < ApplicationMailer
    def afterwards
      @mail = params[:receiver]
      @name = params[:name]
      @phone_number = params[:phone_number]
  
      mail(to: @mail, subject: 'New Account') do |format|
        format.text { 
          render html: "#{@name}, You have created the account! #{@mail}, #{@phone_number}" 
        }
      end
    end
end