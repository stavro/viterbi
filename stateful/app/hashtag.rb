class Hashtag
  attr_accessor :hashtag, :count

  def initialize(pg, hashtag, count=0)
    @pg = pg
    @hashtag = hashtag
    @count = count
  end

  def add_score()
    @pg.async_exec("insert into tweets (hashtag, created_at) VALUES ($1, now());", [@hashtag])
    @count += 1
  end

  def stats()
    {
      hashtag: @hashtag,
      count: @count
    }
  end
end
