;; query
; extends
;; STRING SQL INJECTION
; ((string_content) @glsl (#match? @glsl ".*-{2,}( )*[sS][qQ][lL]( )*\n"))
; ((string_content) @glsl (#match? @glsl ".*/{2,}( )*[gG][lL][sS][lL]( )*\n"))
; ((assignment_statement) @glsl (#match? @glsl "vertex =") (expression_list(string(string_content)@glsl]) @glsl)
; ((assignment_statement) @glsl (#match? @glsl "vertex =") (expression_list(string(string_content))@glsl) @glsl)
; ((assignment_statement) @glsl (#match? @glsl ".*vertex.*") (expression_list))
; ((assignment_statement) @glsl (#match? @glsl ".*vertex.*"))
; (((comment) @_comment (#match? @_comment "sql") (lexical_declaration(variable_declarator[(string(string_fragment)@glsl)(template_string)@glsl]))) @glsl)


; (assignment_statement
;   (expression_list) @injection.content
;   (#set! injection.language "glsl")
;   (#set! injection.include-children)
;   (#set! injection.combined)
;   )


(assignment_statement
  (variable_list) @var
  (#any-of? @var "vertex" "inout" "fragment")
  (expression_list
     (string content: (string_content) @injection.content))
   (#set! injection.language "glsl")
   (#set! injection.include-children)
   (#set! injection.combined)
)


; (fenced_code_block
;   (info_string
;     (language) @_lang)
;   (code_fence_content) @injection.content
;   (#set-lang-from-info-string! @_lang))
;
; ((html_block) @injection.content
;   (#set! injection.language "html")
;   (#set! injection.combined)
;   (#set! injection.include-children))
;
; ((minus_metadata) @injection.content
;   (#set! injection.language "yaml")
;   (#offset! @injection.content 1 0 -1 0)
;   (#set! injection.include-children))
;
; ((plus_metadata) @injection.content
;   (#set! injection.language "toml")
;   (#offset! @injection.content 1 0 -1 0)
;   (#set! injection.include-children))
;
; ([
;   (inline)
;   (pipe_table_cell)
; ] @injection.content
;   (#set! injection.language "markdown_inline"))
