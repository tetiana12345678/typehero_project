ExUnit.start

Mix.Task.run "ecto.create", ~w(-r TypeheroWeb.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r TypeheroWeb.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(TypeheroWeb.Repo)

