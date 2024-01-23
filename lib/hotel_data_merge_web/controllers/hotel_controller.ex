defmodule HotelDataMergeWeb.HotelController do
  use HotelDataMergeWeb, :controller

  def index(conn, %{"destination_id" => destination_id}) do
    # get hotels
    render(conn, :index, hotels: [])
  end

  def index(conn, %{"hotel_id" => hotel_ids}) do
    # get hotels
    render(conn, :index, hotels: [])
  end

  def index(conn, _) do
    render(conn, :index, hotels: [])
  end
end
