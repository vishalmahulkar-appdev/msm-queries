# MSM QUERIES

## Objective

In this project, we'll practice using `.where` and other ActiveRecord query methods. (It would be good to have [the ActiveRecord Chapter](https://chapters.firstdraft.com/chapters/770#where) open in a tab for easy reference.) We're going to practice in the context of our familiar movie-related domain — Directors, Movies, Characters, and Actors. If you still have the printed-out paper tables from Day 1, it's very helpful to have it out to look at.

## Setup

 1. Open a `rails console` from the command prompt. If it doesn't launch successfully, then you may need to `bin/setup` and wait for it to complete.
 
## Important notes about rails console 

 1. Sometimes when the output of a Ruby expression is very long, `rails console` is going to paginate it for you. You will have a `:` prompt when this is true, and you can hit <kbd>return</kbd> to scroll through line by line, or <kbd>space</kbd> to scroll through page by page.

    When you reach the end of the output, you'll see `(END)`.

    **To get back to the regular prompt so that you can enter your next command, just hit q at any time.**

 2. If you are in `rails console` and then make a change to a model (for example, you define a new method or fix a syntax error), then, annoyingly, **you have to `exit` and then start a new `rails console`** to pick up the new logic. Or, you can use the `reload!` method.

## 2. Exploring the tables

Open a Terminal tab, launch a `rails console` session, and then try the following:

```ruby
Director.count
Movie.count
Character.count
Actor.count
```

You'll see that I have already created these 4 tables; they exist, but right now there are no rows in any of them. You can see what columns are in each table by:

 - Typing just the class name into `rails console`, e.g.

    ```
    [2] pry(main)> Character
    => Character(id: integer, movie_id: integer, actor_id: integer, name: string, created_at: datetime, updated_at: datetime)
    ```

 - Looking at the comments at the top of the model file, e.g. `app/models/movie.rb`. (These comments are auto-generated and kept up to date by the excellent [annotate gem](https://github.com/ctran/annotate_models).)

## 3. CRUD some records Manually

You can enter some rows into tables using the [ActiveRecord methods that you learned](https://chapters.firstdraft.com/chapters/770):

```ruby
d = Director.new
d.name = "Anthony Russo"
d.dob = "February 3, 1970"
d.save
```

You can check out your newly saved director:

```ruby
Director.last
```

Assuming the new director's ID number is `42`, we can add a new movie:

```ruby
m = Movie.new
m.title = "Avengers: Infinity War"
m.year = 2018
m.duration = 149
m.director_id = 42
m.save
```

Add a couple more directors and movies to get some practice instantiating objects, assigning values to their attributes, and saving  them.

## 4. Hydrate with dummy data

We could enter a bunch of movies — perhaps even [the entire IMDB Top 250](https://www.imdb.com/chart/top) — manually in `rails console` this way; adding directors and actors first, then adding movies, and finally adding characters to join movies and actors.

Go ahead and add the IMDB Top 250 by hand with `.new`, `.save`, etc..... just kidding! That would take forever. In the real world, _someone_ would initially have to add all of our data, whether it's us, or our employees, or our users (through forms in their browser, obviously, not through `rails console`).

But, to make life easy for developers working on this app, I've included a program that will populate your tables for you quickly. I named the program `dev:prime`, and you can run it from the command prompt with `rails dev:prime`.

We'll talk more about how to write these programs in a later lesson, but they are just Ruby scripts like the ones you've written before. In this case, the Ruby script automates what you've been doing in `rails console` — using `Director`, `Movie`, `Character`, and `Actor` to CRUD records.

When you run `rails dev:prime`, you should see output like this:

```bash
There are 34 directors in the database
There are 50 movies in the database
There are 652 actors in the database
There are 722 characters in the database
```

You can verify this yourself by `.count`ing each table in `rails console`.

## 5. Appetizer queries 

Okay! Now that we have some data to play around with, let's practice answering some queries in `rails console`.

### Finding a movie by title

In what year was the movie `"The Dark Knight"` released?

 - Use the [`.where` method](https://chapters.firstdraft.com/chapters/770#where). It is everything.
 - Remember that [`.where` always returns a collection, not a single row](https://chapters.firstdraft.com/chapters/770#where-always-returns-a-collection-not-a-single-row).

### Other queries

 - How many movies in our table are from [before](https://chapters.firstdraft.com/chapters/770#less-than-or-greater-than) the year 2000?
 - Who is the youngest director in our table?
 - How many directors in our table are less than 55 years old? What are their names?
 - How many films in our table were directed by Francis Ford Coppola?
 - How many films did Morgan Freeman appear in?

## 6. Your Tasks

Define the following methods. When you think you've got them working, you can run `rails grade` at a command prompt to check your work.

### Class methods to define

The following are [class-level methods](https://chapters.firstdraft.com/chapters/769#defining-class-methods) to define.

 - `Director.youngest` should return the youngest director on the list. Start by defining a class method with that name:

    ```ruby
    class Director < ApplicationRecord
      def Director.youngest
        return "hello world"
      end
    end
    ```

    And then try calling that method in `rails console` with `Director.youngest` (don't forget to `reload!`). Once you've established that you've defined the method correctly, work on enhancing the method to return what we're actually looking for. _Work in small steps._

 - `Director.eldest` should return the eldest director on the list. Watch out for `nil` values in the `dob` column — `nil` is considered to be "less than" anything else, when ordered.

    You can [use `.not` to filter out](https://chapters.firstdraft.com/chapters/770#wherenotthis) those rows first.
 - `Movie.last_decade` should return all of the rows in the movies table where the year is within the last 10 years.
 - `Movie.short` should return all of the rows in the movies table where the duration is less than 90 minutes.
 - `Movie.long` should return all of the rows in the movies table where the duration is greater than 180 minutes.

### Instance methods to define

The following are [instance-level methods](https://chapters.firstdraft.com/chapters/769#defining-instance-methods) to define.

 - You should define an instance method called `filmography` such that any director, let's imagine it was in a variable called `d`, could use `d.filmography` and return the rows in the movies table that belong to it.

    Remember, our models are accessible from anywhere in the Rails application — `lib/tasks`, `rails console`, and _even from within other models_. So, we can reference `Movie` from inside `Director`:

    ```ruby
    class Director < ApplicationRecord
      def filmography
        return Movie.where({ :director_id => self.id })
      end
    end
    ```
 - Imagine there's an arbitrary movie in a variable `m`. Define instance methods such that:
    - `m.director` should return the **row** in the directors table whose ID matches the movie's `director_id`. Note that the method shouldn't just return the _name_ of the director; we want the whole row, so that we can use the other details if we want them (like date of birth or bio).
    - `m.characters` should return a collection of the characters that were in the movie.
 - Imagine there's an arbitrary actor in a variable `a`. `a.characters` should return a collection of the characters that were played by the actor.

### Stretch goals

 - Imagine there's an arbitrary movie in a variable `m`. `m.cast` should return a collection of `Actor`s (_not_ `Character`s) that appeared in that movie. Hint: [`.pluck`](https://chapters.firstdraft.com/chapters/770#pluck).
 - Imagine there's an arbitrary actor in a variable `a`. `a.filmography` should return a collection of `Movie`s that the actor appeared in.
