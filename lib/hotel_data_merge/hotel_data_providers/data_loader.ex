defmodule HotelDataMerge.HotelDataProviders.DataLoader do
  @moduledoc """
  Configurable data provider
  """
  alias HotelDataMerge.HotelDataProviders.Schemas.Unified

  require Logger

  @spec get(list(), map()) :: list()
  def get([url: url, parser_module: parser_module], filters) do
    Req.get(url)
    |> case do
      {:ok, %Req.Response{status: 200, body: body}} ->
        body

      err ->
        Logger.warning(inspect(err))
        []
    end
    |> Stream.map(fn data ->
      with {:ok, validated_params} <- parser_module.load(data),
           {:passes_filter?, true} <-
             {:passes_filter?, passes_filter?(validated_params, filters)},
           unified_changeset <- Unified.Data.changeset(validated_params),
           {:ok, data} <- Ecto.Changeset.apply_action(unified_changeset, :update) do
        data
      else
        err ->
          Logger.warning(inspect(err))
          nil
      end
    end)
    |> Enum.reject(&is_nil(&1))
  end

  defp passes_filter?(data, %{"destination" => destination_id}),
    do: Integer.to_string(data.destination_id) == destination_id

  defp passes_filter?(data, %{"hotels" => hotel_ids}) when is_list(hotel_ids),
    do: data.id in hotel_ids

  defp passes_filter?(_, _), do: true
end
