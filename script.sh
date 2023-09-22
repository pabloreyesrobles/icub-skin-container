echo 'Starting Yarp Server...'
yarpserver > /dev/null 2>&1 &

sleep 1
echo 'Starting gzserver with iCub skin...'
gzserver code-icub-gazebo-skin/worlds/icub_skin.world -s libgazebo_yarp_clock.so > /dev/null 2>&1 &
GAZEBO_PID=$!
sleep 15

echo 'Starting iCub modules'
yarprobotinterface --context gazeboCartesianControl --config no_legs.xml > /dev/null 2>&1 &
iKinCartesianSolver --context gazeboCartesianControl --part right_arm > /dev/null 2>&1 &
iKinCartesianSolver --context gazeboCartesianControl --part left_arm > /dev/null 2>&1 &

echo 'Training will start in 5 seconds'
sleep 5
python ./HebbianMetaLearning/train_hebb.py --environment icub_skin-v0 --generations 100 --popsize 25 --threads 1 --sigma 0.15

#iCubSkinGui --from left_arm.ini --useCalibration > /dev/null 2>&1 &
#iCubSkinGui --from left_forearm.ini --useCalibration > /dev/null 2>&1 &
#iCubSkinGui --from left_hand.ini --useCalibration > /dev/null 2>&1 &
#iCubSkinGui --from right_arm.ini --useCalibration > /dev/null 2>&1 &
#iCubSkinGui --from right_forearm.ini --useCalibration > /dev/null 2>&1 &
#iCubSkinGui --from right_hand.ini --useCalibration > /dev/null 2>&1 &
#iCubSkinGui --from torso.ini --useCalibration > /dev/null 2>&1 &

#sleep 1

#yarp connect /icubSim/skin/left_arm_comp /skinGui/left_arm:i
#yarp connect /icubSim/skin/left_forearm_comp /skinGui/left_forearm:i
#yarp connect /icubSim/skin/left_hand_comp /skinGui/left_hand:i
#yarp connect /icubSim/skin/right_arm_comp /skinGui/right_arm:i
#yarp connect /icubSim/skin/right_forearm_comp /skinGui/right_forearm:i
#yarp connect /icubSim/skin/right_hand_comp /skinGui/right_hand:i
#yarp connect /icubSim/skin/torso_comp /skinGui/torso:i

#trap interruptHandler SIGINT SIGTERM
#wait