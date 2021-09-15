defmodule FlyWeb.AppLive.Allocation do
  use FlyWeb, :live_view

  require Logger

  alias Fly.Client
  alias FlyWeb.Components.HeaderBreadcrumbs

  @impl true
  def mount(%{"name" => name, "id" => id}, session, socket) do
    socket =
      assign(socket,
        config: client_config(session),
        state: :loading,
        app_name: name,
        allocation_id: id,
        status: nil,
        allocation: nil,
        authenticated: true
      )

    # Only make the API call if the websocket is setup. Not on initial render.
    if connected?(socket) do
      {:ok, fetch_allocation(socket)}
    else
      {:ok, socket}
    end
  end

  defp client_config(session) do
    Fly.Client.config(access_token: session["auth_token"] || System.get_env("FLYIO_ACCESS_TOKEN"))
  end

  defp fetch_allocation(socket) do
    app_name = socket.assigns.app_name
    allocation_id = socket.assigns.allocation_id

    case Client.fetch_allocation(app_name, allocation_id, socket.assigns.config) do
      {:ok, status} ->
        assign(socket, :status, status)
        assign(socket, :allocation, status["allocation"])

      {:error, :unauthorized} ->
        put_flash(socket, :error, "Not authenticated")

      {:error, reason} ->
        Logger.error("Failed to load allocation. Reason: #{inspect(reason)}")

        put_flash(socket, :error, reason)
    end
  end

  def status_bg_color(status) do
    case status do
      value when value in ["running", "passing"] -> "bg-green-100"
      "complete" -> "bg-gray-100"
      _ -> "bg-red-100"
    end
  end

  def status_text_color(status) do
    case status do
      value when value in ["running", "passing"] -> "text-green-800"
      "complete" -> "text-gray-800"
      _ -> "text-red-800"
    end
  end
end