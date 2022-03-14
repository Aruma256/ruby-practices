#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'optparse'

today = Date.today
year = today.year
month = today.month

opt = OptionParser.new
opt.on('-m', '--month N', Integer) { |val| month = val }
opt.on('-y', '--year N', Integer) { |val| year = val }
opt.parse!(ARGV)

lines = []
first_day = Date.new(year, month)

lines << ['  '] * first_day.wday

date = first_day
while date.month == month
  lines << [] if lines.last.size == 7
  date_str = date.day.to_s.rjust(2)
  date_str = "\e[;7m#{date_str}\e[m" if date == today
  lines.last << date_str
  date = date.next_day
end

puts "      #{month}月 #{year}"
puts '日 月 火 水 木 金 土'
lines.each do |line|
  puts line.join(' ')
end
