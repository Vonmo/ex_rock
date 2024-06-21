# ExRock

[![Tests](https://github.com/Vonmo/ex_rock/actions/workflows/elixir.yml/badge.svg?branch=develop)](https://github.com/Vonmo/ex_rock/actions/workflows/elixir.yml)
[![Build precompiled NIFs](https://github.com/Vonmo/ex_rock/actions/workflows/release.yml/badge.svg?branch=develop)](https://github.com/Vonmo/ex_rock/actions/workflows/release.yml)

## About

ExRock is NIF for Elixir which uses Rust binding for [RocksDB](https://github.com/facebook/rocksdb). Its key features are safety, performance and a minimal codebase. The keys and data are kept binary and this doesn’t impose any restrictions on storage format. So far the project is suitable for being used in third-party solutions.
ExRock is a logical continuation of [Rocker](https://github.com/Vonmo/rocker) - NIF for Erlang

## Build Information
ExRock requires
* Erlang >= 24.
* Rust >= 1.76.
* Clang >= 15.

## Features
* kv operations
* column families support
* batch write
* support of flexible storage setup
* range iterator
* delete range
* multi get
* snapshots
* checkpoints (Online backups)
* backup api

## Main requirements for a driver
* Reliability
* Performance
* Minimal codebase
* Safety
* Functionality

## Performance
In a set of tests you can find a performance test. It demonstrates about 135k write RPS and 2.1M read RPS on my machine. In real conditions we might expect something about 50k write RPS and 400k read RPS with average amount of data being about 1 kB per key and the total number of keys exceeding 1 billion.

## Status
Passed all the functional and performance tests.

## License
ExRock's license is [Apache License Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html)