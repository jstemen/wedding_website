class InvitationGroupsController < ApplicationController
  before_action :set_invitation_group, only: [:edit, :update, :destroy]

  def show_events
    code = params[:code]
    @invitation_group = InvitationGroup.find_by_code code
    if @invitation_group.nil?
      flash[:danger] = "You have entered the invalid RSVP code: \"#{code}\".  If you believe that you have received this message in error, please contact us via palakandjared@gmail.com, or call Veena at 678-232-4506."
      redirect_to "#{root_path}#rsvp"
    end
  end

  def edit_invitations
    authenticate_admin!
    id = params[:id]
    @invitation_group = InvitationGroup.find id
=begin
    already_invited = {}
    @invitation_group.invitations.each { |inv|
      already_invited["#{inv.guest.full_name}-#{inv.event.name}"] = true
    }

    Event.all.each { |event|
      @invitation_group.guests.each { |guest|
        unless already_invited["#{guest.full_name}-#{event.name}"]
          @invitation_group.invitations << Invitation.new(event: event, guest: guest)
        end
      }
    }
=end
  end

  # POST /invitation_groups
  # POST /invitation_groups.json
  def create
    @invitation_group = InvitationGroup.new(invitation_group_params)

    respond_to do |format|
      if @invitation_group.save
        #format.html { redirect_to @invitation_group, notice: 'Invitation group was successfully created.' }
        format.html { redirect_to action: "show", code: @invitation_group.code, notice: 'Invitation group was successfully created.' }
        format.json { render :show, status: :created, location: @invitation_group }
      else
        format.html { render :new }
        format.json { render json: @invitation_group.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    authenticate_admin!
    @invitation_groups = InvitationGroup.all
  end

  def confirmation
    code = params[:code]
    @invitation_group = InvitationGroup.find_by_code code
    @invitation_group.is_confirmed = true
  end

  def thank_you
    code = params[:code]
    @invitation_group = InvitationGroup.find_by_code code
  end

  # PATCH/PUT /invitation_groups/1
  # PATCH/PUT /invitation_groups/1.json
  def update

    respond_to do |format|
      if @invitation_group.update(invitation_group_params)
        if @invitation_group.is_confirmed
          format.html { redirect_to action: "thank_you", code: @invitation_group.code, notice: 'Invitation group was successfully updated.' }
        else
          format.html { redirect_to action: "confirmation", code: @invitation_group.code, notice: 'Invitation group was successfully updated.' }
        end
        format.json { render :show, status: :ok, location: @invitation_group }
      else
        format.html { render :edit }
        format.json { render json: @invitation_group.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_invitation_group
    @invitation_group = InvitationGroup.find(params[:id])
  end


  def invitation_group_params
=begin
    {
        "invitations_attributes" => {"0" => {"is_accepted" => "1", "id" => "30"},
                                     "1" => {"is_accepted" => "0", "id" => "31"}
        }
    }
=end
    inv_grp_params = params["invitation_group"]
    res= params.permit(:invitation_group).tap do |whitelisted|
      is_confirmed = inv_grp_params["is_confirmed"]
      if is_confirmed
        whitelisted[:is_confirmed] = is_confirmed
      end

      invi_attrs = inv_grp_params["invitations_attributes"]
      if invi_attrs
        whitelisted[:invitations_attributes] = invi_attrs
      end
    end
    res
  end
end
