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
  sql = "select id, title from videos"
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
  sql = "insert into videos (
    title, 
    description, 
    url, 
    genre) values (
    '#{params[:title]}',
    '#{params[:description]}',
    '#{params[:url]}',
    '#{params[:genre]}'
    ) returning *;"
  @outcome = @db.exec(sql)
  erb :videos
end


#show
get "/:video_id" do
  @header = "Video Details"
  sql = "select * from videos where id = #{params[:video_id]};"
  @video = @db.exec(sql) 
  erb :video
end

#edit

#update

#delete