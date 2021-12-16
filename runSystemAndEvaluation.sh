sequences=("desk_with_person" "sitting_static" "sitting_xyz" "sitting_halfsphere" "sitting_rpy"
 "walking_static" "walking_xyz" "walking_halfsphere" "walking_rpy")

index=0
if [ $1 ]
then
  index = $1
else
  echo "Choose TUM sequence:"
  for sequence in ${sequences[@]}; do
    echo "$index - $sequence"
    (( index += 1 ))
  done
  
  read -p "Sequence index: " index
fi

settings=3
if [ ! $index ]
then
  settings=2
fi

./runSystem.sh $index
./runEvaluation.sh $index
