require 'spec_helper'

describe IssuesController do

	let(:valid_attributes) do
		{title: 'myTitle', description:'A very good issue'}
	end

	let(:invalid_params) do
		{"title" => nil, "description" => nil}
	end

	let(:valid_session) do
		{}
	end

	describe 'GET index' do
		it "assigns @issues" do
      		issue = Issue.create valid_attributes
      		get :index
      		expect(assigns(:issues)).to eq([issue])
    	end

    	it "renders the index template" do
      		get :index
      		expect(response).to render_template("index")
    	end
	end

	describe "GET show" do
    	it "assigns the requested issue as @issue" do
      		issue = Issue.create! valid_attributes
      		get :show, {:id => issue.to_param}, valid_session
      		assigns(:issue).should eq(issue)
    	end
  	end

  	describe "GET new" do
    	it "assigns a new issue as @issue" do
      		get :new, {}, valid_session
      		assigns(:issue).should be_a_new(Issue)
    	end
  	end

  	describe "GET edit" do
    	it "assigns the requested person as @person" do
      		issue = Issue.create! valid_attributes
      		get :edit, {:id => issue.to_param}, valid_session
      		assigns(:issue).should eq(issue)
    	end
  	end

  	describe "POST create" do
	    describe "with valid params" do
	      it "creates a new issue" do
	        expect {
	          post :create, {:issue => valid_attributes}, valid_session
	        }.to change(Issue, :count).by(1)
	      end

	      it "assigns a newly created issue as @issue" do
	        post :create, {:issue => valid_attributes}, valid_session
	        assigns(:issue).should be_a(Issue)
	        assigns(:issue).should be_persisted
	      end

	      it "redirects to the created issue" do
	        post :create, {:issue => valid_attributes}, valid_session
	        response.should redirect_to(Issue.last)
	      end
	    end

	    describe "with invalid params" do
	      it "assigns a newly created but unsaved issue as @issue" do
	        # Trigger the behavior that occurs when invalid params are submitted
	        Issue.any_instance.stub(:save).and_return(false)
	        post :create, {:issue => invalid_params}, valid_session
	        assigns(:issue).should be_a_new(Issue)
	      end

	      it "re-renders the 'new' template" do
	        # Trigger the behavior that occurs when invalid params are submitted
	        Issue.any_instance.stub(:save).and_return(false)
	        post :create, {:issue => invalid_params}, valid_session
	        response.should render_template("new")
	      end
	    end
  	end

  	 describe "PUT update" do
	    describe "with valid params" do
	      it "updates the requested issue" do
	        issue = Issue.create! valid_attributes
	        # Assuming there are no other people in the database, this
	        # specifies that the Issue created on the previous line
	        # receives the :update_attributes message with whatever params are
	        # submitted in the request.
	        Issue.any_instance.should_receive(:update).with({ "title" => "MyString" })
	        put :update, {:id => issue.to_param, :issue => { "title" => "MyString" }}, valid_session
	      end

	      it "assigns the requested issue as @issue" do
	        issue = Issue.create! valid_attributes
	        put :update, {:id => issue.to_param, :issue => valid_attributes}, valid_session
	        assigns(:issue).should eq(issue)
	      end

	      it "redirects to the issue" do
	        issue = Issue.create! valid_attributes
	        put :update, {:id => issue.to_param, :issue => valid_attributes}, valid_session
	        response.should redirect_to(issue)
	      end
	    end

	    describe "with invalid params" do
	      it "assigns the issue as @issue" do
	        issue = Issue.create! valid_attributes
	        # Trigger the behavior that occurs when invalid params are submitted
	        Issue.any_instance.stub(:save).and_return(false)
	        put :update, {:id => issue.to_param, :issue => invalid_params}, valid_session
	        assigns(:issue).should eq(issue)
	      end

	      it "re-renders the 'edit' template" do
	        issue = Issue.create! valid_attributes
	        # Trigger the behavior that occurs when invalid params are submitted
	        Issue.any_instance.stub(:save).and_return(false)
	        put :update, {:id => issue.to_param, :issue => invalid_params}, valid_session
	        response.should render_template("edit")
	      end
	    end
  	end
end
