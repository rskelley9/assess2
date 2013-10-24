set :session_expired, 60*60

get '/' do
  @all_events = Event.all
  erb :index
end

get '/signup' do

  erb :sign_up
end

post '/login' do
  user = User.find_by_email(params[:email])
  auth_user = user.authenticate(params[:password]) if user

  if auth_user
    session[:user_id] = auth_user.id
    session_start!
    redirect "/user/#{auth_user.id}"
  elsif user
    @error = "Wrong password"
    @all_events = Event.all
    erb :index
  else
    @error = "User #{params[:email]} was not found"
    @all_events = Event.all
    erb :index
  end

end

post '/sign_up' do

 user = User.create(email: params[:email], password: params[:password], first_name: params[:first_name], last_name: params[:last_name], birthdate: params[:birthdate])

 auth_user = user.authenticate(params[:password]) if user

 if auth_user
  session_start!
  session[:user_id] = auth_user.id
  redirect "/user/#{auth_user.id}"
else
  @error = "User #{params[:email]} could not be authenticated."
  erb :index
end
end

#user events homepage
get '/user/:auth_user_id' do
  @user = User.find(params[:auth_user_id])
  @created_events = @user.created_events
  @attended_events = @user.attended_events
  erb :events
end

get '/events/:event_id' do
  # @user = session[:user_id]

  @event = Event.find(params[:event_id])
  @user = User.find(@event.creator.id)

  erb :edit_event
end

get "/attend/:event_id" do

  @event = Event.find(params[:event_id])

  if session?
    @user = User.find(session[:user_id])
    erb :attend_event
  else
    redirect to "/"
  end
end

#attend confirmation, attend event
get "/users/:user_id/attend" do
  @user = User.find(params[:user_id])
  @event = Event.find_by_name(params[:name])

  @eventattendance = EventAttendance.create(attendee_id: @user.id, event_id: @event.id)

  @attended_events = @user.attended_events

  erb :events
end

#link to create event from events erb

get '/create/event/:user_id' do
  user = User.find(params[:user_id])
  if session?
    # @user = User.find(session[:user_id])
    @user = user
    erb :create_event
  else
    @error = "Wrong password"
    @all_events = Event.all
    erb :index
  end
end

#from create event form, after creation back to user events homepage

post "/create/event/:user_id" do
  # @user = User.find(session[:user_id])
  @user = User.find(params[:user_id])

  if request.xhr?
    @event = Event.create(creator_id: @user.id, name: params[:name], location: params[:location], starts_at: params[:starts_at], ends_at: params[:ends_at])
    @created_events = @user.created_events
    @attended_events = @user.attended_events
    erb :events, layout: false
  else
    @event = Event.create(creator_id: @user.id, name: params[:name], location: params[:location], starts_at: params[:starts_at], ends_at: params[:ends_at])
    redirect to "/user/#{@user.id}"
  end
end

#delete from edit_event erb link

get "/delete/:event_id/:user_id" do
  @user = User.find(params[:user_id])

  @event = Event.find(params[:event_id])

  Event.delete_all(id: @event.id)

  redirect to "/user/#{@user.id}"
end

get "/delete-all/:event_id/:user_id" do
  @user = User.find(params[:user_id])

  @event = Event.find(params[:event_id])
  Event.delete_all(creator_id: @user.id)

  redirect to "/user/#{@user.id}"
end

#update from edit_event.erb

post "/update/event/:event_id/user/:user_id" do
  # @user = User.find(session[:user_id])

  @event = Event.find(params[:event_id])
  @user = User.find(params[:user_id])
  Event.update(id: @event.id, creator_id: @user.id, name: params[:name], location: params[:location], starts_at: params[:starts_at], ends_at: params[:ends_at])

  # redirect to "/user/#{@user.id}"
  redirect to "/events/#{@event.id}"
end

post "/logout" do
  if session?
    session_end!
    session[:user_id] = nil
    redirect "/"
  else
    @error = "You aren't logged in, so that fact that you're seeing this navbar is puzzling. Refresh yoself."
    erb :index
  end
end

