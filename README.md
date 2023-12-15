<!DOCTYPE html>
<!-- saved from url=(0085)https://www.gnu.org/software/emacs/manual/html_node/elisp/Nonprinting-Characters.html -->
<html><!-- Created by GNU Texinfo 7.0.3, https://www.gnu.org/software/texinfo/ --><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Nonprinting Characters (GNU Emacs Lisp Reference Manual)</title>

<meta name="description" content="Nonprinting Characters (GNU Emacs Lisp Reference Manual)">
<meta name="keywords" content="Nonprinting Characters (GNU Emacs Lisp Reference Manual)">
<meta name="resource-type" content="document">
<meta name="distribution" content="global">
<meta name="Generator" content="makeinfo">
<meta name="viewport" content="width=device-width,initial-scale=1">

<link rev="made" href="mailto:bug-gnu-emacs@gnu.org">
<link rel="icon" type="image/png" href="https://www.gnu.org/graphics/gnu-head-mini.png">
<meta name="ICBM" content="42.256233,-71.006581">
<meta name="DC.title" content="gnu.org">
<style type="text/css">
@import url('/software/emacs/manual.css');
</style>
</head>

<body lang="en">
<div class="subsubsection-level-extent" id="Nonprinting-Characters">
<div class="nav-panel">
<p>
Next: <a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Text-Props-and-Strings.html" accesskey="n" rel="next">Text Properties in Strings</a>, Previous: <a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Non_002dASCII-in-Strings.html" accesskey="p" rel="prev">Non-<abbr class="acronym">ASCII</abbr> Characters in Strings</a>, Up: <a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/String-Type.html" accesskey="u" rel="up">String Type</a> &nbsp; [<a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/index.html#SEC_Contents" title="Table of contents" rel="contents">Contents</a>][<a href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Index.html" title="Index" rel="index">Index</a>]</p>
</div>
<hr>
<h4 class="subsubsection" id="Nonprinting-Characters-in-Strings">2.4.8.3 Nonprinting Characters in Strings</h4>

<p>You can use the same backslash escape-sequences in a string constant
as in character literals (but do not use the question mark that begins a
character constant).  For example, you can write a string containing the
nonprinting characters tab and <kbd class="kbd">C-a</kbd>, with commas and spaces between
them, like this: <code class="code">"\t, \C-a"</code>.  See <a class="xref" href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Character-Type.html">Character Type</a>, for a
description of the read syntax for characters.
</p>
<p>However, not all of the characters you can write with backslash
escape-sequences are valid in strings.  The only control characters that
a string can hold are the <abbr class="acronym">ASCII</abbr> control characters.  Strings do not
distinguish case in <abbr class="acronym">ASCII</abbr> control characters.
</p>
<p>Properly speaking, strings cannot hold meta characters; but when a
string is to be used as a key sequence, there is a special convention
that provides a way to represent meta versions of <abbr class="acronym">ASCII</abbr>
characters in a string.  If you use the ‘<samp class="samp">\M-</samp>’ syntax to indicate
a meta character in a string constant, this sets the
2**7
bit of the character in the string.  If the string is used in
<code class="code">define-key</code> or <code class="code">lookup-key</code>, this numeric code is translated
into the equivalent meta character.  See <a class="xref" href="https://www.gnu.org/software/emacs/manual/html_node/elisp/Character-Type.html">Character Type</a>.
</p>
<p>Strings cannot hold characters that have the hyper, super, or alt
modifiers.
</p>
</div>





</body></html>