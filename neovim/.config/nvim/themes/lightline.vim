set laststatus=2

if !has('gui_running')
  set t_Co=256
endif

set noshowmode

let g:lightline = {
      \ 'colorscheme': 'onedark',
      \}


let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': '', 'right': '' }


