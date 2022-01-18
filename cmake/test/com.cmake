
set(tplt "A" "B" "C" "A" "D" "B")
message("${tplt}")
bmf_remove_repeat(tplt)
bmf_remove_repeat(${tplt})
message("${tplt}")