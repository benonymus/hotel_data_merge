defmodule HotelDataMergeWeb.HotelController do
  use HotelDataMergeWeb, :controller

  alias HotelDataMerge.HotelDataProviders.Data

  def index(conn, params) do
    conn
    |> put_status(200)
    |> render(:index, hotels: Data.get(params))
  end
end
