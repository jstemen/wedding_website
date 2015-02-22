class InvitationGroupsController < ApplicationController
  before_action :set_invitation_group, only: [:edit, :update, :destroy]

  # GET /invitation_groups
  # GET /invitation_groups.json
  def index
    @invitation_groups = InvitationGroup.all
  end

  def search
    @new_guest = Guest.new
    @invitation_group = InvitationGroup.find_by_code(params[:code])
    render :show_events
  end

  # GET /invitation_groups/1
  # GET /invitation_groups/1.json
  def show
    code = params[:code]
    @invitation_group = InvitationGroup.find_by_code code
    @invitation_group.guests.build
  end


  def show_events
    code = params[:code]
    @invitation_group = InvitationGroup.find_by_code code
  end


  # GET /invitation_groups/new
  def new
    @invitation_group = InvitationGroup.new
  end

  # GET /invitation_groups/1/edit
  def edit
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
  end

  # PATCH/PUT /invitation_groups/1
  # PATCH/PUT /invitation_groups/1.json
  def update

    respond_to do |format|
      if @invitation_group.update(invitation_group_params)
        #format.html { redirect_to @invitation_group, notice: 'Invitation group was successfully updated.' }
        format.html { redirect_to action: "confirmation", code: @invitation_group.code, notice: 'Invitation group was successfully updated.' }
        format.json { render :show, status: :ok, location: @invitation_group }
      else
        format.html { render :edit }
        format.json { render json: @invitation_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invitation_groups/1
  # DELETE /invitation_groups/1.json
  def destroy
    @invitation_group.destroy
    respond_to do |format|
      format.html { redirect_to invitation_groups_url, notice: 'Invitation group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_invitation_group
    @invitation_group = InvitationGroup.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def invitation_group_params
    params.require(:invitation_group).permit!
  end
end
