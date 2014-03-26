require "active_record"

require "./lib/answer"
require "./lib/question"
require "./lib/response"
require "./lib/survey"
require "./lib/taker"

database_configuration = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configuration['development']
ActiveRecord::Base.establish_connection(development_configuration)


def main_menu
  clear
  puts "Press 'a' for admin menu"
  puts "Press 'u' for user menu"

  case gets.chomp
  when 'a'
    admin_menu
  when 'u'
    user_menu
  else
    "Invalid"
    main_menu
  end
end


# ADMIN MENU -----------------------
def admin_menu
  clear
  puts "c: create survey, e: edit survey, s: survey stats, x: return to main menu"
  case gets.chomp
  when 'c'
    create_survey
  when 'e'
    edit_survey
  when 's'
    view_stats
  when 'x'
    main_menu
  else
    "Invalid"
    admin_menu
  end
end

def view_stats
  Survey.all.each_with_index { |survey, index| puts "#{index + 1}.  #{survey.name}" }
  puts "Enter a survey"
  survey_choice = gets.chomp.to_i - 1
  survey = Survey.find(Survey.all[survey_choice].id)
  survey_questions = Question.all.where(survey_id: survey.id)
  survey_questions.each do |q|
    puts q.name
    all_answers = []
    survey_responses = Response.all.where(question_id: q.id)
    survey_responses.each do |r|
      all_answers << r.answer_id
    end
    unique_answers = survey_responses.select(:answer_id).distinct
    answer_total = all_answers.length
    # puts answer_total
    unique_answers.each do |ua|
      answer_count = all_answers.grep(ua.answer_id).size
      answer_percentage = ((answer_count.to_f / answer_total.to_f) * 100).round
      puts "\t#{Answer.find(ua.answer_id).name} (Total: #{answer_percentage}%)"
    end
  end
  admin_menu
end

def create_survey
  clear
  puts "Enter a survey name:"
  name = gets.chomp
  new_survey = Survey.create({:name => name})
  @current_survey = new_survey
  add_question
end

def add_question
  clear
  puts "Enter a question:"
  question = gets.chomp
  new_question = Question.create({:name => question, :survey_id => @current_survey.id})
  @current_question = new_question
  add_answers
end

#maybe change to bulk add answers, split at "comma"
def add_answers
  clear
  puts "Enter the answers, split by a comma for each"
  answers = gets.chomp
  answers = answers.gsub(/,\s/,',')
  answers = answers.split(",")
  answers.each do |answer|
    new_answer = Answer.create({:name => answer, :question_id => @current_question.id})
  end
  puts "Do you want to add another question (y/n)?"
  input = gets.chomp
  if input == 'y'
    add_question
  else
    admin_menu
  end
end

def add_another(method_name)
  puts "Would you like to add another (y/n)?"
  user_choice = gets.chomp
  if user_choice == 'y'
    method(method_name).call
  else
    puts "Do you want to add another question (y/n)?"
    input = gets.chomp
    if input == 'y'
      add_question
    else
      admin_menu
    end
  end
end

# USER MENU -----------------------
def user_menu
  clear
  puts "l: login, r: register"
  case gets.chomp
  when 'l'
    puts "Enter your name:"
    @current_taker = Taker.find_by(name: gets.chomp)
  when 'r'
    puts "Enter your name:"
    taker_name = gets.chomp
    @current_taker = Taker.create({:name => taker_name})
  end
  list_surveys
end

def list_surveys
  clear
  puts "Completed Surveys:"
  completed = Survey.joins(:takers).where(takers: {id: @current_taker.id})
  # completed = Survey
  completed.each {|survey| puts survey.name }

  puts "Elligible Surveys:"
  Survey.all.each_with_index do |sur, index|
    if not completed.pluck(:id).include?(sur.id)
      puts "#{sur.id}: #{sur.name}"
    end
  end
  if Survey.all.length == completed.length
    puts "No available surveys.  Come back later.  Press enter to return to main menu."
    gets.chomp
    main_menu
  else
    puts "Enter the id of the survey:"
    survey_choice = gets.chomp.to_i
    survey = Survey.find(survey_choice)
    survey.takers << @current_taker
    take_survey(survey)
  end
end

def take_survey(survey)
  clear
  survey_questions = Question.all.where(survey_id: survey.id)
  survey_questions.each_with_index do |question, index|
    puts "#{index + 1}: #{question.name}"
    answers_hash = {}
    question.answers.each_with_index do |answer, index|
      answers_hash[index + 1] = answer.id
      puts "\t#{index + 1}: #{answer.name}"
    end
    puts "Enter ID for choice"
    hash_choice = gets.chomp.to_i
    choice = answers_hash[hash_choice]
    Response.create({:question_id => question.id, :answer_id => Answer.find(choice).id, :taker_id => @current_taker.id })
  end
  puts "Survey Complete"
  user_menu
end


def clear
  system('clear')
end

main_menu











