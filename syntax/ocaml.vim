" Vim syntax file
" Language:     OCaml
" Filenames:    *.ml *.mli *.mll *.mly
" Maintainers:  Markus Mottl      <markus.mottl@gmail.com>
"               Karl-Heinz Sylla  <Karl-Heinz.Sylla@gmd.de>
"               Issac Trotts      <ijtrotts@ucdavis.edu>
" URL:          http://www.ocaml.info/vim/syntax/ocaml.vim
" Last Change:
"               2018 Nov 08 - Improved highlighting of operators (Maëlan)
"               2018 Apr 22 - Improved support for PPX (Andrey Popp)
"               2018 Mar 16 - Remove raise, lnot and not from keywords (Étienne Millon, "copy")
"               2017 Apr 11 - Improved matching of negative numbers (MM)
"               2016 Mar 11 - Improved support for quoted strings (Glen Mével)
"               2015 Aug 13 - Allow apostrophes in identifiers (Jonathan Chan, Einar Lielmanis)
"               2015 Jun 17 - Added new "nonrec" keyword (MM)

" A minor patch was applied to the official version so that object/end
" can be distinguished from begin/end, which is used for indentation,
" and folding. (David Baelde)

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax") && b:current_syntax == "ocaml"
  finish
endif

" ' can be used in OCaml identifiers
setlocal iskeyword+='

