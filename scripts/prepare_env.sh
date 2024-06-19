echo "[Setup Elixir/Erlang versions and other external deps via 'asdf' tool]"
asdf plugin add elixir
asdf plugin add erlang
asdf plugin add rust
asdf install
mix local.hex --force
mix local.rebar --force
mix deps.get