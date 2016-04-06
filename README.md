Tweet Tracker
=============

> This repository accompanies a presentation made for USC Course 31934, Spring 2016: **Web Application Project**.

Goal: Examine a traditional three tier web application compared to a stateful web service.

Contained within this repository are two API servers capable of tracking and persisting occurrences of hashtags, and responding with a global statistics counter.

  * **Three-Tier**: A traditional stateless web app delegating all stateful behavior to the database.
  * **Stateful**: A stateful web app leveraging in-process data locality to respond immediately to requests.

Both servers have two routes exposed:

  * `GET /`: Retrieves statistics on all tracked hashtags
  * `POST /track?hashtag=<name>`: Tracks a usage event of a particular hashtag.

Both servers are backed by a Postgres instance.

Instructions:
  * Clone repository, create the database, and ensure both servers can start.
  * Benchmark both servers for reading and writing.
  * (extra credit) - Generate 100k+ rows and repeat the benchmark.
  * Share and discuss results.

### Database

Both apps use the same database.  Once you have Postgres installed, create a database called `tweets`:
  1. `createdb tweets`
  2. `psql -d tweets`
  3. `create table tweets (id serial primary key, hashtag text not null, created_at timestamp not null);`

### Starting your web server

1. `cd three_tier` (or `cd stateful`)
2. `bundle install`
3. `bundle exec ruby app.rb`
4. `verify the app loads by going to http://localhost:4567/ on your browser`

### Benchmarking

Once you have a web server running, time to benchmark!

Install `wrk`: `brew install wrk`

```bash
# GET '/'
wrk -d10s --timeout 2000 http://localhost:4567/

# POST '/track?hashtag=<insert hashtag>'
wrk -d10s --timeout 2000 -s track.lua http://localhost:4567/
```

### (Extra Credit) Generating Extra Rows

`insert into tweets (hashtag, created_at) select 'hashtag_' || (s.i / 100)::text, now() as created_at from generate_series(1,100000) as s(i);`
