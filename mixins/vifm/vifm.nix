{ config, lib, pkgs, ... }:

{
  config = {
    environment.systemPackages = with pkgs; [
      tree # for directory previews
      mediainfo # for the mediainfo program (audio and video information)
      ( poppler.override { utils = true; } )
    ];
    home-manager.users.kazimazi = { pkgs, ... }: {
      home.file = {
        ".config/vifm/vifmrc".source = (pkgs.writeText "vifm" ''
          " vim: filetype=vifm :
          " Sample configuration file for vifm (last updated: 9 September, 2020)
          " You can edit this file by hand.
          " The " character at the beginning of a line comments out the line.
          " Blank lines are ignored.
          " The basic format for each item is shown with an example.

          " ------------------------------------------------------------------------------

          " Command used to edit files in various contexts.  The default is vim.
          " If you would like to use another vi clone such as Elvis or Vile
          " you will need to change this setting.

          set vicmd=vim
          " set vicmd=elvis\ -G\ termcap
          " set vicmd=vile

          " This makes vifm perform file operations on its own instead of relying on
          " standard utilities like `cp`.  While using `cp` and alike is a more universal
          " solution, it's also much slower when processing large amounts of files and
          " doesn't support progress measuring.

          set syscalls

          " Trash Directory
          " The default is to move files that are deleted with dd or :d to
          " the trash directory.  If you change this you will not be able to move
          " files by deleting them and then using p to put the file in the new location.
          " I recommend not changing this until you are familiar with vifm.
          " This probably shouldn't be an option.

          set trash

          " This is how many directories to store in the directory history.

          set history=100

          " Automatically resolve symbolic links on l or Enter.

          set nofollowlinks

          " With this option turned on you can run partially entered commands with
          " unambiguous beginning using :! (e.g. :!Te instead of :!Terminal or :!Te<tab>).

          " set fastrun

          " Natural sort of (version) numbers within text.

          set sortnumbers

          " Maximum number of changes that can be undone.

          set undolevels=100

          " Use Vim's format of help file (has highlighting and "hyperlinks").
          " If you would rather use a plain text help file set novimhelp.

          set vimhelp

          " If you would like to run an executable file when you
          " press Enter, l or Right Arrow, set this.

          set norunexec

          " List of color schemes to try (picks the first one supported by the terminal)

          colorscheme Default-256 Default

          " Format for displaying time in file list. For example:
          " TIME_STAMP_FORMAT=%m/%d-%H:%M
          " See man date or man strftime for details.

          set timefmt=%m/%d\ %H:%M

          " Show list of matches on tab completion in command-line mode

          set wildmenu

          " Display completions in a form of popup with descriptions of the matches

          set wildstyle=popup

          " Display suggestions in normal, visual and view modes for keys, marks and
          " registers (at most 5 files).  In other view, when available.

          set suggestoptions=normal,visual,view,otherpane,keys,marks,registers

          " Ignore case in search patterns unless it contains at least one uppercase
          " letter

          set ignorecase
          set smartcase

          " Don't highlight search results automatically

          set nohlsearch

          " Use increment searching (search while typing)
          set incsearch

          " Try to leave some space from cursor to upper/lower border in lists

          set scrolloff=4

          " Don't do too many requests to slow file systems

          if !has('win')
              set slowfs=curlftpfs
          endif

          " Set custom status line look

          set statusline="  Hint: %z%= %A %10u:%-7g %15s %20d  "

          " ------------------------------------------------------------------------------

          " :mark mark /full/directory/path [filename]

          mark b ~/bin/
          mark h ~/

          " ------------------------------------------------------------------------------

          " :com[mand][!] command_name action
          " The following macros can be used in a command
          " %a is replaced with the user arguments.
          " %c the current file under the cursor.
          " %C the current file under the cursor in the other directory.
          " %f the current selected file, or files.
          " %F the current selected file, or files in the other directory.
          " %b same as %f %F.
          " %d the current directory name.
          " %D the other window directory name.
          " %m run the command in a menu window

          command! df df -h %m 2> /dev/null
          command! diff vim -d %f %F
          command! zip zip -r %f.zip %f
          command! run !! ./%f
          command! make !!make %a
          command! mkcd :mkdir %a | cd %a
          command! vgrep vim "+grep %a"
          command! reload :write | restart full

          " ------------------------------------------------------------------------------

          " The file type is for the default programs to be used with
          " a file extension.
          " :filetype pattern1,pattern2 defaultprogram,program2
          " :fileviewer pattern1,pattern2 consoleviewer
          " The other programs for the file type can be accessed with the :file command
          " The command macros like %f, %F, %d, %D may be used in the commands.
          " The %a macro is ignored.  To use a % you must put %%.

          " For automated FUSE mounts, you must register an extension with :file[x]type
          " in one of following formats:
          "
          " :filetype extensions FUSE_MOUNT|some_mount_command using %SOURCE_FILE and %DESTINATION_DIR variables
          " %SOURCE_FILE and %DESTINATION_DIR are filled in by vifm at runtime.
          " A sample line might look like this:
          " :filetype *.zip,*.jar,*.war,*.ear FUSE_MOUNT|fuse-zip %SOURCE_FILE %DESTINATION_DIR
          "
          " :filetype extensions FUSE_MOUNT2|some_mount_command using %PARAM and %DESTINATION_DIR variables
          " %PARAM and %DESTINATION_DIR are filled in by vifm at runtime.
          " A sample line might look like this:
          " :filetype *.ssh FUSE_MOUNT2|sshfs %PARAM %DESTINATION_DIR
          " %PARAM value is filled from the first line of file (whole line).
          " Example first line for SshMount filetype: root@127.0.0.1:/
          "
          " You can also add %CLEAR if you want to clear screen before running FUSE
          " program.

          " Pdf
          fileviewer {*.pdf},<application/pdf> pdftotext -nopgbrk %c -

          " FuseZipMount
          fileviewer *.zip,*.jar,*.war,*.ear,*.oxt zip -sf %c

          " ArchiveMount
          fileviewer *.tgz,*.tar.gz tar -tzf %c
          fileviewer *.tar.bz2,*.tbz2 tar -tjf %c
          fileviewer *.tar.txz,*.txz xz --list %c
          fileviewer {*.tar},<application/x-tar> tar -tf %c

          " Rar2FsMount and rar archives
          fileviewer {*.rar},<application/x-rar> unrar v %c

          " Open all other files with default system programs (you can also remove all
          " :file[x]type commands above to ensure they don't interfere with system-wide
          " settings).  By default all unknown files are opened with 'vi[x]cmd'
          " uncommenting one of lines below will result in ignoring 'vi[x]cmd' option
          " for unknown file types.
          " For *nix:
          filetype * xdg-open %f %i &
          " For OS X:
          " filetype * open
          " For Windows:
          " filetype * start, explorer

          " ------------------------------------------------------------------------------

          " What should be saved automatically between vifm sessions.  Drop "savedirs"
          " value if you don't want vifm to remember last visited directories for you.
          set vifminfo=dhistory,savedirs,chistory,state,tui,shistory,
              \phistory,fhistory,dirstack,registers,bookmarks,bmarks

          " ------------------------------------------------------------------------------

          " Sample mappings

          " Start shell in current directory
          nnoremap s :shell<cr>

          " Display sorting dialog
          nnoremap S :sort<cr>

          " Toggle visibility of preview window
          nnoremap w :view<cr>
          vnoremap w :view<cr>gv

          " Mappings for faster renaming
          nnoremap I cw<c-a>
          nnoremap cc cw<c-u>
          nnoremap A cw

          " Midnight commander alike mappings
          " Open current directory in the other pane
          nnoremap <a-i> :sync<cr>
          " Open directory under cursor in the other pane
          nnoremap <a-o> :sync %c<cr>
          " Swap panes
          nnoremap <c-u> <c-w>x

          " ------------------------------------------------------------------------------

          " Various customization examples

          " Use ag (the silver searcher) instead of grep
          "
          " set grepprg='ag --line-numbers %i %a %s'

          " Add additional place to look for executables
          "
          " let $PATH = $HOME.'/bin/fuse:'.$PATH

          " Block particular shortcut
          "
          " nnoremap <left> <nop>

          " Export IPC name of current instance as environment variable and use it to
          " communicate with the instance later.
          "
          " It can be used in some shell script that gets run from inside vifm, for
          " example, like this:
          "     vifm --server-name "$VIFM_SERVER_NAME" --remote +"cd '$PWD'"
          "
          " let $VIFM_SERVER_NAME = v:servername
        '');
        ".config/vifm/colors/Default.vifm".source = (pkgs.writeText "vifm" ''
          " You can edit this file by hand.
          " The " character at the beginning of a line comments out the line.
          " Blank lines are ignored.

          " The Default color scheme is used for any directory that does not have
          " a specified scheme and for parts of user interface like menus. A
          " color scheme set for a base directory will also
          " be used for the sub directories.

          " The standard ncurses colors are:
          " Default = -1 = None, can be used for transparency or default color
          " Black = 0
          " Red = 1
          " Green = 2
          " Yellow = 3
          " Blue = 4
          " Magenta = 5
          " Cyan = 6
          " White = 7

          " Light versions of colors are also available (set bold attribute):
          " LightBlack
          " LightRed
          " LightGreen
          " LightYellow
          " LightBlue
          " LightMagenta
          " LightCyan
          " LightWhite

          " Available attributes (some of them can be combined):
          " bold
          " underline
          " reverse or inverse
          " standout
          " italic (on unsupported systems becomes reverse)
          " none

          " Vifm supports 256 colors you can use color numbers 0-255
          " (requires properly set up terminal: set your TERM environment variable
          " (directly or using resources) to some color terminal name (e.g.
          " xterm-256color) from /usr/lib/terminfo/; you can check current number
          " of colors in your terminal with tput colors command)

          " highlight group cterm=attrs ctermfg=foreground_color ctermbg=background_color

          highlight clear

          highlight Win cterm=none ctermfg=white ctermbg=black
          highlight Directory cterm=bold ctermfg=cyan ctermbg=default
          highlight Link cterm=bold ctermfg=yellow ctermbg=default
          highlight BrokenLink cterm=bold ctermfg=red ctermbg=default
          highlight HardLink cterm=none ctermfg=yellow ctermbg=default
          highlight Socket cterm=bold ctermfg=magenta ctermbg=default
          highlight Device cterm=bold ctermfg=red ctermbg=default
          highlight Fifo cterm=bold ctermfg=cyan ctermbg=default
          highlight Executable cterm=bold ctermfg=green ctermbg=default
          highlight Selected cterm=bold ctermfg=magenta ctermbg=default
          highlight CurrLine cterm=bold,reverse ctermfg=default ctermbg=default
          highlight TopLine cterm=none ctermfg=black ctermbg=white
          highlight TopLineSel cterm=bold ctermfg=black ctermbg=default
          highlight StatusLine cterm=bold ctermfg=black ctermbg=white
          highlight WildMenu cterm=underline,reverse ctermfg=white ctermbg=black
          highlight CmdLine cterm=none ctermfg=white ctermbg=black
          highlight ErrorMsg cterm=none ctermfg=red ctermbg=black
          highlight Border cterm=none ctermfg=black ctermbg=white
          highlight OtherLine ctermfg=default ctermbg=default
          highlight JobLine cterm=bold,reverse ctermfg=black ctermbg=white
          highlight SuggestBox cterm=bold ctermfg=default ctermbg=default
          highlight CmpMismatch cterm=bold ctermfg=white ctermbg=red
          highlight AuxWin ctermfg=default ctermbg=default
          highlight TabLine cterm=none ctermfg=white ctermbg=black
          highlight TabLineSel cterm=bold,reverse ctermfg=default ctermbg=default
          highlight User1 ctermfg=default ctermbg=default
          highlight User2 ctermfg=default ctermbg=default
          highlight User3 ctermfg=default ctermbg=default
          highlight User4 ctermfg=default ctermbg=default
          highlight User5 ctermfg=default ctermbg=default
          highlight User6 ctermfg=default ctermbg=default
          highlight User7 ctermfg=default ctermbg=default
          highlight User8 ctermfg=default ctermbg=default
          highlight User9 ctermfg=default ctermbg=default
          highlight OtherWin ctermfg=default ctermbg=default
          highlight LineNr ctermfg=default ctermbg=default
          highlight OddLine ctermfg=default ctermbg=default
        '');
      };
      # NOTE https://github.com/NixOS/nixpkgs/pull/75004
      home.packages = with pkgs; [ vifm-full ];
    };
  };
}
