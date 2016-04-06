require 'thread'

class PgAsyncWrapper
  def initialize(pg)
    @mutex = Mutex.new
    @queue = Queue.new
    @pg = pg
    async_listen()
  end

  def async_exec(statement, args=[])
    @queue.push({statement: statement, args: args})
    true
  end

  def exec(statement, args=[])
    @mutex.synchronize do
      @pg.exec(statement, args)
    end
  end

  def finish()
    @queue.push(:done)
    @listener.join
  end

  private

  def async_listen()
    @listener = Thread.start do
      while (query = @queue.pop) != :done do
        begin
          res = exec(query[:statement], query[:args])
        rescue => e
          puts e.inspect
        end
      end
    end
  end
end
