Mongoid.configure do |config|
  database = ENV['mongodb_db'] || "contributingcode_" + Rails.env
  host = ENV['mongodb_host'] || "127.0.0.1"
  port = ENV['mongodb_port']  || 27017
  username = ENV['mongodb_username']
  password = ENV['mongodb_password']

  cnx = Mongo::Connection.new(host, port)
  db = cnx[database]
  if !username.blank? and !password.blank?
    db.authenticate(username, password)
  end

  config.master = db

end