defmodule FlyWeb.AppLive.Show do
  use FlyWeb, :live_view
  require Logger

  alias Fly.Client
  alias FlyWeb.Components.HeaderBreadcrumbs

  @impl true
  def mount(%{"name" => name}, session, socket) do
    socket =
      assign(socket,
        config: client_config(session),
        state: :loading,
        app: nil,
        app_name: name,
        count: 0,
        authenticated: true
      )

    # Only make the API call if the websocket is setup. Not on initial render.
    if connected?(socket) do
      # update immediately after mount
      Process.send_after(self(), :update, 0)
      {:ok, socket}
    else
      {:ok, socket}
    end
  end

  defp client_config(session) do
    Fly.Client.config(access_token: session["auth_token"] || System.get_env("FLYIO_ACCESS_TOKEN"))
  end

  @impl true
  def handle_info(:update, socket) do
    socket = fetch_app(socket)

    # Refresh after 3 seconds
    Process.send_after(self(), :update, 3000)

    {:noreply, socket}
  end

  defp fetch_app(socket) do
    app_name = socket.assigns.app_name

    case Client.fetch_app(app_name, socket.assigns.config, true) do
      {:ok, app} ->
        socket |> assign(:app, app)

      {:error, :unauthorized} ->
        socket |> put_flash(:error, "Not authenticated")

      {:error, reason} ->
        Logger.error("Failed to load app '#{inspect(app_name)}'. Reason: #{inspect(reason)}")

        socket |> put_flash(:error, reason)
    end
  end

  @impl true
  def handle_event("click", _params, socket) do
    {:noreply, assign(socket, count: socket.assigns.count + 1)}
  end

  def status_bg_color(app) do
    case app["status"] do
      "running" -> "bg-green-100"
      "dead" -> "bg-red-100"
      _ -> "bg-yellow-100"
    end
  end

  def status_text_color(app) do
    case app["status"] do
      "running" -> "text-green-800"
      "dead" -> "text-red-800"
      _ -> "text-yellow-800"
    end
  end

  def preview_url(app) do
    "https://#{app["name"]}.fly.dev"
  end
end
