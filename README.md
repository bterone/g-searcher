# GSearcher

![Build Status](https://github.com/bterone/g-searcher/actions/workflows/test.yml/badge.svg)

<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
  </ol>
</details>

## About The Project

G-Searcher is a Google Web Scraper. You upload a CSV with all the keywords you want searched, and let G-Searcher handle the rest!

- Upload CSV files for massive queries 📝
- Google Authentication 👮‍♀️
- Dedicated API endpoints 🎯
- Advanced filters to search through all your queries 🔎
- Sleek modern dashboard for your data needs 👩‍🏫

### Built With

* [Erlang/OTP 23.2.4](https://www.erlang.org/)
* [Elixir 1.11.3](https://elixir-lang.org/)
* [Phoenix Framework 1.5.5](https://phoenixframework.org/)
* [Node Version 14.16.1](https://nodejs.org/en/)

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
