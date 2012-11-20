class ContactUsController < ApplicationController
    skip_filter :login
    def show

    end
    
    def index

    end
    
  def create
      mailp = params[:mail]
      from = 'project.conman@gmail.com'
      p = 'Raging_Flamingos'
      email = Mail.new do
          from     mailp[:email]
          to       'project.conman@gmail.com'
          subject  'Comment'
          body     "Comment from: #{mailp[:email]} \r #{mailp[:comment]}"
      end
      
      Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
      Net::SMTP.start('smtp.gmail.com',587,'gmail.com',from,p,:login) do |smtp|
          smtp.send_message email.to_s(),from,from
      end
      flash[:notice] ="We have receive your comment. Thank you for your time"
      redirect_to contact_us_path
  end


end
