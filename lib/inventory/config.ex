defmodule Inventory.Config do
  use Vapor.Planner

  dotenv()

  config :db,
         env([
           {:database, "DB_NAME"},
           {:username, "DB_USER"},
           {:password, "DB_PASS"},
           {:hostname, "DB_HOST"},
           {:poolsize, "DB_POOL_SIZE", default: 10, map: &String.to_integer/1}
         ])
end
