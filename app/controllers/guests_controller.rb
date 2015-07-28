class GuestsController < ApplicationController
  before_action :authenticate_admin!

  def new
    #params[:invitation_group_id]
    @guest = Guest.new
  end

  def create
    perm= params.permit(guest: [:first_name, :last_name, :email_address]).tap do |p|
      p[:guest][:invitation_group_id] = params[:invitation_group_id]
    end
    if Guest.new(perm[:guest]).save

      id = perm['guest']['invitation_group_id']
      redirect_to(edit_invitations_url(id), notice: 'Guest was successfully created.')
    else
      @guest = Guest.new(perm[:guest])
      render :new
    end
  end

  def edit
    @guest = Guest.find params[:id]
  end

  def update
    perm= params.permit(guest: [:first_name, :last_name, :email_address])
    guest = Guest.find(params[:id])

    if guest.update perm['guest']
      redirect_to(edit_invitations_url(params[:invitation_group_id]), notice: 'Guest was successfully updated.')
    else
      redirect_to guest
    end
  end

end
