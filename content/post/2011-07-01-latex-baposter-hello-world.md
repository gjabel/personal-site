---
title: 'Basic LaTeX "Hello World" baposter Poster.'
author: Guy
date: '2012-07-01'
slug: latex-baposter-hello-world
categories: [LaTeX]
tags: [bacluster, poster]
---

Finished my second poster using the baposter class in LaTeX. As with the first time, it took a little while to set up the poster style. In the end I found it a lot easier to strip down one of the examples on the baposter website. This gave me a really simple poster....


![](/img/hello_world_baposter.png)

I then worked on building this up to get precisely the poster style I wanted. I found it a lot easier to experiment with a basic template, than adapt straight from the more complicated examples around on the web.

Below is the tex code for this poster. I have also put in comments for each of the options available. Hopefully you can run this code fairly easily to get the same poster, and then play around to develop your own style. There are two things you will need in the directory where you save the .tex file below to replicate the poster... 

  1) the baposter.cls file from the Brian Amberg's baposter <a href="http://www.brian-amberg.de/uni/poster/baposter/">website</a> 
  
  2) the rolling-stones.pdf file (get it <a href="https://docs.google.com/open?id=0B1VTDLs9SzZ0Y1VrWDB3STFZek0">here</a>). 
    
Let me know in the comments if you have any problems or find any other options?

```latex
\documentclass[a0paper,landscape]{baposter}
\usepackage{graphicx}  % to insert pictures
\usepackage{color}     % to set colors
\usepackage{helvet}    % to use helvet font
\renewcommand{\familydefault}{\sfdefault} % default font to sans-serif
  
\begin{document}
\begin{poster}{
% Poster Environment Options 
grid=false,
columns=4,
colspacing=0.5cm,
headerheight=0.1\textheight,
background=plain,
bgColorOne=white,
bgColorTwo=red,
eyecatcher=false,

borderColor=black,
headerColorOne=red,
headerColorTwo=red,
textborder=roundedsmall,
headerborder=closed,
headershape=roundedright,
headershade=plain,
boxshade=none,
headerfont=\sc,
headerFontColor=white,
linewidth=0.15cm
}

% POSTER HEADER
% Eye catcher image to go left of your title.
% will not show if put eyecatcher=false
{\includegraphics[height=0.1\textheight]{rolling-stones.pdf}} 
{Poster Title}
{Author}
% logo
{\includegraphics[height=0.1\textheight]{rolling-stones.pdf}}
  
% POSTER CONTENTS
\headerbox{Box 1}{name=box1,column=0,row=0}{
blah
}
\headerbox{Box 2}{name=box2,column=0,below=box1}{
blah blah
}
\headerbox{Box 3}{name=box3,column=1}{
blah blah blah
}
\headerbox{Box 4}{name=box4,column=1,below=box3,span=2}{
blah blah blah, blah blah blah
}
\headerbox{Box 5}{name=box5,column=2}{
blah blah
}
\headerbox{Box 6}{name=box6,column=3}{
blah blah blah blah
}
\end{poster}
\end{document}
```

Same tex file but with more comments on potentail options... 

