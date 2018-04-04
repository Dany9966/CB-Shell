#!/bin/sh
#saving filelist
cd $1
filelist=`ls`
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

return $count
echo "there are $count occurences"
