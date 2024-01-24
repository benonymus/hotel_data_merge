defmodule HotelDataMerge.HotelDataProviders.Params.Acme do
  @moduledoc """
  Params for casting external data
  """
  use Parameter.Schema

  # Fields that are not supplied by the provider are left out.
  # For the full list of fields check the unified schema.
  param do
    field(:id, :string, key: "Id", required: true)
    field(:destination_id, :integer, key: "DestinationId", required: true)
    field(:name, :string, key: "Name")
    field(:description, :string, key: "Description")

    has_one :amenities, Amenities, key: "Facilities" do
      field(:general, {:array, :string})
    end

    has_one :location, Location do
      field(:lat, :float, key: "Latitude")
      field(:lng, :float, key: "Longitude")
      field(:address, :string, key: "Address")
      field(:city, :string, key: "City")
      field(:country, :string, key: "Country")
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
  defp adjust_amenities(%{"Facilities" => general_amenities} = data),
    do: Map.replace(data, "Facilities", %{"general" => general_amenities})

  defp adjust_location(data),
    do:
      Map.put(
        data,
        "location",
        Map.take(data, ["Latitude", "Longitude", "Address", "City", "Country"])
      )
end
