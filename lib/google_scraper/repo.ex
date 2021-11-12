defmodule GoogleScraper.Repo do
  use Ecto.Repo,
    otp_app: :google_scraper,
    adapter: Ecto.Adapters.Postgres
end
