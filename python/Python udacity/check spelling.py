import urllib.request as ur

def read_text():
    quotes = open("C:\\Users\\prabanch\\PycharmProjects\\Python udacity\\text.txt")
    contents = quotes.read()

    quotes.close()

    connection = ur.urlopen("http://www.wdylike.appspot.com/?q="+contents)
    output = connection.read()
    print(output)

read_text()