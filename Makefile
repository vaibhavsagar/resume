resume.pdf: resume.md resume.tex
	pandoc resume.md --template=resume.tex -o resume.pdf

clean:
	rm resume.pdf