import moo from "moo";
import{content} from "./text.js"
let lexer = moo.compile({
  /** 
   * .
   * regex match EOF  $(?![\r\n]) 
   * 
  */
  end:/\.(?=\n|\r|$(?![\r\n])|%| )/,
  open_ct: /[ \t\r\n]\(/,
  ws:      {match:/[ \t\r\n]+/,lineBreaks:true},
  line_comment: {match:/\%.*?$/,lineBreaks:true},
  block_comment: {match:/\/\*(?:.|\n)*?\*\//,lineBreaks:true},
  cut:"!",
  open:"(",
  clsoe:")",
  comma:",",
  semicolon:";",
  open_list:"[",
  close_list:"]",
  open_curly:"{",
  close_curly:"}",
  ht_sep:"|",
  string:{match:/"(?:""|\\(?:.|\n)|(?!").)*"/,lineBreaks:true},
  quoted_atom:{match:/'(?:''|\\(?:.|\n)|(?!').)*'/,lineBreaks:true},
  var:{match:/[_A-Z][_0-9a-zA-Z]*/},
  int:[
    {match:/0'(?:\\[abcefnrstv\\'"`\r\n]|\\x[0-9A-Fa-f]{1,4}\\?|\\u\[0-9A-Fa-f]{4}|\\U\[0-9A-Fa-f]{8}|\\[0-7]+|(?!\\).)/},
    {match:/[2-9]'[0-9]+/},
    {match:/[0-9 ]+/}
  ],
  atom:{match:/[a-z][_0-9a-zA-Z]*/},
  graphic:{match:/[#$&*+\-./:<=>?@^~\\]+/},
})

let tokens = [...lexer.reset(content)]
.filter(t => t.type !== 'ws'&& t.type !== 'line_comment'&&t.type!=="block_comment")
console.log(tokens)
