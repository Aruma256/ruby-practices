#!/usr/bin/env ruby

require 'date'
require 'optparse'

Today = Date.today

# デフォルト値の指定
year = Today.year
month = Today.month

# 引数解析
opt = OptionParser.new
opt.on('-m', '--month N', Integer) {|val| month = val}
opt.on('-y', '--year N', Integer) {|val| year = val}
opt.parse!(ARGV)

# 入力バリデーション
unless (1..12).include?(month)
  puts "month は1〜12の中から選択してください"
  exit
end

# カレンダー作成用オブジェクトの用意
lines = [[]]
First_day = Date.new(year, month)

# 事前にパディングを追加する
date = First_day
while !date.sunday?
  lines.last << "  "
  date = date.prev_day
end

# 日付リストの作成
date = First_day
while date.month == month
  if lines.last.size >= 7 # 8日目→次の週
    lines << []
  end
  date_str = date.day.to_s.rjust(2)
  if date == Today
    date_str = "\e[;7m#{date_str}\e[m"
  end
  lines.last << date_str
  date = date.next_day
end

# 出力: ヘッダー
puts "      #{month}月 #{year}"
puts "日 月 火 水 木 金 土"

# 出力: 日付
lines.each do |line|
  puts line.join(" ")
end
