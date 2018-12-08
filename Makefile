TEXMF=`kpsewhich -var-value TEXMFHOME`
PKGDIR=$(TEXMF)/tex/latex/mathjax
FONTS= MathJax_Main-Regular.otf MathJax_Main-Bold.otf MathJax_Main-Italic.otf MathJax_Caligraphic-Regular.otf MathJax_Math-Italic.otf MathJax_Math-BoldItalic.otf
FONTSAMPLES= $(addsuffix .pdf,$(basename $(FONTS)))

%.otf:
	wget https://raw.githubusercontent.com/mathjax/MathJax/master/fonts/HTML-CSS/TeX/otf/$@

%.pdf: %.otf
	fntsample -f $< -o $@
fontsamples: $(FONTSAMPLES)

clean:
	rm -f MathJax_* #downloaded fonts
	rm -f *.pfb *.tfm *.vf a_*.enc #created by otftotfm
	rm -f example.aux example.pdf example.log #created by pdflatex
	rm -f example-diagram-1* mptextmp.* example-diagram.mpx example-diagram.log example-diagram.1 #created by metapost

$(PKGDIR):
	mkdir -p $(PKGDIR)

installsty: $(PKGDIR)
	cp mathjax.sty $(PKGDIR)

install: $(FONTS) installsty
	otftotfm --no-updmap -a -e mathjaxr MathJax_Main-Regular.otf mathjaxr
	otftotfm --no-updmap -a -e - MathJax_Main-Bold.otf mathjaxb
	otftotfm --no-updmap -a -e - MathJax_Main-Italic.otf mathjaxi
	otftotfm --no-updmap -a -e - MathJax_Caligraphic-Regular.otf mathjaxcal #osf
	otftotfm --no-updmap -a -e mathjaxmi MathJax_Math-Italic.otf mathjaxmi
	otftotfm --no-updmap -a -e mathjaxbi MathJax_Math-BoldItalic.otf mathjaxbi
	otftotfm --no-updmap -a -e lm-mathit --slant=-0.25 MathJax_Math-Italic.otf mathjaxug #upgreek (not slanted)
	updmap -user --nomkmap --enable Map lcdftools.map
	updmap -user


example-diagram-1.pdf: example-diagram.mp
	mptopdf example-diagram.mp

example-diagram-1.svg: example-diagram-1.pdf
	pdf2svg example-diagram-1.pdf example-diagram-1.svg

example.pdf: example.tex
	pdflatex example.tex

examples: example-diagram-1.svg example.pdf
