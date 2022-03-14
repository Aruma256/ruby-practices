#!/usr/bin/env ruby
# frozen_string_literal: true

results = ARGV[0].split(',').map! { |c| c == 'X' ? 10 : c.to_i }

total_score = 0

# 初期状態の設定
frame = 1
first_shot = true
remaining_pins = 10

# 得点計算
results.each_with_index do |pins, index|
  # 基礎点を加算する
  total_score += pins
  next if frame == 10

  remaining_pins -= pins
  # ボーナスがあれば加算する
  if remaining_pins.zero?
    total_score += if first_shot # ストライクの場合
                     results[index + 1] + results[index + 2]
                   else # スペアの場合
                     results[index + 1]
                   end
  end
  # 状態を更新する
  if remaining_pins.zero? || !first_shot
    frame += 1
    first_shot = true
    remaining_pins = 10
  else
    first_shot = false
  end
end

puts total_score
