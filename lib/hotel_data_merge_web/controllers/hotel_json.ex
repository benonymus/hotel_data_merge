defmodule HotelDataMergeWeb.HotelJSON do
  def index(%{hotels: hotels}) do
    %{data: for(data <- hotels, do: hotel(data))}
  end

  defp hotel(data) do
    %{
      id: data.id,
      destination_id: data.destination_id,
      name: data.name,
      description: data.description,
      booking_conditions: data.booking_conditions,
      location: location(data.location),
      amenities: amenities(data.amenities),
      images: images(data.images)
    }
  end

  defp location(data) do
    %{
      lat: data.lat,
      lng: data.lng,
      address: data.address,
      city: data.city,
      country: data.country
    }
  end

  defp amenities(data) do
    %{
      general: data.general,
      room: data.room
    }
  end

  defp images(data) do
    %{
      rooms: for(image <- data.rooms, do: image_model(image)),
      site: for(image <- data.site, do: image_model(image)),
      amenities: for(image <- data.amenities, do: image_model(image))
    }
  end

  defp image_model(data) do
    %{link: data.link, description: data.description}
  end
end
