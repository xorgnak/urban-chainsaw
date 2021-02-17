module Nomadic
  class User
    include Redis::Objects
    sorted_set :stat
    hash_key :attr
    set :group
    list :msgs
    def initialize u, h={}
      @id = u
      if h[:contacts]
        JSON.parse(h[:contacts]).each { |e| self.group << e }
        h.delete(:contacts)
      end
      if h[:messages]
        JSON.parse(h[:messages]).each { |e| self.msgs << e }
        h.delete(:messages)
      end
      h.each_pair { |k,v| self.attr[k] = v }
    end
    def id; @id; end
    def friends
      o = []
      self.group.members.to_a.each { |u|
        if u != nil
        @u = Nomadic::User.new(u)
        o << %[<div class="friend" style="position: relative; text-align: center; border-radius: 10px; padding: 1%;">
        <img src="/logo.png" style="width: 100%;">
        <span style="position: absolute; top: 0; left: 0; background-color: white; background-color: white; border: thin solid orangered; border-radius: 10px;">#{@u.attr['pitch']}</span>
        <button class="material-icons call" value='#{u}' style="position: absolute; top: 0; right: 0; font-size: initial;">
call</button>
        <p style="position: absolute; bottom: 0; left: 50%; transform: translate(-50%, -50%); background-color: white; border: thin solid orangered; border-radius: 10px;">#{@u.attr['desc']}</p>
      </div>]
        end
      }
      return o.join('');
    end
    def messages
      o = []
      self.msgs.values.to_a.reverse.each { |e| o << %[<p>#{e}</p>] }
      self.msgs.clear
      return o.join('')
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
