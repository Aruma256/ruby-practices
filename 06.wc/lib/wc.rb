#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

NUMBER_OUTPUT_DIGITS = 8

def main
  params = {}
  opt = OptionParser.new
  opt.on('-l') { params[:l] = true }
  opt.parse!(ARGV)
  results = if ARGV.empty?
              [[stat($stdin.read), nil]]
            else
              ARGV.map { |path| [stat(IO.read(path)), path] }
            end
  totals = Hash.new(0)
  results.each do |stat, name|
    stat.each { |key, value| totals[key] += value }
    puts to_formatted_string(stat, name: name, only_lines: params[:l])
  end
  puts to_formatted_string(totals, name: 'total', only_lines: params[:l]) if results.length > 1
end

def stat(content)
  {
    lines: content.count("\n"),
    words: content.split.length,
    bytes: content.length
  }
end

def to_formatted_string(stat, name: nil, only_lines: false)
  res = if only_lines
          stat[:lines].to_s.rjust(NUMBER_OUTPUT_DIGITS)
        else
          stat.map { |_key, value| value.to_s.rjust(NUMBER_OUTPUT_DIGITS) }.join
        end
  name ? "#{res} #{name}" : res
end

main if __FILE__ == $PROGRAM_NAME
