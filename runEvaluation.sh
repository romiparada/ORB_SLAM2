ATE_URL=https://svncvpr.in.tum.de/cvpr-ros-pkg/trunk/rgbd_benchmark/rgbd_benchmark_tools/src/rgbd_benchmark_tools/evaluate_ate.py
RPE_URL=https://svncvpr.in.tum.de/cvpr-ros-pkg/trunk/rgbd_benchmark/rgbd_benchmark_tools/src/rgbd_benchmark_tools/evaluate_rpe.py

CURRENT_PATH=$PWD
NODE_PATH="${CURRENT_PATH}/Examples/ROS/ORB_SLAM2"
DATA_PATH=$HOME/data

cd $DATA_PATH

[ ! -e evaluate_ate.py ] && wget ${ATE_URL}
[ ! -e evaluate_rpe.py ] && wget ${RPE_URL}

sequences=("desk_with_person" "sitting_static" "sitting_xyz" "sitting_halfsphere" "sitting_rpy"
 "walking_static" "walking_xyz" "walking_halfsphere" "walking_rpy")

index=0
if [ $1 ]
then
  index=$1
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

sequence=rgbd_dataset_freiburg${settings}_${sequences[$index]}

cd $CURRENT_PATH/data/TUM/${sequence}
mkdir -p evaluation
cd evaluation

trajectory=../results/CameraTrajectory.txt
groundtruth=$DATA_PATH/TUM/$sequence/groundtruth.txt

python $DATA_PATH/evaluate_ate.py $groundtruth $trajectory --verbose --plot ate_plot.png > ate_values.txt 
python $DATA_PATH/evaluate_rpe.py $groundtruth $trajectory --verbose > rpe_values.txt  
