#Set annoying greeting to empty
set -U fish_greeting

## Left Prompt
function fish_prompt
  #Show the current working directory
  set_color black
  if test (id -u) -eq 0
    set_color --background=brred
  else
    set_color --background=yellow
  end
  if test (id -u) -eq 0
    echo -n ' # '
    set_color brred
    set_color --background=brblack
    echo -n ' '
  else
    echo -n ' $ '
    set_color yellow
    set_color --background=brblack
    echo -n ' '
  end
  set_color --background=brblack
  set_color brwhite
  echo -n $USER
  echo -n ' '
  set_color brblack
  set_color --background=blue
  echo -n ' '
  set_color black
  echo -n (prompt_pwd_full)
  echo -n ' '
  set_color normal
  set_color blue
  echo -n ' '
  set_color normal
end

function prompt_pwd_full --description "Menampilkan folder kerja 4 huruf"
  # This allows overriding fish_prompt_pwd_dir_length from the outside (global or universal) without leaking it
  set -q fish_prompt_pwd_dir_length
  or set -l fish_prompt_pwd_dir_length 4

  # Replace $HOME with "~"
  set -l realhome ~
  set -l tmp (string replace -r '^'"$realhome"'($|/)' '~$1' $PWD)

  if [ $fish_prompt_pwd_dir_length -eq 0 ]
      echo $tmp
  else
      # Shorten to at most $fish_prompt_pwd_dir_length characters per directory
      string replace -ar '(\.?[^/]{'"$fish_prompt_pwd_dir_length"'})[^/]*/' '$1/' $tmp
  end
end


