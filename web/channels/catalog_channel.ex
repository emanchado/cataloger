defmodule Cataloger.CatalogChannel do
  use Phoenix.Channel

  def join("catalog:" <> _catalog_id, _params, socket) do
    {:ok, socket}
  end

  def handle_in("start-structure-export", %{"id" => id}, socket) do
    CatalogExporter.export_structure(id)
    {:noreply, socket}
  end

  def handle_in("start-image-export", %{"id" => id}, socket) do
    CatalogExporter.export_images(id)
    {:noreply, socket}
  end
end
