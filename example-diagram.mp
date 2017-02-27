defaultfont:="mathjaxr--base";
defaultscale := 12pt/fontsize defaultfont;

input TEX;
TEXPRE("\documentclass[12pt]{article}\usepackage{mathjax}\begin{document}");

beginfig(1)
	r:=1.5cm; %radius
	draw fullcircle scaled 2r;
	label.bot("MetaPost diagram",(0,-r));

	z1 = ((r,0) rotated 120);
	draw (0,0)--z1;
	label.urt(TEX("$r$"),z1/2);

	dotlabel.bot(TEX("$A = \pi r^2$"),(0,0));
	label.urt(TEX("$C = 2\pi r$"),(r,0) rotated 40);
endfig;
end
