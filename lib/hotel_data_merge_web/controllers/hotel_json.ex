defmodule HotelDataMergeWeb.HotelJSON do
  def index(%{hotels: hotels}) do
    %{data: for(hotel <- hotels, do: data(hotel))}
  end

  defp data(hotel) do
    IO.inspect(hotel)
  end
end
