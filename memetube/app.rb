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

def get_Single_Video db
  sql = "select * from videos where id = #{params[:video_id]};"
  result = db.exec(sql) 
  video = result.first
end

#index
get "/" do
  @header = "Memetube"
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
  @newly_added = @db.exec(sql)
  erb :videos
end


#show
get "/:video_id" do
  @video = get_Single_Video @db
  @header = @video["title"]
  erb :video
end

#edit
get "/:video_id/edit" do
  @header = "Edit Video"
  @edit = true
  @video = get_Single_Video @db
  erb :video
end

#update
post "/:video_id" do
  sql = "update videos set 
  title='#{params['title']}', 
  description='#{params['description']}', 
  url='#{params['url']}', 
  genre='#{params['genre']}' 
  where id=#{params['video_id']} returning *"
  @updated = @db.exec(sql)
  erb :video
end

#delete
post "/:video_id/delete" do
  sql = "delete from videos where id=#{params['video_id']} returning *"
  @deleted = @db.exec(sql)
  erb :videos
end