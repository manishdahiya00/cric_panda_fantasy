module ApplicationHelper

  def contest_category_for_collection
    ContestCategory.active.sort_by(&:title).collect{ |a| [a.title, a.id] }
  end

  # def contest_category_name(cid)
  # 	ContestCategory.find(cid).title
  # end
  
end
