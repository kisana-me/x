module ApplicationHelper
  def link_to(name = nil, options = nil, html_options = nil, &block)
    html_options ||= {}
    html_options[:data] ||= {}
    html_options[:data][:turbo_prefetch] = false unless html_options[:data].key?(:turbo_prefetch)
    super(name, options, html_options, &block)
  end

  def to_kanji_single_number(number)
    kanji_map = {
      0 => '零', 1 => '一', 2 => '二', 3 => '三', 4 => '四', 5 => '五', 
      6 => '六', 7 => '七', 8 => '八', 9 => '九'
    }
    number.to_s.chars.map { |char| kanji_map[char.to_i] }.join
  end

  def to_kanji_number(number)
    kanji_digits = %w[零 一 二 三 四 五 六 七 八 九]
    kanji_units = ['', '十', '百', '千']
    kanji_big_units = ['', '万', '億', '兆']
  
    return kanji_digits[0] if number == 0
  
    kanji_str = ""
    big_unit_index = 0
  
    while number > 0
      part = number % 10_000
      part_str = ""
  
      part.to_s.chars.reverse.each_with_index do |digit, index|
        next if digit == '0'
        part_str = kanji_digits[digit.to_i] + kanji_units[index] + part_str
      end
  
      part_str += kanji_big_units[big_unit_index] if !part_str.empty?
      kanji_str = part_str + kanji_str
  
      number /= 10_000
      big_unit_index += 1
    end
  
    kanji_str
  end

  def to_kanji_date(date = Time.current)
    year = to_kanji_single_number(date.year)
    month = to_kanji_single_number(date.month)
    day = to_kanji_single_number(date.day)
    hour = to_kanji_single_number(date.hour)
    minute = to_kanji_single_number(date.min)

    "#{year}年#{month}月#{day}日、#{hour}時#{minute}分"
  end

  def time_ago_in_words_kanji(date)
    relative_time = time_ago_in_words(date)
    relative_time.gsub(/\d+/) { |match| to_kanji_single_number(match.to_i) }
  end
end
