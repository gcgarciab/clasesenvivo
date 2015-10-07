Clasesenvivo::App.controllers :video do

  video_upload_params = [:title, :description, :url, :tags]

  before(:new) do
     halt 403,{ msg: 'Envia token!! '}.to_json unless request.env['HTTP_AUTHORIZATION']
     @user = User.validate_token(request.env['HTTP_AUTHORIZATION'])
     halt 403,{ msg: 'Quien eres ? '}.to_json unless @user
     halt 400,{ msg: 'Que inventas?' }.to_json unless video_upload_params.map{ |i| params.key? i.to_s}.all?
     #Hace un recorrido por params y verifica que tenga todo el contenido !!!
  end


  post :new, params: video_upload_params do
    params[:user] = @user
      @video = Video.new(params)
      puts @video.inspect
      @video.save ? render(:new) : @video.errors.full_messages.to_json
  end

end
