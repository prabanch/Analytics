import webbrowser
class Movie():
    def __init__(self, title, storyline,poster,trailer):
        self.title = title
        self.storyline = storyline
        self.poster_image_url = poster
        self.trailer_youtube_url = trailer


    def showtrailer(self):
        webbrowser.open(self.trailer)