(setq package-enable-at-startup nil)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
                                    'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(scroll-bar-mode -1)        ; Desabilitar el scroll bar
(tool-bar-mode -1)          ; Desabilitar la barra de herramientas
(tooltip-mode -1)           ; Desabilitar tool tips
(set-fringe-mode 10)        ; Dar algo de espacio entre ventanas
(menu-bar-mode -1)          ; Desabilitar barra de menú
(global-visual-line-mode)   ; Word wrapping por defecto en todos los modos
(global-auto-revert-mode t) ; Activar global auto-revert

(set-face-attribute 'fixed-pitch nil :font "Inconsolata Nerd Font 11")
(set-frame-font "Inconsolata Nerd Font 11" nil t)

(use-package evil
  :custom
  ;; Inicia en modo NORMAL por defecto en todos los modos
  (evil-default-state 'normal)
  ;; Para evitar conflictos con TAB en org-mode
  (evil-want-C-i-jump nil)
  ;; Evitar conflictos con evil-collecction
  (evil-want-keybinding nil)
  :config
  ;; Arracnar evil-mode por defecto
  (evil-mode))

(use-package general
  :after evil
  :config
  ;; defniciión de tecla lider global para modo normal.
  (general-create-definer j/lider
    :states '(normal insert emacs)
    :keymaps 'override
    :prefix "SPC"
    :non-normal-prefix "M-SPC")

  ;; definición de tecla lider local (relativo al major mode) para modo normal.
  (general-create-definer j/lider-local
    :states '(normal insert emacs)
    :prefix "SPC m"
    :non-normal-prefix "M-SPC m"))

(use-package evil-collection
  :config
  (evil-collection-init))

(use-package ivy
  :diminish ivy-mode
  :bind (:map ivy-minibuffer-map
       ("C-j" . ivy-next-line)
       ("C-k" . ivy-previous-line))
  :config
  (ivy-mode 1))

(use-package counsel
  :after ivy
  :config
  (global-set-key (kbd "M-x") 'counsel-M-x))

(use-package ivy-rich
  :after (ivy counsel)
  :init
  (ivy-rich-mode 1))

(use-package all-the-icons-ivy-rich
  :after ivy-rich
  :init (all-the-icons-ivy-rich-mode 1))

(use-package prescient
  :after ivy
  :config
  (use-package ivy-prescient
    :after counsel
    :config
    (ivy-prescient-mode)
    (prescient-persist-mode)))

(use-package all-the-icons)

(use-package doom-modeline
  :after 
  all-the-icons
  :init 
  ;; Activar doom-modeline en todos los modos
  (doom-modeline-mode 1))

(use-package which-key
  :config
  (which-key-mode))

(use-package modus-themes
  :config
  ;; Cargar los temas
  (modus-themes-load-themes)
  ;; Cargar modus-vivendi
  (modus-themes-load-vivendi))

(use-package helpful
  :after
  counsel
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable))

(use-package rainbow-delimiters
  :hook (org-mode . rainbow-delimiters-mode))

(j/lider
 "SPC" '(evil-normal-state :which-key "volver a modo normal"))

(j/lider
  :infix "a"
  "" '(:ignore t :which-key "archivo")
  "a" '(counsel-find-file :which-key "abrir archivo")
  "A" '(counsel-recentf :which-key "abrir reciente")
  "g" '(save-buffer :which-key "guardar")
  "e" '(j/delete-file-and-buffer :which-key "cerrar y eliminar")
  "G" '(write-file :which-key "guardar como"))

(defun j/delete-file-and-buffer ()
  "Eliminar el archivo actual del disco duro y cierra su buffer"
  (interactive)
  (let ((filename (buffer-file-name)))
    (if filename
        (if (y-or-n-p (concat "De verdad quiere eliminar " filename " ?"))
            (progn
              (delete-file filename)
              (message "%s eliminado." filename)
              (kill-buffer)))
      (message "Este buffer no representaba un archivo"))))

(j/lider
  :infix "v"
  "" '(:ignore t :which-key "window")
  "e" '(evil-window-delete :which-key "cerrar ventaan")
  "d" '(evil-window-split :which-key "dividir horizontalmente")
  "<" '(evil-window-decrease-width :which-key "reducir ancho")
  ">" '(evil-window-increase-width :which-key "aumentar ancho")
  "j" '(evil-window-down :which-key "ir abajo")
  "q" '(evil-quit-all :which-key "salir de emacs")
  "k" '(evil-window-up :which-key "ir arriba")
  "h" '(evil-window-left :which-key "ir a izquierda")
  "l" '(evil-window-right :which-key "ir a derecha")
  "o" '(delete-other-windows :which-key "cerrar otras ventanas")
  "TAB" '(evil-window-next :which-key "siguiente ventana")
  "v" '(evil-window-vsplit :which-key "dividir verticalmente"))

(j/lider
  :infix "b"
  "" '(:ignore t :which-key "buffer")
  "e" '(kill-this-buffer :which-key "cerrar buffer")
  "k" '(previous-buffer :which-key "buffer previo")
  "-" '(text-scale-adjust :which-key "reducir fuente")
  "+" '(text-scale-adjust :which-key "aumentar fuente")
  "r" '(revert-buffer :which-key "revert-buffer")
  "v" '(visual-line-mode :which-key "visual-line-mode")
  "b" '(counsel-switch-buffer :which-key "buscar buffer")
  "u" '(evil-switch-to-windows-last-buffer :which-key "último buffer")
  "j" '(next-buffer :which-key "siguiente buffer"))

(j/lider
 :infix "h"
 "" '(:ignore t :which-key "ayuda")
 "m" '(describe-mode :which-key "describir modo")
 "f" '(counsel-describe-function :which-key "describir función")
 "v" '(counsel-describe-variable :which-key "describir variable")
 "K" '(describe-key-briefly :which-key "describe-key-briefly")
 "w" '(where-is :which-key "where-is")
 "F" '(counsel-describe-face :which-key "describir face")
 "t" '(helpful-key :which-key "describir tecla"))

(j/lider
  :infix "o"
  "" '(:ignore t :which-key "ir a")
  "a" '(org-agenda :which-key "agenda")
  "g" '(j/gtd :which-key "archivo gtd")
  "d" '(dired :which-key "dired")
  "s" '(eshell :which-key "eshell")
  "t" '(org-todo-list :which-key "lista completa TO-DO"))

(defun j/gtd ()
  "Abre archivo ~/personal/orgmode/gtd.org"
  (interactive)
  (find-file "~/personal/orgmode/gtd.org"))

(general-define-key
 :states '(normal)
 "j" '(evil-next-visual-line :which-key "siguiente linea visual")
 "k" '(evil-previous-visual-line :which-key "linea visual previa"))

(general-define-key
 :states '(normal)
 :infix "g"
 "h" '(evil-beginning-of-line :which-key "evil-beginning-of-line")
 "G" '(end-of-buffer :which-key "end-of-buffer")
 "j" '(evil-next-line :which-key "evil-next-linex")
 "k" '(evil-previous-line :which-key "evil-previous-line")
 "l" '(evil-end-of-line :which-key "evil-end-of-line"))

(use-package ispell
  :custom 
  (ispell-dictionary "es" "Diccionario en español por defecto")
  :hook
  (text-mode . flyspell-mode))

(use-package org
  :hook
  ((org-mode . (lambda () (electric-indent-local-mode -1))))
  :custom
  (org-startup-folded t)          ; Colapsar contenido al abrir un archivo
  (org-startup-align-all-table t) ; Empezar con las tablas colapsadas
  (org-startup-indented t)        ; Activar org-indent-mode por defecto 
  (org-tags-column 0)             ; Quitar espacio entre título y etiquetas
  (org-list-allow-alphabetical t) ; Permitir listas con letras
  (org-table-header-line-p t)     ; Congelar primera fila de tablas largas
  (org-export-in-background t)    ; Exportación asíncrona
  (org-todo-keywords '((sequence "TODO(t)"
                                 "ESPE(e)"
                                 "EMPE(m)"
                                 "PROY(p)"
                                 "FUTU(f)"
                                 "|" "DONE(d)"
                                 "CANC(c)")))
  (org-todo-keyword-faces '(("PROY" . (:foreground "#d33682" :weight bold))
                            ("ESPE" . (:foreground "#b58900" :weight bold))
                            ("EMPE" . (:foreground "#b58900" :weight bold))
                            ("DONE" . (:foreground "#859900" :weight bold))
                            ("CANC" . (:foreground "#859900" :weight bold))
                            ("FUTU" . (:foreground "#2aa198" :weight bold))
                            ("TODO" . (:foreground "#6c71c4" :weight bold))))
  
  (org-highest-priority ?A)
  (org-default-priority ?D)
  (org-lowest-priority ?D)
  (org-priority-faces '((?A . (:foreground "#dc322f" :weight bold))
                        (?B . (:foreground "#b58900" :weight bold))
                        (?C . (:foreground "#2aa198"))
                        (?D . (:foreground "#859900"))))
  
  
  (org-tag-persistent-alist '(("@Casa" . ?c)
                              ("@Oficina" . ?o)
                              ("@PC" . ?p)
                              ("@Internet" . ?i)
                              ("@Lectura" . ?l)
                              ("@Calle" . ?k)
                              ("#Docencia" . ?d)
                              ("#Carrera" . ?u)
                              ("#DevP" . ?v)
                              ("#ProyPer" . ?y)
                              ("#IngresoAdicional" . ?s)
                              ("#Puntos" . ?n)
                              ("Urgente" . ?g)
                              ("Corta" . ?r)
                              ("PasarBalon" . ?b)))
  (org-log-into-drawer "BITÁCORA")
  (org-latex-pdf-process '("tectonic %f"))
  (org-agenda-files '("~/personal/orgmode/gtd.org"))
  (org-agenda-window-setup 'current-window)
  ;; Destinos hasta de nivel 3
  (org-refile-targets '((org-agenda-files :maxlevel . 3)))
  ;; Construcción del destino paso a paso
  (org-refile-use-outline-path 'file)
  (org-outline-path-complete-in-steps nil)
  (j/lider-local
    :states '(normal insert emacs)
    :keymaps '(org-capture-mode-map)
    "r"   '(org-capture-refile :which-key "refile"))
  :config
  (setf (alist-get 'file org-link-frame-setup) #'find-file)
  (defun j/dwim-at-point (&optional arg)
    "Do-what-I-mean at point.
  If on a:
  - checkbox list item or todo heading: toggle it.
  - clock: update its time.
  - headline: cycle ARCHIVE subtrees, toggle latex fragments and inline images in
    subtree; update statistics cookies/checkboxes and ToCs.
  - footnote reference: jump to the footnote's definition
  - footnote definition: jump to the first reference of this footnote
  - table-row or a TBLFM: recalculate the table's formulas
  - table-cell: clear it and go into insert mode. If this is a formula cell,
    recaluclate it instead.
  - babel-call: execute the source block
  - statistics-cookie: update it.
  - latex fragment: toggle it.
  - link: follow it
  - otherwise, refresh all inline images in current tree."
    (interactive "P")
    (let* ((context (org-element-context))
           (type (org-element-type context)))
      ;; skip over unimportant contexts
      (while (and context (memq type '(verbatim code bold italic underline strike-through subscript superscript)))
        (setq context (org-element-property :parent context)
              type (org-element-type context)))
      (pcase type
        (`headline
         (cond ((memq (bound-and-true-p org-goto-map)
                      (current-active-maps))
                (org-goto-ret))
               ((and (fboundp 'toc-org-insert-toc)
                     (member "TOC" (org-get-tags)))
                (toc-org-insert-toc)
                (message "Updating table of contents"))
               ((string= "ARCHIVE" (car-safe (org-get-tags)))
                (org-force-cycle-archived))
               ((or (org-element-property :todo-type context)
                    (org-element-property :scheduled context))
                (org-todo
                 (if (eq (org-element-property :todo-type context) 'done)
                     (or (car (+org-get-todo-keywords-for (org-element-property :todo-keyword context)))
                         'todo)
                   'done))))
         ;; Update any metadata or inline previews in this subtree
         (org-update-checkbox-count)
         (org-update-parent-todo-statistics)
         (when (and (fboundp 'toc-org-insert-toc)
                    (member "TOC" (org-get-tags)))
           (toc-org-insert-toc)
           (message "Updating table of contents"))
         (let* ((beg (if (org-before-first-heading-p)
                         (line-beginning-position)
                       (save-excursion (org-back-to-heading) (point))))
                (end (if (org-before-first-heading-p)
                         (line-end-position)
                       (save-excursion (org-end-of-subtree) (point))))
                (overlays (ignore-errors (overlays-in beg end)))
                (latex-overlays
                 (cl-find-if (lambda (o) (eq (overlay-get o 'org-overlay-type) 'org-latex-overlay))
                             overlays))
                (image-overlays
                 (cl-find-if (lambda (o) (overlay-get o 'org-image-overlay))
                             overlays)))
           (+org--toggle-inline-images-in-subtree beg end)
           (if (or image-overlays latex-overlays)
               (org-clear-latex-preview beg end)
             (org--latex-preview-region beg end))))
  
        (`clock (org-clock-update-time-maybe))
  
        (`footnote-reference
         (org-footnote-goto-definition (org-element-property :label context)))
  
        (`footnote-definition
         (org-footnote-goto-previous-reference (org-element-property :label context)))
  
        ((or `planning `timestamp)
         (org-follow-timestamp-link))
  
        ((or `table `table-row)
         (if (org-at-TBLFM-p)
             (org-table-calc-current-TBLFM)
           (ignore-errors
             (save-excursion
               (goto-char (org-element-property :contents-begin context))
               (org-call-with-arg 'org-table-recalculate (or arg t))))))
  
        (`table-cell
         (org-table-blank-field)
         (org-table-recalculate arg)
         (when (and (string-empty-p (string-trim (org-table-get-field)))
                    (bound-and-true-p evil-local-mode))
           (evil-change-state 'insert)))
  
        (`babel-call
         (org-babel-lob-execute-maybe))
  
        (`statistics-cookie
         (save-excursion (org-update-statistics-cookies arg)))
  
        ((or `src-block `inline-src-block)
         (org-babel-execute-src-block arg))
  
        ((or `latex-fragment `latex-environment)
         (org-latex-preview arg))
  
        (`link
         (let* ((lineage (org-element-lineage context '(link) t))
                (path (org-element-property :path lineage)))
           (if (or (equal (org-element-property :type lineage) "img")
                   (and path (image-type-from-file-name path)))
               (+org--toggle-inline-images-in-subtree
                (org-element-property :begin lineage)
                (org-element-property :end lineage))
             (org-open-at-point arg))))
  
        ((guard (org-element-property :checkbox (org-element-lineage context '(item) t)))
         (let ((match (and (org-at-item-checkbox-p) (match-string 1))))
           (org-toggle-checkbox (if (equal match "[ ]") '(16)))))
  
        (_
         (if (or (org-in-regexp org-ts-regexp-both nil t)
                 (org-in-regexp org-tsr-regexp-both nil  t)
                 (org-in-regexp org-link-any-re nil t))
             (call-interactively #'org-open-at-point)
           (+org--toggle-inline-images-in-subtree
            (org-element-property :begin context)
            (org-element-property :end context)))))))
  
  (defun +org--toggle-inline-images-in-subtree (&optional beg end refresh)
    "Refresh inline image previews in the current heading/tree."
    (let ((beg (or beg
                   (if (org-before-first-heading-p)
                       (line-beginning-position)
                     (save-excursion (org-back-to-heading) (point)))))
          (end (or end
                   (if (org-before-first-heading-p)
                       (line-end-position)
                     (save-excursion (org-end-of-subtree) (point)))))
          (overlays (cl-remove-if-not (lambda (ov) (overlay-get ov 'org-image-overlay))
                                      (ignore-errors (overlays-in beg end)))))
      (dolist (ov overlays nil)
        (delete-overlay ov)
        (setq org-inline-image-overlays (delete ov org-inline-image-overlays)))
      (when (or refresh (not overlays))
        (org-display-inline-images t t beg end)
        t)))
  
  (defun +org-get-todo-keywords-for (&optional keyword)
    "Returns the list of todo keywords that KEYWORD belongs to."
    (when keyword
      (cl-loop for (type . keyword-spec)
               in (cl-remove-if-not #'listp org-todo-keywords)
               for keywords =
               (mapcar (lambda (x) (if (string-match "^\\([^(]+\\)(" x)
                                       (match-string 1 x)
                                     x))
                       keyword-spec)
               if (eq type 'sequence)
               if (member keyword keywords)
               return keywords)))
  (defun j/org-evaluate-if-actionable ()
    "Returns t if the task at point is actionable or nil if it isn't"
    (and (org-entry-get (point) "ACTIONABLE")
         (string< (org-read-date nil nil (org-entry-get (point) "ACTIONABLE"))
                  (org-read-date nil nil "+1"))))
  
  (defun j/org-process-task ()
    "Vefifies if a task is actionable. If it is, set it as actionable"
    (when (j/org-evaluate-if-actionable)
      (org-todo "TODO")
      (org-delete-property "ACTIONABLE")))
  
  (defun j/org-verify-actionable-tasks ()
    "Goes through al agenda files checking if FUTU tasks are actionable"
    (org-map-entries
     '(j/org-process-task)
     "/+FUTU" 'agenda))
  
  ;; Ejecutar j/org-verify-actionable-tasks cada vez que se corra la agenda. Lo hace antes de que se calcula le agenda.
  (add-hook 'org-agenda-mode-hook #'j/org-actionable)
  (defun j/org-actionable ()
    (j/org-verify-actionable-tasks))
  
  (defun j/org-set-futu ()
    "Cambiar el estado de una tarea a FUTU y definir la fecha en que se convierte en accionable"
    (interactive)
    (org-set-property "ACTIONABLE" (concat "[" (org-read-date nil nil nil "ACTIONABLE: ") "]"))
    (org-todo "FUTU"))
  ;; Definir la lista DESPUÉS de cargar org-capture. Esto es necesario porque de no tenerlo la lista de plantillas se reiniciaba
  
  (with-eval-after-load 'org-capture       
    (add-to-list 'org-capture-templates
                 '("l" "Tarea enlazada" ; l para una terea que incluya enlace a documento o correo
                   entry
                   (file+headline
                    "~/personal/orgmode/gtd.org" ; Guardar en gtd.org
                    "Inbox") ; Guarda por defecto en el headline Inbox
                   "* TODO [#D] %?\nOrigen o referencia: %a\n"))
    (add-to-list 'org-capture-templates
                 '("c" "Tarea de clipboard" ; c para una tarea que referencia información contenida en clipboard
                   entry
                   (file+headline
                    "~/personal/orgmode/gtd.org" ; Guardar en gtd.org
                    "Inbox") ; Guarda por defecto en el headline Inbox
                   "* TODO [#D] %? \n %x"))
    (add-to-list 'org-capture-templates
                 '("t" "Tarea simple" ; l para una terea que incluya enlace a documento o correo
                   entry
                   (file+headline
                    "~/personal/orgmode/gtd.org" ; Guardar en gtd.org
                    "Inbox") ; Guarda por defecto en el headline Inbox
                   "* TODO [#D] %? \n")))
  (j/lider
    "c" '(org-capture :which-key "org-capture"))
  (add-to-list 'org-modules 'org-habit)
  (general-define-key
   :states '(normal)
   :keymaps '(org-mode-map)
   "K"   '(org-previous-visible-heading :which-key "Encabezado previo")
   "J"   '(org-next-visible-heading :which-key "Encabezado siguiente")
   "H"   '(outline-up-heading :which-key "Encabezado siguiente"))
  (general-define-key
   :states '(normal)
   :keymaps '(org-mode-map)
   "RET" '(j/dwim-at-point :which-key "dwim"))
  
  (j/lider-local
    :states '(normal insert emacs)
    :keymaps '(org-mode-map)
    "T"    '(org-babel-tangle :which-key "tangle"))
  (j/lider-local
    :states '(normal insert emacs)
    :keymaps '(org-mode-map)
    "a"   '(org-archive-subtree-default :which-key "archivar")
    "p"   '(org-priority :which-key "prioridad")
    "q"   '(org-set-tags-command :which-key "etiquetas")
    "o"   '(org-set-property :which-key "propiedades")
    "t"   '(org-todo :which-key "propiedades")
    "r"   '(org-refile :which-key "refile")
    "e"   '(org-export-dispatch :which-key "exportar"))
  (j/lider-local
    :infix "j"
    :keymaps '(org-mode-map)
    "" '(:ignore t :which-key "reloj")
    "e" '(org-set-effort :which-key "definir esfuerzo")
    "E" '(org-inc-effort :which-key "aumentar esfuerzo")
    "i" '(org-clock-in :which-key "iniciar reloj")
    "I" '(org-clock-in-last :which-key "continuar reloj")
    "g" '(org-clock-goto :which-key "ir a actual")
    "c" '(org-clock-cancel :which-key "cancelar reloj")
    "o" '(org-clock-out :which-key "cerrar y eliminar"))
  
  ;; Manipulación del reloj desde menú de accesos directos 
  (j/lider
    :infix "o j"
    "" '(:ignore t :which-key "reloj")
    "I" '(org-clock-in-last :which-key "continuar reloj")
    "c" '(org-clock-cancel :which-key "cancelar reloj")
    "o" '(org-clock-out :which-key "cerrar y eliminar"))
  (j/lider-local
    :infix "c"
    :keymaps '(org-mode-map)
    "" '(:ignore t :which-key "Calendario")
    "d" '(org-deadline :which-key "definir deadline")
    "f" '(j/org-set-futu :which-key "A futuro")
    "c" '(org-schedule :which-key "agendar"))
  (add-to-list 'evil-normal-state-modes 'org-agenda-mode)
  (general-define-key
   :states '(normal)
   :keymaps '(org-agenda-mode-map)
   "q" '(org-agenda-quit :which-key "salir")
   "r" '(org-agenda-redo :which-key "refrescar")
   "t" '(org-agenda-todo :which-key "cambiar estado")
   "c" '(org-agenda-schedule :which-key "agendar")
   "a" '(org-agenda-archive :which-key "archivar")
   "d" '(org-agenda-deadline :which-key "fecha límite")
   "p" '(org-agenda-priority :which-key "cambiar prioridad")
   "i" '(org-agenda-clock-in :which-key "iniciar reloj")
   "o" '(org-agenda-clock-out :which-key "cerrar reloj")
   "G" '(org-save-all-org-buffers :which-key "guardar archivos org")
   "RET" '(org-agenda-switch-to :which-key "visitar"))
  (defun my-beamer-bold (contents backend info)
    (when (eq backend 'beamer) ;;
      (replace-regexp-in-string "\\`\\\\[A-Za-z0-9]+" "\\\\textbf" contents)))
  ;;(add-to-list 'org-export-filter-bold-functions 'my-beamer-bold)
  (org-beamer-mode))

(use-package org-superstar
  :hook (org-mode . org-superstar-mode))

(use-package org-ref
  :after org
  :custom
  (org-ref-default-citation-link "citep")
  (reftex-default-bibliography '("~/biblioteca/main.bib"))
  (org-ref-default-bibliography '("~/biblioteca/main.bib"))
  (org-ref-pdf-directory "~/biblioteca/")
  (bibtex-dialect 'biblatex)
  :config
  (org-ref-ivy-cite-completion)
  (j/lider-local
    :states '(normal insert emacs)
    :keymaps 'org-mode-map
    "}" '(org-ref-ivy-insert-ref-link :which-key "insertar referencia")
    "]" '(org-ref-ivy-insert-cite-link :which-key "insertar cita")))

(use-package yasnippet
  :after (evil general)
  :diminish yas-minor-mode
  :config
  (yas-global-mode)
  (yas-reload-all)
  (j/lider
    "y" '(yas-insert-snippet :which-key "insertar plantilla")))

(use-package yasnippet-snippets
  :after yasnippet
  :config (yasnippet-snippets-initialize))

(use-package dired
  :straight (:type built-in)
  :commands (dired dired-jump)
  :custom
  (dired-recursive-copies 'always)
  (dired-recursive-deletes 'always)
  :config
  (put 'dired-find-alternate-file 'disabled nil))

(use-package all-the-icons-dired
  :after dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package magit
  :commands (magit-status magit-init magit-clone)
  :init
  (j/lider
      :infix "o"
      "m" '(magit-status :which-key "magit")))

(use-package projectile
  :custom
  (projectile-enable-caching t)                   ; Para acelerar 
  (projectile-globally-ignored-files '("*.org~"))
  (projectile-completion-system 'ivy) 

  :config
  (projectile-mode)
  (setq projectile-enable-caching t))

(use-package counsel-projectile
  :after projectile
  :config
  (counsel-projectile-mode))

(j/lider
  "p" '(:keymap projectile-command-map :which-key "projectile"))

(use-package pdf-tools
  :config
  (pdf-tools-install))

(j/lider
 :infix "k"
 "" '(:ignore t :which-key "macros")
 "k" '(kmacro-end-or-call-macro-repeat :which-key "ejecutar macro")
 "d" '(kmacro-end-macro :which-key "detener grabación")
 "g" '(kmacro-start-macro :which-key "grabar macro"))
