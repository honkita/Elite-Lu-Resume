%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{altacv}[2023/06/27 AltaCV v1.6.5c, yet another alternative class for a resume/curriculum vitae, now forked.]

\DeclareOption{academicons}{\ClassWarning{altacv}{academicons option is now obsolete and unnecessary.}}
\newif\if@normalphoto
\DeclareOption{normalphoto}{\@normalphototrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{extarticle}}
\newif\if@raggedtwoe
\DeclareOption{ragged2e}{\@raggedtwoetrue}
\newif\if@withhyper
\DeclareOption{withhyper}{\@withhypertrue}
\newif\ifdarkmode
\DeclareOption{darkmode}{\darkmodetrue}
\ProcessOptions\relax

\LoadClass{extarticle}
\RequirePackage{etoolbox}
\RequirePackage[a-1b]{pdfx}
\RequirePackage{accsupp}
\RequirePackage[margin=2cm]{geometry}
\RequirePackage[fixed]{fontawesome5}
\RequirePackage{ifxetex,ifluatex}
\RequirePackage{scrlfile}
\RequirePackage{xparse}

\newif\ifxetexorluatex
\ifxetex
  \xetexorluatextrue
\else
  \ifluatex
    \xetexorluatextrue
  \else
    \xetexorluatexfalse
  \fi
\fi

\ifxetexorluatex
  \RequirePackage{fontspec}
\else
  \RequirePackage{cmap}
  \RequirePackage[utf8]{inputenc}
  \RequirePackage[T1]{fontenc}
  \input{glyphtounicode}
  \pdfglyphtounicode{f_f}{FB00}
  \pdfglyphtounicode{f_f_i}{FB03}
  \pdfglyphtounicode{f_f_l}{FB04}
  \pdfglyphtounicode{f_i}{FB01}
  \pdfgentounicode=1
\fi

\if@raggedtwoe
  \RequirePackage[newcommands]{ragged2e}
\fi

\if@withhyper
  \AtBeginDocument{%
    \hypersetup{hidelinks}
    \urlstyle{same}
  }
\fi

\RequirePackage{xcolor}
\newcommand{\itemmarker}{{\small\textbullet}}
\newcommand{\ratingmarker}{\faCircle}

\RequirePackage{tikz}
\usetikzlibrary{arrows}
\RequirePackage[skins]{tcolorbox}
\RequirePackage[inline]{enumitem}
\setlist{leftmargin=*,labelsep=0.5em,nosep,itemsep=0.25\baselineskip,after=\vspace{0.25\baselineskip}}
\setlist[itemize]{label=\itemmarker}
\RequirePackage{graphicx}
\RequirePackage{trimclip}
\RequirePackage{dashrule}
\RequirePackage{multirow,tabularx}
\RequirePackage{changepage}
% \RequirePackage{marginfix}

\setlength{\parindent}{0pt}
\newcommand{\divider}{\textcolor{body!30}{\hdashrule{\linewidth}{0.6pt}{0.5ex}}\smallskip}

\newenvironment{fullwidth}{%
  \begin{adjustwidth}{}{\dimexpr-\marginparwidth-\marginparsep\relax}}
  {\end{adjustwidth}}


