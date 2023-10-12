function! contemplate#complete(arg, line, ...) abort
  let parts = split(a:line, ' ')
  let ft = empty(&ft) ? (len(parts) == 3 ? parts[1] : '*') : &ft
  let candidates = contemplate#candidates(ft, a:arg)

  if empty(candidates)
    return getcompletion(a:arg, 'filetype')
  endif

  return map(candidates, function('contemplate#name'))
endfunction

function! contemplate#name(i, val) abort
  return fnamemodify(a:val, ':t:r')
endfunction

function! contemplate#expand(...) abort
  if a:0 == 2
    if contemplate#isFiletype(a:1)
      let ft = a:1
      let type = a:2
    else
      let ft = a:2
      let type = a:1
    endif
  elseif a:0 == 1 && empty(&ft)
    if contemplate#isFiletype(a:1)
      let ft = a:1
      let type = ''
    else
      let type = a:1
      let matches = contemplate#glob('/*/' . type . '*')
      if len(matches) == 1
        let ft = fnamemodify(matches[0], ':h:t')
      elseif len(matches) > 1
        let ft = contemplate#prompt(map(matches, {i, v -> fnamemodify(v, ':h')}), 'Choose filetype:', 1)
      else
        echoerr 'Unable to infer filetype. Please set the filetype with :setf or pass it as an additional argument to :Contemplate'
        return
      endif
    endif
  elseif a:0 > 0
    let ft = &ft
    let type = a:1
  else
    let type = ''
    let ft = &ft
  endif

  if empty(ft)
    let fts = contemplate#glob('/*')
    if len(fts) == 0
      echoerr 'You don''t have any templates defined.'
      return
    endif

    let ft = contemplate#prompt(fts, 'Choose filetype:', 1)
    redraw
  endif

  if empty(ft)
    return
  endif

  let candidates = contemplate#candidates(ft, type)

  if len(candidates) == 1
    let skeleton = candidates[0]
  else
    if len(candidates) == 0
      echoerr 'You don''t have any templates definted for the filetype' ft . '.'
      return
    endif

    " Try to find exact match in the case that one skeleton name begins with the entirety of another
    let exactMatch = reduce(candidates, { acc, val -> split(split(val, '/')[-1], '\.')[0] == type ? val : acc})

    if !empty(exactMatch)
      let skeleton = exactMatch
    else
      let skeleton = contemplate#prompt(candidates, 'Choose skeleton:', 0)
      redraw
    endif
  endif

  if empty(skeleton)
    return
  endif

  let contents = readfile(skeleton)
  let joined = join(contents, "\n")
  call UltiSnips#Anon(joined)

  if empty(&ft)
    let &ft = ft
  endif
endfunction

function! contemplate#candidates(ft, ...) abort
  let partial = a:0 > 0 ? a:1 : ''
  let fts = split(a:ft, '\.')
  let files = []
  for ft in fts
    let files += contemplate#glob('/' . ft . '/' . partial . '*')
  endfor

  return files
endfunction

function! contemplate#glob(subpath) abort
  return glob(g:contemplate_skeleton_dir . a:subpath, 0, 1)
endfunction

function! contemplate#prompt(list, message, modify) abort
  let choice = inputlist([a:message] + map(copy(a:list), {idx, item -> (idx + 1) . '. ' . fnamemodify(item, ':t:r')}))
  if choice
    let item = a:list[ choice - 1]
    return a:modify ? fnamemodify(item, ':t:r') : item
  else
    return ''
  endif
endfunction

function! contemplate#isFiletype(str) abort
  let completions = getcompletion(a:str, 'filetype')
  return index(completions, a:str) > -1
endfunction
