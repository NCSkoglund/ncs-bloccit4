class FavoriteMailer < ActionMailer::Base
  default from: "faux_email@example.com"

  def new_comment(user, post, comment)
    @user = user
    @post = post
    @comment = comment

    # New Headers
    headers["Message-ID"] = "<comments/#{@comment.id}@ncs-bloccit4.example>"
    headers["In-Reply-To"] = "<post/#{@post.id}@ncs-bloccit4.example>"
    headers["References"] = "<post/#{@post.id}@ncs-bloccit4.example>"

    mail(to: user.email, subject: "New comment on #{post.title}")
  end
end
