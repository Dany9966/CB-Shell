#!/bin/sh

# function that determines whether the argument is a tar archive or not  
isTarArchive(){
	#echo "isTarArchive $1"
	tarCheck=`echo $1 | grep -Ec '(*\.tar\.gz$|*\.tgz$)'`
	if test $tarCheck -gt 0 ; then
		true
	else 
		false
	fi
}

#Testing user, if root then echo
#Tried with $UID here, but didn't work, idk why
if test `id -u` -eq 0 ; then	
	echo "Sorry, no root allowed!"
else
	#argument handling
	arglist=""
	recursivecall=`echo $0 $@ | grep -c '\ -r\ '` # returns 1 if there is a -r argument
	printnames=`echo $0 $@ | grep -c '\ -n\ '`	# returns 1 if there is a -n argument
	countoccurances=`echo $0 $@ | grep -c '\ -c\ '` 	# returns 1 if there is a -c argument

	if test $printnames -eq 1 ; then
		arglist="$arglist -n"
	fi

	if test $countoccurances -eq 1 ; then
		arglist="$arglist -c"
	fi
	
	if test $# -eq `expr $recursivecall + 1` ; then
		printnames=1
		countoccurances=1
	fi

	lastarg=`echo $@ | cut -f $# -d ' '` #gets the last argument

	#if tar archive 
	if isTarArchive $lastarg ; then
		mkdir _arch 	# make temp dir for archive
		tar -xf $lastarg --directory _arch # extract into _arch
		aux_dir="_arch"
		filelist=`tar -tf $lastarg`
		archive=1
	
	#if directory
	elif test -d $lastarg ; then
		checkWholePath=`echo $lastarg | grep -Ec '^\/'`
		if test $checkWholePath -eq 0 ; then
			aux_dir=`pwd`/$lastarg
		else
			aux_dir=$lastarg
		fi
		aux_dir=`echo $aux_dir | sed '$ s/\/$//'`
		#saving filelist
		filelist=`ls $lastarg`
		

		archive=0
	fi

	count=0
		#for every item in filelist check if regfile or dir

	for i in $filelist
	do
	    if test -d $aux_dir/$i ; then
	    	
			$0 -r $arglist $aux_dir/$i
				count=`expr $count + $?`
			
	    elif test -f $aux_dir/$i ; then #if regfile then check if tar archive
	    	if isTarArchive $i ; then
	    		
	    		$0 -r$arglist $aux_dir/$i
	    			count=`expr $count + $?`
	    	else
	    	#else check occurance
				check=`cat $aux_dir/$i | grep -c 'much Open, such Stack'`
				if test $check -gt 0 ; then #if there are, print filenames and count
					if test $printnames -eq 1 ; then
				    	echo $aux_dir/$i
				    fi
				    	count=`expr $count + 1`
				fi
			fi
	    fi
	done

	#if it was an archive, delete its extracted filelist
	if test $archive -eq 1 ; then
		for i in $filelist
		do
			rm -rf _arch
		done
	fi
	#if last argument is 1 then return value
	if test $recursivecall -eq 1 ; then
		return $count
	fi
	#else print final count
	if test $countoccurances -eq 1 ; then
		echo "there are $count occurences"
	fi
fi