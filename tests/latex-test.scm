
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

(define (test-font-series)
  (check-latex
    '(with "font-series" "medium" "aa")
    '(textmd "aa")
    "\\textmd{aa}")
  (check-latex
    '(with "font-series" "bold" "aa")
    '(textbf "aa")
    "\\textbf{aa}")
)

(define (test-font-family)
  (check-latex
    '(with "font-family" "rm" "aa")
    '(textrm "aa")
    "\\textrm{aa}")
  (check-latex
    '(with "font-family" "ss" "aa")
    '(textsf "aa")
    "\\textsf{aa}")
  (check-latex
    '(with "font-family" "tt" "aa")
    '(texttt "aa")
    "\\texttt{aa}")
)

(define (test-font-shape)
  (check-latex
    '(with "font-shape" "right" "hello")
    '(textup "hello")
    "\\textup{hello}")
  (check-latex
    '(with "font-shape" "slanted" "hello")
    '(textsl "hello")
    "\\textsl{hello}")
  (check-latex
    '(with "font-shape" "italic" "hello")
    '(textit "hello")
    "\\textit{hello}")
  (check-latex
    '(with "font-shape" "small-caps" "hello")
    '(textsc "hello")
    "\\textsc{hello}")
)

(define (test-font)
  (test-font-shape)
  (test-font-family)
  (test-font-series))

(define (latex-test)
  (test-section)
  (test-font)
  (check-report))
