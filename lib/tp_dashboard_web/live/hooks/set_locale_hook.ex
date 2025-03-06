defmodule TpDashboardWeb.SetLocaleHook do
  def on_mount(:default, %{"lang" => language} = _params, _session, socket)
      when is_binary(language) do
    IO.puts("We are inside hook")
    Gettext.put_locale(TpDashboardWeb.Gettext, language)
    {:cont, socket}
  end

  def on_mount(:default, _params, _session, socket), do: {:cont, socket}
end
