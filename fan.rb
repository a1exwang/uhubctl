#!/usr/bin/env ruby


# Your device port 
@port = 2

mode = nil
if ARGV[0] == 'rate'
  mode = :rate
  rate = ARGV[1].to_f
elsif ARGV[0] == 'sine'
  mode = :sine
  period = ARGV[1].to_f
else
  exit
end


# Set fan rate for 'delta' seconds time
def set_rate(rate, delta)
  down_time = (1 - rate) * delta
  up_time = rate * delta
  `./uhubctl -p #{@port} -a on &> /dev/null`
  sleep(up_time)
  `./uhubctl -p #{@port} -a off &> /dev/null`
  sleep(down_time)
end

def sine(period, delta)
  t = 0
  loop do |x|
    v = Math.sin(2 * Math::PI * t / period).abs
    puts("v #{v}")
    set_rate(v, delta)
    sleep(delta)
    t += delta
  end
end

delta = 0.01
case mode
when :rate
  loop { set_rate(rate, delta) }
when :sine
  sine(period, delta)
else
  raise RuntimeError
end
