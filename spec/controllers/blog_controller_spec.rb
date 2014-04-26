require 'spec_helper'

describe BlogController do
	
	describe '#index' do
		context 'user signed in' do
			before do
				@user = alice
        sign_in @user
        @aspect = @user.aspects.first
      end

	    it 'succeeds' do
	        get :index, :person_id => @user.guid
	        response.should be_success
	    end  

	    it "assigns all the user's posts" do
        @user.posts.should be_empty
        @user.post(:status_message, :text => "to one aspect", :to => @aspect.id)
        @user.post(:status_message, :text => "to all aspects", :to => 'all')
        @user.post(:status_message, :text => "public", :to => 'all', :public => true)
        @user.reload.posts.length.should == 3
        get :index, :person_id => @user.guid
        assigns(:stream).posts.map(&:id).should =~ @user.posts.map(&:id)
      end

		end
	
	end

end
