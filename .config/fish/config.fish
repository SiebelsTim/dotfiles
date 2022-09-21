# fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch blue

# Status Chars
set __fish_git_prompt_char_dirtystate '✚'
set __fish_git_prompt_char_stagedstate '●'
set __fish_git_prompt_char_stashstate "☰ "
set __fish_git_prompt_char_upstream_ahead '↑'
set __fish_git_prompt_char_upstream_behind '↓'
 
function fish_prompt
        set -l last_status $status
        set -l host_color "red"
        set -l pwd_color "green"
        set -l dollar_color "normal"
        if test (id -u) -eq 0
          set is_root 1
          set pwd_color "red"
        end

        printf '['
        set_color --bold $host_color 
        printf '%s@%s' (whoami) (hostname) 
        set_color $pwd_color
        printf ' %s' (prompt_pwd)
        set_color normal
        printf ']'

        if test $last_status -ne 0
           set_color --bold red
           printf "[%d]" $last_status
           set_color normal
        end

       printf '\n'
       printf '%s ' (__fish_git_prompt)
       if [ $is_root ]
          set_color --bold red
          printf '# '
       else
          printf '$ '
       end
       set_color normal
end


function fish_right_prompt
    set jobs_count (jobs -p | wc -l)
    if test $jobs_count -ne 0
        set_color yellow
        printf '%%'
        set_color normal
    end
    set_color 888888
    if test $CMD_DURATION -gt 70
        # Show duration of the last command in seconds
        if test $CMD_DURATION -gt 3000
           set_color red 
        end
        printf "%dms" $CMD_DURATION
        set_color 888888
    end

    printf " <%s" (date "+%X %x")
end


function fish_title
    echo (whoami) "@" (hostname) "#" (pwd) '$' $_
end

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias xclipc='xclip -sel clipboard'
alias xclipv='xclip -out -sel clipboard'
alias V='vim -c "set nomod" -'
set -x ISERV_GIT_BASE /home/tim/iserv/copy/iserv3
set -x MKROOT /home/tim/iserv/copy/iserv3/buildtools/lib/buildtools/mk
