;; extends

; ============================================================================
; Zig declaration identifiers
;
; Tree-sitter's default priority is 100.
; Neovim LSP semantic tokens in this setup reach priority 127.
;
; 130 = ordinary declaration classification
; 135 = more-specific classification overriding const/variable
; ============================================================================


; ----------------------------------------------------------------------------
; Constants
; ----------------------------------------------------------------------------

; Any const declaration begins as a constant.
;
; More-specific classifications such as modules and types below deliberately
; use a higher priority and therefore override this capture.
(variable_declaration
  "const"
  (identifier) @constant
  (#set! @constant priority 130))


; Preserve conventional ALL_CAPS constants as constants everywhere they occur.
;
; Zig does not generally require constants to use ALL_CAPS, but this also
; fixes the stock Zig query's @type/@constant collision for names such as
; SILVER_RATIO_64.
((identifier) @constant
  (#match? @constant "^[A-Z][A-Z0-9_]+$")
  (#set! @constant priority 130))


; ----------------------------------------------------------------------------
; Variables
; ----------------------------------------------------------------------------

; Explicit mutable bindings.
(variable_declaration
  "var"
  (identifier) @variable
  (#set! @variable priority 130))


; ----------------------------------------------------------------------------
; Modules / imports
; ----------------------------------------------------------------------------

; const std = @import("std");
; const builtin = @import("builtin");
; const c = @cImport(...);
;
; These declarations also match the general const rule above, so @module
; deliberately receives a higher priority.
(variable_declaration
  "const"
  (identifier) @module
  (builtin_function
    (builtin_identifier) @_import
    (#any-of? @_import "@import" "@cImport"))
  (#set! @module priority 135))


; ----------------------------------------------------------------------------
; Explicitly-created types
; ----------------------------------------------------------------------------

; const Foo = struct {};
; const Foo = enum {};
; const Foo = union {};
; const Foo = opaque {};
;
; These are syntactically identifiable as types without relying on their name.
(variable_declaration
  "const"
  (identifier) @type
  "="
  [
    (struct_declaration)
    (enum_declaration)
    (union_declaration)
    (opaque_declaration)
  ]
  (#set! @type priority 135))


; ----------------------------------------------------------------------------
; TitleCase type identifiers
; ----------------------------------------------------------------------------

; Zig's naming convention uses TitleCase for types.
;
; This is intentionally narrower than the stock Zig query:
;
;     ^[A-Z_][a-zA-Z0-9_]*
;
; because that expression also treats names such as SILVER_RATIO_64 as types.
;
; Single-letter type names such as T.
((identifier) @type
  (#match? @type "^[A-Z]$")
  (#set! @type priority 135))

; Conventional TitleCase names:
;
; Vector3
; ArrayList
; Foo
; HashMap
;
; Requiring the second character to be lowercase prevents ALL_CAPS constants
; such as SILVER_RATIO_64 from being interpreted as types.
((identifier) @type
  (#match? @type "^[A-Z][a-z][A-Za-z0-9]*$")
  (#set! @type priority 135))


; ----------------------------------------------------------------------------
; Parameters
; ----------------------------------------------------------------------------

(parameter
  name: (identifier) @variable.parameter
  (#set! @variable.parameter priority 135))

(payload
  (identifier) @variable.parameter
  (#set! @variable.parameter priority 135))


; ----------------------------------------------------------------------------
; Fields / members
; ----------------------------------------------------------------------------

(field_initializer
  .
  (identifier) @variable.member
  (#set! @variable.member priority 135))

(field_expression
  (_)
  member: (identifier) @variable.member
  (#set! @variable.member priority 135))

(container_field
  name: (identifier) @variable.member
  (#set! @variable.member priority 135))

(initializer_list
  (assignment_expression
    left: (field_expression
      .
      member: (identifier) @variable.member
      (#set! @variable.member priority 135))))


; ----------------------------------------------------------------------------
; Functions
; ----------------------------------------------------------------------------

(function_declaration
  name: (identifier) @function
  (#set! @function priority 135))

(call_expression
  function: (identifier) @function.call
  (#set! @function.call priority 135))

(call_expression
  function: (field_expression
    member: (identifier) @function.call
    (#set! @function.call priority 135)))


; ----------------------------------------------------------------------------
; Builtins
; ----------------------------------------------------------------------------

(builtin_identifier) @function.builtin
(#set! @function.builtin priority 135)

((identifier) @variable.builtin
  (#eq? @variable.builtin "_")
  (#set! @variable.builtin priority 135))

(calling_convention
  (identifier) @variable.builtin
  (#set! @variable.builtin priority 135))
