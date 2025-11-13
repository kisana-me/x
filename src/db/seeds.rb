# migration2
file_path = Rails.root.join("data.json")
data = JSON.parse(File.read(file_path))

# アカウント読み込み
data.find { |i| i["type"] == "table" && i["name"] == "accounts" }["data"].each do |d|
  Account.create!(
    name: d["name"],
    name_id: d["name_id"],
    description: d["bio"],
    created_at: d["created_at"],
    updated_at: d["updated_at"]
  )
end

# 投稿読み込み
data.find { |i| i["type"] == "table" && i["name"] == "posts" }["data"].each do |d|
  Post.create!(
    account_id: d["account_id"],
    post_id: d["post_id"],
    aid: d["name_id"],
    content: d["content"],
    created_at: d["created_at"],
    updated_at: d["updated_at"]
  )
end

# リアクション読み込み
data.find { |i| i["type"] == "table" && i["name"] == "reactions" }["data"].each do |d|
  Reaction.create!(
    account_id: d["account_id"],
    post_id: d["post_id"],
    kind: d["kind"].to_i,
    created_at: d["created_at"],
    updated_at: d["updated_at"]
  )
end
