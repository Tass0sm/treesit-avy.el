;;; treesit-avy.el --- avy for tree sitter nodes -*- lexical-binding: t -*-

;; Author: Tassos Manganaris
;; Maintainer: Tassos Manganaris
;; Version: 0.0.1
;; Package-Requires: (avy)
;; Homepage: homepage
;; Keywords: tree-sitter avy


;; This file is not part of GNU Emacs

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.


;;; Commentary:

;; Avy for tree sitter nodes

;;; Code:

(require 'avy)
(require 'treesit)

(defun treesit-avy--buffer-node-list ()
  "docstring"
  (let (nodes)
    (treesit-traverse-depth-first (treesit-buffer-root-node)
                                  (lambda (n)
                                    (push (cons
                                           (cons (treesit-node-start n)
                                                 (treesit-node-end n))
                                           (selected-window))
                                          nodes)
                                    nil))
    nodes))

(defun treesit-avy--candidates (&optional beg end pred group)
  (let (candidates)
    (avy-dowindows current-prefix-arg
      (dolist (pair (avy--find-visible-regions
                     (or beg (window-start))
                     (or end (window-end (selected-window) t))))
        (dolist (c (treesit-avy--buffer-node-list))
          (push c candidates))))
    candidates))

(defun treesit-avy-node ()
  "docstring"
  (interactive)
  (avy-process
     (treesit-avy--treesit-candidates)))

(provide 'treesit-avy)

;;; treesit-avy.el ends here
