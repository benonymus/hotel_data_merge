defmodule HotelDataMerge.HotelDataProviders.Schemas.Unified do
  @moduledoc """
  Schmas for casting internal data to unform shape
  """

  # helper to clean up input data
  def ensure_format(changeset, fields) do
    Enum.reduce(fields, changeset, fn field, acc ->
      Ecto.Changeset.update_change(acc, field, &format/1)
    end)
  end

  defp format(nil), do: nil
  defp format(string) when is_binary(string), do: string |> String.trim() |> Recase.to_sentence()
  defp format(list) when is_list(list), do: for(string <- list, do: format(string))
  defp format(value), do: value

  defmodule Location do
    use Ecto.Schema
    import Ecto.Changeset
    alias HotelDataMerge.HotelDataProviders.Schemas.Unified

    @primary_key false

    embedded_schema do
      field(:lat, :decimal)
      field(:lng, :decimal)
      field(:address, :string)
      field(:city, :string)
      field(:country, :string)
    end

    def changeset(data, attrs) do
      data
      |> cast(attrs, [:lat, :lng, :address, :city, :country])
      |> Unified.ensure_format([:address, :city, :country])
    end
  end

  defmodule Amenities do
    use Ecto.Schema
    import Ecto.Changeset
    alias HotelDataMerge.HotelDataProviders.Schemas.Unified

    @primary_key false

    embedded_schema do
      field(:general, {:array, :string})
      field(:room, {:array, :string})
    end

    def changeset(data, attrs) do
      data
      |> cast(attrs, [:general, :room])
      |> Unified.ensure_format([:general, :room])
    end
  end

  defmodule ImageModel do
    use Ecto.Schema
    import Ecto.Changeset
    alias HotelDataMerge.HotelDataProviders.Schemas.Unified

    @primary_key false

    embedded_schema do
      field(:link, :string)
      field(:description, :string)
    end

    def changeset(data, attrs) do
      data
      |> cast(attrs, [:link, :description])
      |> Unified.ensure_format([:description])
    end
  end

  defmodule Images do
    use Ecto.Schema
    import Ecto.Changeset

    @primary_key false

    embedded_schema do
      embeds_many(:rooms, ImageModel)
      embeds_many(:site, ImageModel)
      embeds_many(:amenities, ImageModel)
    end

    def changeset(data, attrs) do
      data
      |> cast(attrs, [])
      |> cast_embed(:rooms)
      |> cast_embed(:site)
      |> cast_embed(:amenities)
    end
  end

  defmodule Data do
    use Ecto.Schema
    import Ecto.Changeset
    alias HotelDataMerge.HotelDataProviders.Schemas.Unified

    @primary_key false

    embedded_schema do
      field(:id, :string)
      field(:destination_id, :integer)
      field(:name, :string)
      field(:description, :string)
      field(:booking_conditions, {:array, :string})

      embeds_one(:location, Location)
      embeds_one(:amenities, Amenities)
      embeds_one(:images, Images)
    end

    def changeset(attrs) do
      %__MODULE__{}
      |> cast(attrs, [:id, :destination_id, :name, :description, :booking_conditions])
      |> Unified.ensure_format([:name, :description, :booking_conditions])
      |> validate_required([:id, :destination_id])
      |> cast_embed(:location)
      |> cast_embed(:amenities)
      |> cast_embed(:images)
    end
  end
end
