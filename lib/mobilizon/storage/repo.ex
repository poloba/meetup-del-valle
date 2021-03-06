defmodule Mobilizon.Storage.Repo do
  @moduledoc """
  Mobilizon Repo.
  """

  use Ecto.Repo,
    otp_app: :mobilizon,
    adapter: Ecto.Adapters.Postgres

  @doc """
  Dynamically loads the repository url from the DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, opts}
  end
end
