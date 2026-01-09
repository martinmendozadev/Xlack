module MessagesHelper
  def format_message_content(content)
    sanitized_content = html_escape(content)

    formatted_content = sanitized_content.gsub(/@(\w+)/) do |match|
      username = Regexp.last_match(1)

      if User.exists?(username: username)
        "<span class='bg-blue-100 text-blue-800 font-semibold px-1 rounded'>#{match}</span>"
      else
        match
      end
    end

    simple_format(formatted_content, {}, sanitize: false)
  end
end
