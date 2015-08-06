require 'spec_helper'

describe InvitationGroupsController do
  describe '#update' do

    it "should redirect" do

      invitation_group = create(:invitation_group, :five_guests)

      invi_attr_hash = {"invitations_attributes" => {}}
      invitation_group.invitations.each_with_index { |invitation, i|
        invi_attr_hash["invitations_attributes"][i.to_s] ={"is_accepted" => "1", "id" => invitation.id.to_s}
      }

=begin
    post_body = {
        "invitations_attributes" => {"0" => {"is_accepted" => "1", "id" => "30"},
                                     "1" => {"is_accepted" => "0", "id" => "31"}
        }
    }
=end


      post_body = {'invitation_group' => invi_attr_hash}
      params = post_body.merge({'id' => invitation_group.id})

      put(:update, params)
      expect(response.status).to eq(302)
    end
  end
  describe '#show_events' do
    before do
      @invitation_group = create(:invitation_group, :five_guests)
    end
    it 'should find invitation groups when there are spaces in the code' do
      code = " #{@invitation_group.code} " 
      get(:show_events,{code: code})
     expect(response.status).to eq(200) 
    end
    it 'should find invitation groups when there are letters in the wrong case in the code' do
      code = @invitation_group.code.upcase
      get(:show_events,{code: code})
     expect(response.status).to eq(200) 
    end
  end

end
