defmodule HotelDataMerge.Hotels do
  @moduledoc """
  Data aggregator module, acts as an interface to all data providers and returns a uniform result set.
  """

  alias HotelDataMerge.HotelDataProviders.{Acme, Patagonia, Paperflies}
  alias HotelDataMerge.HotelDataProviders.Schemas.Unified

  def get_data() do
    acme_task = Task.async(&Acme.get/0)
    patagonia_task = Task.async(&Patagonia.get/0)
    paperflies_task = Task.async(&Paperflies.get/0)

    available_keys = Map.keys(Unified.Data.__struct__())

    [acme_task, patagonia_task, paperflies_task]
    |> Task.await_many()
    |> List.flatten()
    |> Enum.group_by(& &1.id)
    |> Enum.map(fn {_, [head | tail]} ->
      Enum.reduce(tail, head, fn data, acc ->
        merge(acc, data, available_keys)
      end)
    end)
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
    |> Enum.uniq_by(fn
      string when is_binary(string) ->
        string |> String.replace(" ", "") |> String.downcase()

      value ->
        value
    end)
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
