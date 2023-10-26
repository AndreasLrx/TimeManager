# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TimeManager.Repo.insert!(%TimeManager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule TimeManager.Seeds do
  alias TimeManager.Users.User
  alias TimeManager.Clocks.Clock
  alias TimeManager.WorkingTimes.WorkingTime
  alias TimeManager.Repo

  def seed_data do
    seed_users()
    # seed_clocks()
    # seed_working_times()
  end

  defp insert_models(models_attrs, empty_model) do
    models_attrs
    |> Enum.each(fn attrs ->
      empty_model
      |> empty_model.__struct__.changeset(attrs)
      |> Repo.insert()
    end)
  end

  defp random_bool() do
    :rand.uniform(2) == 1
  end

  defp create_user_clock(%User{:id => id} = user) do
    if random_bool do
      %Clock{}
      |> Clock.changeset(%{user_id: id, time: DateTime.utc_now(), status: random_bool})
      |> Repo.insert()
    end
    user
  end

  defp create_user_working_times(%User{:id => id} = user) do
    user
  end

  defp create_random_user do
    with {:ok, %User{} = user} <-
      %User{}
      |> User.changeset(%{email: Faker.Internet.email(), username: Faker.Person.name()})
      |> Repo.insert()
    do
      user
      |> create_user_clock()
      |> create_user_working_times()
    end

  end

  defp seed_users do
    Enum.map(1..10, fn _ -> create_random_user() end)

    # # Define your user data here
    # [
    #   %{email: "user1@example.com", username: "user1"},
    #   %{email: Faker.Internet.email(), username: Faker.Person.name()},
    # ]
    # |> insert_models(%User{})

  end

  defp seed_clocks do
    [
      %{status: true, time: DateTime.utc_now(), user_id: 1},
      %{status: true, time: DateTime.add(DateTime.utc_now(), 4, :hour), user_id: 2},
    ]
    |> insert_models(%Clock{})
  end

  defp seed_working_times do
    # Define your working times data here
    [
      %{start: DateTime.utc_now(), end: DateTime.add(DateTime.utc_now(), 8, :hour), user_id: 1},
    ]
    |> insert_models(%WorkingTime{})
  end
end

TimeManager.Seeds.seed_data()
