module Nomadic
  class Project
    include Redis::Objects
    sorted_set :stat
    hash_key :attr
    set :team
    list :tasks
    hash_key :done
    def initialize u
      @id = u
    end
    def id; @id; end
  end
  
  class User
    include Redis::Objects
    sorted_set :stat
    hash_key :attr
    set :projects
    def initialize u, h={}
      @id = u
      Redis.new.publish "DEBUG.User.initialize", "#{h}"
      h.each_pair { |k,v| if v.class == String; self.attr[k] = v; end }
      self.projects << h[:project]
      @project = Project.new(h[:project])
      @project.team << u
      if h[:act] == 'done'
        if !@project.tasks.include? h[:payload]
          self.stat.incr(h[:project])
          self.stat.incr("jobs")
          @project.tasks << h[:payload]
          @project.done[h[:payload]] = JSON.generate({
                                                       before: {
                                                         on: Time.now.utc.to_i,
                                                         by: h[:token],
                                                         picture: "#{h[:picture]}",
                                                         paragraph: "#{h[:paragraph]}"
                                                       }
                                                     })
        else
          self.stat.decr(h[:project])
          @project.stat.decr("jobs")
          d = JSON.parse(@project.done[h[:payload]])
          d[:completed] = Time.now.utc.to_i
          d[:completer] = h[:token]
          d[:after] = { on: Time.now.utc.to_i, by: h[:token], picture: "#{h[:picture]}", paragraph: h[:paragraph] }
          @project.done[h[:payload]] = JSON.generate(d)
          @project.tasks.delete h[:payload]
          Redis.new.publish "DEBUG.User.initialize.done", @project.done[h[:payload]] 
        end
      end
    end
    def id; @id; end
    def to_json
      {
        project: self.attr['project'],
        token: self.attr['token'],
        output: @project.tasks.values.to_a.reverse,
        stats: @project.stat.members(with_scores: true).to_h,
        conf: self.attr.all
      }
    end
  end
  # (token, {}) -> User
  def self.user t, p={}
    Nomadic::User.new(Nomadic.whois(t), p)
  end
  # (token) -> clientid
  def self.whois t
    Redis.new.get("token:#{t}")
  end
end
