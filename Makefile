all: pdf html readme

pdf: resume.md resume.tex
	pandoc resume.md --template=resume.tex -o resume.pdf

html: resume.md resume.css
	pandoc resume.md -s -H resume.css -o index.html

readme: resume.md
	pandoc resume.md -t markdown_github -o readme.md

clean:
	rm resume.pdf