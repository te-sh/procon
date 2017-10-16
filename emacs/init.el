;; d-mode
(add-hook 'd-mode-hook
	  (lambda ()
	    (disable-indent-tabs-mode)
	    (setup-flycheck-d-unittest)
	    (flycheck-dmd-dub-set-variables)))

;; Copy buffer to submit
(defun d-copy-for-submit ()
  (interactive)
  (let ((old-buf (current-buffer)))
    (with-temp-buffer
      (insert-buffer-substring old-buf)
      (goto-char (point-min))
      (while (re-search-forward "^\\(version(unittest)\\|// \\(path\\|url\\):\\)" nil t)
	(let ((start (line-beginning-position)))
	  (forward-line)
	  (if (= (point) (line-end-position))
	      (forward-line))
	  (delete-region start (point))
	  (goto-char (point-min))))
      (while (re-search-forward "^\s*unittest" nil t)
	(backward-word)
	(let* ((indent (current-column))
	       (start (line-beginning-position)))
	  (if (re-search-forward (format "^\s\\{%s\\}}" indent) nil t)
	      (progn
		(forward-line)
		(if (= (point) (line-end-position))
		    (forward-line))
		(delete-region start (point))))))
      (clipboard-kill-ring-save (point-min) (point-max)))))

;; yasnippet
(require 'yasnippet)
(setq yas-snippet-dirs (append yas-snippet-dirs
			       '("~/projects/procon/emacs/snippets")))
(yas-global-mode 1)
