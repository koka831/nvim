;; extends
;; @see https://neovim.io/doc/user/treesitter.html#treesitter-query-modeline

; highlight `SAFETY` keyword in comment (for Rust)
((tag
  (name) @text.safety @nospell
  ( "(" (user) ")" )? ":" )
  (#eq? @text.safety "SAFETY"))
