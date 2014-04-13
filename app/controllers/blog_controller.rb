class BlogController < ApplicationController

	before_filter :authenticate_user!, :except => :show

	respond_to :html
	respond_to :json, :only => [:index, :show]

	def index
		@person = Person.find_from_guid_or_username({:id => params[:person_id]})

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

      format.json { render :json => @stream.stream_posts.map { |p| LastThreeCommentsDecorator.new(PostPresenter.new(p, current_user)) }}
    end


	end

	def show
		
	end

end
