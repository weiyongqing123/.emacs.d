;;; prosjekt-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (prosjekt-find-project-file) "find-project-file-prosjekt"
;;;;;;  "find-project-file-prosjekt.el" (21334 35402 418277 820000))
;;; Generated autoloads from find-project-file-prosjekt.el

(autoload 'prosjekt-find-project-file "find-project-file-prosjekt" "\
Find a file in the current project.

\(fn)" t nil)

;;;***

;;;### (autoloads (prosjekt-setup-save-and-close prosjekt-run-tool-by-name
;;;;;;  prosjekt-repopulate prosjekt-setup prosjekt-close prosjekt-save
;;;;;;  prosjekt-clone prosjekt-open prosjekt-open-recent prosjekt-delete
;;;;;;  prosjekt-new) "prosjekt" "prosjekt.el" (21334 35402 350277
;;;;;;  820000))
;;; Generated autoloads from prosjekt.el

(autoload 'prosjekt-new "prosjekt" "\
Create a new project.

\(fn DIRECTORY NAME)" t nil)

(autoload 'prosjekt-delete "prosjekt" "\
Delete an existing project.

\(fn FILENAME)" t nil)

(autoload 'prosjekt-open-recent "prosjekt" "\
Open a project named PROJ in the recent-list.

\(fn FILENAME)" t nil)

(autoload 'prosjekt-open "prosjekt" "\
Open the project defined in FILENAME.

\(fn FILENAME)" t nil)

(autoload 'prosjekt-clone "prosjekt" "\
Clone a new project from an existing project.

\(fn DIRECTORY NAME CLONE_FROM)" t nil)

(autoload 'prosjekt-save "prosjekt" "\
Save the current project.

\(fn)" t nil)

(autoload 'prosjekt-close "prosjekt" "\
Close the current project.

\(fn)" t nil)

(autoload 'prosjekt-setup "prosjekt" "\
Edit the project configuration in a new buffer.

\(fn)" t nil)

(autoload 'prosjekt-repopulate "prosjekt" "\
Repopulate the project.

\(fn)" t nil)

(autoload 'prosjekt-run-tool-by-name "prosjekt" "\


\(fn NAME)" t nil)

(autoload 'prosjekt-setup-save-and-close "prosjekt" "\
Save the prosjekt-buffer contents and the new project definition,
and kill that buffer.

\(fn)" t nil)

;;;***

;;;### (autoloads nil nil ("async-shell-command-prosjekt.el" "prosjekt-pkg.el")
;;;;;;  (21334 35402 465111 597000))

;;;***

(provide 'prosjekt-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; prosjekt-autoloads.el ends here
