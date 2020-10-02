class ProgressReport
  include Singleton

  def initialize
    @symbols = ['-', '\\', '|', '/', '-', '\\', '|', '/']
  end

  def start(msg)
    @start_time = Time.now.utc
    @benchmark = []
    @max_status_length = 0
    puts msg
  end

  def benchmark(speed)
    return if ENV['NO_PROGRESS']

    @benchmark = [*@benchmark.last(50), speed]
  end

  def progress(start, current, total, &block)
    return if ENV['NO_PROGRESS']

    speed = @benchmark.reduce(:+) / @benchmark.size.to_f rescue nil
    symbol = @symbols.push(@symbols.shift).first
    current_string = block_given? ? block.call(current) : current.to_s.ljust(total.to_s.length)
    if total - start == 0
      percentage = '0%  '
    else
      p = [(((current - start) / (total - start).to_f) * 100).round(0), 100].min
      percentage = (p.to_s + '%').ljust(4)
    end

    if speed
      speed_string = "~#{format('%.2f', 1 / speed).to_s.rjust(6)}/s"
      begin
        eta_string = ActionController::Base.helpers.time_ago_in_words(
          ((total - current) / (1 / speed)).seconds.from_now
        )
      rescue StandardError
        eta_string = $!.message
      end
      speed_string = "(#{speed_string} -> #{eta_string})"
    else
      speed_string = ''
    end

    status_string = "#{symbol} #{percentage} at #{current_string} #{speed_string}"
    @max_status_length = [@max_status_length, status_string.length].max
    print "#{status_string.ljust(@max_status_length)}\r"
  end

  def report(*extra_lines)
    extra_lines.each do |line|
      puts line.ljust(@max_status_length)
    end
    duration = ActionController::Base.helpers.time_ago_in_words(@start_time)
    puts "#{"\n" unless ENV['NO_PROGRESS']}DONE in #{duration}\n\n".ljust(@max_status_length)
  end
end
