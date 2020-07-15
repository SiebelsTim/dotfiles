" Language:	gitcommit
" Maintainer:	Martin von Wittich <martin.von.wittich@iserv.eu>
" Last Changed:	2017-11-08

function! GitcommitRedmineCallback(channel, msg)
  let b:gitcommit_issue_subject = a:msg
  set tabline=%!GitcommitTabLine()
endfunction

function! GitcommitTimerCallback(timer)
  if b:gitcommit_ticket_id != ""
    let l:job = job_start(["/home/tim/.vim/iserv/redmine_query", b:gitcommit_ticket_id],
        \ {"callback": "GitcommitRedmineCallback"})
  endif
endfunction

function! GitcommitCheckCommitMessage()
  let l:ticket_id = ""
  if getline(1) =~ '\v(refs|fixes|closes).+#\d+>'
    let l:ticket_id = matchstr(getline(1), '\v(refs|fixes|closes).+#\zs\d+>')
  endif

  if !exists ("b:gitcommit_ticket_id") ||
      \ b:gitcommit_ticket_id != l:ticket_id

    let b:gitcommit_ticket_id = l:ticket_id
    let b:gitcommit_issue_subject = "bug report mentioned :)"

    " querying Redmine requires vim >= 8.0
    if filereadable("/home/tim/.vim/iserv/redmine.auth") &&
        \ filereadable("/home/tim/.vim/iserv/redmine_query") &&
        \ has("timers") && has("job")
      if exists("b:gitcommit_timer")
        call timer_stop(b:gitcommit_timer)
      endif
      let b:gitcommit_timer = timer_start(500, "GitcommitTimerCallback")
    endif

    set showtabline=2
    set tabline=%!GitcommitTabLine()
  endif
endfunction

function! GitcommitTabLine()
  let s = ''

  " If b:gitcommit_ticket_id is set for the current buffer, add the notice
  " whether the ticket ID is mentioned to the very left. Missing ticket IDs
  " are highlighted red (Error), and existing ticket IDs are highlighted green
  " (gitcommitHaveTicketID).
  if exists("b:gitcommit_ticket_id")
    if b:gitcommit_ticket_id != ""
      let s .= '%#gitcommitHaveTicketID#'.b:gitcommit_issue_subject
    else
      let s .= '%#Error#no bug report mentioned!'
    endif
  endif

  " Render the remaining tabs if we have more than one. We don't render them
  " if there is only a single tab because for `git commit` there usually is
  " only a single tab, and its filename (.git/COMMIT_EDITMSG) isn't really
  " interesting, and vim wouldn't usually show a tab line for a single file
  " anyway. We force it to display the tab line with :set showtabline=2, so we
  " have to take care of that.
  if tabpagenr('$') > 1
    for i in range(tabpagenr('$'))
      " select the highlighting
      if i + 1 == tabpagenr()
        let s .= '%#TabLineSel#'
      else
        let s .= '%#TabLine#'
      endif

      " set the tab page number (for mouse clicks)
      let s .= '%' . (i + 1) . 'T'

      " the label is made by MyTabLabel()
      let s .= ' %{GitcommitTabLabel(' . (i + 1) . ')} '
    endfor
  endif

  " Render the rest of the empty tab line. Use the same colors as above if
  " b:gitcommit_ticket_id is defined for the current buffer.
  if exists("b:gitcommit_ticket_id")
    if b:gitcommit_ticket_id != ""
      let s .= '%#gitcommitHaveTicketID#%T'
    else
      let s .= '%#Error#%T'
    endif
  else
    let s .= '%#TabLineFill#%T'
  endif

  return s
endfunction

function! GitcommitTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  return bufname(buflist[winnr - 1])
endfunction

function GitcommitLeaveHook()
  let l:msg = '
        \Tip:\n\n
\Put your Redmine API key (My account -> API access key -> Show) into\n
\/etc/iserv/redmine.auth. This will allow vim to query Redmine for your\n
\ticket ID and show you the issue title before you commit.\n\n
\If you''re not interested: touch ~/.vim/no-redmine-query'
  if !filereadable("~/.vim/iserv/redmine.auth") &&
      \ filereadable("~/.vim/iserv/redmine_query") &&
      \ has("timers") && has("job") &&
      \ !filereadable($HOME."/.vim/no-redmine-query")
    execute "!echo -e ".shellescape(&t_te . l:msg)
  endif
endfunction

highlight gitcommitHaveTicketID term=reverse cterm=bold ctermfg=7 ctermbg=green guifg=White guibg=Red

autocmd TextChanged,TextChangedI <buffer> call GitcommitCheckCommitMessage()
autocmd VimLeave <buffer> call GitcommitLeaveHook()
call GitcommitCheckCommitMessage()

" disable automatic word wrap that is for some reason explicitly enabled by
" the default gitcommit.vim (#9564)
setlocal textwidth=0
