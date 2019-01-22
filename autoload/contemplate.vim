function! contemplate#complete(arg, ...)
  let candidates = contemplate#candidates(a:arg)
  return map(candidates, function('contemplate#name'))
endfunction

function! contemplate#name(i, val)
  return fnamemodify(a:val, ':t:r')
endfunction

function! contemplate#expand(...)
  let type = a:0 > 0 ? a:1 : ''
  let candidates = contemplate#candidates(type)

  if len(candidates) == 1
    let skeleton = candidates[0]
  else
    let skeleton = inputlist(['Choose a skeleton:'] + map(candidates, {v, i -> (i + 1). '. ' . v}))
  endif

  if exists('skeleton') && !empty(skeleton)
    let contents = readfile(skeleton)
    let joined = join(contents, "\n")
    if contemplate#containsSnippets(joined)
      call UltiSnips#Anon(joined)
    else
      call append(getline('.'), contents)
    endif
  endif
endfunction

function! contemplate#candidates(...)
  let partial = a:0 > 0 ? a:1 : ''
  let fts = split(&ft, '\.')
  let files = []
  for ft in fts
    let files += glob(g:contemplate_skeleton_dir . '/' . ft . '/' . partial . '*', 0, 1)
  endfor

  return files
endfunction

function! contemplate#containsSnippets(contents)
  return match(a:contents, '${\d') > -1
endfunction
