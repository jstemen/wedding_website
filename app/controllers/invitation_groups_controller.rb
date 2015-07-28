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
  end

  # ToDo make this better.  Is kind of hacky. Seems like there should be a more "rails" way of doing this.
  # Unable to add temp invitations for view to manipulate.
  # Rails automatically saves the invitations when adding them to the collection of invitations.
  def update_invitations
    authenticate_admin!
    ig = InvitationGroup.find params[:id]
    saved_keys = ig.invitations.collect { |inv|
      [view_context.generate_key(event: inv.event, guest: inv.guest), true]
    }.to_h

    # Add needed invitations
    params[:event_to_guests].each { |relation_str, val|
      if saved_keys[relation_str]
        # we're good
      else
        # Need to add one
        event, guest = view_context.extract_event_and_guest(relation_str)
        ig.invitations.build(event: event, guest: guest).save!
      end
    }

    # Remove old invitations
    saved_keys.each { |relation_str, val|
      if params[:event_to_guests][relation_str]
        # in both, good
      else
        # shouldn't be saved
        event, guest = view_context.extract_event_and_guest(relation_str)
        invitations = Invitation.where(event: event, guest: guest, invitation_group: ig)
        raise "more than one found" if invitations.size > 1
        Invitation.destroy(invitations.first.id)
      end
    }
    flash[:success] = 'Successfully updated invitation group!'
    redirect_to action: 'index'
  end

  # POST /invitation_groups
  # POST /invitation_groups.json
  def create
    authenticate_admin!
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
