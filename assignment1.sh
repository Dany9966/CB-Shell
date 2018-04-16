#!/bin/sh


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
	#$0 $i 
	continue
	
    elif test -f $i ; then #if regfile then check if there is occurance
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


return $count
echo "there are $count occurences"
