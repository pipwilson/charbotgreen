# beeb.rb @VERSION
#
# Copyright (c) 2008 Libby Miller
# Licensed under the MIT (MIT-LICENSE.txt)

require 'rubygems'
require 'net/http'
require 'uri'
require 'open-uri'
require 'json/pure'
require 'sqlite3'

# This class parses a JSON representation of today's programmes and stores them in a database

class Twitter

    SQL_DROP_TABLE = "DROP table beeb;"

    # we use TEXT for the timestamp, see http://www.sqlite.org/datatype3.html and http://www.sqlite.org/lang_datefunc.html
    SQL_CREATE_TABLE = "CREATE TABLE if not exists beeb(STARTTIME TEXT, PID VARCHAR(8), TITLE VARCHAR(255), SUBTITLE VARCHAR(255));"

    SQL_INSERT_ROW = <<-INSERT
        INSERT into "beeb"
        VALUES
        (:starttime, :pid, :title, :subtitle);
    INSERT

    @db = SQLite3::Database.new('beeb.db')

    def Twitter.status()

        u = "http://www.bbc.co.uk/radio4/programmes/schedules/fm/today.json"
        da = DateTime.now - (30/1440.0)
        url = URI.parse u
        puts "checking for updates #{url}"

        req = Net::HTTP::Get.new(url.path)

        # retrieve the json data
        # should be some error checking here

        res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }

        # Parse the json data

        j = nil
        begin
           j = JSON.parse(res.body)
        rescue OpenURI::HTTPError=>e
           case e.to_s
               when /^404/
                   raise 'Not Found'
               when /^304/
                   raise 'No Info'
           end
        end

        j = j['schedule']['day']['broadcasts']
        puts "found #{j.length} results"

        # Make sure the table is empty
        begin
           @db.execute(SQL_DROP_TABLE)
        rescue
            puts "There was an error dropping the table: ", $!
        end

        # Create the table
        begin
           @db.execute(SQL_CREATE_TABLE)
        rescue
            puts "There was an error creating the table: ", $!
        end

        # Insert the data

        begin
            x = 0
            while x < j.length
               starttime = j[x]['start']
               pid       = j[x]['programme']['pid']
               title     = j[x]['programme']['display_titles']['title']
               subtitle  = j[x]['programme']['display_titles']['subtitle']
               # subtitle may only be a date, but we leave it to todaysTwits
               # to decide whether to display it or not

               puts "#{x} #{starttime} #{title}"

              # break the ISO8601 timestamp into YYYY-MM-DD and HH:MM:SS and insert
              if (starttime != nil && starttime =~ /(.*)T(.*)Z/)
                d = $1
                t = $2
                ds = "#{d} #{t}"

                @db.execute(SQL_INSERT_ROW, 'starttime' => starttime,
                                            'pid' => pid,
                                            'title' => title,
                                            'subtitle' => subtitle)

              end
              x = x + 1
           end
        rescue
            puts "There was an error inserting a row: ", $!
        end
   end

end


Twitter.status()

