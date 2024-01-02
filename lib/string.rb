# frozen_string_literal: true

# Monkey patching String class to check if string is a number
class String
  def number?
    true if Float(self)
  rescue StandardError
    false
  end
end
