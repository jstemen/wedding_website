class GuestsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_guest, only: [:show, :edit, :update, :destroy]

  def new
    @guest = Guest.new
  end

  def create
    @guest = Guest.new(guest_params[:guest])
    if @guest.save
      id = guest_params['guest']['invitation_group_id']
      redirect_to(edit_invitations_url(id), notice: 'Guest was successfully created.')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @guest.update guest_params['guest']
      redirect_to(edit_invitations_url(params[:invitation_group_id]), notice: 'Guest was successfully updated.')
    else
      render :edit
    end
  end

  private

  def guest_params
    perm= params.permit(guest: [:first_name, :last_name, :email_address]).tap do |p|
      p[:guest][:invitation_group_id] = params[:invitation_group_id]
    end
    perm
  end

  def set_guest
    @guest = Guest.find params[:id]
  end

end
