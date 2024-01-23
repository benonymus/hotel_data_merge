defmodule HotelDataMerge.HotelDataProviders.Params.Patagonia do
  @moduledoc """
  Params for casting external data
  """
  use Parameter.Schema

  defmodule ImageModel do
    @moduledoc false
    use Parameter.Schema

    param do
      field(:link, :string, key: "url")
      field(:description, :string)
    end
  end

  # Fields that are not supplied by the provider are left out.
  # For the full list of fields check the unified schema.
  param do
    field(:id, :string, required: true)
    field(:destination_id, :integer, key: "destination", required: true)
    field(:name, :string)
    field(:description, :string, key: "info")

    has_one :amenities, Amenities do
      field(:room, {:array, :string})
    end

    has_one :location, Location do
      field(:lat, :decimal)
      field(:lng, :decimal)
      field(:address, :string)
    end

    has_one :images, Images do
      has_many(:rooms, ImageModel)
      has_many(:amenities, ImageModel)
    end
  end

  @spec load(map()) :: {:ok, map()} | {:error, any()}
  def load(data) do
    data =
      data
      |> adjust_amenities()
      |> adjust_location()

    Parameter.load(__MODULE__, data, ignore_empty: true, ignore_nil: true)
  end

  # provider specific adjustments
  defp adjust_amenities(%{"amenities" => room_amenities} = data),
    do: Map.replace(data, "amenities", %{"room" => room_amenities})

  defp adjust_location(data),
    do: Map.put(data, "location", Map.take(data, ["lat", "lng", "address"]))
end
