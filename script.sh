interruptHandler () {
    yarp disconnect /icubSim/skin/left_arm_comp /skinGui/left_arm:i
    yarp disconnect /icubSim/skin/left_forearm_comp /skinGui/left_forearm:i
    yarp disconnect /icubSim/skin/left_hand_comp /skinGui/left_hand:i
    yarp disconnect /icubSim/skin/right_arm_comp /skinGui/right_arm:i
    yarp disconnect /icubSim/skin/right_forearm_comp /skinGui/right_forearm:i
    yarp disconnect /icubSim/skin/right_hand_comp /skinGui/right_hand:i
    yarp disconnect /icubSim/skin/torso_comp /skinGui/torso:i

    kill $GAZEBO_PID
    pkill -f gzserver
    kill $(jobs -p)
}

gzserver code-icub-gazebo-skin/worlds/icub_skin.world &
GAZEBO_PID=$!
sleep 15

iCubSkinGui --from left_arm.ini --useCalibration > /dev/null 2>&1 &
iCubSkinGui --from left_forearm.ini --useCalibration > /dev/null 2>&1 &
iCubSkinGui --from left_hand.ini --useCalibration > /dev/null 2>&1 &
iCubSkinGui --from right_arm.ini --useCalibration > /dev/null 2>&1 &
iCubSkinGui --from right_forearm.ini --useCalibration > /dev/null 2>&1 &
iCubSkinGui --from right_hand.ini --useCalibration > /dev/null 2>&1 &
iCubSkinGui --from torso.ini --useCalibration > /dev/null 2>&1 &

sleep 1

yarp connect /icubSim/skin/left_arm_comp /skinGui/left_arm:i
yarp connect /icubSim/skin/left_forearm_comp /skinGui/left_forearm:i
yarp connect /icubSim/skin/left_hand_comp /skinGui/left_hand:i
yarp connect /icubSim/skin/right_arm_comp /skinGui/right_arm:i
yarp connect /icubSim/skin/right_forearm_comp /skinGui/right_forearm:i
yarp connect /icubSim/skin/right_hand_comp /skinGui/right_hand:i
yarp connect /icubSim/skin/torso_comp /skinGui/torso:i

trap interruptHandler SIGINT SIGTERM
wait