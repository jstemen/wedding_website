require 'spec_helper'

describe InvitationGroupsController do

  it "should be successful" do

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