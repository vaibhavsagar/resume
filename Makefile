all: pdf html

pdf: resume.md resume.tex
	pandoc resume.md --template=resume.tex -o resume.pdf

html: resume.md resume.css
	pandoc resume.md -s -H resume.css -o index.html

clean:
	rm resume.pdf