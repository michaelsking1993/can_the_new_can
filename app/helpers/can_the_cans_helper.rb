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






  def scrape
    verbs = Word.where(pos: 'v')
    verbs.each do |verb|

      page_url = "http://www.verbix.com/webverbix/English/#{verb}.html"
      


      original_word = Word.where(word: word, inflection_form: 'itself')
      page = Nokogiri::HTML(open(page_url, "User-Agent" => "Mozilla/5.0"))
      conjugations = []
      different_infinitives = []
      debugger
      page.css('.irregular, .normal, .orto').each_with_index do |verb, index|
        #0 = infinitive, 1 = participle, 2 = gerund
        if index == 0
          if !verb.text.split(' ')[1] == word
            different_infinitives.push(word)
          end
        elsif index == 1
          participle = verb.text
          Word.create!(word: word, inflection_form: 'participle')
        elsif index == 2
        elsif index > 2

        end


      end
    end



      # the URL for the es-en WR dict is built in the format 'baseURL/translation.asp?=word'
      #page_url = "http://www.wordreference.com/#{target_language_code}/en/translation.asp?spen=" + word
      ## TODO: when refactoring the method to operate with more languages, there needs to be
      ##       some tweaking. Sadly wordreference doesn't use the same URL structure
      ##       for all languages, so the German URL e.g. looks like this 'deen' (no '/')


      # creating a bucket for the simple definitions and the compound phrases

      #return 'oh shit, it didn\'t work - enter in another word' if !page.css('tr.even, tr.odd').present?
      debugger
      #this is where all the stuff for this word will be put. We can differentiate between
      #actual word entries and compound phrase entries by taking the headword of each word, splitting it, and seeing if
      #the count is equal to one or greater than one.

      wrd_clicked_hash = {}
      def_list = []

      wrd_clicked_hash['def_list'] = def_list
      wrd_clicked_hash['page_url'] = page_url
      wrd_clicked_hash['definition_url'] = definition_url
      wrd_clicked_hash['conjugation_url'] = conjugation_url


      #First, get the possibilities of what the word could be along with the corresponding word forms, all of which is
      # contained at the top of the page


      #I'm not yet done with the below code, but i'm leaving it since we'll incorporate it once there's a place for it
      #in the design.
      #for now this will only work for Spanish since "inflexiones", but we can easily change !

      #if page.at_css('div[id="WHlinks"]').next_element.next_element.next_element.text.eql?('Inflexiones')
      #if true, it's a noun and/or an adjective, and the inflections are on the page
      # if page.at_css('div[id="WHlinks"]').next_element.next_element.next_element.next_element.next_element.text.eql?('n')
      #it's a noun, and the inflections will be after it
      # elsif page.at_css('div[id="WHlinks"]').next_element.next_element.next_element.next_element.next_element.text.eql?('n')

      #end
      #else

      #possibility_hash = {}
      #For spanish (asombro), the next line gives back 'n' for noun
      # possibility_hash['pos'] = page.at_css('div[id="WHlinks"]').next_element.next_element.next_element.next_element.next_element.text
      #For Spanish (asombro), then next line gives back "mpl" for "male, plural"
      #possibility_hash['pos_specifics'] = page.at_css('div[id="WHlinks"]').next_element.next_element.next_element.next_element.next_element.next_element.text
      #possibility_hash['headword'] = page.at_css('div[id="WHlinks"]').next_element.next_element.next_element.next_element.text
      #end

      #possibilities_arr.push(possibility_hash)
      #end

      # if something equals verb?
      #    do the verb stuff
      # end
      #procedencia = page.at_css('dl').children.each do |possible_word_form|
      #at_css('dt').text.gsub(/\(.*?\)/, "").strip
      #iterate over the children and grab the types, push them all into an array
      #end


      #find all the css classes with the even or the odd class, which is how the page is structured - it changes for each
      #new entry, which is also how the css is set up in order to change the coloring on the entries
      page.css('tr.even, tr.odd').each do |juicy_tidbit|
        # we're looking for the rows that have an id and from there we'll traverse down the dom,
        # so if it doesn't have an id, we'll ignore it (as you'll see, we'll already have iterated over them by the time
        # it becomes a juicy_tidbit - aka, we'll already have squeezed the juice out of it)
        if juicy_tidbit.attr('id').nil?
          next # skip to the next juicy_tidbit
        else
          last_class = juicy_tidbit.attr('class') #set the last class name in order to know when it's a new word entry
          this_def_hash = {} # this is the hash that we'll put all the stuff into for this definition
          this_def_hash['headword'] = juicy_tidbit.css('strong').text.gsub('⇒', '') #set the headword so that we can know if it's a word or a compound phrase, and what the compound phrase is if so
          # we get the pos by finding the first td element, then finding the em element, and getting the text from only
          # the first layer of nesting, ignoring everything under that
          this_def_hash['pos'] = juicy_tidbit.css('td')[0].css('em > text()').text
          # the 'i' tags represent the formality of the word, of which there are anywhere from 0 to 2 on any given
          # first line of an entry (meaning this might fuck up for others)so we'll check if it's there, and if it is, we'll grab it
          # and set it equal to 'formality'. if it isn't there, juicy_tidbit...('i') is [], whereas ('i')[0] will be nil
          if juicy_tidbit.css('td')[1].css('i')[0]
            formality = juicy_tidbit.css('td')[1].css('i')[0].text
            this_def_hash['formality'] = ' (' + formality.to_s + ')'
            count = juicy_tidbit.css('td')[1].children.count
            simple_def = juicy_tidbit.css('td')[1].children[count - 2].text
            this_def_hash['meaning'] = simple_def
          else
            #otherwise, we'll just set it equal to the simple def, with no formality included
            simple_def = juicy_tidbit.css('td > text()')[1].text.strip.gsub(/[()]/, '')
            this_def_hash['meaning'] = simple_def
            this_def_hash['formality'] = ''
          end
        end

        # we'll get the simple_def by getting the 2nd td element in this first row (aka, the juicy_tidbit row),
        # and we'll get the text, strip the leading and trailing whitespace, and remove the parentheses with gsub

        #if the formality was set, we'll include it in our meaning with a pair of parentheses
        # around it (we removed the parentheses from the definition and kept them for the meaning, ha - we can totally
        # change this up, and could have handled it outside of the function, but I figured I'd include it because I was
        # having fun).


        #if juicy_tidbit.css('td')[1].children[2]
        #simple_def = juicy_tidbit.css('td')[1].children[2].text.strip.gsub(/[()]/, '').gsub(/\A\p{Space}*|\p{Space}*\z/, '')
        #elsif juicy_tidbit.css('td')[1].children[4]
        #  simple_def = juicy_tidbit.css('td')[1].children[4].text.strip.gsub(/[()]/, '').gsub(/\A\p{Space}*|\p{Space}*\z/, '')
        #else
        #  simple_def juicy_tidbit.css('td')[1].children[3].text.strip.gsub(/[()]/, '').gsub(/\A\p{Space}*|\p{Space}*\z/, '')
        # end



        #we'll make a new array for the translations below, and then we'll iterate over the rest of the rows and grab
        # them and throw them into the arr.
        trans_arr = []
        #set the translations key of the hash equal to the empty array
        this_def_hash['translations'] = trans_arr
        #get the translation by finding the 'td.ToWrd' class from within the children of the juicy_tidbit and stripping
        # the text - but we'll only do so if the 'td.ToWrd' exists, so we include an if statement
        trans = juicy_tidbit.children.at('td.ToWrd > text()').text.strip if juicy_tidbit.children.at('td.ToWrd')
        #then we'll push the translation, assuming we did so above
        trans_arr.push(trans) if trans
        #we'll then set next_row equal to the sibling row with the same class directly beneath it on the dom,
        # which will return nil if it doesn't exist
        next_row = juicy_tidbit.at("+ tr.#{last_class}")
        #from here, we'll create a loop that keeps going until next_row is nil, or until the class name is 'even more'
        # or "odd more " (it was getting confused at one point and counting even more / odd more as odd / even)
        until !next_row || next_row.attr('class') == 'even more' || next_row.attr('class') == 'odd more'
          # set the example_sentence equal to the children of the text from just the first level of nesting of the
          # next row element+class combo that's equal to 'td.FrEx', get the text, and strip it - but only if 'td.frex' exists
          this_def_hash['example_sentence'] = next_row.children.at('td.FrEx > text()').text.strip if next_row.children.at('td.FrEx')
          #if the ToWrd class on a td element exists, we'll get the trqnslations from teh first level of nesting, strip it,
          # and put push it into the trans_arr.
          # I didn't do a same line if statement here because of the two lines of code, which would've required
          # me to write the same line if statement on both lines like I did before the until loop,
          # but I wasn't about that life at this point in the process.
          if next_row.children.at('td.ToWrd')
            trans = next_row.children.at('td.ToWrd > text()').text.strip
            trans_arr.push(trans)
          end
          # after all the above is said and done, we'll set the next_row variable
          # equal to the next row after the next row, which will return nil if it doesn't exist, which will then
          # stop our until loop from continuing.
          next_row = next_row.at("+ tr.#{last_class}")
        end
        # after all is actually said and done, push the this_def_hash into the def_list array, and go to the next juicy
        # tidbit that has an id attribute so that we can suck the juicy tidbits from it and it's siblings (hehe)
        def_list.push(this_def_hash)
      end
      possibilities = self.get_possibilities(def_list)
      unique_indices = possibilities[:pos_indices].concat(possibilities[:accents_indices]).uniq
      wrd_clicked_hash['unique_indices'] = unique_indices
      #debugger
      verb_form_hash = {}
      if page.css('dl').count > 0
        verb_elements = page.css('dl').children
        from_verb_arr = verb_elements[0].text.split(" ") if verb_elements[0]
        from_verb_arr.delete_at(3) if from_verb_arr[3].eql?('(conjugar)')
        verb_form_hash['from_verb'] = from_verb_arr.join(' ').gsub(':', '')
        verb_form_hash['without_accent'] = verb_elements[1].text.split(' ')[0] if verb_elements[1]
        verb_form_hash['without_accent_form'] = verb_elements[2].text if verb_elements[2]
        if verb_elements[3]
          verb_form_hash['with_accent'] = verb_elements[3].text.split(' ')[0]
          verb_form_hash['with_accent_form'] = verb_elements[4].text if verb_elements[4]
        else
          verb_form_hash['with_accent'] = ''
          verb_form_hash['with_accent_form'] = ''
        end
      else
        verb_form_hash['from_verb'] = ''
        verb_form_hash['without_accent'] = ''
        verb_form_hash['without_accent_form'] = ''
        verb_form_hash['with_accent'] = ''
        verb_form_hash['with_accent_form'] = ''
      end
      wrd_clicked_hash['accented_verbs'] = verb_form_hash

      return wrd_clicked_hash
      #debugger
  end
end
