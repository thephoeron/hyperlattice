(in-package :cl-user)

(defpackage hyperlattices/hyperlattice
  (:nicknames hyperlattice)
  (:use c2cl
        hyperlattices/hash-table-utils
        hyperlattices/generic-interface
        hyperlattices/lattice)
  (:export #:hyperlattice-sup
           #:hyperlattice-inf
           #:hyperlattice-add
           #:hyperlattice-remove
           #:hyperlattice-member-p
           #:hyperlattice-sup-set
           #:hyperlattice-inf-set
           #:hyperlattice-closure
           #:hyperlattice
           #:elements-of
           #:sup-of
           #:inf-of)
  (:documentation "Implementation of HYPERLATTICE algebraic datatype's type class and method specializations."))

(in-package :hyperlattices/hyperlattice)

;; Define a function to compute the supremum of two lattices
(defun hyperlattice-sup (a b)
  (make-instance 'hyperlattice :elements (merge-hash-tables (elements-of a) (elements-of b))
                                :sup (sup-of a)
                                :inf (inf-of a)))

;; Define a function to compute the infimum of two lattices
(defun hyperlattice-inf (a b)
  (make-instance 'hyperlattice :elements (intersection-hash-tables (elements-of a) (elements-of b))
                                :sup (sup-of a)
                                :inf (inf-of a)))

;; Define a class to represent a hyperlattice
(defclass hyperlattice (lattice)
  ((elements :initarg :elements :accessor elements-of)
   (sup :initarg :sup :accessor sup-of)
   (inf :initarg :inf :accessor inf-of))
  (:default-initargs :elements (make-hash-table)
                     :sup #'hyperlattice-sup
                     :inf #'hyperlattice-inf))

;; Define a function to add a lattice to the hyperlattice
(defun hyperlattice-add (hyperlattice lattice)
  (setf (gethash lattice (elements-of hyperlattice)) t))

;; Define a function to remove a lattice from the hyperlattice
(defun hyperlattice-remove (hyperlattice lattice)
  (remhash lattice (elements-of hyperlattice)))

;; Define a function to check if a lattice is in the hyperlattice
(defun hyperlattice-member-p (hyperlattice lattice)
  (gethash lattice (elements-of hyperlattice)))

;; Define a function to compute the supremum of a set of lattices
(defun hyperlattice-sup-set (hyperlattice set)
  (reduce (sup-of hyperlattice) set))

;; Define a function to compute the infimum of a set of lattices
(defun hyperlattice-inf-set (hyperlattice set)
  (reduce (inf-of hyperlattice) set))

;; Define a function to compute the closure of a set of lattices
(defun hyperlattice-closure (hyperlattice set)
  (let ((closure set))
    (loop
      for element being the hash-keys of (elements-of hyperlattice)
      unless (member element closure)
      when (every (lambda (x) (hyperlattice-member-p hyperlattice x)) (cons element closure))
      do (push element closure))
    closure))