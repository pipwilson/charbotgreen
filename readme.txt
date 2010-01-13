CharBotGreen Installation Instructions
--------------------------------------

CharBotGreen is a twitter bot written in jruby using 
http://www.bbc.co.uk/radio4/programmes/schedules/fm/today.json
(see http://www.bbc.co.uk/programmes/developers#alternateserialisations)

The author is Libby Miller, http://nicecupoftea.org 
The license is MIT (MIT-License.txt).

There are four easy steps:


1. Installing jruby 
-------------------

# see http://jruby.org/getting-started

Download from http://jruby.org/download


2. Installing sqlite3
---------------------

Download and install the relevant binary version. 
On Ubuntu this is in Synaptic.
On Windows you can download the sqlitedll zip file and unzup it into c:\ruby\bin

gem install sqlite3-ruby

To inspect the database you can either use the command-line tool that comes
with SQLite on Ubuntu (separate download on Windows) or a GUI like
http://www.yunqa.de/delphi/doku.php/products/sqlitespy/index (Windows) or
http://sqlitebrowser.sourceforge.net/index.html (cross platform) or
https://addons.mozilla.org/en-US/firefox/addon/5817 (firefox add-on)

3. Installing Json Pure
-----------------------

jruby -S gem install json_pure 


4. Running the ruby files
-------------------------

curl -O http://svn.foaf-project.org/foaftown/2009/charbotgreen/beeb.rb
curl -O http://svn.foaf-project.org/foaftown/2009/charbotgreen/todaysTwits.rb

OR

svn co http://svn.foaf-project.org/foaftown/2009/charbotgreen/ .


# edit the todaysTwits.rb with the correct username and password

jruby beeb.rb # run once a day between 1am and 5:20am
jruby todaysTwits.rb # run every 5 minutes
