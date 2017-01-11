json.extract! snippet, :id, :title, :content
json.author do
  json.id snippet.author.id
  json.name snippet.author.name
end
