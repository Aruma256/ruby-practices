N_start = 1
N_end = 20

(N_start..N_end).each do |i|
  case
  when i%3 == 0 && i%5 == 0
    puts "FizzBuzz"
  when i%3 == 0
    puts "Fizz"
  when i%5 == 0
    puts "Buzz"
  else
    puts i
  end
end
