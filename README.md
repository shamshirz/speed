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

## Notes to self

Read the writing-to-think article and really liked it
Then read the 40yrs as a developer post and also really liked it

I want to write to think here and "just do it" to explore some coding ideas. I think I can be a judgemental programmer about "reinventing the wheel" and about people not thinking through their projects before working on them. For that reason, I think I've been judgemental of myself and not practicing because I am too tired of project planning to do it for myself right now. No planning = no coding, so too tired from project planning at job has lead to me doing tno practice work - which I would (or atleast historically) have enjoyed.

Even now, looking at this, I'm thinking, "too long, needs to be susinct".

If I was coding for fun and practice, then these are the things I want to check out.

- Elixir
  - Adapter patterns
  - Behavours & Protocols
  - req > Finch > Httpoison
- Elm
- Project: Notes service as a library
  - Maybe just library writing in general
- OSS contributions
  - Let someone else do the planning and I can just jump in to do the execution
  - Absinthe
- Project: Company Research
  - Liveview page that lets you request company information
- Project: Spotify
  - Write to the DB and have it live update in liveview?
  - SQLite
    - ✅ Write a migration for a table
    - ✅ Need to connect via ssh+iex to write to table
  - ✅ Fly
  - Liveview
    - Need a view
    - Surface lib for liveview = https://github.com/surface-ui/surface
  - Could create a scheduled job to pull Spotify data and update
  - Behaviors exploration
  - Share learning in blog post?
  - Share learning in Fly.io example repo?

For now, in the car, it's easiest to work on adapters.

### Fly.io

Extremely streamlined, heroku2.0, all CLI driven
Deploy any Docker container with a `fly.toml` in the CURRENT directory.

```
> brew install flyctl
  # aliased to just `fly`
> fly auth signup
  # next time `fly auth login`
> fly launch --image flyio/hellofly:latest
  # there is also a `fly launch` cmd, what's the diff?
> fly status
  # This lists the host name!
> fly open /path
> fly deploy

# Cleanup
fly apps list
fly destroy <app_name>

# Connect
> fly ssh console
> app/bin/speed remote
```

#### Setting up a Volume for our DB files

Since the SQLite db is stored local to the app as files, we need to persist that data across deploys.
We can do that with a docker volume attached to our fly container

- Create a Volume: `fly volumes create <volume_name> -a <app_name>`
- Mount it `fly.toml [[mount]]…`
- Add `DATABASE_PATH` env var
  - Can add to the `[env]` section of `fly.toml`
- Move migrate action to within `start/2` rather than as a "release_command" in `fly.toml`
  - [Essential details Gist](https://gist.github.com/mcrumm/98059439c673be7e0484589162a54a01)
  - Update [Fly.io example app](https://github.com/fly-apps/hello_elixir_sqlite) with these findings?

#### To Explore

- CI ([Docs](https://fly.io/docs/hands-on/next))
- Custom Domain
-

### SQLite

```
> sqlite3 local_db.db
> .schema users
> .tables
`


### Elixir Adapters via Spotify Example

- Start simple - single file, `spotify.ex`
  - Manually test it, and it works
- Next step, I want an automated test
  - It only knows how to call the real server
  - I can intercept the request and handle it with `exvcr`
    - Cons:
      - Results in big test json files that I hate (why)
      - The files are bloat, and it's easy to lose track of them ("when can I delete them?")
      - There are naming questions about them and they have a huge code footprint
      - SLOW. Unclear how to make it work for dev environment too
    - Pros:
      - It mimics the real request the most truly (highest test coverage)
      - It requires 0 additional product code, only test code
  - I can intercept it by making the base url configurable and hit a local replica
    - Requires that I write a local server for testing, simple, but += code
    - Big code footprint and it's all my responsibility, not interested
  - I can mock it via a lib like `exmock` (requires a behavior)
    - Nothing wrong with the behavior requirement, but adds code
  - I can mock it via a manual mock (~adapter pattern)
  - Time to try it all ways
- Additional condition, I want to run a dev server that doesn't make live requests
  - what will the dev server do?
    - Make requests to a test endpoint provided by Spotify? (Nah, they don't offer it)
    - Prevent the request and return some fake data? (sounds good)
    - Unlike the test case, I don't really care if this hits _all_ of the production code
    - on the flip, for dev, it's also great to mimic prod as much as possible
    - and if I want to work on that code specifically, would I need to change the config to test it live locally? I want to be able to test it without needing to hit the prod 3rd party service locally
    - To be confident in the code, I want to either hit the real service (they offer test data or a secondary account that can be setup for dev or staging)
      - This may not always be an option, what if the service costs real money$$?
- Inspiration
  - Bamboo - local "adapter" doesn't send Emails, but stores them so you can view locally
    - Different adapters for different Email senders and Test adapter that you can assert on
  - Mock - Jóse lib, behavior based mocking. Doesn't provide a solution for non-test env
  - spotify_ex - uses mock
```
