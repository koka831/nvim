;; extends

((crate) @namespace.crate @nospell)

;; feature(box_patterns)
((identifier) @type.qualifier.box
 (#eq? @type.qualifier.box "box"))
((tuple_struct_pattern
   (identifier) @type.qualifier.box)
    (#eq? @type.qualifier.box "box"))

;; module(super)
; ((use_declaration)
 ((scoped_identifier
  (super) @path.qualifier.super))
