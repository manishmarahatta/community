defmodule Mix.Tasks.DevelopmentSeeds do
  use Mix.Task
  import Community.Factory
  alias Community.Repo

  @shortdoc "Insert the seeds for development"

  def run(_args) do
    Application.ensure_all_started(:ex_machina)
    Mix.Task.run("ecto.migrate", [])
    Mix.Task.run("app.start", [])

    for table_name <- tables_to_truncate() do
      Ecto.Adapters.SQL.query!(Repo, "TRUNCATE TABLE #{table_name} CASCADE")
    end

    approve_member(%{
      name: "Sam Seaborn",
      title: "Freelance",
      twitter_handle: "samsconstruction",
    })
    approve_member(%{
      name: "Michelangelo",
      title: "UX Engineer",
      dribbble_username: "Mikey",
      available_for_hire: true,
    })
    approve_member(%{
      name: "Scott Summers",
      title: "Designer at Cyclops Shades",
    })
    approve_member(%{
      name: "Wade Wilson",
      title: "Professional Lion Wrangler",
      available_for_hire: true,
    })
    approve_member(%{
      name: "Bruce Banner",
      title: "Cat Herder",
    })

    for title <- titles() do
      insert(
        :job,
        approved: true,
        company: Enum.random(companies()),
        title: "#{title}"
      )
    end

    insert(:job, title: "Awsesome Designer")
    insert(:job, title: "Rockstar")

    insert(
      :organization,
      admin_email_address: "admin@example.com,admin@raleighdesign.io",
      upcoming_meetups_url: "https://api.meetup.com/self/calendar?photo-host=public&page=20&sig_id=205839672&sig=57e1d519c30c3e5f331d36feab8bebab7fbe494e",
      name: "Raleigh Design",
      no_reply_email_address: "noreply@raleighdesign.io",
      short_description: "A resource for designers in Raleigh to stay connected and find prospective
  career opportunities.",
      twitter: "raleighdesignio"
    )
  end

  def titles do
    [
      "Lead Designer",
      "Design Ninja",
      "Junior Designer",
      "Digital Designer",
      "Product Designer"
    ]
  end

  def companies do
    [
      "thoughtbot",
      "Vista",
      "Microsoft",
      "Citrix",
      "WebAssign",
      "BigLeap",
      "EA",
      "Big Corp",
    ]
  end

  def approve_member(attributes) do
    build(:member, attributes) |> approve |> insert
  end

  defp tables_to_truncate do
    ~w(
      jobs
      members
      organizations
    )
  end
end
