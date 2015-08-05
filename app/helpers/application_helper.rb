require 'digest/md5'

module ApplicationHelper
  def avatar_url(user, size)
    if user.image
      user.image
    else
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      default_img = "http://i.imgur.com/cUCKHb9.jpg"
      "http://gravatar.com/avatar/#{gravatar_id}.png?d=#{default_img}&s=#{size}"
    end
  end
end
