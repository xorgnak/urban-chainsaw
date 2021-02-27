module Nomadic
    def self.repo r, *a
      @n = r
      @r = Octokit::Client.new(access_token: ENV['OCTOKIT'])
      if !@r.repository? @n
        @r.create_repository(@n, {issues: true, auto_init: true, has_wiki: true, description: %[#{a[0] || r.gsub("-", " ")}] })
      end
      return @r
    end
end
