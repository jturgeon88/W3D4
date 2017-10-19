# == Schema Information
#
# Table name: actors
#
#  id   :integer          not null, primary key
#  name :string           not null
#

# == Schema Information
#
# Table name: movies
#
#  id          :integer          not null, primary key
#  title       :string           not null
#  yr          :integer          not null
#  score       :float            not null
#  votes       :integer          not null
#  director_id :integer          not null
#
# Table name: actors
#
#  id   :integer          not null, primary key
#  name :string           not null

#
# Table name: castings
#
#  id       :integer          not null, primary key
#  actor_id :integer          not null
#  movie_id :integer          not null
#  ord      :integer          not null
#



def eighties_b_movies
  # List all the movies from 1980-1989 with scores falling between
  # 3 and 5 (inclusive).
  # Show the id, title, year, and score.
  Movie.select(:id, :title, :yr, :score).where(score: 3..5, yr: 1980..1989)
end

def bad_years
  # List the years in which a movie with a rating above 8 was not released.
  # Movie.where.not(yr: Movie.where('score > 8').group(:yr).pluck(:yr)).distinct.pluck(:yr)
  Movie.group(:yr).having('MAX(score) < 8').pluck(:yr)
end

def cast_list(title)
  # List all the actors for a particular movie, given the title.
  # Sort the results by starring order (ord). Show the actor id and name.
  Movie.select('actors.id, actors.name').joins(:actors).where(title: title).order('castings.ord ASC')
end

def vanity_projects
  # List the title of all movies in which the director also appeared
  # as the starring actor.
  # Show the movie id and title and director's name.

  # Note: Directors appear in the 'actors' table.
  # Movie.select('movies.id, movies.title, actors.name').joins(:actors).where('director_id = actor_id').where('castings.ord = 1')   WORKS

  # Movie.select('movies.id, movies.title, actors.name').joins(:director).joins(:actors).where('castings.ord = 1')
  Actor.select('movies.id, movies.title, actors.name').joins(:directed_movies).joins.(:castings).where('castings.ord = 1')
  # Movie.select('movies.id, movies.title, actors.name').joins(:director).joins(:castings).where('castings.ord = 1')

end

def most_supportive
  # Find the two actors with the largest number of non-starring roles.
  # Show each actor's id, name and number of supporting roles.
  Actor.select('actors.id, actors.name, COUNT(*) as roles').joins(:castings).group('actors.id').where('castings.ord != 1').order('COUNT(*) DESC').limit(2)

end
