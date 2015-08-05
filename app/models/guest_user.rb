class GuestUser
  def email
    "example@gmail.com"
  end

  def authenticated?
    false
  end

  def nickname
    "friend"
  end

  def on_slack_team?
    false
  end
end
