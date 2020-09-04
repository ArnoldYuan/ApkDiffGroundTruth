src="source"
rst="result"
if [ ! -e $rst ] ; then
    mkdir $rst
fi
root=`pwd`
cd $src
for dir in `ls` ; do
    if [ -d $dir ] ; then
        echo "**********"$dir" started **********"
        cd "$root/$src/$dir/app"
        rm "proguard-rules.pro"
        cp "$root/proguard-rules.pro" .
        output=tmp.txt
        touch $output
        IFS_old=$IFS
        IFS=$'\n'
        for line in `cat build.gradle` ; do
            tmp=`echo $line | awk '/minifyEnabled/'`
            if [ $tmp ] ; then
                line="            minifyEnabled true"
            fi
            echo $line >> $output
        done
        echo " " > build.gradle
        for line in `cat $output` ; do
            echo $line >> build.gradle
        done
        IFS=$IFS_old
        rm $output
        cd "$root/$src/$dir"
        chmod 777 gradlew
        ./gradlew assembleRelease
        cd "$root/$rst"
        mkdir $dir
        cp -r "$root/$src/$dir/app/build/outputs/apk" $dir
        cp -r "$root/$src/$dir/app/build/outputs/mapping" $dir
        echo "**********"$dir" finished**********"
    fi
    cd "$root/$src"
done
cd $root