json.array!(@invitation_groups) do |invitation_group|
  json.extract! invitation_group, :id
  json.url invitation_group_url(invitation_group, format: :json)
end
