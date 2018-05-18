
if (exists('g:loaded_toggle_comment'))
    finish
endif

let g:loaded_toggle_comment = 1

if !has('python3')
    finish
endif

python3 << EOF
def toggle_comment(mode):
    import vim
    buf = vim.current.buffer
    if mode == 'v':
        (no1, col1) = buf.mark('<')
        (no2, col2) = buf.mark('>')
    elif mode == 'n':
        no1, col = vim.current.window.cursor
        no2 = no1
    else:
        print("Toggle comment is not support in this mode: %s" % mode)
        return
    #print("%d, %d" % (no1, no2))
    #return
    line = buf[no1-1]
    cl = vim.eval('b:comment_leader')
    if line.startswith(cl):
        comment = False
    else:
        comment = True

    for i in range(no1-1, no2):
        line = buf[i]
        if comment:
            buf[i] = cl + line
        else:
            if line.startswith(cl):
                buf[i] = line[len(cl):]
EOF

" Set toggle_comment {{{
augroup comment_set_group
    autocmd!
    autocmd FileType c,cpp,java,scala,trace,javascript let b:comment_leader = '// '
    autocmd FileType sh,ruby,python   let b:comment_leader = '# '
    autocmd FileType conf,fstab,yaml  let b:comment_leader = '# '
    autocmd FileType tex              let b:comment_leader = '% '
    autocmd FileType mail             let b:comment_leader = '> '
    autocmd FileType vim              let b:comment_leader = '" '
    autocmd FileType dosbatch         let b:comment_leader = 'REM '
augroup END
vmap <silent> // :python3 toggle_comment('v')<CR>
nmap <silent> // :python3 toggle_comment('n')<CR>
" }}}
