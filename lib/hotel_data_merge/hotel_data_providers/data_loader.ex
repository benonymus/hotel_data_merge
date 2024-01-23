defmodule HotelDataMerge.HotelDataProviders.DataLoader do
  @moduledoc """
  Configurable data provider
  """
  alias HotelDataMerge.HotelDataProviders.Schemas.Unified

  require Logger

  @spec get(list(), map()) :: list()
  def get([url: url, parser_module: parser_module], filters) do
    Cachex.get(:data_cache, url)
    |> case do
      {:ok, nil} ->
        load_external_data(url, parser_module)

      {:ok, data_set} ->
        data_set
    end
    |> apply_filters(filters)
  end

  defp load_external_data(url, parser_module) do
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
    |> case do
      [] ->
        []

      data_set ->
        Cachex.put(:data_cache, url, data_set, ttl: :timer.seconds(30))
        data_set
    end
  end

  defp apply_filters(data_set, %{"destination" => destination_id}),
    do:
      Enum.filter(data_set, fn data ->
        Integer.to_string(data.destination_id) == destination_id
      end)

  defp apply_filters(data_set, %{"hotels" => hotel_ids}) when is_list(hotel_ids),
    do: Enum.filter(data_set, fn data -> data.id in hotel_ids end)

  defp apply_filters(data_set, _), do: data_set
end
