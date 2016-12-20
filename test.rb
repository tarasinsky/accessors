require_relative 'accessors.rb'

class Test
  include Accessors

  attr_accessor_with_history :hi, :ri

  strong_attr_accessor :at, String

end

t=Test.new
t.hi=1
t.hi=2
t.hi=3

t.ri=11
t.ri=12
t.ri=13

puts "hi_history=#{t.hi_history}"

puts "ri_history=#{t.ri_history}"

begin
  t.at = []
rescue => e
  puts "Error: #{e}"
end

begin
  t.at = 'test'
rescue => e
  puts "Error: #{e}"
end

begin
  t.at = 1
rescue => e
  puts "Error: #{e}"
end
