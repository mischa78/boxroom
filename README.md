# Boxroom

[![Build Status](https://secure.travis-ci.org/mischa78/boxroom.png)](http://travis-ci.org/mischa78/boxroom)
[![Dependency Status](https://gemnasium.com/mischa78/boxroom.png?travis)](https://gemnasium.com/mischa78/boxroom)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/mischa78/boxroom)

Boxroom is a Rails application that aims to be a simple interface for managing and
sharing files in a web browser. It lets users create folders and upload, download
and share files. Admins can manage users, groups and permissions.

Website:  
http://boxroomapp.com/

Bug reports and feature requests:  
https://github.com/mischa78/boxroom/issues/new


Requirements
------------
The requirements for running Boxroom are:

 * Ruby 1.8.7 or Ruby 1.9.2 and above
 * Rails 3.2.x
 * A database (e.g. MySQL or SQLite)


Installation
------------
Follow the these steps:

 1. Extract boxroom.zip and cd to the newly created folder
 2. Update your bundle: `$ bundle`
 3. Create a database and schema: `$ bundle exec rake db:migrate`
 4. Start the server: `$ bundle exec rails server`
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

English is the default. To change the language, open `config/application.rb`, uncomment the following line:

    # config.i18n.default_locale = :de

and set the language you desire:

    config.i18n.default_locale = :nl # Dutch
    config.i18n.default_locale = :de # German
    config.i18n.default_locale = :it # Italian

It would be great to have many more languages. I am waiting for your pull requests!


Credits
-------

Contributors:

 * [Jessica Marcon](https://github.com/marcontwm)
 * [Marcus Ilgner](https://github.com/milgner)
 * [Rob Halff](https://github.com/rhalff)
 * [Ryan Michael](https://github.com/kerinin/boxroom)
 * [Thomas Volkmar Worm](https://github.com/tvw/)
 * [Joan Marc Carbo](https://github.com/jmcarbo)
 * Stian Haklev
 * Craig Box
 * [Stephan Toggweiler](https://github.com/rheoli)

Donations:

 * [IT Partners](http://www.itpartners.co.nz/)
 * Matt Meshulam
 * April Colo

Icons:

 * [Yusuke Kamiyamane](http://p.yusukekamiyamane.com/)


License
-------
Copyright (c) 2006-2012 Mischa Berger

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished to do so, subject
to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
