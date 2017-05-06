module CanTheCansHelper
  def what_can_is_it(inputted_string)
    can_verb_inflections = ['cant', 'couldnt', 'cannot']
    can_noun_inflections = ['cans']
    can_information = []
    inputted_string.split(' ').each_with_index do |word, index|
      cleaned_word = word.strip.downcase.gsub(/[[:punct:]]/, '')
      if can_verb_inflections.include?(cleaned_word)
        can_information.push({'pos' => 'verb', 'index' => index})
      elsif can_noun_inflections.include?(cleaned_word)
        can_information.push({'pos' => 'noun', 'index' => index})
      elsif cleaned_word == 'can'
        meaning = parse_context(inputted_string, index)
        meaning['index'] = index
        can_information.push(meaning)
      else
        next
      end
    end
    return can_information
  end

  def parse_context(sentence, index_to_parse)
    #TODO: generalize this to any word (not just can)
    uncleaned_word_arr = sentence.split(' ')
    cleaned_word_arr = uncleaned_word_arr.map {|word| word.strip.downcase.gsub(/[[:punct:]]/, '')}

    pronouns = ['i', 'you', 'he', 'she', 'it', 'we', 'yall', 'they', 'everyone', 'im', 'hes']
    others = ['mine', 'yours', 'ours', 'hers', 'everyones', 'theirs']
    possessive_adjectives = ['my', 'your', 'their', 'her', 'our']
    articles = ['a', 'an', 'the']
    ambig = ['this', 'that', 'his',]

    meaning = {}
    debugger
    if index_to_parse == 0
      if !cleaned_word_arr[1] == 'is'
        meaning['pos'] = 'verb'
      else
        if pronouns.include?(cleaned_word_arr[index_to_parse + 1]) || others.include?(cleaned_word_arr[index_to_parse + 1]) || articles.include?(cleaned_word_arr[index_to_parse + 1]) || ambig.include?(cleaned_word_arr[index_to_parse + 1])
          meaning['pos'] = 'verb'
        else

          meaning['pos'] = 'noun, declaring a definition'
        end

      end
    elsif index_to_parse == 1
      if pronouns.include?(cleaned_word_arr[0]) || others.include?(cleaned_word_arr[0])
        meaning['pos'] = 'verb'
      elsif articles.include?(cleaned_word_arr[0]) || possessive_adjectives.include?(cleaned_word_arr[0])
        meaning['pos'] = 'noun'
      else
        meaning['pos'] = 'verb'
      end
    elsif index_to_parse > 1
      if pronouns.include?(cleaned_word_arr[index_to_parse - 1]) || others.include?(cleaned_word_arr[index_to_parse - 1])
        meaning['pos'] = 'verb'
      elsif cleaned_word_arr[index_to_parse - 1] == ('this' || 'that')
        if pronouns.include?(cleaned_word_arr[index_to_parse + 1]) || (cleaned_word_arr[index_to_parse + 1] == 'that')
          meaning['pos'] = 'noun'
        else
          meaning['pos'] = 'verb'
        end
      elsif articles.include?(cleaned_word_arr[index_to_parse - 1]) || possessive_adjectives.include?(cleaned_word_arr[index_to_parse - 1])
        meaning['pos'] = 'noun'
      else
        if pronouns.include?(cleaned_word_arr[index_to_parse + 1])
          if !(possessive_adjectives.include?(cleaned_word_arr[index_to_parse - 1]) || articles.include?(cleaned_word_arr[index_to_parse - 1]) || ambig.include?(cleaned_word_arr[index_to_parse - 1]))
            meaning['pos'] = 'verb'
          else
            meaning['pos'] = 'I think it\'s a noun, but I got sloppy here'
          end
        else
          meaning['pos'] = "We do not yet have the parts of speeches for words, so we can\'t process this one"

        end
      end

    end
    return meaning
  end
end
