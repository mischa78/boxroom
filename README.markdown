Welcome to Boxroom
==================

Boxroom is a Rails 3 application that aims to be a simple interface for sharing
files in a web browser. To make this possible the application lets users create
folders and upload and download files. For admins it is possible to create users,
groups and the CRU/D rights these groups have on folders.

For more info go to:  
http://boxroom.rubyforge.org/

Bugs and/or feature requests:  
http://rubyforge.org/tracker/?group_id=1611


Requirements
------------
The minimum requirements for running Boxroom are:

 * Ruby 1.8.7 or Ruby 1.9.2 
 * Rails 3.0 or bigger
 * A database (e.g. MySQL or SQLite)


Installation
------------
Follow the these steps:

 1. Extract boxroom.zip and cd to the newly created folder
 2. Update your bundle: `$ bundle`
 3. Create a database and schema: `$ rake db:migrate`
 4. Start the server: `$ rails server`
 5. Point your browser to http://localhost:3000/
 6. Enjoy!
