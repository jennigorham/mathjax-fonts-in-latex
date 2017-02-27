# mathjax-fonts-in-latex
Allows you to use MathJax's fonts in LaTeX. Why? If you're creating diagrams in MetaPost (or any other drawing program that can use LaTeX labels) to display on a website alongside MathJax then it's nice to have the font in the diagrams match the maths font, and MathJax's version of computer modern is a much heavier weight than the one that comes with LaTeX.


## Installation
```
make install
```
This installs stuff to ~/.texmf-var. If you don't want that then change the TEXMF variable in the [Makefile](https://github.com/jennigorham/mathjax-fonts-in-latex/blob/master/Makefile). See the otftotfm manual for more info.


## Usage

Add `\usepackage{mathjax}` to your tex file (or your texpre file for inclusion in metapost). There are two options you can set: `osf` which gives you old style figures in maths, and `slgreek` which makes the capital greek letters slanted (use `\upGamma` etc to get upright ones). e.g. `\usepackage[osf,slgreek]{mathjax}` to turn them both on.

Run `make examples` to make the example files: example.pdf, example-diagram-1.pdf, and example.html which displays MathJax and the diagram, hopefully in the same font, like this:  
![screenshot of example.html](https://cloud.githubusercontent.com/assets/24600895/23346868/408814f0-fcf2-11e6-8bd5-6b651de527cc.png)

You can use the TEX macro in metapost and configure it to load the mathjax package, as in [example-diagram.mp](https://github.com/jennigorham/mathjax-fonts-in-latex/blob/master/example-diagram.mp), or you can create a file "texpre.tex":
```
%&latex
\documentclass[12pt]{article}
\usepackage{mathjax}
\begin{document}
```
And set `MPTEXPRE=/path/to/texpre.tex` in your shell.


## Getting other glyphs working

I haven't gotten every possible symbol in the MathJax fonts working, just some common ones. Some I've left in the default font (e.g. the integral symbol). So here's a guide on getting other symbols to work, if they exist in the MathJax fonts.

See if the glyph you want is mentioned in the .enc files created by otftotfm, in "~/.texmf-var/fonts/enc/dvips/lcdftools/": 
```
grep <glyphname> ~/.texmf-var/fonts/enc/dvips/lcdftools/*.enc
```
Glyph names: https://github.com/adobe-type-tools/agl-aglfn/blob/master/glyphlist.txt  
Note: to find out which font a .enc file corresponds to, look at the last line in the file, or use `grep -A1 "Command line:" ~/.texmf-var/fonts/enc/dvips/lcdftools/*.enc`

If the glyph's there, make note of the hex address it's at. e.g. this fragment from a .enc file shows the glyphs in the address range 20 to 2F. The comma glyph is at the address 2C.
```
%20
  /space /exclam /quotedbl /numbersign /dollar /percent /ampersand /quoteright
  /parenleft /parenright /asterisk /plus /comma /hyphen /period /slash
```
If the glyph isn't in any .enc file, then you'll need to find out which font it comes from. You can search for the glyph in the fonts' list of supported glyphs:
```
otfinfo -g *.otf | grep <glyphname>
```
Or if you'd rather see the glyphs, you can install fntsample (e.g., `sudo apt-get install fntsample`) then run `make fontsamples`. Look through the pdfs to find out which font has the glyph.  
Note: there are more MathJax fonts than the ones I've used. You can add any of the following to the FONTS list in the [Makefile](https://github.com/jennigorham/mathjax-fonts-in-latex/blob/master/Makefile):
```
MathJax_AMS-Regular.otf          MathJax_SansSerif-Bold.otf
MathJax_Caligraphic-Bold.otf     MathJax_SansSerif-Italic.otf
MathJax_Caligraphic-Regular.otf  MathJax_SansSerif-Regular.otf
MathJax_Fraktur-Bold.otf         MathJax_Script-Regular.otf
MathJax_Fraktur-Regular.otf      MathJax_Size1-Regular.otf
MathJax_Main-Bold.otf            MathJax_Size2-Regular.otf
MathJax_Main-Italic.otf          MathJax_Size3-Regular.otf
MathJax_Main-Regular.otf         MathJax_Size4-Regular.otf
MathJax_Math-BoldItalic.otf      MathJax_Typewriter-Regular.otf
MathJax_Math-Italic.otf          MathJax_WinChrome-Regular.otf
MathJax_Math-Regular.otf         MathJax_WinIE6-Regular.otf
```

Once you've found the glyph in a font, save a copy of that font's .enc file as e.g. "foo.enc" and add the glyph name to one of the `/.notdef` spaces (remember what hex address it's at). Edit the [Makefile](https://github.com/jennigorham/mathjax-fonts-in-latex/blob/master/Makefile)'s "install:" section so that otftotfm uses foo.enc, e.g. 
```
otftotfm -a -e foo <font.otf> <fontname>
```
Add lines to mathjax.sty to make the glyph available, e.g.
```
\DeclareMathSymbol{,}\mathpunct{operators}{"2C}
```
(2C was the hex address from the enc file we found. The "operators" font was declared earlier in mathjax.sty with `\DeclareSymbolFont{operators}{T1}{MathJax}{m}{n}` to refer to the "MathJax" font defined as `\DeclareFontShape{T1}{MathJax}{m}{n}{ <-> mathjaxr }{}`, which uses "mathjaxr" created in the [Makefile](https://github.com/jennigorham/mathjax-fonts-in-latex/blob/master/Makefile) with the line `otftotfm -a -e mathjaxr MathJax_Main-Regular.otf mathjaxr` which uses the file "mathjaxr.enc" as the encoding.)

Then run `make install`.
