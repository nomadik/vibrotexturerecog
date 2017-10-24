First Finger (index finger) FF was
moving from left to right and from right to left  while sliding over different surfaces.

FFJ4 is the joint that moved.

FFJ4_set_point is the command (joint angle).  each change of the FFJ4_set_point is new trial.

Surfaces: Tkan (fabric material), fabric (fabric material with different structure),
dvp (wood withflat top side and very rough back side), steeel (metalic sheet).

FFJ4_tao  is proportional to the friction force during the slidings.
FFJ3_tao is proportional to the normal force applied to the surface.


The tactile data was recorded at 100 Hz.

finger kinematics and joint names: 
FFJ1 - First (index) finger Joint one - distal joint
FFJ2 - First (index) finger Joint two - proximal joint
FFJ3 - First (index) finger Joint three - metacarpal joint (down up)
FFJ4 - First (index) finger Joint four - metacarpal joint (left right)

FFJ1_dot - velocity of the joint

FFJ1_tao - effort at the joint (do not take this into account. it is the data from the strain gauges attached to the tendon that moves the joint)

Tactile data:
pac0 =  dynamic pressure (high frequency from barometer) channel zero (located at the tip)

pac1 = dynamic pressure (high frequency from barometer) channel one (located at the base of the sensor)

pdc = static pressure (low frequency from barometer)

tac = temperature flow
tdc = static temperature

el0 = electrode value (there are 19 electrodes around the sensor) it is proportional to the deformations of the sensor surface 
el1
el2
...
el18

In order to have more data to compare with, there is the data from Middle finger that was not in contact
