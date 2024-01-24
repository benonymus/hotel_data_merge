defmodule HotelDataMerge.HotelDataProviders.DataLoader do
  @moduledoc """
  Configurable data provider
  """
  alias HotelDataMerge.HotelDataProviders.Schemas.Unified

  require Logger

  @spec get(list(), map()) :: list()
  def get(attrs, filters) do
    attrs
    |> get_data_set()
    |> apply_filters(filters)
  end

  defp get_data_set([url: url, parser_module: _parser_module] = attrs) do
    case Cachex.get(:data_cache, url) do
      {:ok, nil} ->
        load_external_data(attrs)

      {:ok, data_set} ->
        data_set
    end
  end

  defp load_external_data(url: url, parser_module: parser_module) do
    url
    |> request()
    |> unify_data(parser_module)
    |> tap(fn data_set -> maybe_cache(data_set, url) end)
  end

  defp request(url) do
    case Req.get(url) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        body

      err ->
        Logger.warning(inspect(err))
        []
    end
  end

  defp unify_data(data_set, parser_module) do
    data_set
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
  end

  # if there are no valid results do not cache
  defp maybe_cache([], _), do: :ok

  defp maybe_cache(data_set, key),
    do: Cachex.put(:data_cache, key, data_set, ttl: :timer.seconds(30))

  defp apply_filters(data_set, %{"destination" => destination_id}),
    do:
      Enum.filter(data_set, fn data ->
        Integer.to_string(data.destination_id) == destination_id
      end)

  defp apply_filters(data_set, %{"hotels" => hotel_ids}) when is_list(hotel_ids),
    do: Enum.filter(data_set, fn data -> data.id in hotel_ids end)

  defp apply_filters(data_set, _), do: data_set
end
