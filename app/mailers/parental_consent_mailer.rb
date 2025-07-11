class ParentalConsentMailer < ApplicationMailer
  default from: 'noreply@assignment.com'

  def consent_request(user)
    @user = user
    @consent_url = parental_consent_url(token: @user.parental_consent_token)

    mail(
      to: @user.parent_email,
      subject: "Parental Consent Required for #{@user.first_name}'s Account"
    )
  end

  def consent_approved(user)
    @user = user

    mail(
      to: @user.email,
      subject: "Your Account Has Been Approved!"
    )
  end

  def consent_rejected(user)
    @user = user

    mail(
      to: @user.email,
      subject: "Account Approval Update"
    )
  end
end
