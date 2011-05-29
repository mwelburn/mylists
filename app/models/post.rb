class Post < ActiveRecord::Base

  belongs_to :user
  belongs_to :group

  validates_presence_of :user_id, :message, :group_id

  attr_accessible :user_id, :message, :group_id, :topic_id, :created_at, :updated_at

  #has_many :comments, :dependent => :destroy, :class_name => "Post"

  def replies
    Post.where("topic_id = ?", self.id).order("created_at asc")
    #Post.find_all_by_topic_id(self.id).order("created_at desc")
  end

  def self.find_message_by_search_query(q)
    Post.find_all_by_message("%#{q}%")
  end

  def self.find_user_by_search_query(q)
    users = User.find_all_by_username("%#{q}%")
    Post.find_all_by_user_id(users)
  end

  def is_editable?
    return self.user_id = current_user.id
  end

  def is_reply_to?(post)
    return self.topic_id = post.id
    #return Reply.find_by_post_id_and_initial_post_id(self.id, post.id).nil?
  end

  def add_reply(post)
    #self.topic_id = post.id
    #reply = replies.build(:initial_post_id => self.id, :post_id => post.id)
    #if !reply.save
    #  logger.debug "Post '${new_post.message}' already replied to '${post.message}'."
    #end
  end

end
