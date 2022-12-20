# Speed: phx + sqlite

[![Visit](https://img.shields.io/website?down_color=red&down_message=offline&up_color=green&up_message=online&url=https%3A%2F%2Flively-sunset-9810.fly.dev%2Fresearch)](https://lively-sunset-9810.fly.dev)

A playground for experiments. So far they are

> `@behaviour` strategies, `floki`, Fly.io, `GumShoe`, liveview, `req`, sqlite

## Ideas

- Update Landing Page to reflect what the Speed project really is
- Tailwind
- Remove `spotify_ex` not worth the dependency
- Improve Config ([Felt Article - Config](https://felt.com/blog/elixir-configuration))
- Spotify Project
  - Write to DB
  - Scheduled job to pull Spotify data
  - Behaviors exploration
  - Make the UI nice
- Company Research Project (GumShoe)
  - API level testing
- Blog Post on API testing?
- Service as a library Project (notes)
- Elm
- Custom Domain

## Make one of these yourself!

```bash
> mix phx.new <app_name> --database sqlite3
> touch .tools-versions && vim !$
> touch .gitignore && vim !$ # add ignore for DB files
> mix setup # deps, and ecto
> iex -S mix phx.server
```

## Notes to self

Read the writing-to-think article and really liked it
Then read the 40yrs as a developer post and also really liked it

I want to write to think here and "just do it" to explore some coding ideas. I think I can be a judgemental programmer about "reinventing the wheel" and about people not thinking through their projects before working on them. For that reason, I think I've been judgemental of myself and not practicing because I am too tired of project planning to do it for myself right now. No planning = no coding, so too tired from project planning at work has lead to me doing no practice work - which I would (or at least historically) have enjoyed.

Even now, looking at this, I'm thinking, "too long, needs to be succinct".

## Fly.io

Streamlined, heroku2.0.
Deploy any Docker container with a `fly.toml` in the CURRENT directory.

After setup, all I need to do is

```
fly deploy
fly status # lists hosts
fly open /research # opens the app in the browser
```

```
> brew install flyctl # fly vs. flyctl?
> fly auth signup # next time `fly auth login`
fly apps list
fly destroy <app_name> # cleanup

> fly ssh console # Connect
ssh> app/bin/speed remote
```

### Add Volume for our DB files

Since the SQLite db is stored local to the app, we need to persist that data across deploys.

- Create a Volume: `fly volumes create <volume_name> -a <app_name>`
- Mount it `fly.toml [[mount]]…`
- Add `DATABASE_PATH` env var
  - Can add to the `[env]` section of `fly.toml`
- Move migrate action to within `start/2` rather than as a "release_command" in `fly.toml`
  - [Essential details Gist](https://gist.github.com/mcrumm/98059439c673be7e0484589162a54a01)
  - Update [Fly.io example app](https://github.com/fly-apps/hello_elixir_sqlite) with these findings?

### SQLite

```
> sqlite3 local_db.db
> .schema users
> .tables
```
