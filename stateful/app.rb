require 'pg'
require 'sinatra'
require_relative './app/hashtag'
require_relative './app/hashtag_repository'
require_relative './app/pg_async_wrapper'

conn = PG.connect(dbname: 'tweets')
pg   = PgAsyncWrapper.new(conn)
repo = HashtagRepository.new(pg)

get '/' do
  totals = repo
    .stats()
    .map { |stat| "#{stat[:hashtag]}: #{stat[:count]}" }
    .join("<br>\n")

  totals.empty? ? 'No known hashtags!' : totals
end

post '/track' do
  repo.track(params[:hashtag])
  'OK'
end
