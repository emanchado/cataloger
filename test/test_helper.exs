ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Cataloger.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Cataloger.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Cataloger.Repo)

