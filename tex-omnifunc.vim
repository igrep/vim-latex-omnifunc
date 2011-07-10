" vim: expandtab
set omnifunc=TeX_Complete
"ruby <<EOF
"# coding: utf-8
"require 'yaml'
"$KCODE = 'u' if RUBY_VERSION < '1.9'
"dict = YAML.load(File.open( 'dict-labels.yaml' ) )
"base_ref = 'a:base'
"sq  = "'"
"esc = "''"
"EOF

function! TeX_Complete(findstart, base)
  if a:findstart
    let res = strridx( getline(".")[0:(col('.'))], "{" )
    if res != -1
      return res + 1
    else
      return -1
    endif
  else
    let rtn = []
    ruby <<EOF
    # coding: utf-8
    # Ruby assigns nil to first_run when detects its assignment while compiling
    first_run = true if first_run.nil?
    if first_run
      # I wanted to move this clause to the head of this script,
      # But my Vim's bug prevented that: happens SystemStackError.
      require 'yaml'
      $KCODE = 'u' if RUBY_VERSION < '1.9'
      dict = YAML.load(File.open( 'dict-labels.yaml' ) )
      base_ref = 'a:base'
      sq  = "'"
      esc = "''"
      first_run = false
    end
    base = VIM.evaluate base_ref
    comp_info = dict.select{|k,v| k.start_with? base }.map{|pair|
      word = pair[0].gsub(sq, esc)
      menu = pair[1].gsub(sq, esc)
      "{ 'word': '#{ word }', 'menu': '#{ menu }' }"
    }
    VIM.command "let rtn = [ #{ comp_info.join(', ')} ]"
EOF
    return rtn
  endif
endfunction
