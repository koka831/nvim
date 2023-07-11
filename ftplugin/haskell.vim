" Language:     Haskell
" Filenames:    *.hs
"
" https://github.com/neovim/neovim/blob/b26411bacdebf2e483ce6bd670cfb573555156ec/runtime/syntax/haskell.vim#L47
syn keyword haskellAtmark @
match haskellAtmark \@\
hi def link haskellAtmark Blue

" let type and data belonging in haskellKeyword group
" since they are rather reserved word.
syn keyword haskellAdditionalKeyword otherwise type data id
match haskellAdditionalKeyword "\<\(otherwise\|type\|data\|id\)\>"
hi def link haskellAdditionalKeyword Red
