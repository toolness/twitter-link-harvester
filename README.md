This is a simple program that searches your home timeline for links
and sends you an email containing them.

# Quick Start

You will need [bundler][] and Ruby 2.3.

```
bundler install
rspec -fd
```

Um, that's all there is right now.

## Docker Quick Start

If you don't want to deal with installing Ruby and/or installing Ruby
version managers and all that stuff, you can develop (and run) the
app in a Docker container. Just get [Docker Compose][] and run:

```terminal
$ docker-compose build
$ docker-compose run app bash
```

At this point you'll be in the container's `/usr/src/app` directory,
which directly reflects the root directory of the repository. Note that
whenever the `Gemfile` changes, you will need to re-run
`docker-compose build`.

[bundler]: http://bundler.io/
[Docker Compose]: https://docs.docker.com/compose/install/
