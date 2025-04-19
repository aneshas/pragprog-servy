defmodule Servy.Gun do
  @callback fire() :: integer()

  defmacro __using__(opts) do
    quote do
      @behaviour Servy.Gun
      @power unquote(opts[:power])

      def helper_method() do
        @power
      end
    end
  end
end

defmodule Servy.LaserGun do
  use Servy.Gun, power: 100

  def fire() do
    helper_method() + 10
  end
end

defmodule Servy.Tank do
  def fire(gun \\ Servy.LaserGun) do
    gun.fire()
  end
end
