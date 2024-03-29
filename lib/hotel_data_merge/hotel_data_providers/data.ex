defmodule HotelDataMerge.HotelDataProviders.Data do
  @moduledoc """
  Data aggregator module, acts as an interface to all data providers and returns a uniform result set.
  Easily extendable with new providers.
  """
  alias HotelDataMerge.HotelDataProviders.DataLoader
  alias HotelDataMerge.HotelDataProviders.Params.{Acme, Paperflies, Patagonia}
  alias HotelDataMerge.HotelDataProviders.Schemas.Unified

  # data provider urls and data parser modules
  @acme_attrs [
    url: "https://5f2be0b4ffc88500167b85a0.mockapi.io/suppliers/acme",
    parser_module: Acme
  ]
  @patagonia_attrs [
    url: "https://5f2be0b4ffc88500167b85a0.mockapi.io/suppliers/patagonia",
    parser_module: Patagonia
  ]
  @paperflies_attrs [
    url: "https://5f2be0b4ffc88500167b85a0.mockapi.io/suppliers/paperflies",
    parser_module: Paperflies
  ]

  @spec get(map) :: list()
  def get(filters) do
    # order of providers matters for the merging
    # it gives an edge on values with the same length, place higher quality provider in the front
    [@acme_attrs, @patagonia_attrs, @paperflies_attrs]
    |> Task.async_stream(fn attrs -> DataLoader.get(attrs, filters) end)
    |> Enum.reduce([], fn {:ok, data_set}, acc -> acc ++ data_set end)
    |> Enum.group_by(& &1.id)
    |> Task.async_stream(fn {_, [head | tail]} ->
      Enum.reduce(tail, head, fn data, acc ->
        merge(acc, data, Map.keys(Unified.Data.__struct__()))
      end)
    end)
    |> Enum.reduce([], fn {:ok, data}, acc -> [data | acc] end)
  end

  # rules on matching fields
  defp merge(acc, _, []), do: acc

  defp merge(acc, data, [key | tail]) do
    merge(%{acc | key => resolve_values(Map.fetch!(acc, key), Map.fetch!(data, key))}, data, tail)
  end

  defp resolve_values(value, value), do: value

  defp resolve_values(nil, new_value), do: new_value

  defp resolve_values(value, nil), do: value

  # strings - keep the longer for more details
  defp resolve_values(value, new_value) when is_binary(value) and is_binary(new_value) do
    if String.length(value) < String.length(new_value),
      do: new_value,
      else: value
  end

  # lists - concat and uniq
  defp resolve_values(value, new_value) when is_list(value) and is_list(new_value) do
    value
    |> Stream.concat(new_value)
    |> Stream.uniq_by(fn
      string when is_binary(string) ->
        string |> String.replace(" ", "") |> String.downcase()

      value ->
        value
    end)
    |> Enum.sort()
  end

  defp resolve_values(%Unified.Location{} = value, %Unified.Location{} = new_value),
    do: merge(value, new_value, Map.keys(Unified.Location.__struct__()))

  defp resolve_values(%Unified.Amenities{} = value, %Unified.Amenities{} = new_value),
    do: merge(value, new_value, Map.keys(Unified.Amenities.__struct__()))

  defp resolve_values(%Unified.Images{} = value, %Unified.Images{} = new_value),
    do: merge(value, new_value, Map.keys(Unified.Images.__struct__()))

  defp resolve_values(%Unified.ImageModel{} = value, %Unified.ImageModel{} = new_value),
    do: merge(value, new_value, Map.keys(Unified.ImageModel.__struct__()))
end
