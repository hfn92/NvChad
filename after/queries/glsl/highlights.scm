; extends

((identifier) @variable
  (#set! "priority" 100))

((identifier) @variable.builtin
  (#lua-match? @variable.builtin "^gl_")
  (#set! "priority" 101))

; ((identifier) @keyword
;   (#lua-match? @keyword "^frag")
;   (#set! "priority" 101))
;
; ((identifier) @keyword
;   (#lua-match? @keyword "^tex_")
;   (#set! "priority" 101))
;
; ((identifier) @keyword
;   (#lua-match? @keyword "^sin")
;   (#set! "priority" 101))

; [
;  "sout"
;  ] @keyword


((type_identifier) @type.glsl
  (#set! "priority" 100))

((type_identifier) @type.glsl
  (#set! "priority" 100))


; Brackets
([
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket.glsl
  (#set! "priority" 100))


(
[
  "if"
  "else"
  "case"
  "switch"
] @keyword.conditional.glsl
  (#set! "priority" 100))
