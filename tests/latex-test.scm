
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : test-tmtex.scm
;; DESCRIPTION : Test suite for tmtex.scm
;; COPYRIGHT   : (C) 2013  François Poulain, Joris van der Hoeven,
;;               (C) 2002  David Allouche
;;
;; This software falls under the GNU general public license version 3 or later.
;; It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
;; in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(import (liii check)
        (liii base))

(texmacs-module (convert latex tmtex-test)
  (:use (convert latex init-latex)
        (convert latex tmtex)))

(define (mgs->slatex x) (texmacs->latex x '()))
(define slatex->latex serialize-latex)
(define latex->mgs (compose tree->stree latex->texmacs parse-latex))

(define-macro (check-latex mgs slatex latex)
  `(begin
     (check (mgs->slatex ,mgs) => ,slatex)
     (check (slatex->latex ,slatex) => ,latex)
     (check (latex->mgs ,latex) => ,mgs)))

(define (test-section)
  (check-latex '(chapter* "aaa") '(chapter* "aaa") "\\chapter*{aaa}")
)

(define (test-font)
  (check-latex
    '(with "font-shape" "italic" "hello")
    '(textit "hello")
    "\\textit{hello}"))

(define (latex-test)
  (test-section)
  (test-font)
  (check-report))
