%%
%% This is file `oae.cls',
%%
%% Copyright (c) 2020 Zeping Lee

\NeedsTeXFormat{LaTeX2e}[2017/04/15]
\ProvidesClass{oae}[2020/08/27 v1.0 OAE template]

% 报错和警告
\newcommand\class@error[1]{%
  \ClassError{oae}{#1}{}%
}
\newcommand\class@warning[1]{%
  \ClassWaring{oae}{#1}%
}

% 提供 key-value 接口。
\RequirePackage{kvdefinekeys}
\RequirePackage{kvsetkeys}
\RequirePackage{kvoptions}

\kv@set@family@handler{class@key}{%
  \@namedef{class@#1@@name}{#1}%
  \def\class@@default{}%
  \def\class@@choices{}%
  \kv@define@key{class@value}{name}{%
    \@namedef{class@#1@@name}{##1}%
}%
  \@namedef{class@#1@@check}{}%
  \@namedef{class@#1@@code}{}%
  \kv@define@key{class@value}{choices}{%
    \def\class@@choices{##1}%
    \@namedef{class@#1@@reset}{}%
    \@namedef{class@#1@@check}{%
      \@ifundefined{%
        ifclass@\@nameuse{class@#1@@name}@\@nameuse{class@\@nameuse{class@#1@@name}}%
   }{%
        \class@error{Invalid value "#1 = \@nameuse{class@\@nameuse{class@#1@@name}}"}%
   }%
      \@nameuse{class@#1@@reset}%
      \@nameuse{class@\@nameuse{class@#1@@name}@\@nameuse{class@\@nameuse{class@#1@@name}}true}%
 }%
}%
  \kv@define@key{class@value}{default}{%
    \def\class@@default{##1}%
}%
  \kvsetkeys{class@value}{#2}%
  \@namedef{class@\@nameuse{class@#1@@name}}{}%
  \kv@set@family@handler{class@choice}{%
    \ifx\class@@default\@empty
      \def\class@@default{##1}%
    \fi
    \expandafter\newif\csname ifclass@\@nameuse{class@#1@@name}@##1\endcsname
    \expandafter\g@addto@macro\csname class@#1@@reset\endcsname{%
      \@nameuse{class@\@nameuse{class@#1@@name}@##1false}%
 }%
}%
  \kvsetkeys@expandafter{class@choice}{\class@@choices}%
  \expandafter\let\csname class@\@nameuse{class@#1@@name}\endcsname\class@@default
  \expandafter\ifx\csname class@\@nameuse{class@#1@@name}\endcsname\@empty\else
    \@nameuse{class@#1@@check}%
  \fi
  \kv@define@key{class}{#1}{%
    \@namedef{class@\@nameuse{class@#1@@name}}{##1}%
    \@nameuse{class@#1@@check}%
    \@nameuse{class@#1@@code}%
}%
}

\newcommand\class@define@key[1]{%
  \kvsetkeys{class@key}{#1}%
}
\newcommand\documentsetup[1]{%
  \kvsetkeys{class}{#1}%
}
\newcommand\class@option@hook[2]{%
  \expandafter\g@addto@macro\csname class@#1@@code\endcsname{#2}%
}

\class@define@key{
  type = {
    choices = {
      submission,
      final,
 },
    default = submission,
}, 
  name = {
    choices = {
      JSS,
      CS,
      SW,
      JCA,
      IJS,
      CES,
      IR,
      JMI
    },
    default = JSS,
  }
}



% 使用 \pkg{kvoptions} 提供的 key-value 接口，
\SetupKeyvalOptions{
  family  = class,
  prefix  = class@,
  setkeys = \kvsetkeys,
}

\PassOptionsToClass{12pt,twoside}{article}

\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessKeyvalOptions*

\LoadClass{article}[2017/04/15]

% 检查编译引擎，要求使用 XeLaTeX。
\RequirePackage{iftex}
\ifclass@type@final
  \ifXeTeX\else
    \ifLuaTeX\else
      \class@error{XeLaTeX or LuaLaTeX is required to compile the final version}
    \fi
  \fi
\fi

\ifclass@type@final
  \PassOptionsToPackage{scaled=0.8}{newtxmath}
\fi


\RequirePackage{microtype}
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\RequirePackage{amsmath}
\RequirePackage{newtxmath}
\ifclass@type@final
  \RequirePackage[no-math]{fontspec}
\else
  \RequirePackage{newtxtext}
\fi
\RequirePackage{graphicx}
\RequirePackage{color}
\RequirePackage{caption}
\RequirePackage[sort&compress]{natbib}
\RequirePackage{url}
\RequirePackage{etoolbox}

% 对冲突的宏包报错。
\RequirePackage{filehook}
\newcommand\class@package@conflict[2]{
  \AtBeginOfPackageFile*{#2}{
    \class@error{The "#2" package is incompatible with required "#1"}
}
}
\class@package@conflict{natbib}{biblatex}
\class@package@conflict{natbib}{cite}


% 页面

\geometry{
  paperwidth  = 21.0cm,
  paperheight = 28.5cm,
  margin      = 25mm,
  headheight  = 3.75mm,
  headsep     = 6.5mm,
  % showframe   = true,
}


% 字体和字号

% 西文字体

\ifclass@type@final
  \setmainfont{Adobe Thai}%
  \setsansfont{Whitney}[
    UprightFont    = *-Book,
    BoldFont       = *-Semibold,
    ItalicFont     = *-BookItalic,
    BoldItalicFont = *-SemiboldItalic,
  ]
  \setmonofont{Courier New}[Scale = MatchLowercase]%
  \newfontfamily\arial{Arial}[Ligatures=TeX]
  \newfontfamily\helvetica{Helvetica}[Ligatures=TeX]
  \newfontfamily\timesnewroman{Times New Roman}[Ligatures=TeX]
  \newfontfamily\utsaah{Utsaah}[Ligatures=TeX]
  \def\ntx@scaled{s*[0.8]}%
  \DeclareSymbolFont{operators}{OT1}{ntxtlf}{m}{n}
  \SetSymbolFont{operators}{bold}{OT1}{ntxtlf}{b}{n}
\else
  \providecommand\arial{\sffamily}
  \providecommand\helvetica{\sffamily}
  \providecommand\timesnewroman{\rmfamily}
  \providecommand\utsaah{\sffamily}
\fi


% 正文字体

% Adobe Thai

% 大小：12.75
% 行距：13.5

\ifclass@type@final
  \renewcommand\normalsize{%
    % \@setfontsize\normalsize\@xiipt{14.5}%
    \@setfontsize\normalsize{12.75bp}{13.5bp}%
    \abovedisplayskip 10\p@ \@plus2\p@ \@minus5\p@
    \abovedisplayshortskip \z@ \@plus3\p@
    \belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@
    \belowdisplayskip \abovedisplayskip
    \let\@listi\@listI}
  \normalsize
  \ifx\MakeRobust\@undefined \else
      \MakeRobust\normalsize
  \fi
  \DeclareRobustCommand\small{%
    % \@setfontsize\small\@xipt{13.6}%
    \@setfontsize\small\@xipt{11.65}%
    \abovedisplayskip 8.5\p@ \@plus3\p@ \@minus4\p@
    \abovedisplayshortskip \z@ \@plus2\p@
    \belowdisplayshortskip 4\p@ \@plus2\p@ \@minus2\p@
    \def\@listi{\leftmargin\leftmargini
                \topsep -0.5\parskip
                \parsep \z@
                \itemsep \parsep}%
    \belowdisplayskip \abovedisplayskip
}
  \DeclareRobustCommand\footnotesize{%
    % \@setfontsize\footnotesize\@xpt\@xiipt
    \@setfontsize\footnotesize\@xpt{10.59}%
   \abovedisplayskip 6\p@ \@plus2\p@ \@minus4\p@
   \abovedisplayshortskip \z@ \@plus\p@
   \belowdisplayshortskip 3\p@ \@plus\p@ \@minus2\p@
    \def\@listi{\leftmargin\leftmargini
                \topsep -0.5\parskip
                \parsep \z@
                \itemsep \parsep}%
    \belowdisplayskip \abovedisplayskip
}
  \DeclareRobustCommand\scriptsize{\@setfontsize\scriptsize\@viiipt{9.5}}
  \DeclareRobustCommand\tiny{\@setfontsize\tiny\@vipt\@viipt}
  \DeclareRobustCommand\large{\@setfontsize\large\@xivpt{18}}
  \DeclareRobustCommand\Large{\@setfontsize\Large\@xviipt{22}}
  \DeclareRobustCommand\LARGE{\@setfontsize\LARGE\@xxpt{25}}
  \DeclareRobustCommand\huge{\@setfontsize\huge\@xxvpt{30}}
  \let\Huge=\huge
\else
  \renewcommand\normalsize{%
    \@setfontsize\normalsize{10}{11.5}%
    \abovedisplayskip 10\p@ \@plus2\p@ \@minus5\p@
    \abovedisplayshortskip \z@ \@plus3\p@
    \belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@
    \belowdisplayskip \abovedisplayskip
    \let\@listi\@listI}
  \normalsize
  \ifx\MakeRobust\@undefined \else
      \MakeRobust\normalsize
  \fi
  \DeclareRobustCommand\small{%
    % \@setfontsize\small\@ixpt{11}%
    \@setfontsize\small\@ixpt{10.35}%
    \abovedisplayskip 8.5\p@ \@plus3\p@ \@minus4\p@
    \abovedisplayshortskip \z@ \@plus2\p@
    \belowdisplayshortskip 4\p@ \@plus2\p@ \@minus2\p@
    \def\@listi{\leftmargin\leftmargini
                \topsep -0.5\parskip
                \parsep \z@
                \itemsep \parsep}%
    \belowdisplayskip \abovedisplayskip
}
  \DeclareRobustCommand\footnotesize{%
    % \@setfontsize\footnotesize\@viiipt{9.5}%
    \@setfontsize\footnotesize\@viiipt{9.2}%
    \abovedisplayskip 6\p@ \@plus2\p@ \@minus4\p@
    \abovedisplayshortskip \z@ \@plus\p@
    \belowdisplayshortskip 3\p@ \@plus\p@ \@minus2\p@
    \def\@listi{\leftmargin\leftmargini
                \topsep -0.5\parskip
                \parsep \z@
                \itemsep \parsep}%
    \belowdisplayskip \abovedisplayskip
}
  % \DeclareRobustCommand\scriptsize{\@setfontsize\scriptsize\@viipt\@viiipt}
  \DeclareRobustCommand\scriptsize{\@setfontsize\scriptsize\@viipt{8.05}}
  \DeclareRobustCommand\tiny{\@setfontsize\tiny\@vpt{5.75}}
  \DeclareRobustCommand\large{\@setfontsize\large\@xiipt{14}}
  \DeclareRobustCommand\Large{\@setfontsize\Large\@xivpt{18}}
  \DeclareRobustCommand\LARGE{\@setfontsize\LARGE\@xviipt{22}}
  \DeclareRobustCommand\huge{\@setfontsize\huge\@xxpt{25}}
  \DeclareRobustCommand\Huge{\@setfontsize\Huge\@xxvpt{30}}
\fi

\parindent=\z@
\setlength\parskip{13.5bp\@plus \p@}

% \setlength\partopsep{3\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\partopsep{\z@}

\def\@listi{\leftmargin\leftmargini
            % \parsep 5\p@  \@plus2.5\p@ \@minus\p@
            % \topsep 10\p@ \@plus4\p@   \@minus6\p@
            % \itemsep5\p@  \@plus2.5\p@ \@minus\p@}
            \parsep \z@
            \topsep -0.5\parskip
            \itemsep\z@}
\let\@listI\@listi
\@listi
\def\@listii {\leftmargin\leftmarginii
              \labelwidth\leftmarginii
              \advance\labelwidth-\labelsep
              % \topsep    5\p@   \@plus2.5\p@ \@minus\p@
              % \parsep    2.5\p@ \@plus\p@    \@minus\p@
              % \itemsep   \parsep}
              \topsep -0.5\parskip
              \parsep    \z@
              \itemsep   \parsep}
\def\@listiii{\leftmargin\leftmarginiii
              \labelwidth\leftmarginiii
              \advance\labelwidth-\labelsep
              % \topsep    2.5\p@\@plus\p@\@minus\p@
              % \parsep    \z@
              % \partopsep \p@ \@plus\z@ \@minus\p@
              % \itemsep   \topsep}
              \topsep -0.5\parskip
              \parsep    \z@
              % \partopsep \z@
              \itemsep   \z@}
\def\@listiv {\leftmargin\leftmarginiv
              \labelwidth\leftmarginiv
              \advance\labelwidth-\labelsep}
\def\@listv  {\leftmargin\leftmarginv
              \labelwidth\leftmarginv
              \advance\labelwidth-\labelsep}
\def\@listvi {\leftmargin\leftmarginvi
              \labelwidth\leftmarginvi
              \advance\labelwidth-\labelsep}

\setlength\leftmargini{1em}

% 颜色

% 正文
% 颜色：C 5  M 5 Y 5   K 85

% 图表引用
% 颜色： C 100  M 60 Y 0   K 0

\definecolor{main}{cmyk}{0.05,0.05,0.05,0.85}
% \definecolor{main}{rgb}{1,0,0}
\definecolor{ref}{cmyk}{1,0.6,0,0}
\definecolor{section}{cmyk}{0.05,0.05,0.05,0.75}
\definecolor{orange}{cmyk}{0,0.6,1,0}
\definecolor{hint}{rgb}{0.5,0.5,0.5}
\color{main}

\newcommand\hint[1]{[{\color{hint}\itshape\bfseries #1}]}
\newenvironment{tips}[1][Tips]{%
  \color{hint}\itshape
  #1:
  \begin{itemize}%
}{
  \end{itemize}%
}

% 正文


\let\footnoterule\relax
\setlength{\skip\footins}{12mm}

% 设置 url 的样式
\urlstyle{same}

\def\UrlBreaks{%
  \do\/%
  \do\a\do\b\do\c\do\d\do\e\do\f\do\g\do\h\do\i\do\j\do\k\do\l%
     \do\m\do\n\do\o\do\p\do\q\do\r\do\s\do\t\do\u\do\v\do\w\do\x\do\y\do\z%
  \do\A\do\B\do\C\do\D\do\E\do\F\do\G\do\H\do\I\do\J\do\K\do\L%
     \do\M\do\N\do\O\do\P\do\Q\do\R\do\S\do\T\do\U\do\V\do\W\do\X\do\Y\do\Z%
  \do0\do1\do2\do3\do4\do5\do6\do7\do8\do9\do=\do/\do.\do:%
  \do\*\do\-\do\~\do\'\do\"\do\-}

\DeclareRobustCommand\url[1]{%
  \edef\class@@url@tmp{#1}%
  \expandafter\@url\expandafter{\class@@url@tmp}%
}
\DeclareUrlCommand\@url{
  \urlstyle{same}%
  \color{ref}%
}

\DeclareRobustCommand\doi[1]{%
  \edef\class@@url@tmp{#1}%
  \expandafter\@doi\expandafter{\class@@url@tmp}%
}
\DeclareUrlCommand\@doi{\urlstyle{same}}

\DeclareRobustCommand\email[1]{%
  \edef\class@@url@tmp{#1}%
  \expandafter\@email\expandafter{\class@@url@tmp}%
}
\DeclareUrlCommand\@email{\urlstyle{same}}

% 需填项目

\class@define@key{
  title = {
    default = {Title},
},
  authors = {},
  affiliations = {},
  short-author = {
    name = short@author,
},
  journal = {
    default = {Journal of Surveillance, Security and Safety},
},
  short-journal = {
    name = short@journal,
    default = {J Surveill Secur Saf},
},
  correspondence-to = {
    name    = correspondence@to,
},
  how-to-cite = {
    name    = how@to@cite,
},
  received = {},
  first-decision = {
    name = first@decision,
},
  revised = {},
  accepted = {},
  published = {},
  academic-editor = {
    name = academic@editor,
},
  copy-editor = {
    name = copy@editor,
},
  production-editor = {
    name = production@editor,
},
  doi = {},
  year = {
    default = {2020},
},
  volume = {
    default = {6},
},
  number = {
    default = {1},
},
  page = {
    default = {1},
},
  end-page = {
    name = end@page,
    default = {1},
},
}



% 页眉

\pagestyle{fancy}

\newcommand\class@header@font{%
  \arial\fontsize{8bp}{10.5bp}\selectfont
}
\renewcommand\headrulewidth{0pt}

\fancypagestyle{plain}{%
  \fancyhf{}%
  \fancyhead[RO,LE]{\class@header@font Page \thepage{} of \pageref*{LastPage}}%
  \fancyhead[LO,RE]{%
    \class@header@font
    \class@short@author\space
    \textit{\@short@journal}\space
    \class@year;\class@volume:\class@end@page\quad
    \textbf{I}\quad
    \expandafter\url\expandafter{http://dx.doi.org/\class@doi}%
}%
}

\pagestyle{plain}

% \def\@website{\url{https://oaepublish.com/index.php/jsss}}

\fancypagestyle{title}{%
  \fancyhf{}%
  \fancyfoot[L]{\raisebox{-3mm}{\includegraphics[height=8mm]{oae-logo.jpg}}}%
  \fancyfoot[R]{%
    \arial\fontsize{8bp}{10.5bp}\selectfont
    \@website%
}%
}

% 标题页
\renewcommand\maketitle{\par
  \begingroup
    % \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    % \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    % \long\def\@makefntext##1{\parindent 1em\noindent
    %         \hb@xt@1.8em{%
    %             \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
    \if@twocolumn
      \ifnum \col@number=\@ne
        \@maketitle
      \else
        \twocolumn[\@maketitle]%
      \fi
    \else
      \newpage
      \global\@topnum\z@   % Prevents figures from going at top of page.
      \@maketitle
    \fi
    % \thispagestyle{plain}\@thanks
    \thispagestyle{title}%
    \class@title@footnote
  \endgroup
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
}


\ifclass@name@JSS
\def\@journal@name{Journal of Surveillance, Security and Safety}
\def\@website{\url{https://oaepublish.com/index.php/jsss}}
\def\@short@journal{J Surveill Secur Saf}
\fi


\ifclass@name@CS
\def\@journal@name{Chemical Synthesis}
\def\@website{\url{www.chesynjournal.com}}
\def\@short@journal{Chem Synth}
\fi


\ifclass@name@SW
\def\@journal@name{Smart World}
\def\@website{\url{www.smartworldjournal.com}}
\def\@short@journal{Smart World}
\fi


\ifclass@name@JCA
\def\@journal@name{The Journal of Cardiovascular Aging}
\def\@website{\url{www.cardiovascularaging.com}}
\def\@short@journal{J Cardiovasc Aging}
\fi


\ifclass@name@IJS
\def\@journal@name{International Journal of Smart Grid and Sustainable Energy System}
\def\@website{\url{www.sgsesjournal.com}}
\def\@short@journal{Int J Smart Grid Sustain Energy Syst}
\fi


\ifclass@name@CES
\def\@journal@name{Complex Engineering Systems}
\def\@website{\url{www.comengsys.com}}
\def\@short@journal{Complex Eng Syst}
\fi


\ifclass@name@IR
\def\@journal@name{Intelligence \& Robotics}
\def\@website{\url{www.oaepublish.com/ir}}
\def\@short@journal{Intell Robot}
\fi


\ifclass@name@JMI
\def\@journal@name{Journal of materials Informatics}
\def\@website{\url{www.jmijournal.com}}
\def\@short@journal{J Mater Inf}
\fi


\def\@maketitle{%
  \newpage
  % \null
  % \vskip 2em%
  \noindent
  \parbox{\textwidth}{%
    \parbox[c]{0.55\textwidth}{%
      \arial
      \fontsize{8bp}{10.5bp}\selectfont
      \class@short@author\space
      \textit{\@short@journal}\space
      \class@year;\class@volume:\class@end@page\par
      \textbf{DOI:} \class@doi
 }%
    \hfill
    \parbox[c]{0.44\textwidth}{%
      \raggedleft
      \arial\bfseries
      \fontsize{14bp}{14bp}\selectfont
      \color{ref}%
      \@journal@name
 }%
}\par
  \vskip 3mm%
  \begingroup
    \arial\bfseries
    \noindent
    \fontsize{10bp}{12bp}\selectfont
    Research Article
    \hfill
    \color{orange}%
    Open Access
    \par
  \endgroup
  % \vskip 2.5mm%
  \vskip -3mm%
  \hfill\includegraphics[height=3.6mm,width=18mm]{oae-updates.jpg}\par
  \vskip -2mm%
  \let \footnote \thanks
  % {\LARGE \@title \par}%
  \begingroup
    \noindent\helvetica\bfseries
    \fontsize{18bp}{18bp}\selectfont
    \class@title\par
  \endgroup
  \begingroup
    \noindent\arial\bfseries
    \fontsize{9bp}{11bp}\selectfont
    \class@format@authors\par
  \endgroup
  \vskip 10bp%
  \begingroup
    \parskip\z@
    \noindent\sffamily
    \fontsize{8.5bp}{10bp}\selectfont
    \class@format@affiliations\par
  \endgroup
  \begingroup
    \noindent\sffamily
    \fontsize{8.5bp}{10bp}\selectfont
    \parskip=10bp%
    \textbf{Correspondence to:} \class@correspondence@to\par
    \ifx\class@how@to@cite\@empty\else
      \noindent\textbf{How to cite this article:} \class@how@to@cite\par
    \fi
    \noindent\textbf{Received:} \class@received\quad
    \textbf{First Decision:} \class@first@decision\quad
    \textbf{Revised:} \class@revised\quad
    \textbf{Accepted:} \class@accepted\quad
    \textbf{Published:} \class@published\par
    \noindent\textbf{Academic Editor:} \class@academic@editor\quad
    \textbf{Copy Editor:} \class@copy@editor\quad
    \textbf{Production Editor:} \class@production@editor\par
  \endgroup
}

\newcommand\class@format@authors{%
  \let\class@@tmp\@empty
  \kv@set@family@handler{class@authors}{%
    \kvsetkeys{class@author}{##2}%
    \ifx\class@@tmp\@empty
      \def\class@@tmp{##2}%
    \else
      ,\space
    \fi
    \class@@name
    \ignorespaces
    \textsuperscript{\class@format@affil@numbers{\class@@affils}}%
}%
  \kvsetkeys@expandafter{class@authors}{\class@authors}%
}

\kv@define@key{class@author}{name}{\def\class@@name{#1}}
\kv@define@key{class@author}{affiliations}{\def\class@@affils{#1}}

\newcommand\class@valid@affiliations{}
\def\class@@tmp@affil{}
\newcounter{class@affil@count}
\kv@set@family@handler{class@affil@number}{%
  \expandafter\ifx\csname class@affil@number@#1\endcsname\relax
    \stepcounter{class@affil@count}%
    \expandafter\xdef\csname class@affil@number@#1\endcsname{%
      \the\c@class@affil@count
 }%
    \g@addto@macro\class@valid@affiliations{#1,}%
  \fi
  \ifx\class@@tmp@affil\@empty
    \def\class@@tmp@affil{#1}%
  \else
    ,%
  \fi
  \csname class@affil@number@#1\endcsname
}

\newcommand\class@format@affil@numbers[1]{%
  % \kvsetkeys@expandafter{class@affil@number}{#1}%
  \def\class@@tmp@affil{}%
  \kvsetkeys@expandafter{class@affil@number}{#1}%
}

% 隶属机构
\newcommand\class@format@affiliations{%
  \kvsetkeys@expandafter{class@affiliations}{\class@affiliations}%
  \expandafter\comma@parse\expandafter{\class@valid@affiliations}{%
    \class@affiliation@processor
}%
}

\newcommand\class@affiliation@processor[1]{%
  \noindent\textsuperscript{\csname class@affil@number@#1\endcsname}\ignorespaces
  \expandafter\ifx\csname class@affil@#1\endcsname\relax
    \class@error{Unknown affiliation "#1"}%
  \else
    \@nameuse{class@affil@#1}\par
  \fi
}%

\kv@set@family@handler{class@affiliations}{%
  \@namedef{class@affil@#1}{#2}%
}

% 标题页脚注
\newcommand\class@title@footnote{%
  \let\@makefnmark\relax
  \long\def\@makefntext##1{%
    \arial\fontsize{7bp}{10bp}\selectfont
    \hangindent=1.9cm%
    \hangafter=-2%
    \leftskip=0.1cm%
    \rightskip=2.5cm%
    ##1%
}%
  \footnotetext{%
    \makebox[0pt][l]{\hspace{-1.9cm}\raisebox{-12bp}[0pt][0pt]{\includegraphics[height=19bp]{oae-copyright.jpg}}}%
    © The Author(s) 2024. \textbf{Open Access} This article is licensed under a Creative Commons Attribution 4.0
    International License (\url{https://creativecommons.org/licenses/by/4.0/}), which permits unrestricted use,
    sharing, adaptation, distribution and reproduction in any medium or format, for any purpose, even commercially, as long
    as you give appropriate credit to the original author(s) and the source, provide a link to the Creative Commons license,
    and indicate if changes were made.
    \hfill
    \makebox[0pt][l]{\hspace{0.5cm}\raisebox{-3bp}[0pt][0pt]{\includegraphics[height=50bp]{oae-qr-code.jpg}}}%

}%
}



% 章节标题

\setcounter{secnumdepth}{0}

% \def\@sect#1#2#3#4#5#6[#7]#8{%
%   \ifnum #2>\c@secnumdepth
%     \let\@svsec\@empty
%   \else
%     \refstepcounter{#1}%
%     \protected@edef\@svsec{\@seccntformat{#1}\relax}%
%   \fi
%   \@tempskipa #5\relax
%   \ifdim \@tempskipa>\z@
%     \begingroup
%       % \setlength{\parskip}{0pt}%
%       #6{%
%         \@hangfrom{\hskip #3\relax\@svsec}%
%           \interlinepenalty \@M #8
%           \parskip\z@
%           \@@par}%
%     \endgroup
%     \csname #1mark\endcsname{#7}%
%     \addcontentsline{toc}{#1}{%
%       \ifnum #2>\c@secnumdepth \else
%         \protect\numberline{\csname the#1\endcsname}%
%       \fi
%       #7}%
%   \else
%     \def\@svsechd{%
%       #6{\hskip #3\relax
%       \@svsec #8}%
%       \csname #1mark\endcsname{#7}%
%       \addcontentsline{toc}{#1}{%
%         \ifnum #2>\c@secnumdepth \else
%           \protect\numberline{\csname the#1\endcsname}%
%         \fi
%         #7}}%
%   \fi
%   \@xsect{#5}}

% 一级标题
%
% Utsaah
%
% 大小：14
% 行距：18
% 加粗
% 颜色：C 5  M 5 Y 5   K 75

\patchcmd\@startsection
    {\addvspace\@tempskipa}
    {\advance\@tempskipa-\parskip\addvspace\@tempskipa}
    {}{\class@error{Couldn't patch \string\@startsection}}
\patchcmd\@xsect
    {\vskip\@tempskipa}
    {\advance\@tempskipa-\parskip\vskip\@tempskipa}
    {}{\class@error{Couldn't patch \string\@xsect}}

\renewcommand\section{%
  \@startsection {section}{1}{\z@}%
    % {-3.5ex \@plus -1ex \@minus -.2ex}%
    {18bp \@plus 1bp \@minus .2bp}%
    % {2.3ex \@plus.2ex}%
    {4.5bp}%
    % {\normalfont\Large\bfseries}
    {\normalfont\utsaah\bfseries\color{section}%
    \fontsize{14bp}{18bp}\selectfont\MakeUppercase
 }%
}

% 二级标题
%
% Arial
% 大小：9.5
% 行距：12.5
% 加粗
% 颜色： C 5  M 5 Y 5   K 85

\renewcommand\subsection{%
  \@startsection{subsection}{2}{\z@}%
    % {-3.25ex\@plus -1ex \@minus -.2ex}%
    {12.5bp \@plus .5bp \@minus .2bp}%
    % {1.5ex \@plus .2ex}%
    {0.1pt}%
    % {\normalfont\large\bfseries}%
    {\normalfont\arial\bfseries\color{section}%
    \fontsize{9.5bp}{12.5bp}\selectfont
 }%
}

% level 3 heading 的字体和正文字体一样，斜体就可以了。

\renewcommand\subsubsection{%
  \@startsection{subsubsection}{3}{\z@}%
    % {-3.25ex\@plus -1ex \@minus -.2ex}%
    {13.5bp \@plus 1bp \@minus .2bp}%
    % {1.5ex \@plus .2ex}%
    {0.1pt}%
    {\normalfont\normalsize\itshape\color{section}}}

\renewcommand\paragraph{%
  \@startsection{paragraph}{4}{\z@}%
    % {3.25ex \@plus1ex \@minus.2ex}%
    {13.5bp \@plus 1bp \@minus .2bp}%
    % {-1em}%
    {-.5em}%
    % {\normalfont\normalsize\bfseries :}}
    {\sffamily\bfseries\fontsize{9.5bp}{13.5bp}\selectfont}%
}

\renewcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
                                         {3.25ex \@plus1ex \@minus .2ex}%
                                         {-1em}%
                                        {\normalfont\normalsize\bfseries}}


% 图表格式

\renewcommand\topfraction{.85}
\renewcommand\bottomfraction{.7}
\renewcommand\textfraction{.15}
\renewcommand\floatpagefraction{.66}
\renewcommand\dbltopfraction{.66}
\renewcommand\dblfloatpagefraction{.66}

\def\fps@figure{htb}
\def\fps@table{htb}

\setlength{\floatsep}{7mm}
\setlength{\textfloatsep}{7mm}
\setlength{\intextsep}{7mm}

% 表格默认字体

% Whitney Book
% 大小：7.5
% 行距：9
% 颜色： C 5  M 5 Y 5   K 85

\patchcmd\@floatboxreset
  {\normalsize}
  {\expandafter\ifstrequal\expandafter{\@captype}{table}
      % if inside "table" env
      {\sffamily
  \fontsize{7.5bp}{9bp}\selectfont}
      % otherwise
      {\normalsize}}
  {}{\fail}

\AtBeginEnvironment{tabular}{
  \sffamily
  \fontsize{7.5bp}{9bp}\selectfont
}

% 表格标题：

% Whitney-Bold
% 大小：8
% 行距：9
% 加粗
% 颜色： C 5  M 5 Y 5   K 85

\DeclareCaptionFont{table}{\fontsize{8bp}{9bp}\selectfont}
\captionsetup[table]{
  % format   = hang,
  font     = {sf,bf,table},
  labelsep = period,
  skip     = 2mm,
  position = top,
}

% 插图标题

% Whitney-Bold
% 大小：8
% 行距：10
% 颜色： C 5  M 5 Y 5   K 85

\DeclareCaptionFont{figure}{\fontsize{8bp}{10bp}\selectfont}
\captionsetup[figure]{
  % format   = hang,
  font      = {sf,figure},
  labelfont = {bf},
  labelsep  = period,
  skip      = 5mm,
  position  = bottom,
}


% 摘要

\renewenvironment{abstract}{%
  \vskip 8bp%
  \begingroup
    \renewcommand\section{%
      \@startsection {section}{1}{\z@}%
        % {-3.5ex \@plus -1ex \@minus -.2ex}%
        {17bp \@plus 1bp \@minus .2bp}%
        % {2.3ex \@plus.2ex}%
        {1.5bp}%
        % {\normalfont\Large\bfseries}
        {\normalfont\sffamily\bfseries\fontsize{12bp}{15bp}\selectfont}%
 }%
    % \noindent\sffamily\bfseries\fontsize{12bp}{15bp}\selectfont
    % Abstract\par
    % \vskip -\parskip
    \section*{\abstractname}
  \endgroup
  \sffamily\fontsize{9.5bp}{13.5bp}\selectfont
}{
  \vskip 22bp%
}



% 参考文献引用

\newcommand\bibstyle@oae{
  \bibpunct{[}{]}{,}{s}{,}{\textsuperscript{,}}%
  \gdef\bibnumfmt##1{##1.\hfill}
}
\citestyle{oae}
\renewcommand\NAT@@open{%
  \color{ref}%
  \ifNAT@par\NAT@open\fi
}

% 参考文献表

% Times New Roman
% 大小：8
% 行距：11
% 颜色： C 5  M 5 Y 5   K 85

\renewcommand\bibsection{%
  \section*{\refname\@mkboth{\MakeUppercase{\refname}}{\MakeUppercase{\refname}}}%
  \vskip-\parskip
}%
\renewcommand\bibfont{\timesnewroman\fontsize{8bp}{11bp}\selectfont}
\setlength{\bibsep}{\z@}


% 宏包的补充配置

% hyperref
\AtEndOfPackageFile*{hyperref}{
  \hypersetup{
    colorlinks  = true,
    allcolors   = main,
    citecolor   = ref,
    linkcolor   = ref,
    urlcolor    = ref,
}
  \DeclareRobustCommand\@doi[1]{\href{https://doi.org/#1}{\nolinkurl{#1}}}
  \DeclareRobustCommand\@email[1]{\href{mailto:#1}{\nolinkurl{#1}}}
  \pdfstringdefDisableCommands{
    \let\\\@empty
    \let\arial\@empty
    \let\arialscaled\@empty
    \let\xits\@empty
    \let\hspace\@gobble
}
  \def\equationautorefname~#1\null{Equation~(#1)\null}
}

% siunitx
\AtEndOfPackageFile*{siunitx}{
  \sisetup{
    group-minimum-digits = 4,
    group-separator      = {,},
    separate-uncertainty = true,
    inter-unit-product   = \ensuremath{{}\cdot{}},
}
}

\DeclareRobustCommand\cs[1]{\texttt{\char`\\#1}}
