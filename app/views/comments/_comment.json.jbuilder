json.extract! comment, :id, :content
json.author do
  json.id comment.comment_author.id
  json.name comment.comment_author.name
end
json.snippet_id comment.snippet.id
