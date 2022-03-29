#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'pathname'

NUMBER_OUTPUT_DIGITS = 8

def main
  params = {}
  opt = OptionParser.new
  opt.on('-l') { params[:l] = true }
  opt.parse!(ARGV)
  if ARGV.empty?
    results = [[stat($stdin.read)]]
  else
    pathnames = ARGV.map { |path| Pathname(path) }
    results = pathnames.map { |pathname| [stat(pathname.read), pathname.to_s] }
  end
  totals = [0] * 3
  results.each do |stat, name|
    stat.each_with_index { |value, index| totals[index] += value }
    puts to_formatted_string(stat, name: name, only_lines: params[:l])
  end
  puts to_formatted_string(totals, name: 'total', only_lines: params[:l]) if results.length > 1
end

def stat(content)
  [content.count("\n"), content.split.length, content.length]
end

def to_formatted_string(stat, name: nil, only_lines: false)
  res = if only_lines
          stat.first.to_s.rjust(NUMBER_OUTPUT_DIGITS)
        else
          stat.map { |val| val.to_s.rjust(NUMBER_OUTPUT_DIGITS) }.join
        end
  name ? "#{res} #{name}" : res
end

main if __FILE__ == $PROGRAM_NAME