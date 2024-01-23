defmodule HotelDataMerge.HotelDataProviders.Paperflies do
  @moduledoc """
  Paperflies data provider
  """

  alias HotelDataMerge.HotelDataProviders.Params.Paperflies
  alias HotelDataMerge.HotelDataProviders.Schemas.Unified

  require Logger

  @url "https://5f2be0b4ffc88500167b85a0.mockapi.io/suppliers/paperflies"

  def get do
    result = Req.get!(@url)

    Enum.map(result.body, fn data ->
      with {:ok, validated_params} <- Paperflies.load(data),
           unified_changeset <- Unified.Data.changeset(validated_params),
           {:ok, data} <- Ecto.Changeset.apply_action(unified_changeset, :update) do
        data
      else
        err ->
          Logger.error(inspect(err))
          %{}
      end
    end)
  end
end
