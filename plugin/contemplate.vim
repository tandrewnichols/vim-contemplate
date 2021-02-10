if exists("g:loaded_contemplate") || &cp | finish | endif

let g:loaded_contemplate = 1

let g:contemplate_VERSION = '1.0.0'

let g:contemplate_skeleton_dir = get(g:, 'contemplate_skeleton_dir', '$HOME/.vim/skeletons')
let g:contemplate_autoscaffold = get(g:, 'contemplate_autoscaffold', {})

if !empty(g:contemplate_autoscaffold)
  augroup ContemplateAutoscaffold
    au!
    for [pattern, skeleton] in items(g:contemplate_autoscaffold)
      exec "au BufNewFile " . pattern . " au! ContemplateAutoscaffold BufWinEnter <buffer> call contemplate#expand('" . skeleton . "')"
    endfor
  augroup END
endif

command! -nargs=* -complete=customlist,contemplate#complete Contemplate call contemplate#expand(<f-args>)
