if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Keep Python keywords in alphabetical order inside groups for easy
" comparison with the table in the 'Python Language Reference'
" https://docs.python.org/2/reference/lexical_analysis.html#keywords,
" https://docs.python.org/3/reference/lexical_analysis.html#keywords.
" Groups are in the order presented in NAMING CONVENTIONS in syntax.txt.
" Exceptions come last at the end of each group (class and def below).
"
" Keywords 'with' and 'as' are new in Python 2.6
" (use 'from __future__ import with_statement' in Python 2.5).
"
" Some compromises had to be made to support both Python 3 and 2.
" We include Python 3 features, but when a definition is duplicated,
" the last definition takes precedence.
"
" - 'False', 'None', and 'True' are keywords in Python 3 but they are
"   built-ins in 2 and will be highlighted as built-ins below.
" - 'exec' is a built-in in Python 3 and will be highlighted as
"   built-in below.
" - 'nonlocal' is a keyword in Python 3 and will be highlighted.
" - 'print' is a built-in in Python 3 and will be highlighted as
"   built-in below (use 'from __future__ import print_function' in 2)
" - async and await were added in Python 3.5 and are soft keywords.
"
"
syn keyword pythonStatement	False None True
syn keyword pythonStatement	as assert break continue del exec global
syn keyword pythonStatement	lambda nonlocal pass print return with yield
syn keyword pythonConditional	elif else if
syn keyword pythonRepeat	for while
syn keyword pythonOperator	and in is not or
syn keyword pythonException	except finally raise try
syn keyword pythonAsync		async await
syn match pythonIncludeStatement	/\%(from\s\|import\s\)/
syn match pythonDefStatement	/^\s*\%(def\s\|class\s\)/ nextgroup=pythonFunction skipwhite

" Decorators (new in Python 2.4)
" A dot must be allowed because of @MyClass.myfunc decorators.
syn match   pythonDecorator	"@" display contained
syn match   pythonDecoratorName	"@\s*\h\%(\w\|\.\)*" display contains=pythonDecorator

" Python 3.5 introduced the use of the same symbol for matrix multiplication:
" https://www.python.org/dev/peps/pep-0465/.  We now have to exclude the
" symbol from highlighting when used in that context.
" Single line multiplication.
syn match   pythonMatrixMultiply
      \ "\%(\w\|[])]\)\s*@"
      \ contains=ALLBUT,pythonDecoratorName,pythonDecorator,pythonFunction,pythonDoctestValue
      \ transparent
" Multiplication continued on the next line after backslash.
syn match   pythonMatrixMultiply
      \ "[^\\]\\\s*\n\%(\s*\.\.\.\s\)\=\s\+@"
      \ contains=ALLBUT,pythonDecoratorName,pythonDecorator,pythonFunction,pythonDoctestValue
      \ transparent
" Multiplication in a parenthesized expression over multiple lines with @ at
" the start of each continued line; very similar to decorators and complex.
syn match   pythonMatrixMultiply
      \ "^\s*\%(\%(>>>\|\.\.\.\)\s\+\)\=\zs\%(\h\|\%(\h\|[[(]\).\{-}\%(\w\|[])]\)\)\s*\n\%(\s*\.\.\.\s\)\=\s\+@\%(.\{-}\n\%(\s*\.\.\.\s\)\=\s\+@\)*"
      \ contains=ALLBUT,pythonDecoratorName,pythonDecorator,pythonFunction,pythonDoctestValue
      \ transparent

" Folding classes and functions.
syn region  pythonClassFold	start="\%(^\s*\n\)\@<=\z(\s*\)\%(@\|def\s\|class\s\)"
      \ skip="\%(^\s*\n^\s*\n\)\ze\z1\S"
      \ end="\%(^\s*\n\)\ze\%(\z1\S\|^\s*\n\)" fold transparent
syn region  pythonIncludeFold	start="\zs\%(from\|import\)\s"
      \ end="\n\n" fold transparent
      \ contains=pythonIncludeStatement,pythonString,pythonComment

syn match   pythonFunction	"\h\w*" display contained

syn match   pythonComment	"#.*$" contains=pythonTodo,@Spell
syn keyword pythonTodo		FIXME NOTE NOTES TODO XXX contained

" Triple-quoted strings can contain doctests.
syn region  pythonString matchgroup=pythonQuotes
      \ start=+[uU]\=\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
      \ contains=pythonEscape,@Spell
