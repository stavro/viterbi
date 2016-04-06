require 'pg'
require 'sinatra'
require 'thread'

conn = PG.connect(dbname: 'tweets')
mutex = Mutex.new

get '/' do
  result = mutex.synchronize { conn.exec('select hashtag, count(*) from tweets group by hashtag') }

  totals =
    result
    .map { |res| "#{res["hashtag"]}: #{res["count"]}"}
    .join("<br>\n")

  totals.empty? ? 'No known hashtags!' : totals
end

post '/track' do
  mutex.synchronize { conn.exec("insert into tweets (hashtag, created_at) VALUES ($1, now());", [params[:hashtag]]) }
  'OK'
end
