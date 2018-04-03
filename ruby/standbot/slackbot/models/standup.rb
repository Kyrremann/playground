# coding: utf-8
class Standup < Sequel::Model
  # plugin :validation_helpers

  # def validate
  #   validates_presence [:name, :year]
  #   validates_includes 1..10, :rating
  #   if genre == "Horror"
  #     validates_presence :rated
  #   end
  # end

  def pretty_report
    message  = ""
    if yesterday
      message += "Igår: #{yesterday}\n"
    end
    if today
      message += "Idag: #{today}\n"
    end
    if problems
      message += "Problem: #{problems}\n"
    end
    return message
  end
end
