defmodule Cataloger.CatalogChannel do
  use Phoenix.Channel

  def join("catalog:" <> catalog_id, _params, socket) do
    {:ok, socket}
  end

  def handle_in("start-image-export", %{"id" => id}, socket) do
    IO.puts "Starting image export"
    CatalogImageExporter.export_images(id)
    {:noreply, socket}
  end
end
