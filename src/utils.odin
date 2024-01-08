package main

import "core:intrinsics"

@(require_results)
array_cast :: proc "contextless" (v: $A/[$N]$T, $Elem_Type: typeid) -> (w: [N]Elem_Type) #no_bounds_check {
	for i in 0..<N {
		w[i] = Elem_Type(v[i])
	}
	return
}
