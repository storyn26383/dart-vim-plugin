if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

setlocal cindent
setlocal cinoptions+=j1,J1,(2s,u2s,U1,m1,+2s

setlocal indentexpr=dart#GetDartIndent()

let b:undo_indent = 'setl cin< cino<'

if exists('*dart#GetDartIndent')
  finish
endif

function! dart#GetLine(lnum)
  return substitute(substitute(getline(a:lnum), '\s\+$', '', ''), '^\s\+', '', '')
endfunction

function! dart#GetDartIndent()
  let currentLineNumber = v:lnum
  let previousLineNumber = prevnonblank(currentLineNumber - 1)

  if previousLineNumber == 0
    return 0
  endif

  let previousLine = dart#GetLine(previousLineNumber)
  let currentLine = dart#GetLine(currentLineNumber)
  let previousIndent = indent(previousLineNumber)
  let increaseIndent = previousIndent + &sw
  let decreaseIndent = previousIndent - &sw
  let openingSection = '[{([]$'
  let closingSection = '^[})\]]'

  if currentLine =~ closingSection
    if previousLine =~ openingSection
      return previousIndent
    endif

    return decreaseIndent
  endif

  if previousLine =~ openingSection
    return increaseIndent
  endif

  if currentLine =~ '^\.'
    if previousLine =~ closingSection
      return previousIndent
    endif

    return increaseIndent
  endif

  return previousIndent
endfunction

" vim:set sw=2:
