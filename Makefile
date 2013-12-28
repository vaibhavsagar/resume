resume.pdf:
	pandoc resume.md --template=resume.tex -o resume.pdf

clean:
	rm resume.pdf