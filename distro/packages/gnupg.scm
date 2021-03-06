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

(define-module (distro packages gnupg)
  #:use-module (distro packages pth)
  #:use-module (distro packages readline)
  #:use-module (distro packages compression)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu))

(define-public libgpg-error
  (package
    (name "libgpg-error")
    (version "1.10")
    (source
     (origin
      (method url-fetch)
      (uri (string-append "mirror://gnupg/libgpg-error/libgpg-error-"
                          version ".tar.bz2"))
      (sha256
       (base32
        "0cal3jdnzdailr13qcy74grfbplbghkgr3qwk6qjjp4bass2j1jj"))))
    (build-system gnu-build-system)
    (home-page "http://gnupg.org")
    (synopsis
     "Libgpg-error, a small library that defines common error values for all GnuPG components")
    (description
     "Libgpg-error is a small library that defines common error values
for all GnuPG components.  Among these are GPG, GPGSM, GPGME,
GPG-Agent, libgcrypt, Libksba, DirMngr, Pinentry, SmartCard
Daemon and possibly more in the future.")
    (license "LGPLv2+")))

(define-public libgcrypt
  (package
    (name "libgcrypt")
    (version "1.5.0")
    (source
     (origin
      (method url-fetch)
      (uri (string-append "mirror://gnupg/libgcrypt/libgcrypt-"
                          version ".tar.bz2"))
      (sha256
       (base32
        "1ykkh7dm0gyndz7bbpvn3agijj8xb2h02m02f42hm504c18zqqjb"))))
    (build-system gnu-build-system)
    (propagated-inputs
     `(("libgpg-error" ,libgpg-error)))
    (home-page "http://gnupg.org/")
    (synopsis
     "GNU Libgcrypt, a general-pupose cryptographic library")
    (description
     "GNU Libgcrypt is a general purpose cryptographic library based on
the code from GnuPG.  It provides functions for all
cryptographic building blocks: symmetric ciphers, hash
algorithms, MACs, public key algorithms, large integer
functions, random numbers and a lot of supporting functions.")
    (license "LGPLv2+")))

(define-public libassuan
  (package
    (name "libassuan")
    (version "2.0.3")
    (source
     (origin
      (method url-fetch)
      (uri (string-append "mirror://gnupg/libassuan/libassuan-"
                          version ".tar.bz2"))
      (sha256
       (base32
        "06xckkvxxlx7cj77803m8x58gxksap4k8yhspc5cqsy7fhinimds"))))
    (build-system gnu-build-system)
    (propagated-inputs
     `(("libgpg-error" ,libgpg-error) ("pth" ,pth)))
    (home-page "http://gnupg.org")
    (synopsis
     "Libassuan, the IPC library used by GnuPG and related software")
    (description
     "Libassuan is a small library implementing the so-called Assuan
protocol.  This protocol is used for IPC between most newer
GnuPG components.  Both, server and client side functions are
provided.")
    (license "LGPLv2+")))

(define-public libksba
  (package
    (name "libksba")
    (version "1.2.0")
    (source
     (origin
      (method url-fetch)
      (uri (string-append
            "mirror://gnupg/libksba/libksba-"
            version ".tar.bz2"))
      (sha256
       (base32
        "0jwk7hm3x3g4hd7l12z3d79dy7359x7lc88dq6z7q0ixn1jwxbq9"))))
    (build-system gnu-build-system)
    (propagated-inputs
     `(("libgpg-error" ,libgpg-error)))
    (home-page "http://www.gnupg.org")
    (synopsis
     "Libksba is a CMS and X.509 access library under development")
    (description
     "KSBA (pronounced Kasbah) is a library to make X.509 certificates
as well as the CMS easily accessible by other applications.  Both
specifications are building blocks of S/MIME and TLS.")
    (license "GPLv3+")))

(define-public gnupg
  (package
    (name "gnupg")
    (version "2.0.19")
    (source
     (origin
      (method url-fetch)
      (uri (string-append "mirror://gnupg/gnupg/gnupg-" version
                          ".tar.bz2"))
      (sha256
       (base32
        "08n636sfffs5qvg9ppiprvsh00q0dmdw425psg3m3nssja53m8pg"))))
    (build-system gnu-build-system)
    (inputs
     `(;; TODO: Add missing optional deps.
       ;; ("curl" ,curl)
       ;; ("libusb" ,libusb)
       ;; ("openldap" ,openldap)

       ("bzip2" ,bzip2)
       ("libassuan" ,libassuan)
       ("libgcrypt" ,libgcrypt)
       ("libksba" ,libksba)
       ("pth" ,pth)
       ("libgpg-error" ,libgpg-error)
       ("zlib" ,zlib)
       ("readline" ,readline)))
    (home-page "http://gnupg.org/")
    (synopsis
     "GNU Privacy Guard (GnuPG), GNU Project's implementation of the OpenPGP standard")
    (description
     "GnuPG is the GNU project's complete and free implementation of
the OpenPGP standard as defined by RFC4880.  GnuPG allows to
encrypt and sign your data and communication, features a
versatile key managment system as well as access modules for all
kind of public key directories.  GnuPG, also known as GPG, is a
command line tool with features for easy integration with other
applications.  A wealth of frontend applications and libraries
are available.  Version 2 of GnuPG also provides support for
S/MIME.")
    (license "GPLv3+")))