```latex
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% Class Options (see http://www.brian-amberg.de/uni/poster/baposter/baposter_guide.pdf for more details)
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% a0paper               % paper size (choose one)
% a1paper               %
% a2paper               %
% a3paper               %
% a4paper               %
% archE                 %
%
% paperwidth = length   % alternative to paper size eg paperwidth=100cm
% paperheight = length  %
%
% landscape             % paper orientation (choose one)
% portrait              %       
%
% margin = length       % give length e.g. margin=2cm
%
% fontscale = number    % font size
%
% showframe             % frame for debugging
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
\documentclass[a0paper,landscape]{baposter}
\usepackage{graphicx} %to insert pictures
\usepackage{color} %to set colors
\usepackage{helvet} %to use helvet font
\renewcommand{\familydefault}{\sfdefault} %set default font to sans-serif for entire document.
  
\begin{document}
\begin{poster}{
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% Poster Environment Options (see http://www.brian-amberg.de/uni/poster/baposter/baposter_guide.pdf for more details)
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% grid = true               % grid for helping design  (choose one)
% grid = false              %
%
% columns = number          % number of columns (default 4 in landscape and 3 in portrait format, maximum number is 6)
%
% colspacing = length       % space betweeen columns e.g. colspacing=0.5cm
%       
% headerheight = length     % height of poster header (not boxes in poster), default value is 0.1\textheight
%
% background = plain        % background type set as bgColorOne
% background = shade-lr     % background type shades from bgColorOne to bgColorTwo
% background = shade-tb     % background type shades from bgColorOne to bgColorTwo
% background = user         % background from user picture, (set as \background{...})
% background = none         % no background
%
% bgColorOne = color name   % backgound color 1
% bgColorTWO = color name   % backgound color 2 (used for shading)
%
% eyecatcher = true         % eyecatcher image (choose one)
% eyecatcher = false        %
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
grid=false,
columns=4,
colspacing=0.5cm,
headerheight=0.1\textheight,
background=plain,
bgColorOne=white,
bgColorTwo=red,
eyecatcher=false,
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% Posterbox Environment Options (see http://www.brian-amberg.de/uni/poster/baposter/baposter_guide.pdf for more details)
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% borderColor = color             % box border color
%
% headerColorOne = color          % box header color 1
% headerColorTwo = color          % box header color 2
%
% textborder = none               % lower box border type/shape (choose one)
% textborder = bars               %
% textborder = coils              %
% textborder = triangles          %
% textborder = rectangle          %
% textborder = rounded            %
% textborder = faded              %
% textborder = roundedsmall       %
% textborder = roundedleft        %
% textborder = roundedright       %
%                               
% headerborder = none             % upper box border type (choose one)
% headerborder = closed           %
% headerborder = open             %
%
% headershape = rectangle         % upper box border shape (choose one)
% headershape = small-rounded     %
% headershape = roundedright      %
% headershape = roundedleft       %
% headershape = rounded           %
%
% headershade = plain             % upper box shading type (choose one)
% headershade = shade-lr          % left to right
% headershade = shade-tb          % top to bottom
% headershade = shade-tb-inverse  %
%
% boxshade = shade-lr             % lower box shading type (choose one)
% boxshade = shade-tb             %
% boxshade = plain                %
% boxshade = none                 %
%
% headerfont = font               % font type in box header
% headerFontColor = color         % font color in box header
%
% linewidth = length              % width of box border lines
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
borderColor=black,
headerColorOne=red,
headerColorTwo=red,
textborder=roundedsmall,
headerborder=closed,
headershape=roundedright,
headershade=plain,
boxshade=none,
headerfont=\sc,
headerFontColor=white,
linewidth=0.15cm
}
%%
%% POSTER HEADER
%%
% Eye Catcher Images to go left of your title.
{\includegraphics[height=0.1\textheight]{rolling-stones.pdf}} %will not show if put eyecatcher=false
% Title
{Poster Title}
% Author
{Author}
% Logo
{\includegraphics[height=0.1\textheight]{rolling-stones.pdf}}
  
%%
%% POSTER CONTENTS
%%
% BOX 1
\headerbox{Box 1}{name=box1,column=0,row=0}{
blah
}
% BOX 2
\headerbox{Box 2}{name=box2,column=0,below=box1}{
blah blah
}
% BOX 3
\headerbox{Box 3}{name=box3,column=1}{
blah blah blah
}
% BOX 4
\headerbox{Box 4}{name=box4,column=1,below=box3,span=2}{
blah blah blah, blah blah blah
}
% BOX 5
\headerbox{Box 5}{name=box5,column=2}{
blah blah
}
% BOX 6
\headerbox{Box 6}{name=box6,column=3}{
blah blah blah blah
}
\end{poster}
\end{document}
```