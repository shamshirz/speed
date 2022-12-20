# Spotify Favorite Artists

This is my favorite "repeat application" to make with different toolsets to compare and contrast them.
I want to be able to present my recent top 5 most played artists, as told by the Spotify API.
It involves API calls to Spotify, Auth with them, secrets management, temporary token management, and a view.

## TODO

- [ ] Liveview page
- [ ] Display fake results
- [ ] Try `spotify_ex` lib
  - [ ] Set Secrets in Fly
- [ ] Handroll
  - [ ] Auth Elixir <-> Spotify
  - [ ] API call for Data Elixir <-> Spotify
- [ ] Config and secret management
- [ ] Display basic text results in the UI
- [ ] (Phase2) Store Results in the DB
- [ ] (Phase2) Display Pretty results in the UI
- [ ] (Phase2) Display historic results in the UI
- [ ] (Phase2) Compare different Http Clients and test setups

### Elixir Adapters Exploration

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
    - 🚨 New Learning 🚨
      - `Bypass` is a lib that does exactly this and it's used by wojtec in the `Req` library
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
