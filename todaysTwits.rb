# todayTwits.rb @VERSION
#
# Copyright (c) 2008 Libby Miller
# Licensed under the MIT (MIT-LICENSE.txt)

require 'rubygems'
require 'uri'
require 'open-uri'
require 'net/http'
require 'json/pure'
require 'sqlite3'

# This class, which you should cron to run every five minutes, looks in the database to find out what programmes are on now
# and announces it on Twitter

class TodaysTwits

    # Get anything now or in the next 5 mins - non-inclusive for 5 mins' time
    # So at 55, things at 00 will have to wait for the next thing
    # but 58 will be caught
    SQL_SELECT_NEXT_PROG = "select * from beeb where time(starttime) >= time('now') AND time(starttime) < time('now', '+5 minutes');"

    @db = SQLite3::Database.open('beeb.db')

    def TodaysTwits.post(text)
        u = "http://twitter.com/statuses/update.json"
        url = URI.parse u
        puts "sending update #{text}"

        req = Net::HTTP::Post.new(url.path)
        req.basic_auth 'username', 'password' # put the real username and pass here
        req.set_form_data({'status'=>text}, ';')
        res = Net::HTTP.new(url.host, url.port).start {|http|http.request(req) }

        j = nil
        begin
            j = JSON.parse(res.body)
        rescue OpenURI::HTTPError=>e
            case e.to_s
                when /^404/
                    raise 'Not Found'
                when /^304/
                    raise 'No Info'
                when /^error/
                    raise 'Error'
            end
        end
    end

    begin
        arr = []

        @db.results_as_hash = true
        rows = @db.execute(SQL_SELECT_NEXT_PROG);

        # generate the messages and put them in an array

        rows.each do |row|

            title = row["TITLE"]
            subtitle = row["SUBTITLE"]

            if subtitle =~ /\d{2}\/\d{2}\/\d{4}/
                # it's just a date so ignore it
            else
                title = title + ": " + subtitle
            end

            if title.length > 70
              title = title[0, 66]+"..."
            end

            pid = row["PID"]

            # is this going to start in the future or starting this minute?
            # what's the difference between the starting minute and the current minute?
            starttime = row["STARTTIME"]

            timeTilStart = Time.parse(starttime).min - Time.now.min

            # Text niceness
            progInfo = "#{title} #pid:#{pid} http://bbc.co.uk/i/#{pid.gsub('b00', '')}"

            if timeTilStart > 0
              arr.push("In a few minutes on Radio 4: " + progInfo)
            else
              arr.push("Starting now on Radio 4: " + progInfo)
            end

            puts "#{arr.length} items to send"
        end

        # The longest message looks like this:
        # "In a few minutes on Radio 4: TITLE #pid:b00pnpn0 http://bbc.co.uk/i/pnpn0"
        # It is 68 chars + title, leaving us 72 chars for TITLE and SUBTITLE

        # Send the found data to Twitter
        x = 0
        while x < arr.length
          puts arr[x]
          TodaysTwits.post(arr[x])
          x = x + 1
        end

    rescue Exception => error
        puts "There was an error doing stuff: " + error.backtrace.join("\n")
    end

end



