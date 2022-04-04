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
              [{ stat: stat($stdin.read) }]
            else
              ARGV.map { |path| { stat: stat(IO.read(path)), path: path } }
            end
  print_results(results, only_lines: params[:l])
end

def stat(content)
  {
    lines: content.count("\n"),
    words: content.split.length,
    bytes: content.length
  }
end

def print_results(results, only_lines: false)
  totals = Hash.new(0)
  results.each do |result|
    result[:stat].each { |key, value| totals[key] += value }
    puts to_formatted_string(result[:stat], name: result[:path], only_lines: only_lines)
  end
  puts to_formatted_string(totals, name: 'total', only_lines: only_lines) if results.length > 1
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
