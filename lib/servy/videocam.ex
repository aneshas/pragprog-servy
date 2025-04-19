defmodule Servy.VideoCam do
  def get_snapshot(cam) do
    :timer.sleep(1000)
    "#{cam}-snapshot.png"
  end
end
