;; byte-compile-math: news, films, develop -*-


;; The Guile License
;; Guile is Free Software. Guile is copyrighted, not public domain, and there are 
;; restrictions on its distribution or redistribution, but these restrictions are 
;; designed to permit everything a cooperating person would want to do.

;; The Guile library (libguile) and supporting files are published under the terms 
;; of the GNU Lesser General Public License version 3 or later. See the files COPYING.LESSER 
;; and COPYING.

;; The Guile readline module is published under the terms of the GNU General Public License 
;; version 3 or later. See the file COPYING.

;; The manual you’re now reading is published under the terms of the GNU Free Documentation 
;; License (see GNU Free Documentation License).
;; C code linking to the Guile library is subject to terms of that library. Basically such 
;; code may be published on any terms, provided users can re-link against a new or modified 
;; version of Guile.

;; C code linking to the Guile readline module is subject to the terms of that module. 
;; Basically such code must be published on Free terms.

;; Scheme level code written to be run by Guile (but not derived from Guile itself) is not 
;; restricted in any way, and may be published on any terms. We encourage authors to publish 
;; on Free terms.

;; You must be aware there is no warranty whatsoever for Guile. This is described in full in 
;; the licenses.

(defconstant +block-size+ 8192)
(defconstant +pointer-size+    4)
(defconstant +header-size+     8)
(defconstant +trie-tag+       78)
(defconstant +bucket-tag+     66)
(defconstant +trie-size+    2048)
(defconstant +split-factor+  3/4)
(defconstant +cache-size+    128)

