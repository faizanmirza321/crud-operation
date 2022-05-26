
require 'rails_helper'
RSpec.describe 'User', type: :request do
  describe 'GET /index' do
    let!(:user) { FactoryBot.create_list(:user, 1) }
    let(:observed_response_json) do 
      {
        "status"=>200, 
        "users"=>
        [
          {
            "id"=>user.first.id,
            "firstName"=>user.first.firstName,
            "lastName"=>user.first.lastName,
            "email"=>user.first.email,
            "created_at"=>user.first.created_at.as_json,
            "updated_at"=>user.first.updated_at.as_json
          }
        ]
      }
    end 
    it 'it checks the value of user' do
      get '/api/users'
      expect(json).to eq(observed_response_json)
    end 
  
    it 'returns all users' do
      get '/api/users'
      expect(json.size).to eq(2)
    end

    it 'returns all users' do
      get '/api/users', params:{
        page: "3",
      }
      expect(response).to have_http_status(:success)
    end

    it 'returns status code 200' do
      get '/api/users'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    before do
      @user =  User.create(firstName: "deepak", lastName: "check", email: "check123777@yepmail.com")
    end
    it 'returns status code 200' do
      post '/api/user'
      expect(response).to have_http_status(:success)
    end

    it 'if the params are empty' do
      post '/api/user', params:{
        firstName: "",
        lastName: "",
        email: ""
      }
      expect(response).to have_http_status(:success)
    end 

    it 'it includes first name as' do
      post '/api/user'
      body = JSON.parse(response.body)
      expect(body["message"]).to eql("User created sucessfully")
    end

    it "it is a valid record" do
      post '/api/user'
      expect(@user).to be_valid 
    end 
  end

  describe 'PATCH /update' do
    let!(:user) { User.create(firstName: "deepak", lastName: "check", email: "check123777@yepmail.com") }
     it 'changes the user firstname and last name' do
      patch "/api/user/#{user.id}", params:{
        firstName: "John",
        lastName: "Smith"
      }
      expect(user.firstName) == "John"
      expect(user.lastName) == "Smith"
     end 
     it 'returns status code 200' do
      patch "/api/user/#{user.id}"
      expect(response).to have_http_status(:success)
    end
  end 
  
  describe "DELETE /user" do
    before do
     @user = User.create(firstName: "testto", lastName: "delete", email: "check123777@yepmail.com")
    end

    # let!(:user) { User.create(firstName: "testto", lastName: "delete", email: "check123777@yepmail.com") }
    it "deletes the created user" do
      delete "/api/user/#{@user.id}" 
    end

    it 'returns status code 200' do
      delete "/api/user/#{@user.id}"   
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /user' do
    before do
      @user =  User.create(firstName: "deepak", lastName: "check", email: "check123777@yepmail.com")
     end
    let(:observed_response_json_two) do 
    {
      "status" => 200, 
      "user" =>
        {
          "id"=> @user.id,
          "firstName"=> @user.firstName,
          "lastName"=> @user.lastName,
          "email"=> @user.email,
          "created_at"=> @user.created_at.as_json,
          "updated_at"=> @user.updated_at.as_json
        }
    }
    end
    it 'it checks the value of user' do
      get "/api/user/#{@user.id}"
      expect(json).to eq(observed_response_json_two)
    end
  end

  describe 'GET /typehead' do
    before do
      @user =  User.create(firstName: "deepak", lastName: "check", email: "check123777@yepmail.com")
    end
    let!(:search_response) do
      {
        "status" => 200, 
        "users" =>
        [
          {
            "id"=> @user.id,
            "firstName"=> @user.firstName,
            "lastName"=> @user.lastName,
            "email"=> @user.email,
            "created_at"=> @user.created_at.as_json,
            "updated_at"=> @user.updated_at.as_json
          } 

        ]
       }
    end
    it 'it checks the searched value' do
      get "/api/typeahead/deepak", params: {
        input: "deepak"
      }
      expect(json).to eq(search_response)
    end
  end 
end
