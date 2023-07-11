;; extends

((crate) @namespace.crate @nospell)

;; feature(box_patterns)
((tuple_struct_pattern
   (identifier) @type.qualifier.box)
    (#eq? @type.qualifier.box "box"))
