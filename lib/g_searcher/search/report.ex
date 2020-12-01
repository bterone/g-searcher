defmodule GSearcher.Search.Report do
  use Ecto.Schema
  import Ecto.Changeset

  alias GSearcher.Accounts.User
  alias GSearcher.Search.{ReportSearchResult, SearchResult}

  schema "reports" do
    field :title, :string

    field :csv_path, :string, virtual: true

    belongs_to :user, User

    has_many :report_search_results, ReportSearchResult
    many_to_many :search_results, SearchResult, join_through: "reports_search_results"

    timestamps()
  end

  def changeset(report \\ %__MODULE__{}, attrs) do
    report
    |> cast(attrs, [:title, :csv_path, :user_id])
    |> validate_required([:title, :user_id])
    |> unique_constraint([:title, :user_id],
      message: "is already used."
    )
  end
end
