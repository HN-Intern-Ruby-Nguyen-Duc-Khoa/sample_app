module UsersHelper
  def gravatar_for user, size = Settings.users.img_size
#    binding.pry
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, size:size, alt: user.name, class: "gravatar")
  end
end
