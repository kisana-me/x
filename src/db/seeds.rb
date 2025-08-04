# migration1
file_path = Rails.root.join("data.json")
data = JSON.parse(File.read(file_path))
data["account_post"].each do |d|
  account = Account.create!(
    name: d["name"],
    name_id: d["name_id"],
    description: d["bio"],
    anyur_id: d["anyur_id"],
    created_at: d["created_at"],
    updated_at: d["updated_at"]
  )
  d["posts"].each do |p|
    Post.create!(
      aid: p["name_id"],
      account: account,
      content: p["content"],
      created_at: p["created_at"],
      updated_at: p["updated_at"]
    )
  end
end
data["reaction"].each do |r|
  Reaction.create!(
    account: Account.find_by(name_id: r["account"]["name_id"]),
    post: Post.find_by(aid: r["post"]["name_id"]),
    kind: r["kind"]
  )
end
