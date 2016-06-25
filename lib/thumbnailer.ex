defmodule Thumbnailer do
  import Mogrify

  def make_thumbnails(input_path, base_output_path, sizes) do
    errors = Enum.reduce(sizes, [], fn(size, errors) ->
      if make_thumbnail(input_path, base_output_path, size) do
        errors
      else
        [size | errors]
      end
    end)

    case errors do
      [] ->
        {:ok, sizes}
      sizes ->
        {:error, sizes}
    end
  end

  defp make_thumbnail(input_path, base_output_path, size) do
    original_ext = Path.extname(input_path)
    output_filename =
      Path.basename(input_path, original_ext) <> "-#{size}" <> original_ext
    output_path = Path.join(base_output_path, output_filename)

    if File.regular? input_path do
      open(input_path) |>
        resize_to_fill(size) |>
        gravity("Center") |>
        save(path: output_path)
      File.exists? output_path
    else
      false
    end
  end
end
