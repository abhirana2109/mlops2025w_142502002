clear
echo "--------- SUM OF N NUMBERS IN SHELL SCRIPT ----------------"
echo -n "Enter the value of n: "
read digit
t=1
total=0
while test $t -le $digit
do
	total=`expr $total + $t`
	t=`expr $t + 1`	
done
echo "SUM OF $digit: $total"
