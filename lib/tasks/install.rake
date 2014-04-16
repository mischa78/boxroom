desc 'Initial setup of the application'
task :install do
  puts 'Creating database... '
  system 'bundle exec rake db:create'
  system 'bundle exec rake db:migrate'

  puts "\n"
  print 'Creating config/secrets.yml... '
  secret_token = Rails.root.join('config', 'secrets.yml')

  # Only create if it doesn't exit yet
  if !File.exists?(secret_token)
    File.open(secret_token, 'w') do |f|
      %w{development test production}.each do |env|
        f.write "#{env}:\n"
        f.write "  secret_key_base: #{SecureRandom.hex(64)}\n"
      end
    end

    puts 'OK'
  else
    puts "\n"
    puts 'config/secrets.yml already exists'
  end

  puts "\n"
  puts 'Boxroom was installed succesfully.'
  puts "\n"
  puts 'Start the server by executing the following command:'
  puts "\n"
  puts '  bundle exec rails server'
  puts "\n"
  puts 'Point your browser to http://localhost:3000/ and enjoy!'
  puts "\n"
end
