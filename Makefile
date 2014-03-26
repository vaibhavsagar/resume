all: pdf html readme

pdf: resume.md resume_template.tex
	pandoc resume.md --template=resume_template.tex -o resume.pdf

html: resume.md resume_template.css
	pandoc resume.md -s -H resume_template.css -o index.html

readme: resume.md
	pandoc resume.md -t markdown_github -o readme.md

clean:
	rm resume.pdf
	rm readme.md
	rm index.html
