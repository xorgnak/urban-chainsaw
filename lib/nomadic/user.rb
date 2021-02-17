module Nomadic
  class User
    include Redis::Objects
    sorted_set :stat
    hash_key :attr
    set :group
    list :msgs
    def initialize u, h={}
      @id = Nomadic.whois(u)
      if h[:contacts]
      h[:contacts].each { |e| self.group << e }
      h.delete(:contacts)
      end
      h.delete(:id)
      h.each_pair { |k,v| self.attr[k] = v }
    end
    def id; @id; end
    def friends
      self.group.members.map { |u|
        @u = User.new(u)
        %[<div class="friend" style="position: relative; text-align: center; border-radius: 10px; padding: 1%;">
        <img src="/logo.png" style="width: 100%;">
        <span style="position: absolute; top: 0; left: 0; background-color: white; background-color: white; border: thin solid orangered; border-radius: 10px;">#{@u.attr['pitch']}</span>
        <button class="material-icons call" value='#{u}' style="position: absolute; top: 0; right: 0; font-size: initial;">
call</button>
        <p style="position: absolute; bottom: 0; left: 50%; transform: translate(-50%, -50%); background-color: white; border: thin solid orangered; border-radius: 10px;">#{@u.attr['desc']}</p>
      </div>]
      }
    end
    def messages
      o = []
      self.msgs.reverse_each { |e| o << %[<p>#{e}</p>] }
      self.msgs.clear
      return o.join('')
    end
  end
  def self.whois t
    Redis.new.get("token:#{t}")
  end
end
