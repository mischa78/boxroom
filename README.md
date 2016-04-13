# Boxroom

[![Build Status](https://api.travis-ci.org/mischa78/boxroom.png)](http://travis-ci.org/mischa78/boxroom)
[![Dependency Status](https://gemnasium.com/mischa78/boxroom.png?travis)](https://gemnasium.com/mischa78/boxroom)
[![Code Climate](https://codeclimate.com/github/mischa78/boxroom.png)](https://codeclimate.com/github/mischa78/boxroom)

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

 * Ruby 2.0.0 or newer
 * Rails 4.2.6
 * A database (e.g. MySQL or SQLite)


Installation
------------
Follow these steps:

 1. Extract, checkout or clone Boxroom into a new folder
 2. `cd` into the new folder
 3. Install necessary gems: `$ bundle install`
 4. Run the install script: `$ bundle exec rake install`
 5. Start the server: `$ bundle exec rails server`
 6. Point your browser to http://localhost:3000/
 7. Enjoy!


Mail settings
-------------
Boxroom sends email on the following occasions:

 * When inviting new users
 * On a reset password request
 * When a file is shared

For the application to be able to send email, a few things have to be set up. Depending on the environment
you're working in, either open `config/environments/development.rb` or `config/environments/production.rb`.
Uncomment the following lines and fill in the correct settings of your mail server:

```ruby
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  :address => 'mailhost',
  :port => 587,
  :user_name => 'user_name',
  :password => 'password',
  :authentication => 'plain'
}
```

Also uncomment the following and replace `localhost:3000` with the host name the app will be running under:

```ruby
config.action_mailer.default_url_options = { :host => 'localhost:3000' }
```

Lastly, you have to choose the address emails will be sent from. You can do
this by uncommenting and adjusting the following:

```ruby
ActionMailer::Base.default :from => 'Boxroom <yourname@yourdomain.com>'
```


Languages
---------
Thanks to [Rob Halff](https://github.com/rhalff), [Marcus Ilgner](https://github.com/milgner),
[Jessica Marcon](https://github.com/marcontwm), [Arnaud Sellenet](https://github.com/demental) and [Burnaby John](https://github.com/john-coding)
Boxroom is now available in Dutch, German, Italian, French and Simplified Chinese.

English is the default. To change the language, open `config/application.rb` and set the language you desire:

```ruby
config.i18n.default_locale = :en # English
config.i18n.default_locale = :nl # Dutch
config.i18n.default_locale = :de # German
config.i18n.default_locale = :it # Italian
config.i18n.default_locale = :fr # French
config.i18n.default_locale = :'zh-CN' # Simplified Chinese
```

It would be great to have many more languages. I am waiting for your pull requests.


JavaScript runtime
------------------

You need to have a JavaScript runtime installed to run Boxroom. Your system may already have a
runtime installed, but if not, you'll get an error message about a missing JavaScript runtime when
running the install script. In that case uncomment the following line in the `Gemfile`:

    # gem 'therubyracer', platforms: :ruby

and try running `$ bundle install` and `$ bundle exec rake install` again.


Roadmap
-------

These are the features I am planning to implement at some point:

 * Functional tests
 * Thumbnail view
 * Full text search
 * Extract uploaded zip files
 * Batch create new users for admins


Credits
-------

Contributors:

 * [Jessica Marcon](https://github.com/marcontwm)
 * [Marcus Ilgner](https://github.com/milgner)
 * [Rob Halff](https://github.com/rhalff)
 * [Ryan Michael](https://github.com/kerinin)
 * [Thomas Volkmar Worm](https://github.com/tvw)
 * [Joan Marc Carbo](https://github.com/jmcarbo)
 * Stian Haklev
 * Craig Box
 * [Stephan Toggweiler](https://github.com/rheoli)
 * [Kale Worsley](https://github.com/kaleworsley)
 * [Arnaud Sellenet](https://github.com/demental)
 * [Patrick Fratczak](https://github.com/patfrat)
 * [Alessandro Lepore](https://github.com/alepore)
 * [Cayce Balara](https://github.com/Yardboy)
 * [Burnaby John](https://github.com/john-coding)
 * [Andreas Venturini](https://github.com/andreas-venturini)

Donations:

 * [IT Partners](http://www.itpartners.co.nz/)
 * Matt Meshulam
 * April Colo
 * [Mohd Sofian](http://www.zulrafique.com.my/)

Icons:

 * [Yusuke Kamiyamane](http://p.yusukekamiyamane.com/)


License
-------
Copyright (c) 2006-2016 Mischa Berger

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
