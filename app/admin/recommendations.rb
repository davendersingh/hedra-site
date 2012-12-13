ActiveAdmin.register Recommendation do

  controller do
    def scoped_collection
      Recommendation.includes(:book)
    end
  end

  index do
    selectable_column
    column :id
    column :book
    column :updated_at
    default_actions
  end


end
