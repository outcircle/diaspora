class ArticlesController < ApplicationController

	before_filter :authenticate_user! , :except => :show 
	before_filter -> {@css_framework = :bootstrap} , only: [:show]
	respond_to :html
	respond_to :json, :only => [:index]

	def index
		#binding.pry
    #@person = Person.find_from_guid_or_username({:id => params[:person_id]})
    @person = Person.find(params[:person_id])
    
    @articles = @person.articles.paginate(:page => params[:page], :per_page => 10)
    
    unless params[:format] == "json" # hovercard
      if current_user
        @block = current_user.blocks.where(:person_id => @person.id).first
        @contact = current_user.contact_for(@person)
        if @contact && !params[:only_posts]
          @contacts_of_contact_count = @contact.contacts.count
          @contacts_of_contact = @contact.contacts.limit(8)
        else
          @contact ||= Contact.new
        end
      end
    end
    
    respond_to do |format|
      format.all do
        respond_with @person, :locals => {:post_type => :all}
      end
    end
	end

	def show
		@article = current_user.articles.find(params[:id])
	end

	def new
  	@article = current_user.articles.new()

	end

	def create
		@article = current_user.articles.build(article_params)
		@article.save

		redirect_to person_blog_articles_path(current_user)
	end

	def edit
		
	end

	def update
		
	end

	def destroy
		
	end


	private
		def article_params
		  params.require(:article).permit(:user_id ,:title , :content)	
		end

end
