defmodule Servy.Plugins do
  alias Servy.Conv

  def log(%Conv{} = conv), do: IO.inspect conv

  def rewrite_path(%Conv{path: "/wildlife" } = conv) do
    %{conv | path: "/wildthings" }
  end

  def rewrite_path(%Conv{path: "/wildthings?id=" <> id} = conv) do
    %{conv | path: "/wildthings/#{id}"}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def track(%Conv{status_code: 404, path: path} = conv) do
    IO.puts "Warning: #{path} not found"
    conv
  end

  def track(%Conv{} = conv), do: conv
end
