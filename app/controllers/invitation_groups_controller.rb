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

  #ToDo lock this down
  def invitation_group_params
    params.require(:invitation_group).permit!
  end
end
