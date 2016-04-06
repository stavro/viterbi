class HashtagRepository
  def initialize(pg)
    @hashtags = Hash.new { |hash, key| hash[key] = Hashtag.new(pg, key, 0) }

    pg.exec('select hashtag, count(*) from tweets group by hashtag').each do |row|
      @hashtags[row[:hashtag]] = Hashtag.new(pg, row["hashtag"], row["count"].to_i)
    end
  end

  def stats
    @hashtags
    .values
    .map { |hashtag| hashtag.stats() }
  end

  def track(hashtag)
    @hashtags[hashtag].add_score()
  end
end
