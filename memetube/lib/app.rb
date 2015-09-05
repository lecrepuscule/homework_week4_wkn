require "sinatra"
require "sinatra/reloader" if development?
require "pry"
require "pg"

before do
  @db = PG.connect(dbname: "memetube_app", host: "localhost")
end

after do
  @db.close
end

#index
get "/" do
  @header = "my videos"
  sql = "select title from videos"
  @videos = @db.exec(sql)  
  erb :videos
end

#new
get "/new" do 
  @header = "Add New Video"
  erb :new
end

#create
post "/" do 
  
  erb :videos
end


#show

#edit

#update

#delete