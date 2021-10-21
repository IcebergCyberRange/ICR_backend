"""
FP run.py
"""

from mininet.net import Mininet
from mininet.cli import CLI
from mininet.term import makeTerm
from minicps.mcps import MiniCPS
from topo import FPTopo

import time


class FPCPS(MiniCPS):

    """Main container used to run the simulation."""

    def __init__(self, name, net):

        self.name = name
        self.net = net

        net.start()
        net.pingAll()

        # start devices
        plc1, plc2, plc3, s1, attacker, hmi = self.net.get('plc1', 'plc2', 'plc3', 's1',  'attacker', 'hmi')

        
        # run the scripts for the filling process in the respecitve mininet hosts
        s1.cmd('screen -dmSL tank python physical_process.py -Logfile ./logs/tank-screen.log')
        s1.cmd('screen -dmSL bottle python physical_process_bottle.py -Logfile ./logs/bottle-screen.log')
        plc3.cmd('screen -dmSL plc3_process bash plc3_loop.sh -Logfile ./logs/plc3_process-screen.log')
        plc2.cmd('screen -dmSL plc2_process bash plc2_loop.sh -Logfile ./logs/plc2_process-screen.log')
        plc1.cmd('screen -dmSL plc1_process bash plc1_loop.sh -Logfile ./logs/plc1_process-screen.log')
        
        # run the scripts for the defense capability in the respecitve mininet hosts
        plc1.cmd('screen -dmSL plc1_ids python tcp_capture.py -Logfile ./logs/plc1_ids-screen.log')
        hmi.cmd('screen -dmSL hmi_ids python firewall.py -Logfile ./logs/hmi_ids-screen.log')
        
        # run the scripts for the attack capability in the respective mininet hosts
        #attacker.cmd('screen -dmSL attacker_rm_attack bash rm_attack.sh -Logfile')
        attacker.cmd('screen -dmSL attacker_dos_attack bash dos_attack.sh -Logfile ./logs/attacker_dos_attack-screen.log')
        attacker.cmd('screen -dmSL attacker_mitm_attack bash mitm_attack.sh -Logfile ./logs/attacker_mitm_attack-screen.log')
        
        # create screens to get inside the nodes/hosts during run time
        s1.cmd('screen -dmSL s1_shell')
        plc3.cmd('screen -dmSL plc3_shell')
        plc2.cmd('screen -dmSL plc2_shell')
        plc1.cmd('screen -dmSL plc1_shell')
        hmi.cmd('screen -dmSL hmi_shell')
        attacker.cmd('screen -dmSL attacker_shell')
        

        # see the scripts running
        # NB: xterm required
        # uncomment the following lines (while removing the .cmd lines above)
        #net.terms += makeTerm(s1, display=None, cmd='python physical_process.py')
        #time.sleep(0.2)
        #net.terms += makeTerm(s1, display=None, cmd='python physical_process_bottle.py')
        #time.sleep(0.2)
        #net.terms += makeTerm(plc3, display=None, cmd='python plc3.py')    # display=None
        #time.sleep(0.2)
        #net.terms += makeTerm(plc2, display=None, cmd='python plc2.py')
        #time.sleep(0.2)
        #net.terms += makeTerm(plc1, display=None, cmd='python plc1.py')
 

        CLI(self.net)
        # self.net.stop()


if __name__ == "__main__":

    topo = FPTopo()
    net = Mininet(topo=topo)

    fpcps = FPCPS(
        name='FPCPS',
        net=net)
