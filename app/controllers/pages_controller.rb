class PagesController < ApplicationController

  def home
    @features = Feature.includes(:page).joins(:features_publishers).includes(:book => { :participations => [:person, :role] }).where("features_publishers.publisher_id = #{session[:publisher]}").first(6)

    @new_releases = Book.joins(:new_releases).where("books.publisher_id = #{session[:publisher]}").order("books.position desc, books.id desc").first(4)

    @recommendations = Book.joins(:recommendations).where("books.publisher_id = #{session[:publisher]}").order("books.position desc, books.id desc")
  end

  def about
  end

  def contact
  end

  def tag
    @tag   = Tag.where("name = ? or slug = ?", params[:id], params[:id]).first || not_found
    @page  = @tag.page
    @entity = @tag

    books_query = Book.joins(:tags).where("books.publisher_id = #{session[:publisher]} and tags.id = #{@tag.id}").order("books.position desc, books.id desc")
    books_count = books_query.count
    @highlight = books_query.first(4) if books_count >= 6 and (params[:page].nil? or params[:page] == "1")
    @books = books_query.paginate(:page => params[:page], :per_page => 10, :offset => (books_count >= 6 ? 4 : 0), :total_entries => (books_count >= 6 ? books_count - 4 : books_count))
  end

  def authors
    @authors = Person.all.sort_by{|p| SortAlphabetical.normalize(p.name.gsub("[","")).upcase }

    @authors = @authors.group_by{|p| SortAlphabetical.normalize(p.name.gsub("[","")[0]).upcase} 
  end

  def author
    author = Person.where(name: params[:name]).first || not_found 
    @page = author.page
    @entity = author

    books_query = Book.joins(participations: [:role, :person]).where("books.publisher_id = #{session[:publisher]} and people.name = ?", author.name).order("books.position desc, books.id desc").uniq
    books_count = books_query.count
    @highlight = books_query.first(4) if books_count >= 6 and (params[:page].nil? or params[:page] == "1")
    @books = books_query.paginate(:page => params[:page], :per_page => 10, :offset => (books_count >= 6 ? 4 : 0), :total_entries => (books_count >= 6 ? books_count - 4 : books_count))

    render action: "tag"
  end

end
