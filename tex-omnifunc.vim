set omnifunc=TeX_Complete

function! TeX_Complete(findstart, base)
	if a:findstart
		let res = strridx( getline("."), "{" )
		if res != -1
			return res + 1
		else
			return -1
		endif
	else
		let rtn = []
		ruby <<EOF
		# coding: utf-8
		$KCODE = 'u' if RUBY_VERSION < '1.9'
		require 'yaml'
		base = VIM.evaluate 'a:base'
		dict = YAML.load(File.open( 'dict-labels.yaml' ) )
		comp_info = dict.select{|k,v| k.start_with? base }.map{|pair|
		  "{ 'word': '#{ pair[0] }', 'menu': '#{ pair[1] }' }"
		}
		VIM.command "let rtn = [ #{ comp_info.join(', ')} ]"
EOF
		return rtn
	endif
endfunction
