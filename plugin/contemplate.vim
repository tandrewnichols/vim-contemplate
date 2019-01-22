if exists("g:loaded_contemplate") || &cp | finish | endif

let g:loaded_contemplate = 1

let g:contemplate_VERSION = '1.0.0'

let g:contemplate_skeleton_dir = get(g:, 'contemplate_skeleton_dir', '$HOME/.vim/skeletons')
let g:contemplate_autoscaffold = get(g:, 'contemplate_autoscaffold', 0)
let g:contemplate_scaffold_map = get(g:, 'contemplate_scaffold_map', {})

if g:contemplate_autoscaffold
  augroup ContemplateAutoscaffold
    au!
    for [pattern, skeleton] in items(g:contemplate_scaffold_map)
      exec "au BufNewFile,BufRead " . pattern . " call contemplate#expand('" . skeleton . "')"
    endfor
  augroup END
endif

command! -nargs=? -complete=customlist,contemplate#complete Contemplate call contemplate#expand(<f-args>)
