func! custom#lightline#tab#modified(n)
  return gettabwinvar(a:n, tabpagewinnr(a:n), '&modified') ? '+' : ''
endfun

func! custom#lightline#tab#tabnum(n)
  let n = tabpagewinnr(a:n, '$')
  return (n == 1 ? '' : n)
endfun
