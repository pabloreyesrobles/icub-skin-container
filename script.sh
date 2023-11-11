echo 'Starting Yarp Server...'
yarpserver > /dev/null &> ../yarpserver.log &

sleep 1
echo 'Starting gzserver with iCub skin...'
gzserver code-icub-gazebo-skin/worlds/icub_skin.world -s libgazebo_yarp_clock.so > /dev/null &> ../gzserver.log &
GAZEBO_PID=$!
sleep 15

yarprobotinterface --context gazeboCartesianControl --config no_legs.xml > /dev/null &> ../yarprobotinterface.log & 
iKinCartesianSolver --context gazeboCartesianControl --part right_arm > /dev/null &> ../iKinCartesianSolver_right_arm.log &
iKinCartesianSolver --context gazeboCartesianControl --part left_arm > /dev/null &> ../iKinCartesianSolver_left_arm.log &

sleep 10
echo 'Training will start in 3 seconds'
sleep 3
cd HebbianMetaLearning
python train_hebb.py --environment icub_skin-v0 --generations 100 --popsize 25 --threads 1 --sigma 0.15 &> ../train_hebb.log &

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