\newcommand{\utffriendlydetokenize}[1]{%
\scantokens{%
  \catcode`\_=12%
  \catcode`\&=12%
  \catcode`\$=12%
  \catcode`\#=12%
  \catcode`\~=12%
  {#1}%
}%
}

\ExplSyntaxOn
\NewDocumentCommand{\printinfo}{m m o}{%
  \BeginAccSupp{method=escape,ActualText={#1:~#2}}
  \IfNoValueTF{#3}{%
    \mbox{\textcolor{accent}{\normalfont #1}~\utffriendlydetokenize{#2}\hspace{1em}}%
  }{%
     \if@withhyper%
      \mbox{\textcolor{accent}{\normalfont #1}~
      \href{#3}{\utffriendlydetokenize{#2}}\hspace{2em}}
     \else%
       \ClassWarning{Please specify [withhyper] option to enable hyperlinks. Printing out full hyperlink prefix #1 for now.}%
      \mbox{\textcolor{accent}{\normalfont #1}~{\utffriendlydetokenize{#3#2}}\hspace{2em}}%
     \fi%
  }%
  \EndAccSupp{}
}%


%% v1.3: Exploring convenient creation of fields
%% v1.6: Add starred mode to create \printinfo with full URL
\NewDocumentCommand{\NewInfoField}{s m m o}{%
  \IfBooleanF{#1}{
    \IfNoValueF{#4}{\csdef{#2 hyperprefix}{#4}}%
  }
  \csdef{#2 symbol}{#3}%
  \IfBooleanTF{#1}
    { \csdef{#2}##1##2{%
        \if@withhyper
          \IfNoValueTF {##2}
            {\printinfo{\csuse{#2 symbol}}{##1}}%
            {\printinfo{\csuse{#2 symbol}}{##1}[##2]}%
        \else
          \printinfo{\csuse{#2 symbol}}{##1}%
        \fi%
      }%
    }
    { \csdef{#2}##1{%
        \if@withhyper
          \IfNoValueTF {#4}
            {\printinfo{\csuse{#2 symbol}}{##1}}%
            {\printinfo{\csuse{#2 symbol}}{##1}[\csuse{#2 hyperprefix}##1]}%
        \else
          \printinfo{\csuse{#2 symbol}}{##1}%
        \fi%
      }%
    }
}
\ExplSyntaxOff
\newcommand{\name}[1]{\def\@name{#1}}
\newcommand{\personalinfo}[1]{\def\@personalinfo{#1}}
\NewInfoField{email}{\faAt}[mailto:]
\NewInfoField{mailaddress}{\faEnvelope}
\NewInfoField{phone}{\faPhone}[tel:]
\NewInfoField{homepage}{\faGlobe}[https://]
\NewInfoField{twitter}{\faTwitter}[https://twitter.com/]
\NewInfoField{linkedin}{\faLinkedin}[https://linkedin.com/in/]
\NewInfoField{github}{\faGithub}[https://github.com/]
\NewInfoField{orcid}{\faOrcid}[https://orcid.org/]
\NewInfoField{location}{\faMapMarker}
\NewInfoField{dev}{\faDev}[https://dev.to/]
\NewInfoField{medium}{\faMedium}[https://medium.com/@]
\NewInfoField{npm}{\faNpm}[https://www.npmjs.com/~]

% v1.2: Support for multiple photos
\newlength{\altacv@photos@width}
\newlength{\altacv@photo@diam@left}
\newlength{\altacv@photo@diam@right}
\def\altacv@left@photos{}
\def\altacv@right@photos{}

\newcommand{\@makeaphoto}[2]{%
  \begin{minipage}{#1}%
    \if@normalphoto
      \includegraphics[width=\linewidth]{#2}
    \else
% Fork (before v1.6.5a): The photo image has modified to include a border around it, which color is aligned to document's theme
      \tikz\filldraw[color=headingrule, fill overzoom image={#2}, ultra thick](-1,0) circle[radius=0.5\linewidth];
    \fi%
  \end{minipage}%
}

\newcommand{\namefont}{\small\bfseries}
\newcommand{\taglinefont}{\normalsize\bfseries}
\newcommand{\personalinfofont}{\footnotesize\bfseries}
\newcommand{\cvsectionfont}{\small\bfseries}
\newcommand{\cvsubsectionfont}{\large\bfseries}

\newcommand{\makecvheader}{%
  \begingroup
    \begin{minipage}{\linewidth}
      \begin{center}
          {\namefont\color{name}\@name}
          \par\smallskip
          {\personalinfofont\color{tagline}{\@personalinfo}}       
      \end{center}
    \end{minipage}
  \endgroup
}

\renewenvironment{quote}{\color{accent}\itshape\normalsize}{\par}

% Fork (before v1.6.5a): Two bigskip tags added for better section separation
\newcommand{\cvsection}[2][]{%
    \medskip
  \ifstrequal{#1}{}{}{\marginpar{\vspace*{\dimexpr1pt-\baselineskip}\raggedright\input{#1}}}%
  {\color{heading}\cvsubsectionfont{#2}}\\[-1ex]%
  {\color{headingrule}\rule{\linewidth}{1pt}\par}

}

\newcommand{\cvsubsection}[1]{
  \smallskip
  {\color{subheading}\cvsubsectionfont{#1}\par}
  \smallskip
}


% v1.1.4: fixes inconsistent font size
% Fork (before v1.6.5a): Structure modified to include change title, company name, start/end dates and work location (only a string)
\newcommand{\cvevent}[4]{%
  {\normalsize\color{emphasis}#1}
  \ifstrequal{#2}{}{}{\normalsize{\color{accent} | #2}}
  \par\smallskip\normalsize
  \ifstrequal{#3}{}{}{{\small\makebox[0.5\linewidth][l]{\color{accent}\faCalendar\color{emphasis}~#3}}}
  \ifstrequal{#4}{}{}{{\small\makebox[0.5\linewidth][l]{\color{accent}\faMapMarker\color{emphasis}~#4}}}\par
  \medskip\normalsize
}

\newcommand{\cveventy}[4]{%
  {\large\color{emphasis}#1}
  \ifstrequal{#2}{}{}{\large{\color{accent} | #2}}
  \par\medskip\normalsize
  \ifstrequal{#3}{}{}{{\small\makebox[0.5\linewidth][l]{\color{accent}\faCalendar\color{emphasis}~#3}}}
  \newline
  \ifstrequal{#4}{}{}{{\small\makebox[0.5\linewidth][l]{\color{accent}\faMapMarker\color{emphasis}~#4}}}\par
  \medskip\normalsize
}

% Fork v1.6.5b
\newcommand{\cvreference}[2]{
  \textcolor{accent}{\href{#2}{#1}}
}

\newcommand{\cvachievement}[3]{%
  \begin{tabularx}{\linewidth}{@{}p{2em} @{\hspace{1ex}} >{\raggedright\arraybackslash}X@{}}
  \multirow{2}{*}{\Large\color{accent}#1} & \bfseries\textcolor{emphasis}{#2}\\
  & #3
  \end{tabularx}%
  \smallskip
}

% Fork v1.6.5c: A parser for several tags that will reutilize the cvtag component in a less verbose way
\newcommand{\cvtags}[1]{%
  \foreach \tagValue in {#1} {%
      \cvtag{\tagValue}
  }
}

% Fork (before v1.6.5a): Tags now have a more consistent vertican and horizontal separation
\newcommand{\cvtag}[1]{%
  \tikz[baseline]\node[anchor=base,draw=body,rounded corners,inner xsep=1ex,inner ysep=0.75ex,text height=1.5ex,text depth=.25ex]{#1};
}

% v1.6: Use accsupp so that the actual numeric value is copied/pasted
%       and also support 0.5, 1.5, 2.5, 3.5, 4.5
\newcommand{\cvskill}[2]{%
  \textcolor{emphasis}{\textbf{#1}}\hfill
  \BeginAccSupp{method=plain,ActualText={#2}}
  \foreach \x in {1,...,5}{%
    \ifdimequal{\x pt - #2 pt}{0.5pt}%
    {\clipbox*{0pt -0.25ex {.5\width} {\totalheight}}{\color{accent}\ratingmarker}%
     \clipbox*{{.5\width} -0.25ex {\width} {\totalheight}}{\color{body!30}\ratingmarker}}
    {\ifdimgreater{\x bp}{#2 bp}{\color{body!30}}{\color{accent}}\ratingmarker}%
  }\EndAccSupp{}\par%
}

% Fork (before v1.6.5a): Tag added for languages rating, avoiding star/button/progress bar previous ideas, I made a simpler and more accurate representation using a single string, which will be colored to be oustanding
\newcommand{\cvlang}[2]{%
    \textcolor{emphasis}{\textbf{#1: }}
    \textcolor{accent}{\textbf{#2}}
}

% Adapted from @Jake's answer at http://tex.stackexchange.com/a/82729/226
\newcommand{\wheelchart}[4][0]{%
    \begingroup\centering
    \def\innerradius{#3}%
    \def\outerradius{#2}%
    % Calculate total
    \pgfmathsetmacro{\totalnum}{0}%
    \foreach \value/\colour/\name in {#4} {%
        \pgfmathparse{\value+\totalnum}%
        \global\let\totalnum=\pgfmathresult%
    }%
    \begin{tikzpicture}

      % Calculate the thickness and the middle line of the wheel
      \pgfmathsetmacro{\wheelwidth}{\outerradius-\innerradius}
      \pgfmathsetmacro{\midradius}{(\outerradius+\innerradius)/2}
      \pgfmathsetmacro{\totalrot}{-90 + #1}

      % Rotate so we start from the top
      \begin{scope}[rotate=\totalrot]

      % Loop through each value set. \cumnum keeps track of where we are in the wheel
      \pgfmathsetmacro{\cumnum}{0}
      \foreach \value/\width/\colour/\name in {#4} {
            \pgfmathsetmacro{\newcumnum}{\cumnum + \value/\totalnum*360}

            % Calculate the percent value
            \pgfmathsetmacro{\percentage}{\value/\totalnum*100}
            % Calculate the mid angle of the colour segments to place the labels
            \pgfmathsetmacro{\midangle}{-(\cumnum+\newcumnum)/2}

            % This is necessary for the labels to align nicely
            \pgfmathparse{
               (-\midangle>180?"west":"east")
            } \edef\textanchor{\pgfmathresult}
            \pgfmathparse{
               (-\midangle>180?"flush left":"flush right")
            } \edef\textalign{\pgfmathresult}
            \pgfmathsetmacro\labelshiftdir{1-2*(-\midangle<180)}

            % Draw the color segments. Somehow, the \midrow units got lost, so we add 'pt' at the end. Not nice...
            \filldraw[draw=white,fill=\colour] (-\cumnum:\outerradius) arc (-\cumnum:-(\newcumnum):\outerradius) --
            (-\newcumnum:\innerradius) arc (-\newcumnum:-(\cumnum):\innerradius) -- cycle;

            % Draw the data labels
            % v1.6: Use accsupp so that the numeric number is copied/pasted too
            \draw  [*-,thin,emphasis] node [append after command={(\midangle:\midradius pt) -- (\midangle:\outerradius + 1ex) -- (\tikzlastnode)}] at (\midangle:\outerradius + 1ex) [xshift=\labelshiftdir*0.5cm,inner sep=1ex, outer sep=0pt, text width=\width,anchor=\textanchor,align=\textalign,font=\small,text=body]{\BeginAccSupp{method=pdfstringdef,ActualText={\name: \value}}\name\EndAccSupp{}};
            % Set the old cumulated angle to the new value
            \global\let\cumnum=\newcumnum
        }
      \end{scope}
%      \draw[gray] (0,0) circle (\outerradius) circle (\innerradius);
    \end{tikzpicture}\par
    \endgroup
}

% Fork v1.6.5b: Taking from original version, I added some modifications related to optional Linkedin and mail links for each reference (both will be shown only if there is any value)
\newcommand{\cvref}[5]{%
  \textcolor{emphasis}{\textbf{#1}}\par
  \smallskip
  \begin{description}[font=\color{accent},style=multiline,leftmargin=1em,align=center]
    \def\temp{#2}\ifx\temp\empty
    \else
      \item[\faMapMarker]{#2}
    \fi

    \def\temp{#3}\ifx\temp\empty
    \else
      \item[\faPhone] \href{tel:#3}{#3}
    \fi
    
   \def\temp{#4}\ifx\temp\empty
    \else
      \item[\small\normalfont\mailaddresssymbol] \href{mailto:#4}{#4}
    \fi
    
    \def\temp{#5}\ifx\temp\empty
    \else
      \item[\faLinkedin] \href{https://linkedin.com/in/#5}{#5}
    \fi

    
  \end{description}
}

\newenvironment{cvcolumn}[1]{\begin{minipage}[t]{#1}\raggedright}{\end{minipage}}

% v1.5 Move biblatex-related code to separate .cfg file
% so that it's easier to change and customise the style for
% publication lists

% v1.1.2: make it easier to add a sidebar aligned with top of next page
\RequirePackage{afterpage}
\newcommand{\addsidebar}[2][]{\marginpar{%
  \ifstrequal{#1}{}{}{\vspace*{#1}}%
  \input{#2}}%
}
\newcommand{\addnextpagesidebar}[2][]{\afterpage{\addsidebar[#1]{#2}}}

% v1.6.5 But provide for ability to highlight names in publication list
\RequirePackage{pgffor}
\def\my@namelist{}
\newcommand{\mynames}[1]{\def\my@namelist{#1}}
\newtoggle{boldname}
\AddToHook{package/biblatex/after}{
\renewcommand*{\mkbibnamefamily}[1]{%
  \global\togglefalse{boldname}%
  \foreach \my@fname / \my@gname in \my@namelist {%
    \ifboolexpr{ test {\ifdefstrequal{\namepartfamily}{\my@fname}}
                 and
                 test {\ifdefstrequal{\namepartgiven}{\my@gname}}}
      {\global\toggletrue{boldname}}{}%
  }%
  \iftoggle{boldname}{\textbf{#1}}{#1}%
}

\renewcommand*{\mkbibnamegiven}[1]{%
  \global\togglefalse{boldname}%
  \foreach \my@fname / \my@gname in \my@namelist{%
    \ifboolexpr{ test {\ifdefstrequal{\namepartfamily}{\my@fname}}
                 and
                 test {\ifdefstrequal{\namepartgiven}{\my@gname}}}
      {\global\toggletrue{boldname}\breakforeach}{}%
  }%
  \iftoggle{boldname}{\textbf{#1}}{#1}%
}
}

\AddToHook{begindocument/before}{%
  \pagestyle{empty}
  \color{body}
  \raggedright
}
