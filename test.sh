#!/bin/bash --
#Ben 2013/04/06 

H=8;W=10;

input(){
	read -t 1 -n 1 -s td;
}


setV(){
	eval $1='$2';
}
eat(){
	wx=$((`od -vAn -N1 -i /dev/urandom`*($W-1)/255));
	wy=$((`od -vAn -N1 -i /dev/urandom`*($H-1)/255));
	
	let length=$length+1;
	for((i=$length-1;i>=$h;i--));do
		setV sX$(( $i+1 )) $(( sX$(($i)) ));
        	setV sY$(( $i+1 )) $(( sY$(($i)) ));

	done
	
	setV sX$(( $h )) $x;
        setV sY$(( $h )) $y;

	((score++));
}
move(){
	h=$(( ($h-2+$length)%$length +1));
	setV sX$(( $h )) $x;
	setV sY$(( $h )) $y;	
}
check(){
	for((i=1;i<=$length;i++));do
		if [ "$x" -eq "$((sX$(($i))))" ] &&
		   [ "$y" -eq "$((sY$(($i)) ))" ] && 
		   [ $i -ne $h ];then
			tput cup $(($H+1)) 0;
			echo "score=$score              ";
			exit;
		fi
	done


}

init(){
	score=0;

	d="";
	x=0;y=0;
	wx=$(($W-1));wy=$(($H-1));
	
	length=1;head=1;
	sX0=$x;sY0=$y;

	output;
}
process(){
	if [ "$td" == "W" ] || [ "$td" == "S" ] ||
           [ "$td" == "D" ] || [ "$td" == "A" ];then d=$td;fi
	
	if [ "$d" == "W" ];then 
		let y=($y+$H-1)%$H;
	elif [ "$d" == "S" ];then 
		let y=($y+1)%$H;
	elif [ "$d" == "D" ];then
		let x=($x+1)%$W;
	elif [ "$d" == "A" ];then
		let x=($x+$W-1)%$W;
	fi

	if [ "$x" -eq "$wx" ] && [ "$y" -eq "$wy" ];then 
		eat;
	else
		move;
	fi
	check

}

printHead(){
	c=34;
	if [ "$d" == "W" ];then
        	printColor u $1 $2 $c
	elif [ "$d" == "S" ];then
        	printColor n $1 $2 $c
	elif [ "$d" == "D" ];then
        	printColor c $1 $2 $c
	elif [ "$d" == "A" ];then
        	printColor z $1 $2 $c
	fi
}
output(){

	clear;
	background;
	
	for((i=1;i<=$length;i++));do 
		printColor x $(( sY$(($i)) )) $(( sX$(($i)) ))  31;
	done

	#print y $y $x;
	printHead $y $x;
	printColor o $wy $wx 32;	
	print "" $H 0;

	info;	

}
debug(){
	for((i=1;i<=$length;i++));do
                echo $i--  $(( sY$(($i)) )) $(( sX$(($i)) ));
        done
        echo y=$y x=$x
        echo h=$h


}
info(){
	echo "shellSnake."
	echo "move:WASD"
}

printColor(){
	tput cup $2 $3;
	echo -e '\e[0;'"$4"'m'$1'\e[0m'

}

print(){
	tput cup $2 $3;
	echo -n $1

}
background(){
	for((i=0;i<$H;i++));do
		for((j=0;j<$W;j++));do
			echo -n +;
		done
		echo ;
	done
}
init
while true;do 
	input;
	process;
	output;
done
