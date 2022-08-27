# Speed

Phoenix setup with sqlite3.

For reproduction with your own app

```bash
> mix phx.new <app_name> --database sqlite3
> touch .tools-versions && vim !$
> touch .gitignore && vim !$ # add ignore for DB files
> mix ecto.create
```

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).
