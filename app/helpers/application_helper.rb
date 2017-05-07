module ApplicationHelper

  def parse_english_5000
    file_5000 = File.open(File.join(Rails.root, '/app/helpers/5000_english.txt'), 'r')

    File.readlines(file_5000).each do |line|
      line_arr = line.split(' ')
      freq = line_arr[0]
      word = line_arr[1]
      pos = line_arr[2]
      Word.create!(word: word, frequency: freq, pos: pos, inflection_form: 'itself')
    end

    file_5000.close
  end
end

