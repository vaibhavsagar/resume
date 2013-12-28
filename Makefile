all: resume.md resume.tex resume.css
	pandoc resume.md --template=resume.tex -o resume.pdf
	pandoc resume.md -S -c resume.css -o index.html

pdf: resume.md resume.tex
	pandoc resume.md --template=resume.tex -o resume.pdf

html: resume.md resume.css
	pandoc resume.md -S -c resume.css -o index.html

clean:
	rm resume.pdf