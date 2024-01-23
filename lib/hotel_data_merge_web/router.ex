defmodule HotelDataMergeWeb.Router do
  use HotelDataMergeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HotelDataMergeWeb do
    pipe_through :api

    get "/hotels", HotelController, :index
  end
end
