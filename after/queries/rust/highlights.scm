;; inherits: rust
;; extends

((crate) @namespace.crate @nospell)

;; feature(box_patterns)
((identifier) @type.qualifier.box
 (#eq? @type.qualifier.box "box"))
((tuple_struct_pattern
   (identifier) @type.qualifier.box)
    (#eq? @type.qualifier.box "box"))

;; module(super)
 ((scoped_identifier
  (super) @path.qualifier.super))

;; pub
((visibility_modifier) @keyword.modifier.pub
 (#eq? @keyword.modifier.pub "pub")
 (#set! "priority" 100))
