defmodule GSearcherWeb.ErrorView do
  use GSearcherWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  def render("500.html", _assigns) do
    render("500_page.html")
  end

  def render("404.html", _assigns) do
    render("404_page.html")
  end

  def render("error.json", %{status: status, message: message}) do
    %{
      errors: [
        %{
          status: status,
          detail: message
        }
      ]
    }
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
