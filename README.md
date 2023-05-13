<div align="center">

# 📅 `gcal`

Easily view and manage `Google Calendar` events 
from your `Elixir` / `Phoenix` App.

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/dwyl/gcal/ci.yml?label=build&style=flat-square&branch=main)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/gcal/main.svg?style=flat-square)](http://codecov.io/github/dwyl/gcal?branch=main)
[![Hex.pm](https://img.shields.io/hexpm/v/gcal?color=brightgreen&style=flat-square)](https://hex.pm/packages/gcal)
[![contributions welcome](https://img.shields.io/badge/feedback-welcome-brightgreen.svg?style=flat-square)](https://github.com/dwyl/gcal/issues)
[![HitCount](https://hits.dwyl.com/dwyl/gcal.svg)](https://hits.dwyl.com/dwyl/gcal)


</div>

# Why? 🤷‍♀️

After building our 
[`calendar`](https://github.com/dwyl/gcal) 
prototype
that allowed us to visualize 
our `Google Calendar` events
in a more friendly interface,
we realized that much of the `code`
could be reused.
So we decided to split the code
out into an independently tested package
that _anyone_ can use. 

# What? 🗓️

A _tiny_ well-documented, tested & maintained `Elixir` library 
for interacting with `Google Calendar`.

See it in action:
[github.com/dwyl/**calendar**](https://github.com/dwyl/calendar)

# Who?

`gcal` is _by_ us _for_ us (`@dwyl`).
We are _using_ it in our 
[`calendar`](https://github.com/dwyl/gcal) 
and 
[`MVP`](https://github.com/dwyl/mvp).
Anyone `else` that needs to interact with `Google Calendar`
from their `Elixir` / `Phoenix` App(s)
is very welcome to use it.

If you like what you see, please star the repo. ⭐ 🙏
If you have any questions or suggestions,
please 
[open an issue](https://github.com/dwyl/gcal/issues/new)
we _love_ hearing from people. 💬


# How? 

The package is available at:
[hex.pm/packages/**gcal**](https://hex.pm/packages/gcal)


## Installation

Add `gcal` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:gcal, "~> 1.0.0"}
  ]
end
```

## Usage

### Google Auth Session `access_token`

This package expects a valid **`Google` session `access_token`** 
as the **_first_ argument** for all functions.
The easiest way to get a **`access_token`**
is to use 
[`elixir-auth-google`](https://github.com/dwyl/elixir-auth-google)
to allow `people` using your app
to easily authenticate with their `Google` Account. 

### Functions




# Docs

Comprehensive documentation is available at: 
[hexdocs.pm/**gcal**](https://hexdocs.pm/gcal)

