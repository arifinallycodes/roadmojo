require "spec_helper"

describe SpecialEmailsController do
  describe "routing" do

    it "routes to #index" do
      get("/special_emails").should route_to("special_emails#index")
    end

    it "routes to #new" do
      get("/special_emails/new").should route_to("special_emails#new")
    end

    it "routes to #show" do
      get("/special_emails/1").should route_to("special_emails#show", :id => "1")
    end

    it "routes to #edit" do
      get("/special_emails/1/edit").should route_to("special_emails#edit", :id => "1")
    end

    it "routes to #create" do
      post("/special_emails").should route_to("special_emails#create")
    end

    it "routes to #update" do
      put("/special_emails/1").should route_to("special_emails#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/special_emails/1").should route_to("special_emails#destroy", :id => "1")
    end

  end
end