" ` is part of the name of polymorphic variants
setlocal iskeyword+=`

" OCaml is case sensitive.
syn case match

" Access to the method of an object
syn match    ocamlMethod       "#"

" Script headers highlighted like comments
syn match    ocamlComment   "^#!.*" contains=@Spell

" Scripting directives
syn match    ocamlScript "^#\<\(quit\|labels\|warnings\|warn_error\|directory\|remove_directory\|cd\|load\|load_rec\|use\|mod_use\|install_printer\|remove_printer\|require\|list\|ppx\|principal\|predicates\|rectypes\|thread\|trace\|untrace\|untrace_all\|print_depth\|print_length\|camlp4o\|camlp4r\|topfind_log\|topfind_verbose\)\>"

" lowercase identifier - the standard way to match
syn match    ocamlLCIdentifier /\<\(\l\|_\)\(\w\|'\)*\>/

syn match    ocamlKeyChar    "|"

" Errors
syn match    ocamlBraceErr   "}"
syn match    ocamlBrackErr   "\]"
syn match    ocamlParenErr   ")"
syn match    ocamlArrErr     "|]"

syn match    ocamlCommentErr "\*)"

syn match    ocamlCountErr   "\<downto\>"
syn match    ocamlCountErr   "\<to\>"

if !exists("ocaml_revised")
  syn match    ocamlDoErr      "\<do\>"
endif

syn match    ocamlDoneErr    "\<done\>"
syn match    ocamlThenErr    "\<then\>"

" Error-highlighting of "end" without synchronization:
" as keyword or as error (default)
if exists("ocaml_noend_error")
  syn match    ocamlKeyword    "\<end\>"
else
  syn match    ocamlEndErr     "\<end\>"
endif

" Some convenient clusters
syn cluster  ocamlAllErrs contains=ocamlBraceErr,ocamlBrackErr,ocamlParenErr,ocamlCommentErr,ocamlCountErr,ocamlDoErr,ocamlDoneErr,ocamlEndErr,ocamlThenErr

syn cluster  ocamlAENoParen contains=ocamlBraceErr,ocamlBrackErr,ocamlCommentErr,ocamlCountErr,ocamlDoErr,ocamlDoneErr,ocamlEndErr,ocamlThenErr

syn cluster  ocamlContained contains=ocamlTodo,ocamlPreDef,ocamlModParam,ocamlModParam1,ocamlMPRestr,ocamlMPRestr1,ocamlMPRestr2,ocamlMPRestr3,ocamlModRHS,ocamlFuncWith,ocamlFuncStruct,ocamlModTypeRestr,ocamlModTRWith,ocamlWith,ocamlWithRest,ocamlModType,ocamlFullMod,ocamlVal


" Enclosing delimiters
syn region   ocamlEncl transparent matchgroup=ocamlKeyword start="(" matchgroup=ocamlKeyword end=")" contains=ALLBUT,@ocamlContained,ocamlParenErr
syn region   ocamlEncl transparent matchgroup=ocamlKeyword start="{" matchgroup=ocamlKeyword end="}"  contains=ALLBUT,@ocamlContained,ocamlBraceErr
syn region   ocamlEncl transparent matchgroup=ocamlKeyword start="\[" matchgroup=ocamlKeyword end="\]" contains=ALLBUT,@ocamlContained,ocamlBrackErr
syn region   ocamlEncl transparent matchgroup=ocamlKeyword start="\[|" matchgroup=ocamlKeyword end="|\]" contains=ALLBUT,@ocamlContained,ocamlArrErr


" Comments
syn region   ocamlComment start="(\*" end="\*)" contains=@Spell,ocamlComment,ocamlTodo
syn keyword  ocamlTodo contained TODO FIXME XXX NOTE


" Objects
syn region   ocamlEnd matchgroup=ocamlObject start="\<object\>" matchgroup=ocamlObject end="\<end\>" contains=ALLBUT,@ocamlContained,ocamlEndErr


" Blocks
if !exists("ocaml_revised")
  syn region   ocamlEnd matchgroup=ocamlKeyword start="\<begin\>" matchgroup=ocamlKeyword end="\<end\>" contains=ALLBUT,@ocamlContained,ocamlEndErr
endif


" "for"
syn region   ocamlNone matchgroup=ocamlKeyword start="\<for\>" matchgroup=ocamlKeyword end="\<\(to\|downto\)\>" contains=ALLBUT,@ocamlContained,ocamlCountErr


" "do"
if !exists("ocaml_revised")
  syn region   ocamlDo matchgroup=ocamlKeyword start="\<do\>" matchgroup=ocamlKeyword end="\<done\>" contains=ALLBUT,@ocamlContained,ocamlDoneErr
endif

" "if"
syn region   ocamlNone matchgroup=ocamlKeyword start="\<if\>" matchgroup=ocamlKeyword end="\<then\>" contains=ALLBUT,@ocamlContained,ocamlThenErr

"" PPX nodes

syn match ocamlPpxIdentifier /\(\[@\{1,3\}\)\@<=\w\+\(\.\w\+\)*/
syn region ocamlPpx matchgroup=ocamlPpxEncl start="\[@\{1,3\}" contains=TOP end="\]"

"" Modules

" "sig"
syn region   ocamlSig matchgroup=ocamlSigEncl start="\<sig\>" matchgroup=ocamlSigEncl end="\<end\>" contains=ALLBUT,@ocamlContained,ocamlEndErr,ocamlModule
syn region   ocamlModSpec matchgroup=ocamlKeyword start="\<module\>" matchgroup=ocamlModule end="\<\u\(\w\|'\)*\>" contained contains=@ocamlAllErrs,ocamlComment skipwhite skipempty nextgroup=ocamlModTRWith,ocamlMPRestr

" "open"
syn match   ocamlKeyword "\<open\>" skipwhite skipempty nextgroup=ocamlFullMod

" "include"
syn match    ocamlKeyword "\<include\>" skipwhite skipempty nextgroup=ocamlModParam,ocamlFullMod

" "module" - somewhat complicated stuff ;-)
syn region   ocamlModule matchgroup=ocamlKeyword start="\<module\>" matchgroup=ocamlModule end="\<\u\(\w\|'\)*\>" contains=@ocamlAllErrs,ocamlComment skipwhite skipempty nextgroup=ocamlPreDef
syn region   ocamlPreDef start="."me=e-1 matchgroup=ocamlKeyword end="\l\|=\|)"me=e-1 contained contains=@ocamlAllErrs,ocamlComment,ocamlModParam,ocamlGenMod,ocamlModTypeRestr,ocamlModTRWith nextgroup=ocamlModPreRHS
syn region   ocamlModParam start="([^*]" end=")" contained contains=ocamlGenMod,ocamlModParam1,ocamlSig,ocamlVal
syn match    ocamlModParam1 "\<\u\(\w\|'\)*\>" contained skipwhite skipempty
syn match    ocamlGenMod "()" contained skipwhite skipempty

syn region   ocamlMPRestr start=":" end="."me=e-1 contained contains=@ocamlComment skipwhite skipempty nextgroup=ocamlMPRestr1,ocamlMPRestr2,ocamlMPRestr3
syn region   ocamlMPRestr1 matchgroup=ocamlSigEncl start="\ssig\s\=" matchgroup=ocamlSigEncl end="\<end\>" contained contains=ALLBUT,@ocamlContained,ocamlEndErr,ocamlModule
syn region   ocamlMPRestr2 start="\sfunctor\(\s\|(\)\="me=e-1 matchgroup=ocamlKeyword end="->" contained contains=@ocamlAllErrs,ocamlComment,ocamlModParam,ocamlGenMod skipwhite skipempty nextgroup=ocamlFuncWith,ocamlMPRestr2
syn match    ocamlMPRestr3 "\w\(\w\|'\)*\( *\. *\w\(\w\|'\)*\)*" contained
syn match    ocamlModPreRHS "=" contained skipwhite skipempty nextgroup=ocamlModParam,ocamlFullMod
syn keyword  ocamlKeyword val
syn region   ocamlVal matchgroup=ocamlKeyword start="\<val\>" matchgroup=ocamlLCIdentifier end="\<\l\(\w\|'\)*\>" contains=@ocamlAllErrs,ocamlComment,ocamlFullMod skipwhite skipempty nextgroup=ocamlMPRestr
syn region   ocamlModRHS start="." end=". *\w\|([^*]"me=e-2 contained contains=ocamlComment skipwhite skipempty nextgroup=ocamlModParam,ocamlFullMod
syn match    ocamlFullMod "\<\u\(\w\|'\)*\( *\. *\u\(\w\|'\)*\)*" contained skipwhite skipempty nextgroup=ocamlFuncWith

syn region   ocamlFuncWith start="([^*)]"me=e-1 end=")" contained contains=ocamlComment,ocamlWith,ocamlFuncStruct skipwhite skipempty nextgroup=ocamlFuncWith
syn region   ocamlFuncStruct matchgroup=ocamlStructEncl start="[^a-zA-Z]struct\>"hs=s+1 matchgroup=ocamlStructEncl end="\<end\>" contains=ALLBUT,@ocamlContained,ocamlEndErr

syn match    ocamlModTypeRestr "\<\w\(\w\|'\)*\( *\. *\w\(\w\|'\)*\)*\>" contained
syn region   ocamlModTRWith start=":\s*("hs=s+1 end=")" contained contains=@ocamlAENoParen,ocamlWith
syn match    ocamlWith "\<\(\u\(\w\|'\)* *\. *\)*\w\(\w\|'\)*\>" contained skipwhite skipempty nextgroup=ocamlWithRest
syn region   ocamlWithRest start="[^)]" end=")"me=e-1 contained contains=ALLBUT,@ocamlContained

" "struct"
syn region   ocamlStruct matchgroup=ocamlStructEncl start="\<\(module\s\+\)\=struct\>" matchgroup=ocamlStructEncl end="\<end\>" contains=ALLBUT,@ocamlContained,ocamlEndErr

" "module type"
syn region   ocamlKeyword start="\<module\>\s*\<type\>\(\s*\<of\>\)\=" matchgroup=ocamlModule end="\<\w\(\w\|'\)*\>" contains=ocamlComment skipwhite skipempty nextgroup=ocamlMTDef
syn match    ocamlMTDef "=\s*\w\(\w\|'\)*\>"hs=s+1,me=s+1 skipwhite skipempty nextgroup=ocamlFullMod

" Quoted strings
syn region ocamlString matchgroup=ocamlQuotedStringDelim start="{\z\([a-z_]*\)|" end="|\z1}" contains=@Spell

syn keyword  ocamlKeyword  and as assert class
syn keyword  ocamlKeyword  constraint else
syn keyword  ocamlKeyword  exception external fun

syn keyword  ocamlKeyword  in inherit initializer
syn keyword  ocamlKeyword  lazy let match
syn keyword  ocamlKeyword  method mutable new nonrec of
syn keyword  ocamlKeyword  parser private rec
syn keyword  ocamlKeyword  try type
syn keyword  ocamlKeyword  virtual when while with

if exists("ocaml_revised")
  syn keyword  ocamlKeyword  do value
  syn keyword  ocamlBoolean  True False
else
  syn keyword  ocamlKeyword  function
  syn keyword  ocamlBoolean  true false
endif

syn keyword  ocamlType     array bool char exn float format format4
syn keyword  ocamlType     int int32 int64 lazy_t list nativeint option
syn keyword  ocamlType     string unit

syn match    ocamlConstructor  "(\s*)"
syn match    ocamlConstructor  "\[\s*\]"
syn match    ocamlConstructor  "\[|\s*>|]"
syn match    ocamlConstructor  "\[<\s*>\]"
syn match    ocamlConstructor  "\u\(\w\|'\)*\>"

" Polymorphic variants
syn match    ocamlConstructor  "`\w\(\w\|'\)*\>"

" Module prefix
syn match    ocamlModPath      "\u\(\w\|'\)* *\."he=e-1

syn match    ocamlCharacter    "'\\\d\d\d'\|'\\[\'ntbr]'\|'.'"
syn match    ocamlCharacter    "'\\x\x\x'"
syn match    ocamlCharErr      "'\\\d\d'\|'\\\d'"
syn match    ocamlCharErr      "'\\[^\'ntbr]'"
syn region   ocamlString       start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=@Spell

syn match    ocamlTopStop      ";;"

syn match    ocamlAnyVar       "\<_\>"
syn match    ocamlKeyChar      "|[^\]]"me=e-1
syn match    ocamlKeyChar      ";"
syn match    ocamlKeyChar      "\~"
syn match    ocamlKeyChar      "?"

"" Operators

" The grammar of operators is found there:
"     https://caml.inria.fr/pub/docs/manual-ocaml/names.html#operator-name
"     https://caml.inria.fr/pub/docs/manual-ocaml/extn.html#s:ext-ops
"     https://caml.inria.fr/pub/docs/manual-ocaml/extn.html#s:index-operators
" =, *, < and > are both operator names and keywords, we let the user choose how
" to display them (has to be declared before regular infix operators):
syn match    ocamlEqual        "="
syn match    ocamlStar         "*"
syn match    ocamlAngle        "<"
syn match    ocamlAngle        ">"
" Custom indexing operators:
syn match    ocamlIndexingOp   "\.[~?!:|&$%=>@^/*+-][~?!.:|&$%<=>@^*/+-]*\(()\|\[]\|{}\)\(<-\)\?"
" Extension operators (has to be declared before regular infix operators):
syn match    ocamlExtensionOp          "#[#~?!.:|&$%<=>@^*/+-]\+"
" Infix and prefix operators:
syn match    ocamlPrefixOp              "![~?!.:|&$%<=>@^*/+-]*"
syn match    ocamlPrefixOp           "[~?][~?!.:|&$%<=>@^*/+-]\+"
syn match    ocamlInfixOp      "[&$%@^/+-][~?!.:|&$%<=>@^*/+-]*"
syn match    ocamlInfixOp         "[|<=>*][~?!.:|&$%<=>@^*/+-]\+"
syn match    ocamlInfixOp               "#[~?!.:|&$%<=>@^*/+-]\+#\@!"
syn match    ocamlInfixOp              "!=[~?!.:|&$%<=>@^*/+-]\@!"
syn keyword  ocamlInfixOpKeyword      asr land lor lsl lsr lxor mod or
" := is technically an infix operator, but we may want to show it as a keyword
" (somewhat analogously to = for let‐bindings and <- for assignations):
syn match    ocamlRefAssign    ":="
" :: is technically not an operator, but we may want to show it as such:
syn match    ocamlCons         "::"
" -> and <- are keywords, not operators (but can appear in longer operators):
syn match    ocamlArrow        "->[~?!.:|&$%<=>@^*/+-]\@!"
if exists("ocaml_revised")
  syn match    ocamlErr        "<-[~?!.:|&$%<=>@^*/+-]\@!"
else
  syn match    ocamlKeyChar    "<-[~?!.:|&$%<=>@^*/+-]\@!"
endif

syn match    ocamlNumber        "-\=\<\d\(_\|\d\)*[l|L|n]\?\>"
syn match    ocamlNumber        "-\=\<0[x|X]\(\x\|_\)\+[l|L|n]\?\>"
syn match    ocamlNumber        "-\=\<0[o|O]\(\o\|_\)\+[l|L|n]\?\>"
syn match    ocamlNumber        "-\=\<0[b|B]\([01]\|_\)\+[l|L|n]\?\>"
syn match    ocamlFloat         "-\=\<\d\(_\|\d\)*\.\?\(_\|\d\)*\([eE][-+]\=\d\(_\|\d\)*\)\=\>"

" Labels
syn match    ocamlLabel        "\~\(\l\|_\)\(\w\|'\)*"lc=1
syn match    ocamlLabel        "?\(\l\|_\)\(\w\|'\)*"lc=1
syn region   ocamlLabel transparent matchgroup=ocamlLabel start="[~?](\(\l\|_\)\(\w\|'\)*"lc=2 end=")"me=e-1 contains=ALLBUT,@ocamlContained,ocamlParenErr


" Synchronization
syn sync minlines=50
syn sync maxlines=500

if !exists("ocaml_revised")
  syn sync match ocamlDoSync      grouphere  ocamlDo      "\<do\>"
  syn sync match ocamlDoSync      groupthere ocamlDo      "\<done\>"
endif

if exists("ocaml_revised")
  syn sync match ocamlEndSync     grouphere  ocamlEnd     "\<\(object\)\>"
else
  syn sync match ocamlEndSync     grouphere  ocamlEnd     "\<\(begin\|object\)\>"
endif

syn sync match ocamlEndSync     groupthere ocamlEnd     "\<end\>"
syn sync match ocamlStructSync  grouphere  ocamlStruct  "\<struct\>"
syn sync match ocamlStructSync  groupthere ocamlStruct  "\<end\>"
syn sync match ocamlSigSync     grouphere  ocamlSig     "\<sig\>"
syn sync match ocamlSigSync     groupthere ocamlSig     "\<end\>"

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_ocaml_syntax_inits")
  if version < 508
    let did_ocaml_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink ocamlBraceErr	   Error
  HiLink ocamlBrackErr	   Error
  HiLink ocamlParenErr	   Error
  HiLink ocamlArrErr	   Error

  HiLink ocamlCommentErr   Error

  HiLink ocamlCountErr	   Error
  HiLink ocamlDoErr	   Error
  HiLink ocamlDoneErr	   Error
  HiLink ocamlEndErr	   Error
  HiLink ocamlThenErr	   Error

  HiLink ocamlCharErr	   Error

  HiLink ocamlErr	   Error

  HiLink ocamlComment	   Comment

  HiLink ocamlModPath	   Include
  HiLink ocamlObject	   Include
  HiLink ocamlModule	   Include
  HiLink ocamlModParam1    Include
  HiLink ocamlGenMod       Include
  HiLink ocamlModType	   Include
  HiLink ocamlMPRestr3	   Include
  HiLink ocamlFullMod	   Include
  HiLink ocamlFuncWith	   Include
  HiLink ocamlModParam     Include
  HiLink ocamlModTypeRestr Include
  HiLink ocamlWith	   Include
  HiLink ocamlMTDef	   Include
  HiLink ocamlSigEncl	   ocamlModule
  HiLink ocamlStructEncl	   ocamlModule

  HiLink ocamlScript	   Include

  HiLink ocamlConstructor  Constant

  HiLink ocamlVal          Keyword
  HiLink ocamlModPreRHS    Keyword
  HiLink ocamlMPRestr2	   Keyword
  HiLink ocamlKeyword	   Keyword
  HiLink ocamlMethod	   Include
  HiLink ocamlArrow	   Keyword
  HiLink ocamlKeyChar	   Keyword
  HiLink ocamlAnyVar	   Keyword
  HiLink ocamlTopStop	   Keyword

  HiLink ocamlRefAssign    ocamlKeyChar
  HiLink ocamlEqual        ocamlKeyChar
  HiLink ocamlStar         ocamlInfixOp
  HiLink ocamlAngle        ocamlInfixOp
  HiLink ocamlCons         ocamlInfixOp

  HiLink ocamlPrefixOp       ocamlOperator
  HiLink ocamlInfixOp        ocamlOperator
  HiLink ocamlExtensionOp    ocamlOperator
  HiLink ocamlIndexingOp     ocamlOperator

  if exists("ocaml_highlight_operators")
    HiLink ocamlInfixOpKeyword ocamlOperator
    HiLink ocamlOperator       Operator
  else
    HiLink ocamlInfixOpKeyword Keyword
  endif

  HiLink ocamlBoolean	   Boolean
  HiLink ocamlCharacter    Character
  HiLink ocamlNumber	   Number
  HiLink ocamlFloat	   Float
  HiLink ocamlString	   String
  HiLink ocamlQuotedStringDelim Identifier

  HiLink ocamlLabel	   Identifier

  HiLink ocamlType	   Type

  HiLink ocamlTodo	   Todo

  HiLink ocamlEncl	   Keyword

  HiLink ocamlPpxEncl       ocamlEncl

  delcommand HiLink
endif

let b:current_syntax = "ocaml"

" vim: ts=8
