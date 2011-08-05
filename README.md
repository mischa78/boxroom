Welcome to Boxroom
==================

Boxroom is a Rails 3 application that aims to be a simple interface for sharing
files in a web browser. To make this possible the application lets users create
folders and upload and download files. For admins it is possible to create users,
groups and the CRU/D rights these groups have on folders.

Website:  
http://boxroom.rubyforge.org/

Bug reports and feature requests:  
https://github.com/mischa78/boxroom/issues/new


Requirements
------------
The requirements for running Boxroom are:

 * Ruby 1.8.7 or Ruby 1.9.2 
 * Rails 3.0.x
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


Mail settings
-------------
Boxroom sends email when users want to reset their password or when they share files.
For this to work, depending on your environment, you have op to open
`config/environments/development.rb` or `config/environments/production.rb`, uncomment
the following lines and fill in the correct settings of your mail server:

    # config.action_mailer.delivery_method = :smtp
    # config.action_mailer.smtp_settings = {
    #   :address => 'mailhost',
    #   :port => 587,
    #   :user_name => 'user_name',
    #   :password => 'password',
    #   :authentication => 'plain'
    # }

In order for Boxroom to send a user to the correct URL for either downloading a shared
file or for resetting passwords, you have to uncomment and update the following:

    # config.action_mailer.default_url_options = { :host => 'localhost:3000' }

You also have to choose a from address for the emails that will be sent. You can do
this by uncommenting and adjusting the following line:

    # ActionMailer::Base.default :from => 'Boxroom <yourname@yourdomain.com>'


Languages
---------
Thanks to [Rob Halff](https://github.com/rhalff), [Marcus Ilgner](https://github.com/milgner) and
[Jessica Marcon](https://github.com/marcontwm) Boxroom is now available in Dutch, German and Italian.

English is the default. To change the language, open `config/application.rb` and change the following line:

    config.i18n.default_locale = :en

to:

    config.i18n.default_locale = :nl # Dutch
    config.i18n.default_locale = :de # German
    config.i18n.default_locale = :it # Italian

It would be great to have many more languages. I am waiting for your pull requests! ;-)


Downloaded files are empty
--------------------------
If you encounter an issue with Boxroom where downloaded files are always empty,
it may help to uncomment the following line in `config/environments/production.rb`:

    # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'
