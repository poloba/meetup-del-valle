defmodule Mobilizon.Federation.ActivityPub.Refresher do
  @moduledoc """
  Module that provides functions to explore and fetch collections on a group
  """

  alias Mobilizon.Actors
  alias Mobilizon.Actors.Actor
  alias Mobilizon.Federation.ActivityPub
  alias Mobilizon.Federation.ActivityPub.{Fetcher, Relay, Transmogrifier}
  require Logger

  def refresh_profile(%Actor{domain: nil}), do: {:error, "Can only refresh remote actors"}

  def refresh_profile(%Actor{type: :Group, url: url, id: group_id} = group) do
    on_behalf_of =
      case Actors.get_single_group_member_actor(group_id) do
        %Actor{} = member_actor ->
          member_actor

        _ ->
          Relay.get_actor()
      end

    with :ok <- fetch_group(url, on_behalf_of) do
      {:ok, group}
    end
  end

  def refresh_profile(%Actor{type: :Person, url: url}) do
    ActivityPub.make_actor_from_url(url)
  end

  @spec fetch_group(String.t(), Actor.t()) :: :ok
  def fetch_group(group_url, %Actor{} = on_behalf_of) do
    with {:ok,
          %Actor{
            outbox_url: outbox_url,
            resources_url: resources_url,
            members_url: members_url,
            posts_url: posts_url,
            todos_url: todos_url,
            discussions_url: discussions_url,
            events_url: events_url
          }} <-
           ActivityPub.make_actor_from_url(group_url),
         :ok <- fetch_collection(outbox_url, on_behalf_of),
         :ok <- fetch_collection(members_url, on_behalf_of),
         :ok <- fetch_collection(resources_url, on_behalf_of),
         :ok <- fetch_collection(posts_url, on_behalf_of),
         :ok <- fetch_collection(todos_url, on_behalf_of),
         :ok <- fetch_collection(discussions_url, on_behalf_of),
         :ok <- fetch_collection(events_url, on_behalf_of) do
      :ok
    end
  end

  def fetch_collection(nil, _on_behalf_of), do: :error

  def fetch_collection(collection_url, on_behalf_of) do
    Logger.debug("Fetching and preparing collection from url")
    Logger.debug(inspect(collection_url))

    with {:ok, data} <- Fetcher.fetch(collection_url, on_behalf_of: on_behalf_of),
         :ok <- Logger.debug("Fetch ok, passing to process_collection"),
         :ok <- process_collection(data, on_behalf_of) do
      :ok
    end
  end

  @spec fetch_element(String.t(), Actor.t()) :: any()
  def fetch_element(url, %Actor{} = on_behalf_of) do
    with {:ok, data} <- Fetcher.fetch(url, on_behalf_of: on_behalf_of) do
      case handling_element(data) do
        {:ok, _activity, entity} ->
          {:ok, entity}

        {:ok, entity} ->
          {:ok, entity}

        err ->
          {:error, err}
      end
    end
  end

  defp process_collection(%{"type" => type, "orderedItems" => items}, _on_behalf_of)
       when type in ["OrderedCollection", "OrderedCollectionPage"] do
    Logger.debug(
      "Processing an OrderedCollection / OrderedCollectionPage with has direct orderedItems"
    )

    Logger.debug(inspect(items))

    Enum.each(items, &handling_element/1)
    :ok
  end

  defp process_collection(%{"type" => "OrderedCollection", "first" => first}, on_behalf_of)
       when is_map(first),
       do: process_collection(first, on_behalf_of)

  defp process_collection(%{"type" => "OrderedCollection", "first" => first}, on_behalf_of)
       when is_bitstring(first) do
    Logger.debug("OrderedCollection has a first property pointing to an URI")

    with {:ok, data} <- Fetcher.fetch(first, on_behalf_of: on_behalf_of) do
      Logger.debug("Fetched the collection for first property")
      process_collection(data, on_behalf_of)
    end
  end

  defp process_collection(_, _), do: :error

  defp handling_element(data) when is_map(data) do
    id = Map.get(data, "id")

    if id do
      Mobilizon.Tombstone.delete_uri_tombstone(id)
    end

    activity = %{
      "type" => "Create",
      "to" => data["to"],
      "cc" => data["cc"],
      "actor" => data["actor"],
      "attributedTo" => data["attributedTo"],
      "object" => data
    }

    Transmogrifier.handle_incoming(activity)
  end

  defp handling_element(uri) when is_binary(uri) do
    ActivityPub.fetch_object_from_url(uri)
  end
end
