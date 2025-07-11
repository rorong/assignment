class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Organization associations
  has_many :organization_memberships, dependent: :destroy
  has_many :organizations, through: :organization_memberships
  has_many :administered_organizations, class_name: 'Organization', foreign_key: 'admin_id'

  before_create :generate_parental_consent_token, if: :minor?

  # Rails 8 enum syntax - first argument is the attribute name, second is the mapping
  enum :parental_consent_status, { pending: 0, approved: 1, rejected: 2 }, default: :pending

  validates :first_name, :last_name, presence: true
  validates :birth_date, presence: true

  def age
    return nil unless birth_date
    ((Date.current - birth_date) / 365.25).to_i
  end

  def minor?
    age < 18
  end

  def has_parental_consent?
    !minor? || parental_consent_status == 'approved'
  end

  def needs_parental_consent?
    minor? && parental_consent_status != 'approved'
  end

  def can_join_organizations?
    !minor? || parental_consent_status == 'approved'
  end

  def can_share_data?
    !minor? || parental_consent_status == 'approved'
  end

  def restricted_profile?
    minor? && parental_consent_status != 'approved'
  end

  def parental_consent_url
    Rails.application.routes.url_helpers.parental_consent_url(token: parental_consent_token)
  end

  after_create :send_parental_consent_email, if: :minor_with_parent_email?

  private

  def generate_parental_consent_token
    self.parental_consent_token = SecureRandom.urlsafe_base64(32)
  end

  def minor_with_parent_email?
    minor? && parent_email.present?
  end

  def send_parental_consent_email
    ParentalConsentMailer.consent_request(self).deliver_later
  end
end
