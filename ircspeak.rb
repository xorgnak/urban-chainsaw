require 'cinch'
require 'redis-objects'

class Speech
  include Redis::Objects
  list :text
  def initialize i
    @id = i
  end
  def id; @id; end
  def play
    self.text.values.to_a.join("\n\n").gsub("?", "").gsub('.', '')
  end
end

Cinch::Bot.new do
  configure do |c|
    c.nick = "vangome"
    c.server = "irc.freenode.org"
    c.channels = ["#vango"]
  end

  on(:channel, /^!! (.*)/) { |m, mm| `echo "#{mm}" | espeak` }
  on(:channel, /^!speech (.*)/) { |m, a|
    if a == "reset"
      Speech.new(m.user.nick).text.clear
      m.reply "speech #{m.user.nick} reset"
    elsif a == "play"
      s = Speech.new(m.user.nick).play
      m.reply "#{s}"
      `echo "#{s}" | espeak`
    elsif a == ""
      Speech.new(m.user.nick).text << ","
    else
      Speech.new(m.user.nick).text << a.gsub(",", "")
    end
  }
end.start
