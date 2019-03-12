DIR=$1
hostname=$(hostname)
nodeid=$(echo $hostname | cut -c8-9)
jobstxt="jobs$nodeid.txt"

cp /dev/null $jobstxt

for i in $(ls $DIR| grep mat); do
	echo $DIR/$i >> ./$jobstxt;
done
