// Typst show file for exam format
// This file invokes the exam template with metadata from YAML

#show: exam.with(
$if(title)$
  title: [$title$],
$endif$
$if(author)$
  author: [$author$],
$endif$
$if(date)$
  date: [$date$],
$endif$
$if(add-points)$
  add-points: $add-points$,
$endif$
$if(point-name)$
  point-name: "$point-name$",
$endif$
$if(bonus-point-name)$
  bonus-point-name: "$bonus-point-name$",
$endif$
$if(point-position)$
  point-position: "$point-position$",
$endif$
$if(point-format)$
  point-format: "$point-format$",
$endif$
$if(print-answers)$
  print-answers: $print-answers$,
$endif$
$if(solution-style)$
  solution-style: "$solution-style$",
$endif$
$if(solution-color)$
  solution-color: rgb("#$solution-color$"),
$endif$
$if(solution-title)$
  solution-title: "$solution-title$",
$endif$
$if(choice-label-style)$
  choice-label-style: "$choice-label-style$",
$endif$
$if(checkbox-char)$
  checkbox-char: "$checkbox-char$",
$endif$
$if(checked-char)$
  checked-char: "$checked-char$",
$endif$
$if(correct-choice-emphasis)$
  correct-choice-emphasis: "$correct-choice-emphasis$",
$endif$
$if(paper-size)$
  paper-size: "$paper-size$",
$endif$
$if(margin)$
  margin: $margin$,
$endif$
$if(header-left)$
  header-left: [$header-left$],
$endif$
$if(header-center)$
  header-center: [$header-center$],
$endif$
$if(header-right)$
  header-right: [$header-right$],
$endif$
$if(footer-left)$
  footer-left: [$footer-left$],
$endif$
$if(footer-center)$
  footer-center: [$footer-center$],
$endif$
$if(footer-right)$
  footer-right: [$footer-right$],
$endif$
$if(first-page-header-left)$
  first-page-header-left: [$first-page-header-left$],
$endif$
$if(first-page-header-center)$
  first-page-header-center: [$first-page-header-center$],
$endif$
$if(first-page-header-right)$
  first-page-header-right: [$first-page-header-right$],
$endif$
$if(first-page-footer-left)$
  first-page-footer-left: [$first-page-footer-left$],
$endif$
$if(first-page-footer-center)$
  first-page-footer-center: [$first-page-footer-center$],
$endif$
$if(first-page-footer-right)$
  first-page-footer-right: [$first-page-footer-right$],
$endif$
$if(running-header-left)$
  running-header-left: [$running-header-left$],
$endif$
$if(running-header-center)$
  running-header-center: [$running-header-center$],
$endif$
$if(running-header-right)$
  running-header-right: [$running-header-right$],
$endif$
$if(running-footer-left)$
  running-footer-left: [$running-footer-left$],
$endif$
$if(running-footer-center)$
  running-footer-center: [$running-footer-center$],
$endif$
$if(running-footer-right)$
  running-footer-right: [$running-footer-right$],
$endif$
$if(header-rule)$
  header-rule: $header-rule$,
$endif$
$if(footer-rule)$
  footer-rule: $footer-rule$,
$endif$
$if(running-header-rule)$
  running-header-rule: $running-header-rule$,
$endif$
$if(running-footer-rule)$
  running-footer-rule: $running-footer-rule$,
$endif$
$if(extra-head-height)$
  extra-head-height: $extra-head-height$,
$endif$
$if(extra-foot-height)$
  extra-foot-height: $extra-foot-height$,
$endif$
)
