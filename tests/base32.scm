;;; Guix --- Nix package management from Guile.         -*- coding: utf-8 -*-
;;; Copyright (C) 2012 Ludovic Courtès <ludo@gnu.org>
;;;
;;; This file is part of Guix.
;;;
;;; Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (test-base32)
  #:use-module (guix base32)
  #:use-module (guix utils)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-64)
  #:use-module (ice-9 rdelim)
  #:use-module (ice-9 popen)
  #:use-module (rnrs bytevectors)
  #:use-module (rnrs io ports))

;; Test the (guix base32) module.

(define %nix-hash
  (or (getenv "NIX_HASH")
      "nix-hash"))

(test-begin "base32")

(test-assert "bytevector->base32-string"
  (fold (lambda (bv expected result)
          (and result
               (string=? (bytevector->base32-string bv)
                         expected)))
        #t

        ;; Examples from RFC 4648.
        (map string->utf8 '("" "f" "fo" "foo" "foob" "fooba" "foobar"))
        '(""
          "my"
          "mzxq"
          "mzxw6"
          "mzxw6yq"
          "mzxw6ytb"
          "mzxw6ytboi")))

(test-assert "base32-string->bytevector"
  (every (lambda (bv)
           (equal? (base32-string->bytevector
                    (bytevector->base32-string bv))
                   bv))
         ;; Examples from RFC 4648.
         (map string->utf8 '("" "f" "fo" "foo" "foob" "fooba" "foobar"))))

(test-assert "nix-base32-string->bytevector"
  (every (lambda (bv)
           (equal? (nix-base32-string->bytevector
                    (bytevector->nix-base32-string bv))
                   bv))
         ;; Examples from RFC 4648.
         (map string->utf8 '("" "f" "fo" "foo" "foob" "fooba" "foobar"))))

;; The following tests requires `nix-hash' in $PATH.
(test-skip (if (false-if-exception (system* %nix-hash "--version"))
               0
               1))

(test-assert "sha256 & bytevector->nix-base32-string"
  (let ((file (search-path %load-path "tests/test.drv")))
    (equal? (bytevector->nix-base32-string
             (sha256 (call-with-input-file file get-bytevector-all)))
            (let* ((c (format #f "~a --type sha256 --base32 --flat \"~a\""
                              %nix-hash file))
                   (p (open-input-pipe c))
                   (l (read-line p)))
              (close-pipe p)
              l))))

(test-end)


(exit (= (test-runner-fail-count (test-runner-current)) 0))

;;; Local Variables:
;;; eval: (put 'test-assert 'scheme-indent-function 1)
;;; End:
