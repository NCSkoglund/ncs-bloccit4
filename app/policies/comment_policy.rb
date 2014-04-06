class CommentPolicy < ApplicationPolicy

  # class Scope < Struct.new(:user, :scope)
  #   def resolve
  #     if user.present?
  #       scope.all
  #     else
  #       puts scope.to_yaml
  #       scope.joins(:post).where("post IS NOT NULL")
  #     end
  #   end
  # end

  def show?
    puts "**** #{record.to_yaml}"
    user.present? || ( record.each { |comment| puts comment if comment.post.topic.public? } )
    # The above works but does not filter for privacy.
    # Run through the comments array and print each comment depending on whether its topic is public or not
    # Or define something in the Users controller that allows one comment to be selected at a time?
    #
    # This works for first/last entries:  user.present? || record.first.post.topic.public?
  end

  def destroy?
    user.present? && (record.user == user || user.role?(:admin) || user.role?(:moderator))
  end
end