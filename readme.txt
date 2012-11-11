CharBotGreen Installation Instructions
--------------------------------------

CharBotGreen is a twitter bot written in Ruby using 
http://www.bbc.co.uk/radio4/programmes/schedules/fm/today.json
(see http://www.bbc.co.uk/programmes/developers#alternateserialisations)

The original author is Libby Miller (http://nicecupoftea.org) 
Libby's code is available on http://svn.foaf-project.org/foaftown/2009/charbotgreen/

This fork is by Phil Wilson (http://philwilson.org/) 
The code is on http://github.com/pipwilson/charbotgreen

The license is MIT (MIT-License.txt).

There are four easy steps:

1. Installing Ruby 
-------------------

Download from http://www.ruby-lang.org/en/downloads/


2. Installing sqlite3
---------------------

On Ubuntu you can install sqlite from Synaptic.

On Windows you can download the sqlitedll zip file from 
http://www.sqlite.org/download.html and unzip it into C:\Ruby\bin

Install the Ruby bindings

$ gem install sqlite3-ruby

To inspect the database you can either use the command-line tool that comes
with SQLite (separate download on Windows) or a GUI like:

* http://www.yunqa.de/delphi/doku.php/products/sqlitespy/index (Windows)
* http://sqlitebrowser.sourceforge.net/index.html (cross platform)
* https://addons.mozilla.org/en-US/firefox/addon/5817 (firefox add-on)


3. Installing Json Pure
-----------------------

$ gem install json_pure 


4. Running the ruby files
-------------------------

Edit the todaysTwits.rb with the correct username and password

$ ruby beeb.rb # run once a day between 1am and 5:20am
$ ruby todaysTwits.rb # run every 5 minutes
