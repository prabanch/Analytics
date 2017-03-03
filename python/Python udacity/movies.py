import fresh_tomatoes
import media


toystory = media.Movie("toy", "a toy story", "https://en.wikipedia.org/wiki/Avatar_(2009_film)#/media/File:Avatar-Teaser-Poster.jpg", "https://www.youtube.com/watch?v=cRdxXPV9GNQ")

avatar = media.Movie("avatar", "a avathar story", "https://en.wikipedia.org/wiki/Avatar_(2009_film)#/media/File:Avatar-Teaser-Poster.jpg", "https://www.youtube.com/watch?v=cRdxXPV9GNQ")

#print(toystory.storyline)
#toystory.showtrailer()

movies = [toystory, avatar]

fresh_tomatoes.open_movies_page(movies=movies)

