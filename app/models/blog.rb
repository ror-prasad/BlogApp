class Blog < ActiveRecord::Base

  validates :title, presence: true, length: {minimum: 10}
  validates :body, presence: true

  def self.search(search)
    where("title LIKE ?", "%#{search}%")
  end

  def self.sort_blogs(type, search)

    
    unless search.blank?
      sorted_blogs = search(search)
    else
      sorted_blogs = self.all
    end

    if type.eql?('latest')
      sorted_blogs = sorted_blogs.order(created_at: :desc)
    end

    if type.eql?('popular')
      sorted_blogs = sorted_blogs.order(view_count: :desc)
    end

    if type.eql?('oldest')
      sorted_blogs = sorted_blogs.order(created_at: :asc)
    end

    sorted_blogs

  end

  def add_view_count
    update(view_count: view_count+1)
  end

end
