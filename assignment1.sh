#!/bin/sh

#TODO tarCheck function


#if tar archive 
tarCheck=`echo $1 | grep -Ec '(*\.tar\.gz$|*\.tgz$)'`
if test $tarCheck -gt 0 ; then
	tar -xf $1
	filelist=`tar -tf $1`
	#echo $filelist
	archive=1
fi


#if directory
if test -d $1 ; then

	#saving filelist
	cd $1
	filelist=`ls`
	archive=0	
fi

count=0
	#for every item in filelist check if regfile or dir

for i in $filelist
do
    #echo $i
    if test -d $i ; then
		#echo "directory $i"
		$0 $i 
		#continue
		
    elif test -f $i ; then #if regfile then check if tar archive TODO

    	#else check occurance
		check=`cat $i | grep -c 'much Open, such Stack'`
		if test $check -gt 0 ; then #if there are, print filenames and count
		    echo $i
		    count=`expr $count + 1`
		fi
    fi
done

#if it was an archive, delete its extracted filelist
if test $archive -eq 1 ; then
	for i in $filelist
	do
		rm -rf $i
	done
fi
#if last argument is 1 then return value TODO
return $count
#else print final count TODO
echo "there are $count occurences"
