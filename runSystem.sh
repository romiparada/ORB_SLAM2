DATA_URL=https://vision.in.tum.de/rgbd/dataset/freiburg
ASSOCIATE_URL=https://svncvpr.in.tum.de/cvpr-ros-pkg/trunk/rgbd_benchmark/rgbd_benchmark_tools/src/rgbd_benchmark_tools/associate.py

CURRENT_PATH=$PWD
NODE_PATH="${CURRENT_PATH}/Examples/ROS/ORB_SLAM2"
DATA_PATH=$HOME

getData () {
  wget ${DATA_URL}$2/$1
}

export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:${NODE_PATH}
cd $DATA_PATH

mkdir -p data/TUM

cd data
DATA_PATH=$DATA_PATH/data

[ ! -e associate.py ] && wget ${ASSOCIATE_URL}

cd TUM

sequences=("desk_with_person" "sitting_static" "sitting_xyz" "sitting_halfsphere" "sitting_rpy" "walking_static" "walking_xyz" "walking_halfsphere" "walking_rpy")


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

if [ ! -d ${sequence} ]
then
  getData $sequence.bag $settings
  getData ${sequence}.tgz ${settings}
  tar zxvf ${sequence}.tgz
  rm ${sequence}.tgz
fi

python $DATA_PATH/associate.py ${sequence}/rgb.txt ${sequence}/depth.txt > ${sequence}/associate.txt



cd ${CURRENT_PATH} 
mkdir -p data/TUM/${sequence}/results

settings=${NODE_PATH}/../../RGB-D/TUM${settings}.yaml 
association=${DATA_PATH}/TUM/${sequence}/associate.txt 
results_path=${CURRENT_PATH}/data/TUM/${sequence}/results/
sequence=${DATA_PATH}/TUM/${sequence}.bag

roslaunch TUM.launch settings:=${settings} sequence:=${sequence} association:=${association} results_path:=${results_path}
