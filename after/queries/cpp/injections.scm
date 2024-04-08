;; query
; extends
; ((string_content) @lua (#match? @lua ".*-{2,}( )*[lL][uU][aA]( )*\n"))
; ((string_content) @lua (#match? @lua ".*--lua.*"))
; ((raw_string_literal) @lua (#match? @lua ".*-{2,}( )*[lL][uU][aA]( )*\n"))
; ((raw_string_literal) 
;    (#set! injection.language "glsl")
;    (#set! injection.include-children)
;    (#set! injection.combined)
;                       )
;
; ((string_content) @lua (#match? @lua ".*-{2,}( )*[lL][uU][aA]( )*\n"))
 ; ((string_content) @lua (#contains? @lua "lua"))
 ((raw_string_content) @lua (#match? @lua ".*--lua.*"))

; ((string) 
;    (#set! injection.language "glsl")
;    (#set! injection.include-children)
;    (#set! injection.combined)
;                       )

; ((string_content) @lua )
; ((raw_string_content) @injection.content
;   ; (#contains? @injection.content "lua")
;   ; (expression_list
;   ;    ((string_content) @injection.content))
;    (#set! injection.language "lua")
;    (#set! injection.include-children)
;    (#set! injection.combined)
;                       )
;
; ((raw_string_content) 
;    (#set! injection.language "lua")
;    (#set! injection.include-children)
;    (#set! injection.combined)
;                       )
