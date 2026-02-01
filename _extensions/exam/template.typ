// Main template file for Quarto exam format
// This file is the entry point that Quarto uses

$typst-template.typ()$

$typst-show.typ()$

$for(header-includes)$
$header-includes$
$endfor$

$for(include-before)$
$include-before$
$endfor$

$body$

$for(include-after)$
$include-after$
$endfor$