syn region  pythonString matchgroup=pythonTripleQuotes
      \ start=+[uU]\=\z('''\|"""\)+ end="\z1" keepend fold
      \ contains=pythonEscape,pythonSpaceError,pythonDoctest,@Spell
syn region  pythonRawString matchgroup=pythonQuotes
      \ start=+[uU]\=[rR]\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
      \ contains=@Spell
syn region  pythonRawString matchgroup=pythonTripleQuotes
      \ start=+[uU]\=[rR]\z('''\|"""\)+ end="\z1" keepend
      \ contains=pythonSpaceError,pythonDoctest,@Spell

syn match   pythonEscape	+\\[abfnrtv'"\\]+ contained
syn match   pythonEscape	"\\\o\{1,3}" contained
syn match   pythonEscape	"\\x\x\{2}" contained
syn match   pythonEscape	"\%(\\u\x\{4}\|\\U\x\{8}\)" contained

" Python allows case-insensitive Unicode IDs: http://www.unicode.org/charts/
syn match   pythonEscape	"\\N{\a\+\%(\s\a\+\)*}" contained
syn match   pythonEscape	"\\$"

" Group the built-ins in the order in the 'Python Library Reference' for
" easier comparison.
" https://docs.python.org/2/library/constants.html
" https://docs.python.org/3/library/constants.html
" http://docs.python.org/2/library/functions.html
" http://docs.python.org/3/library/functions.html
" http://docs.python.org/2/library/functions.html#non-essential-built-in-functions
" http://docs.python.org/3/library/functions.html#non-essential-built-in-functions
" Python built-in functions are in alphabetical order.

" Built-in constants
" 'False', 'True', and 'None' are also reserved words in Python 3
syn keyword pythonBuiltin	False True None
syn keyword pythonBuiltin	NotImplemented Ellipsis __debug__

" Built-in functions
syn keyword pythonBuiltin	abs all any bin bool bytearray callable chr
syn keyword pythonBuiltin	classmethod compile complex delattr dict dir
syn keyword pythonBuiltin	divmod enumerate eval filter float format
syn keyword pythonBuiltin	frozenset getattr globals hasattr hash
syn keyword pythonBuiltin	help hex id input int isinstance
syn keyword pythonBuiltin	issubclass iter len list locals map max
syn keyword pythonBuiltin	memoryview min next object oct open ord pow
syn keyword pythonBuiltin	print property range repr reversed round set
syn keyword pythonBuiltin	setattr slice sorted staticmethod str
syn keyword pythonBuiltin	sum super tuple type vars zip __import__

" Python 2 only
syn keyword pythonBuiltin	basestring cmp execfile file
syn keyword pythonBuiltin	long raw_input reduce reload unichr
syn keyword pythonBuiltin	unicode xrange

" Python 3 only
syn keyword pythonBuiltin	ascii bytes exec

" Non-essential built-in functions; Python 2 only
syn keyword pythonBuiltin	apply buffer coerce intern

" Avoid highlighting attributes as builtins
syn match   pythonAttribute	/\.\h\w*/hs=s+1
      \ contains=ALLBUT,pythonBuiltin,pythonFunction,pythonAsync
      \ transparent

" From the 'Python Library Reference' class hierarchy at the bottom.
" http://docs.python.org/2/library/exceptions.html
" http://docs.python.org/3/library/exceptions.html

" builtin base exceptions (used mostly as base classes for other exceptions)
syn keyword pythonExceptions	BaseException Exception
syn keyword pythonExceptions	ArithmeticError BufferError
syn keyword pythonExceptions	LookupError
" builtin base exceptions removed in Python 3
syn keyword pythonExceptions	EnvironmentError StandardError
" builtin exceptions (actually raised)
syn keyword pythonExceptions	AssertionError AttributeError
syn keyword pythonExceptions	EOFError FloatingPointError GeneratorExit
syn keyword pythonExceptions	ImportError IndentationError
syn keyword pythonExceptions	IndexError KeyError KeyboardInterrupt
syn keyword pythonExceptions	MemoryError NameError NotImplementedError
syn keyword pythonExceptions	OSError OverflowError ReferenceError
syn keyword pythonExceptions	RuntimeError StopIteration SyntaxError
syn keyword pythonExceptions	SystemError SystemExit TabError TypeError
syn keyword pythonExceptions	UnboundLocalError UnicodeError
syn keyword pythonExceptions	UnicodeDecodeError UnicodeEncodeError
syn keyword pythonExceptions	UnicodeTranslateError ValueError
syn keyword pythonExceptions	ZeroDivisionError
" builtin OS exceptions in Python 3
syn keyword pythonExceptions	BlockingIOError BrokenPipeError
syn keyword pythonExceptions	ChildProcessError ConnectionAbortedError
syn keyword pythonExceptions	ConnectionError ConnectionRefusedError
syn keyword pythonExceptions	ConnectionResetError FileExistsError
syn keyword pythonExceptions	FileNotFoundError InterruptedError
syn keyword pythonExceptions	IsADirectoryError NotADirectoryError
syn keyword pythonExceptions	PermissionError ProcessLookupError
syn keyword pythonExceptions	RecursionError StopAsyncIteration
syn keyword pythonExceptions	TimeoutError
" builtin exceptions deprecated/removed in Python 3
syn keyword pythonExceptions	IOError VMSError WindowsError
" builtin warnings
syn keyword pythonExceptions	BytesWarning DeprecationWarning FutureWarning
syn keyword pythonExceptions	ImportWarning PendingDeprecationWarning
syn keyword pythonExceptions	RuntimeWarning SyntaxWarning UnicodeWarning
syn keyword pythonExceptions	UserWarning Warning
" builtin warnings in Python 3
syn keyword pythonExceptions	ResourceWarning

" trailing whitespace
syn match   pythonSpaceError	display excludenl "\s\+$"
" mixed tabs and spaces
syn match   pythonSpaceError	display " \+\t"
syn match   pythonSpaceError	display "\t\+ "

" Sync at the beginning of class, function, or method definition.
syn sync match pythonSync grouphere NONE "^\%(def\|class\)\s\+\h\w*\s*[(:]"

" The default highlight links. Can be overridden later.
hi def link pythonStatement		Statement
hi def link pythonDefStatement		Statement
hi def link pythonConditional		Conditional
hi def link pythonRepeat		Repeat
hi def link pythonOperator		Operator
hi def link pythonException		Exception
hi def link pythonIncludeStatement		Include
hi def link pythonAsync			Statement
hi def link pythonDecorator		Define
hi def link pythonDecoratorName		Function
hi def link pythonFunction		Function
hi def link pythonComment		Comment
hi def link pythonTodo			Todo
hi def link pythonString		String
hi def link pythonRawString		String
hi def link pythonQuotes		String
hi def link pythonTripleQuotes		pythonQuotes
hi def link pythonEscape		Special
hi def link pythonBuiltin		Function
hi def link pythonExceptions		Structure
hi def link pythonSpaceError		Error

let b:current_syntax = "python"

let &cpo = s:cpo_save
unlet s:cpo_save
