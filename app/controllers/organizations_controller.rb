class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization, only: [:show, :edit, :update, :destroy, :join, :approve_member, :remove_member]
  before_action :authorize_organization_creation, only: [:new, :create]

  def index
    @organizations = Organization.all
  end

  def show
    @membership = current_user.organization_memberships.find_by(organization: @organization)
    @pending_members = can?(:manage, @organization) ? @organization.organization_memberships.pending : []
  end

  def new
    @organization = Organization.new
    authorize! :create, Organization
  end

  def create
    authorize! :create, Organization

    @organization = Organization.new(organization_params)
    @organization.admin = current_user

    if @organization.save
      # Auto-approve the creator as admin
      @organization.organization_memberships.create!(
        user: current_user,
        role: 'admin',
        approved: true
      )
      redirect_to @organization, notice: 'Organization created successfully!'
    else
      render :new
    end
  end

  def edit
    authorize! :manage, @organization
  end

  def update
    authorize! :manage, @organization
    
    if @organization.update(organization_params)
      redirect_to @organization, notice: 'Organization updated successfully!'
    else
      render :edit
    end
  end

  def destroy
    authorize! :manage, @organization
    @organization.destroy
    redirect_to organizations_path, notice: 'Organization deleted successfully!'
  end

  def join
    # Check if user can join organizations
    unless can? :join, Organization
      redirect_to @organization, alert: 'You do not have permission to join organizations.'
      return
    end

    # Check if already a member
    if current_user.organization_memberships.find_by(organization: @organization)
      redirect_to @organization, alert: 'You have already requested membership or are already a member.'
      return
    end

    @membership = current_user.organization_memberships.build(
      organization: @organization,
      role: 'member',
      status: 'pending'
    )

    if @membership.save
      redirect_to @organization, notice: 'Membership request sent successfully!'
    else
      redirect_to @organization, alert: 'Failed to send membership request.'
    end
  end

  def approve_member
    @membership = @organization.organization_memberships.find(params[:membership_id])
    @membership.update(approved: true)
    redirect_to @organization, notice: 'Member approved!'
  end

  def remove_member
    authorize! :manage, @organization
    @membership = @organization.organization_memberships.find(params[:membership_id])
    @membership.destroy
    redirect_to @organization, notice: 'Member removed successfully!'
  end


  private

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name, :description)
  end

  def authorize_organization_creation
    unless can? :create, Organization
      redirect_to organizations_path, alert: 'Only adults or minors with parental consent can create organizations.'
    end
  end
end 