defmodule HotelDataMerge.HotelDataProviders.Params.Paperflies do
  @moduledoc """
  Params for casting external data
  """
  use Parameter.Schema

  defmodule ImageModel do
    use Parameter.Schema

    param do
      field(:link, :string)
      field(:description, :string, key: "caption")
    end
  end

  # Fields that are not supplied by the provider are left out.
  # For the full list of fields check the unified schema.
  param do
    field(:id, :string, key: "hotel_id", required: true)
    field(:destination_id, :integer, required: true)
    field(:name, :string, key: "hotel_name")
    field(:description, :string, key: "details")
    field(:booking_conditions, {:array, :string})

    has_one :amenities, Amenities do
      field(:general, {:array, :string})
      field(:room, {:array, :string})
    end

    has_one :location, Location do
      field(:address, :string)
      field(:country, :string)
    end

    has_one :images, Images do
      has_many(:rooms, ImageModel)
      has_many(:site, ImageModel)
    end
  end

  def load(data), do: Parameter.load(__MODULE__, data, ignore_empty: true, ignore_nil: true)
end
