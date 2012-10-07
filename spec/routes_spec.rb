require 'spec_helper'

describe "messages routes" do

  let(:default_controller) { "acts_as_messageable/messages" }

  it "GET /messages" do
    expect(:get => "/messages").to route_to(
      :controller => default_controller,
      :action => "index"
    )
  end

  it "GET /messages/1" do
    expect(:get => "/messages/1").to route_to(
      :controller => default_controller,
      :action => "show",
      :id => "1"
    )
  end

  it "GET /messages/new" do
    expect(:get => "/messages/new").to route_to(
       :controller => default_controller,
       :action => "new"
     )
  end

  it "GET /messages/1/reply" do
    expect(:get => "/messages/1/reply").to route_to(
       :controller => default_controller,
       :action => "reply",
       :id => "1"
     )
  end

  it "POST /messages" do
    expect(:post => "/messages").to route_to(
      :controller => default_controller,
      :action => "create"
    )
  end

  it "POST /messages/1/reply" do
    expect(:post => "/messages/1/reply").to route_to(
      :controller => default_controller,
      :action => "reply",
      :id => "1"
    )
  end

  it "PUT /messages/1" do
    expect(:put => "/messages/1").to route_to(
      :controller => default_controller,
      :action => "update",
      :id => "1"
    )
  end

  it "DELETE /messages/1" do
    expect(:delete => "/messages/1").to route_to(
      :controller => default_controller,
      :action => "destroy",
      :id => "1"
    )
  end
end
