defmodule HotelDataMerge.HotelDataProviders.DataLoader do
  @moduledoc """
  Configurable data provider
  """
  alias HotelDataMerge.HotelDataProviders.Schemas.Unified

  require Logger

  def get(url: url, parser_module: parser_module) do
    result = Req.get!(url)

    Enum.map(result.body, fn data ->
      with {:ok, validated_params} <- parser_module.load(data),
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
