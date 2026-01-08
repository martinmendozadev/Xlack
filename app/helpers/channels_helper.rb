module ChannelsHelper
  def channel_display_name(channel)
    if channel.is_private?
      other_user = channel.users.find { |u| u != current_user }

      other_user ? other_user.username : "Usuario eliminado"
    else
      "#{channel.name}"
    end
  end

  def channel_icon(channel)
    if channel.is_private?
      raw('<svg class="mr-2 h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg>')
    else
      raw('<span class="mr-2">#</span>')
    end
  end
end
