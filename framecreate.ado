program define framecreate 
	version 16.0
	syntax [namelist(name=frame_name max=1)], ///
		NEWFrame(string) ///
		[ ///
		CHANGE ///
		DROP ///
		]

	*Storing cwf
	local cf
	local cf "`c(frame)'"

	*!!!!!Error checking
	*1. If -newframe- exists, require -drop- before creating new frame.
	cap confirm new frame `newframe'
	local nf=0
	if _rc!=0 & mi("`drop'") {
		local nf=1
		di as error "Frame `newframe' already defined. Specify -drop- option to drop and replace."
		exit 110
	}
	if _rc!=0 & !mi("`drop'") {
		local nf=1
		if "`c(frame)'"=="`newframe'" {
			di as error "Can't drop working frame."
			exit 110
		}
	}
		
	*Step 1: Copying existing frame to new frame to new frame.
	if `nf'==0 & !mi("`frame_name'") {
		qui frame copy `frame_name' `newframe'
	}
	
	if `nf'==1 & !mi("`frame_name'") {
		cap assert !mi("`drop'")
		if _rc!=0 {
			di as error "Option -drop- required when attempting to replace an existing frame."
			exit 110
		}
		qui frame `drop' `newframe'
		qui frame copy `frame_name' `newframe'
	}
	
	*Step 2: Creating a new frame
	if mi("`frame_name'") {
		cap confirm frame `newframe'
		if _rc==0 {
			qui frame `drop' `newframe'
		}
		else {
		}
		qui frame create `newframe'
	}

	*Step 3: Change to the new frame, if option specified.
	if !mi("`change'") {
		qui frame change `newframe'
	}
	if mi("`change'") {
		qui frame change `cf'
	}
end