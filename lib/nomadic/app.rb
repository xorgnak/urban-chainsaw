#module Example
  class App < Sinatra::Base
    class Metric
      include Redis::Objects
      sorted_set :stat
      def initialize k
        @id = k
      end
      def id; @id; end
      def up k
        self.stat.incr(k)
      end
      def dn k
        self.stat.decr(k)
      end
      def to_h
        self.stat.members(with_scores: true).to_h
      end
    end
    
    configure do
      set :server, 'thin'
      set :port, 8081
      set :bind, '0.0.0.0'
      set :views, 'views/'
      set :public_folder, 'public/'
    end
    
    before do
      Metric.new(:referer).up request.referer
      Metric.new(:agent).up request.user_agent
      Metric.new(:route).up request.path_info
      Redis.new.publish "App.#{request.request_method}", "#{request.fullpath} #{params}"
    end
    get '/' do
        erb :index
    end
    get '/home' do
      if params[:token]
        if Nomadic.whois(params[:token])
          erb :home
        else
          redirect '/home'
        end
      else
        erb :auth
      end
    end
    post '/auth' do
      if params[:user] && params[:pass]
        # new user
        if !Redis::HashKey.new("AUTH").has_key? params[:user]
          Redis::HashKey.new("AUTH")[params[:user]] = params[:pass]
        end

        if Redis::HashKey.new("AUTH")[params[:user]] == params[:pass]
          t = []; 16.times { t << rand(16).to_s(16) }
          @token = t.join("")
          r = Redis.new
          r.setex("token:#{t.join('')}", ((60 * 60) * 10), params[:user])
          redirect "/home?token=#{t.join('')}"
        else
          redirect '/home'
        end
      end
    end
    post '/'do
      content_type 'application/json'
      p = {}
      # valid token
      if params[:token]
        p[:token] = params[:token]
        p[:contacts] = params[:contacts]
        @u = Nomadic::User.new(p[:token], params)
        p[:friends] = @u.friends
        p[:messages] = @u.messages
        p[:name] = @u.attr['name']
        p[:pitch] = @u.attr['pitch']
        p[:image] = @u.attr['image']
        p[:desc] = @u.attr['desc']
        p.each {|k,v| session[k] = v }
      end
      return JSON.generate(p)
    end
    not_found do
      h = {
        method: request.request_method,
        host: request.host,
        port: request.port,
        path: request.path_info,
        referer: request.referer,
        agent: request.user_agent,
        params: params
      }
      t = Time.now.utc.to_i
      Redis::Set.new("404s") << t
      Redis::HashKey.new("404")[t] = JSON.generate(h)
      Redis.new.publish "404.#{t}", JSON.generate(h)
    end    
  end
  Process.detach(fork { App.run! })
#end
