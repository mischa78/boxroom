Welcome to Boxroom
==================

Boxroom is a Rails 3 application that aims to be a simple interface for sharing
files in a web browser. To make this possible the application lets users create
folders and upload and download files. For admins it is possible to create users,
groups and the CRU/D rights these groups have on folders.

Website:  
http://boxroom.rubyforge.org/

Report bugs here:  
https://github.com/mischa78/boxroom/issues/new

Feature requests:  
http://rubyforge.org/tracker/?atid=6303&group_id=1611&func=browse


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


Languages
---------
Thanks to [Rob Halff](https://github.com/rhalff) and [Marcus Ilgner](https://github.com/milgner)
Boxroom is now available in Dutch and German.

English is the default. To change the language, open `config/application.rb` and change the following line:

    config.i18n.default_locale = :en

to:

    config.i18n.default_locale = :nl # Dutch

or:

    config.i18n.default_locale = :de # German

It would be great to have many more languages. I am waiting for your pull requests! ;-)


Downloaded files are empty
--------------------------
If you encounter an issue with Boxroom where downloaded files are always empty,
it may help to uncomment the following line in `config/environments/production.rb`:

    # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'
