This is a simple program that searches your home timeline for links
and sends you an email containing them.

It was designed to be run as a `cron` or [Heroku Scheduler][] job.

# Quick Start

You will need [bundler][] and Ruby 2.3.

```terminal
$ bundler install
$ rspec -fd
$ cp .env.sample .env
```

Now edit `.env` as needed and run:

```terminal
$ ruby tlh.rb harvest
```

This will harvest links and send an email containing them.

Run `ruby tlh.rb` for more options.

## Docker Quick Start

If you don't want to deal with installing Ruby and/or installing Ruby
version managers and all that stuff, you can develop (and run) the
app in a Docker container. Install [Docker Compose][] and run:

```terminal
$ docker-compose build
$ docker-compose run app bash
```

At this point you'll be in the container's `/usr/src/app` directory,
which directly reflects the root directory of the repository, and you can
run any Ruby scripts without needing to worry about dependencies, having
the right Ruby version, or anything like that.

Note, however, that whenever the `Gemfile` changes, you will need to re-run
`docker-compose build`.

Also, if you change your `.env` file, you will need to exit your container
and re-run `docker-compose run app bash`.

### Easy Email Testing

To test email, you can use `./docker-compose.mailcatcher.sh` instead of the
standard `docker-compose` command. This will alter the default container setup
to use [MailCatcher][] for email. To start MailCatcher, run:

```terminal
$ ./docker-compose.mailcatcher.sh up
```

Then use your browser to visit port 1080 on your Docker host (this will
likely be localhost if you're running Linux; if you're running Windows or
OS X it will likely be the IP provided by `docker-machine ip default`).

In a separate terminal, run:

```terminal
$ ./docker-compose.mailcatcher.sh run app bash
```

Now any emails you send through this bash session will be sent to mailcatcher
and appear in your browser.

# Modifying The Email Template

The email is sent in two formats:

* **Plain text.** This is actually the Markdown source, but formatted in a way
  to maximize human readability.
* **HTML.** This is just the Markdown source rendered to HTML.

You can edit the Markdown template in `template/markdown_email.erb`. You can
render the template with some sample data by running:

```terminal
$ ruby tlh.rb example_email
```

[Heroku Scheduler]: https://devcenter.heroku.com/articles/scheduler
[bundler]: http://bundler.io/
[Docker Compose]: https://docs.docker.com/compose/install/
[MailCatcher]: http://mailcatcher.me/
