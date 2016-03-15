" Load SQL syntax
unlet b:current_syntax
syn include @SQL syntax/sql.vim
unlet b:current_syntax

syn region SQLEmbedded start=+\z(['"]\)\zs[ \s\n]*\v(ALTER|CALL|COMMENT|COMMIT|CONNECT|CREATE|DELETE|DROP|EXPLAIN|EXPORT|GRANT|IMPORT|INSERT|LOAD|LOCK|MERGE|REFRESH|RENAME|REPLACE|REVOKE|ROLLBACK|SELECT|SET|TRUNCATE|UNLOAD|UNSET|UPDATE|UPSERT)+ skip=+\\\z1+ end=+\ze\z1+ contains=@SQL containedin=pythonString

let b:current_syntax = "pysql"
