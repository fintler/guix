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

(define-module (guix build-system)
  #:use-module (guix utils)
  #:export (build-system
            build-system?
            build-system-name
            build-system-description
            build-system-builder
            build-system-cross-builder))

(define-record-type* <build-system> build-system make-build-system
  build-system?
  (name        build-system-name)         ; symbol
  (description build-system-description)  ; short description
  (build       build-system-builder)      ; (store system name source inputs)
  (cross-build build-system-cross-builder ; (store system x-system ...)
               (default #f)))