;;; The B-trie STREAM/ARRAY-ELEMENT-TYPE.
(deftype octet () '(unsigned-byte 8))

(defstruct bt
  (stream nil)
  (blocks nil))

(defmethod print-object ((bt bt) stream)
  (cond ((eq (bt-stream bt) nil) (call-next-method))
        ((let* ((bt-name (namestring (bt-stream bt)))
                (length (file-length (bt-stream bt)))
                (block-count (/ length +block-size+)))
           (print-unreadable-object (bt stream :type t :identity t)
             (format stream "~S (~D block~:P)" bt-name block-count))))))

(defun %open-bt (pathname)
  (open pathname :direction :io
        :if-does-not-exist :create
        :if-exists :overwrite
        :element-type 'octet))

(defun open-bt (pathname)
  (let* ((bt (make-bt :stream (%open-bt pathname)))
         (length (file-length (bt-stream bt))))
    (when (zerop length) (allocate-block bt +trie-tag+ +trie-size+))
    (assert (zerop (mod (file-length (bt-stream bt)) +block-size+)))
    bt))

(defun close-bt (bt)
  (setf (bt-blocks bt) nil)
  (unless (eq (bt-stream bt) nil)
    (with-accessors ((stream bt-stream)) bt
      (prog1 (close stream) (setq stream nil)))))

(defmacro %prune-cache (cache)
  (let ((tail-pos (1- +cache-size+)))
    `(when (> (list-length ,cache) +cache-size+)
       (rplacd (nthcdr ,tail-pos ,cache) nil))))

(defun get-block (bt number)
  (let ((entry (assoc number (bt-blocks bt))) entry-tail)
    (cond (entry (with-accessors ((cache bt-blocks)) bt
                   (unless (eq entry (car cache))
                     (loop for tail on cache
                           when (eq (cadr tail) entry)
                           do (setq entry-tail (cdr tail))
                              (setf (cdr tail) (cddr tail)))
                     ;; Move to front of cache.
                     (rplacd entry-tail cache)
                     (setq cache entry-tail)
                     (%prune-cache cache))
                   (cdr entry)))
          ;; Not in cache, read from file.
          (t (file-position (bt-stream bt) (* +block-size+ number))
             (let ((block (make-array +block-size+ :element-type 'octet)))
               (assert (= (read-sequence block (bt-stream bt)) +block-size+))
               (progn (push (cons number block) (bt-blocks bt)) block))))))

(defun get-block-number (bt block)
  (or (car (rassoc block (bt-blocks bt)))
      (error "No block found: ~S." block)))

(defun sync-block (bt block &optional number)
  (let ((number (or number (get-block-number bt block))))
    (file-position (bt-stream bt) (* +block-size+ number))
    (values (write-sequence block (bt-stream bt)) number)))

(defun make-cell-pointer (length offset)
  (check-type length (unsigned-byte 16))
  (check-type offset (unsigned-byte 16))
  (logior length (ash offset 16)))

(defun read-u32 (block offset)
  (logior (aref block offset)
          (ash (aref block (+ offset 1)) 8)
          (ash (aref block (+ offset 2)) 16)
          (ash (aref block (+ offset 3)) 24)))

(defun (setf read-u32) (new-value block offset)
  (loop for byte-position fixnum from 0 below 32 by 8
        for octet = (ldb (byte 8 byte-position) new-value)
        do (setf (aref block offset) octet) (incf offset)
        finally (return new-value)))

(defun free-space (block)
  (let ((free-pointer (read-u32 block 4)))
    (values (ldb (byte 16 0) free-pointer)
            (ldb (byte 16 16) free-pointer))))

(defsetf free-space (block) (free-space free-offset)
  `(multiple-value-prog1 (values ,free-space ,free-offset)
     (let ((pointer (make-cell-pointer ,free-space ,free-offset)))
       (setf (read-u32 ,block +pointer-size+) pointer))))

(defun allocate-block (bt tag &optional (overhead 0))
  (let* ((word-count (/ +block-size+ +pointer-size+))
         (free-offset (+ +header-size+ overhead))
         (free-space (- +block-size+ free-offset))
         (stream (bt-stream bt))
         (file-length (file-length stream))
         (number (/ file-length +block-size+)))
    (file-position stream (* +block-size+ number))
    (write-sequence (vector 84 tag 0 0) stream)
    (write-byte (ldb (byte 8 0) free-space) stream)
    (write-byte (ldb (byte 8 8) free-space) stream)
    (write-byte (ldb (byte 8 0) free-offset) stream)
    (write-byte (ldb (byte 8 8) free-offset) stream)
    (loop do (write-sequence #(0 0 0 0) stream)
          repeat (- word-count (/ +header-size+ +pointer-size+))
          finally (return (values (get-block bt number) number)))))

(defun allocate-cell (block vector &optional (length (length vector)))
  (multiple-value-bind (free-space free-offset) (free-space block)
    (declare (type (unsigned-byte 16) free-space free-offset))
    (assert (>= free-space (+ length +pointer-size+)))
    (let* ((datum-end (+ free-offset free-space))
           (datum-start (- datum-end length)))
      (declare (type (unsigned-byte 16) datum-start datum-end))
      (decf free-space (the (unsigned-byte 16) (+ length +pointer-size+)))
      (when vector (setf (subseq block datum-start datum-end) vector))
      (let ((datum-pointer (make-cell-pointer length datum-start)))
        (setf (read-u32 block free-offset) datum-pointer)
        (incf free-offset +pointer-size+) ; The cell is now "used."
        (let ((free-pointer (make-cell-pointer free-space free-offset)))
          (setf (read-u32 block +pointer-size+) free-pointer) datum-pointer)))))

(defun trie-node-lookup (block key key-start)
  (let* ((key-index (aref key key-start))
         (offset (+ +header-size+ (* 2 +pointer-size+ key-index)))
         (exhaust-pointer-p (eql (1+ key-start) (length key))))
    (declare (type (unsigned-byte 16) key-index offset))
    (when exhaust-pointer-p (incf offset +pointer-size+))
    (values (read-u32 block offset) key-index exhaust-pointer-p)))

(defun get-datum (block cell-pointer)
  (when (zerop cell-pointer) (return-from get-datum nil))
  (make-array (ldb (byte 16 0) cell-pointer) :element-type 'octet
              :displaced-index-offset (ldb (byte 16 16) cell-pointer)
              :displaced-to block))

(defun bucket-cell-count (bucket)
  (let* ((free-offset (nth-value 1 (free-space bucket)))
         (cell-count-in-bytes (- free-offset +header-size+))
         (cell-count (/ cell-count-in-bytes +pointer-size+)))
    (declare (type (unsigned-byte 16) free-offset cell-count-in-bytes))
    (progn (assert (evenp cell-count)) cell-count)))

(defun get-bucket-cell (bucket cell-number)
  (let ((offset-from-header (* +pointer-size+ cell-number)))
    (get-datum bucket (read-u32 bucket (+ +header-size+
                                          offset-from-header)))))

(defun block-type (block &optional (tag (aref block 1)))
  (let ((known-tag-p (or (eql tag +trie-tag+) (eql tag +bucket-tag+))))
    (progn (assert known-tag-p () "Invalid type tag: ~D." tag) tag)))

(defun key-range (bucket)
  "Get key range (values: low, high)."
  (let ((lo-key-byte (aref bucket 2))
        (hi-key-byte (aref bucket 3)))
    (check-type lo-key-byte octet)
    (check-type hi-key-byte octet)
    (assert (<= lo-key-byte hi-key-byte))
    (values lo-key-byte hi-key-byte)))

(defsetf key-range (bucket) (lo-key-byte hi-key-byte)
  `(set-key-range ,bucket ,lo-key-byte ,hi-key-byte))

(defun set-key-range (bucket lo-key-byte hi-key-byte)
  (multiple-value-prog1 (values lo-key-byte hi-key-byte)
    (assert (<= 0 lo-key-byte hi-key-byte 255))
    (let ((was-hybrid-p (hybrid-bucket-p bucket))
          (now-pure-p (eql (setf (aref bucket 2) lo-key-byte)
                           (setf (aref bucket 3) hi-key-byte))))
      ;; Going hybrid->pure consumes keys.
      (when (and was-hybrid-p now-pure-p)
        (loop with pure-bucket-key-index of-type octet = lo-key-byte
              with cell-count of-type fixnum = (bucket-cell-count bucket)
              for cell-number of-type fixnum from 0 below cell-count by 2
              for offset fixnum = (+ +header-size+ (* +pointer-size+ cell-number))
              for pointer of-type (unsigned-byte 32) = (read-u32 bucket offset)
              do (symbol-macrolet ((pointer-offset (ldb (byte 16 16) pointer)))
                   (assert (eql (aref bucket pointer-offset) pure-bucket-key-index))
                   (progn (incf pointer-offset) (decf (ldb (byte 16 0) pointer)))
                   (setf (read-u32 bucket offset) pointer)))))))

(defun find-in-bucket (bucket key &optional (key-start 0))
  (when (pure-bucket-p bucket) (setq key-start (1+ key-start)))
  (loop with cell-count fixnum = (bucket-cell-count bucket)
        for cell-number fixnum from 0 below cell-count by 2
        do (let ((key-in-bucket (get-bucket-cell bucket cell-number)))
             (when (not (mismatch key-in-bucket key :start2 key-start))
               (return (get-bucket-cell bucket (1+ cell-number)))))))

(defun trie-node-p (block)
  (eql (block-type block)
       +trie-tag+))

(defun pure-bucket-p (block)
  (symbol-macrolet ((key-range (key-range block)))
    (when (eql (block-type block) +bucket-tag+)
      (multiple-value-call #'= key-range))))

(defun hybrid-bucket-p (block)
  (symbol-macrolet ((key-range (key-range block)))
    (when (eql (block-type block) +bucket-tag+)
      (multiple-value-call #'< key-range))))

(defun cell-space (&rest vectors)
  (loop for vector in vectors
        sum (length vector)
        sum +pointer-size+))

(defun bucket-key-distribution (bucket)
  (loop with counts = (make-array 256 :initial-element 0)
        with cell-count fixnum = (bucket-cell-count bucket)
        for cell-number fixnum from 0 below cell-count by 2
        for key-in-bucket = (get-bucket-cell bucket cell-number)
        do (incf (svref counts (aref key-in-bucket 0)))
        finally (return counts)))

(defun find-split-point (bucket)
  (multiple-value-bind (lo hi) (key-range bucket)
    (loop with best-split-point of-type octet = hi
          with key-distribution = (bucket-key-distribution bucket)
          with distincts fixnum = (count-if #'plusp key-distribution)
          with best-split-margin of-type fixnum = most-positive-fixnum
          initially (when (eql distincts 1) (return key-distribution))
          for split-point of-type octet from lo to hi
          for left-count = (reduce #'+ key-distribution :end split-point)
          for right-count = (reduce #'+ key-distribution :start split-point)
          for ratio = (when (plusp left-count) (/ right-count left-count))
          for split-margin = (when ratio (abs (- ratio +split-factor+)))
          when (and split-margin (> right-count 0) (< split-margin best-split-margin))
          do (setq best-split-margin split-margin best-split-point split-point)
          finally (return best-split-point))))

(defun move-bucket-cells (old-bucket new-bucket split-point)
  (assert (< 0 split-point 256) (split-point) "Bad SPLIT-POINT.")
  (symbol-macrolet ((free-space (- +block-size+ +header-size+)))
    (loop with cell-count of-type fixnum = (bucket-cell-count old-bucket)
          for cell-number of-type fixnum from 0 below cell-count by 2
          for key = (copy-seq (get-bucket-cell old-bucket cell-number))
          for value = (copy-seq (get-bucket-cell old-bucket (1+ cell-number)))
          if (< (aref key 0) split-point) append `(,key ,value) into retained-cells
          else do (allocate-cell new-bucket key) (allocate-cell new-bucket value)
          finally (setf (free-space old-bucket) (values free-space +header-size+))
                  (dolist (datum retained-cells) (allocate-cell old-bucket datum))
                  (multiple-value-bind (old-lo old-hi) (key-range old-bucket)
                    (setf (key-range new-bucket) (values split-point old-hi))
                    (setf (key-range old-bucket) (values old-lo (1- split-point)))
                    (return split-point)))))

(defun purify-bucket (bt bucket trie-node key-distribution)
  (let ((key-leader (position-if #'plusp key-distribution)))
    (loop for bucket-number = (get-block-number bt bucket)
          for i of-type octet from 0 to 255
          ;; We have to undo the work that was done by ENGULF-POINTERS.
          do (symbol-macrolet ((pointer (trie-pointer trie-node i)))
               (when (and (/= i key-leader) (eql pointer bucket-number))
                 (setq pointer 0)))
          ;; Now there is only one pointer to this bucket.
          finally (set-key-range bucket key-leader key-leader)
                  (sync-block bt bucket) (sync-block bt trie-node)
                  (return (split-pure-bucket bt bucket trie-node)))))

(defun split-hybrid-bucket (bt bucket trie-node)
  (let ((bucket-split-point (find-split-point bucket)))
    (cond ((typep bucket-split-point 'simple-vector)
           (purify-bucket bt bucket trie-node bucket-split-point))
          ((multiple-value-bind (new-bucket new-bucket-number)
               (allocate-block bt +bucket-tag+)
             (move-bucket-cells bucket new-bucket bucket-split-point)
             (multiple-value-bind (new-lo new-hi) (key-range new-bucket)
               (loop for i of-type octet from new-lo to new-hi
                     do (setf (trie-pointer trie-node i) new-bucket-number)
                     finally (sync-block bt bucket) (sync-block bt new-bucket))))))))

(defun delete-bucket-cell (bucket cell-number)
  (multiple-value-bind (free-space free-offset) (free-space bucket)
    (let ((cell-offset (+ +header-size+ (* +pointer-size+ cell-number))))
      (replace bucket bucket
               :start1 cell-offset :end1 (- free-offset +pointer-size+)
               :start2 (+ cell-offset +pointer-size+) :end2 free-offset)
      ;; Free the space that was occupied by the pointer.
      ;; The actual data may remain until there's a split.
      (setf (free-space bucket)
            (values (+ free-space +pointer-size+)
                    (- free-offset +pointer-size+))))))

(defun trie-pointer (trie-node key-index)
  (let ((offset-from-header (* 8 key-index)))
    (read-u32 trie-node (+ +header-size+
                           offset-from-header))))

(defun (setf trie-pointer) (trie-pointer trie-node key-index)
  (setf (read-u32 trie-node (+ +header-size+ (* 8 key-index)))
        trie-pointer))

(defun exhaust-pointer (trie-node key-index)
  (let ((base (+ +header-size+ (* 8 key-index))))
    (read-u32 trie-node (+ base +pointer-size+))))

(defun (setf exhaust-pointer) (exhaust-pointer trie-node key-index)
  (let ((offset (+ +header-size+ (* 8 key-index) +pointer-size+)))
    (setf (read-u32 trie-node offset) exhaust-pointer)))

(defun hoist-exhaustible-keys (bucket trie-node)
  "Transfer one-byte keys from BUCKET to the parent TRIE-NODE."
  (loop with cell-count fixnum = (bucket-cell-count bucket)
        with cell-number of-type (unsigned-byte 16) = 0
        while (< cell-number cell-count)
        do (let* ((key-in-bucket (get-bucket-cell bucket cell-number))
                  (exhaustible-key-p (eql (length key-in-bucket) 1))
                  (leading-key-byte (aref key-in-bucket 0)))
             ;; If it's a multi-byte key then skip over the pair.
             (cond ((not exhaustible-key-p) (incf cell-number 2))
                   ((let ((value (get-bucket-cell bucket (1+ cell-number))))
                      (setf (exhaust-pointer trie-node leading-key-byte)
                            (allocate-cell trie-node value))
                      ;; After deleting the key, the
                      ;; value has the same CELL-NUMBER.
                      (delete-bucket-cell bucket cell-number)
                      (delete-bucket-cell bucket cell-number)
                      (decf cell-count 2)))))))

(defun hybridize-bucket (bt bucket)
  "BUCKET will cover the full range of keys under a new TRIE-NODE."
  (loop with trie-node = (allocate-block bt +trie-tag+ +trie-size+)
        with bucket-number = (get-block-number bt bucket)
        with pure-bucket-key-index = (key-range bucket)
        for i of-type octet from 0 to 255
        do (setf (trie-pointer trie-node i) bucket-number)
        finally (setf (key-range bucket) (values 0 255))
                (hoist-exhaustible-keys bucket trie-node)
                (sync-block bt bucket bucket-number)
                (return (values (sync-block bt trie-node)
                                pure-bucket-key-index))))

(defun split-pure-bucket (bt bucket parent-node)
  (multiple-value-bind (child-node key-index) (hybridize-bucket bt bucket)
    (progn (split-hybrid-bucket bt bucket child-node) (sync-block bt child-node))
    (setf (trie-pointer parent-node key-index) (get-block-number bt child-node))))

(defun engulf-pointers (trie-node block-pointer key-index)
  (setf (trie-pointer trie-node key-index) block-pointer)
  (let ((lo-key-index key-index) (hi-key-index key-index))
    (declare (type octet lo-key-index hi-key-index))
    ;; Set adjacent null pointers (to the right).
    (loop while (< hi-key-index 255)
          while (zerop (trie-pointer trie-node (1+ hi-key-index)))
          do (setf (trie-pointer trie-node (incf hi-key-index))
                   block-pointer))
    ;; Same thing, but to the left.
    (loop while (> lo-key-index 0)
          finally (return (values lo-key-index hi-key-index))
          while (zerop (trie-pointer trie-node (1- lo-key-index)))
          do (setf (trie-pointer trie-node (decf lo-key-index))
                   block-pointer))))

(defun make-bucket (bt parent-node key-index)
  (let* ((bucket (allocate-block bt +bucket-tag+))
         (number (get-block-number bt bucket)))
    (multiple-value-bind (lo-key-index hi-key-index)
        (engulf-pointers parent-node number key-index)
      (set-key-range bucket lo-key-index hi-key-index)
      (sync-block bt parent-node)
      (sync-block bt bucket))))

(defmacro %add-to-bucket (key value split-function-name)
  (let ((total-required-space `(cell-space ,key ,value)))
    `(cond ((> ,total-required-space (free-space next-block))
            ;; Split the bucket and retry the insertion.
            (,split-function-name bt next-block block)
            ;; Update trie node.
            (sync-block bt block))
           ;; There's space for KEY and VALUE.
           (t (allocate-cell next-block ,key)
              (allocate-cell next-block ,value)
              (sync-block bt next-block)
              (return next-block)))))

(defun add-to-trie (bt block key value &optional (key-start 0))
  (loop (multiple-value-bind (pointer key-index exhaust-pointer-p)
            (trie-node-lookup block key key-start)
          (let (next-block)
            (cond (exhaust-pointer-p
                   (let ((cell-pointer (allocate-cell block value)))
                     (setf (exhaust-pointer block key-index) cell-pointer)
                     (return (sync-block bt block))))
                  ((zerop pointer) (make-bucket bt block key-index))
                  ((pure-bucket-p (setq next-block (get-block bt pointer)))
                   (let ((partially-consumed-key (subseq key (1+ key-start))))
                     (%add-to-bucket partially-consumed-key value split-pure-bucket)))
                  ((hybrid-bucket-p next-block)
                   (let ((partially-consumed-key (subseq key key-start)))
                     (%add-to-bucket partially-consumed-key value split-hybrid-bucket)))
                  ((trie-node-p next-block) (setq block next-block) (incf key-start))
                  ((error "Failed to acquire bucket: ~S, ~S in ~S." key value bt)))))))

(defun fetch (key bt)
  (let ((root (get-block bt 0)))
    (find-in-trie bt root key)))

(defun find-in-trie (bt block key &optional (key-start 0))
  (loop (multiple-value-bind (pointer key-index exhaust-pointer-p)
            (trie-node-lookup block key key-start)
          (declare (ignore key-index))
          (let (next-block)
            (cond ((zerop pointer) (return nil))
                  (exhaust-pointer-p (return (get-datum block pointer)))
                  ((trie-node-p (setq next-block (get-block bt pointer)))
                   (setq block next-block key-start (1+ key-start)))
                  ((return (find-in-bucket next-block key key-start))))))))

(defun (setf fetch) (value key bt)
  (symbol-macrolet ((root (get-block bt 0)))
    (add-to-trie bt root key value) value))