class ParentalConsentController < ApplicationController
  skip_before_action :authenticate_user!
  
  def show
    @user = User.find_by(parental_consent_token: params[:token])
    
    if @user.nil?
      redirect_to root_path, alert: 'Invalid consent link.'
      return
    end
    
    if @user.approved?
      redirect_to root_path, notice: 'Parental consent has already been approved.'
      return
    end
  end
  
  def approve
    @user = User.find_by(parental_consent_token: params[:token])
    
    if @user.nil?
      redirect_to root_path, alert: 'Invalid consent link.'
      return
    end
    
    # Change this line from string to enum method
    @user.approved!
    @user.update!(parental_consent_approved_at: Time.current)
    
    # Send confirmation email to the child
    ParentalConsentMailer.consent_approved(@user).deliver_later
    
    redirect_to root_path, notice: 'Parental consent approved successfully! Your child can now join organizations.'
  end
  
  def reject
    @user = User.find_by(parental_consent_token: params[:token])
    
    if @user.nil?
      redirect_to root_path, alert: 'Invalid consent link.'
      return
    end
    
    @user.rejected!
    
    # Send notification email to the child
    ParentalConsentMailer.consent_rejected(@user).deliver_later
    
    redirect_to root_path, notice: 'Parental consent has been rejected.'
  end
end 