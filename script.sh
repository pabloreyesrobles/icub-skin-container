yarpserver > /dev/null 2>&1 &
sleep 1
gzserver code-icub-gazebo-skin/worlds/icub_skin.world -s libgazebo_yarp_clock.so > /dev/null 2>&1 &
GAZEBO_PID=$!
sleep 15

yarprobotinterface --context gazeboCartesianControl --config no_legs.xml > /dev/null 2>&1 &
iKinCartesianSolver --context gazeboCartesianControl --part right_arm > /dev/null 2>&1 &
iKinCartesianSolver --context gazeboCartesianControl --part left_arm > /dev/null 2>&1 &

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