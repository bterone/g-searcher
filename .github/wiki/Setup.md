### Built With

* [Erlang/OTP 23.2.4](https://www.erlang.org/)
* [Elixir 1.11.3](https://elixir-lang.org/)
* [Phoenix Framework 1.5.5](https://phoenixframework.org/)

## Getting Started

### Prerequisites

You will require

* Docker
* [OAuth 2.0 Credentials](https://developers.google.com/identity/protocols/oauth2)

### Installation

To start G-Searcher:

  * Clone the repo
    ```sh
    git clone https://github.com/bterone/g-searcher
    ```
  * Install dependencies 
    ```sh
    mix deps.get
    ```
  * Start docker container
    ```sh
    docker compose -f docker-compose.dev.yml up -d
    ```
  * Create and migrate your database 
    ```sh
    mix ecto.setup
    ```
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Fill in Oauth credientials to `dev.exs`
    ```elixir
    config :ueberauth, Ueberauth.Strategy.Google.OAuth,
      client_id: "<GOOGLE CLIENT ID>",
      client_secret: "<GOOGLE CLIENT SECRET>"
    ```
  * Start Phoenix endpoint with 
    ```sh
    mix phx.server
    ```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
