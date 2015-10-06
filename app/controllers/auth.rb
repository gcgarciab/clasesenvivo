Clasesenvivo::App.controllers :auth do

   login_params = [:email, :password]

   before(:login) do
      halt 400,{ msg: 'Que inventas?' }.to_json unless login_params.map{ |i| params.key? i.to_s}.all?
      #Hace un recorrido por params y verifica que tenga todo el contenido !!!
   end

   post :login, params: login_params do
      @user = User.login(params[:email], params[:password])
      @user ? render(:user) : { msg: 'Quien eres?'}.to_json
      #Cuando uso render, va a ir a la carpeta views/auth/ y va a buscar un archivo user.rabl
   end

end
