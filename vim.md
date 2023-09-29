#### Vim

##### Check spell in VIM

Edit _vimrc accordingly

    " support for pl
    if has("multi_byte")
      if &termencoding == ""
        let &termencoding = &encoding
      endif
      set encoding=utf-8
      setglobal fileencoding=utf-8 bomb
      set fileencodings=ucs-bom,utf-8,latin1
      set spell spelllang=pl
    endif
     
    "some MS WIN enhancements
    if has("win32")
    set shell=cmd.exe
    set shellcmdflag=/c\ powershell.exe\ -NoLogo\ -NoProfile\ -NonInteractive\ -ExecutionPolicy\ RemoteSigned
    set shellpipe=|
    set shellredir=>
    set nobackup
    set nowritebackup
    set paste
    set gfn=Consolas:h10:cANSI:qDRAFT
    set backspace=indent,eol,start
    source $VIMRUNTIME/mswin.vim
    behave mswin
    endif

This should make possible to use pl keyboard with nice fonts and give the access to PowerShell directly from VIM.

For getting spell check use command `:setlocal spell spelllang=pl` or set it in vimrc file as in example above, vim try to download whatever is needed 
If there is problem, you can download dictionaries for spell check manually from e.g. ftp://ftp.vim.org/pub/vim/runtime/spell/.
Then add these dictionaries (.spl files) to spell directory in your vim (e.g. vim81/spell).
For Polish you can download pl.cp1250.spl, pl.utf-8.spl and pl.iso-8859-2.spl

Working with spelling

 * ]s Move to next misspelled word after the cursor. A count before the command can be used to repeat. 'wrapscan' applies.
 * [s Like "]s" but search backwards, find the misspelled word before the cursor.
 * z= For the word under/after the cursor, suggest correctly spelled words.
 * zg Add word under the cursor as a good word

Autocorrect macro:

    ggqq]s1z=@qq@q
    
    gg  Move to the beginning of the file
    qq  Start recording the "q" macro
    ]s  Find the next misspelled word
    1z= Correct its spelling
    @q  Call the "q" macro (we're still recording!)
    q   Finish recording
    @q  Call the macro for the first time

##### Edit binary files in VIM

Vim used on linux can easily do your work for editing binary files, though it is not perfect as you will not get ASCII preview of your changes.
For small changes and under condition that you know what you are doing it’s OK.
Sample usage of editing binary file with EBCDIC encoding (e.g. PNRs in binary format)
        • open your file (vim file.dat)
        • use command :%!xxd -E to see the content
        • use command :%!xdd -r to write changes in binary format
        • :wq and you are done

Preview changes with xdd -E file.dat to confirm your changes

##### Built in command-line diff tool

Vim in provided package binaries has got a great diff tool, that can be used for running diff with syntax highlighting from command line on all linux boxes

    vimdiff file.1 file.2

##### Personalized vim on any linux box

Assuming that you have your VM with polished vim with all your favorite settings, you are able to use it on any box, as vim supports remote editing

    vim scp://someuser@somehost/tmp/sample.txt

##### Use VIM in pipes

Vim can be also used as a part of pipline

    cat file.to.rm.tags.txt | vim -es '+%s/<.\{-}>//g' '+%print' '+:q!' /dev/stdin


