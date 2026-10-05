/////////////////////////////////
//          GS RQMT            //
/////////////////////////////////

/******GS1******/
//Include 1 or more displays to show the telemetry from the CTR & PQ
//STATUS: TODO

/******GS2******/
//CTR's altitude, temperature and batter current shall be plotted in real time
//STATUS: done; all sensor readings from telemetry are plottable

/******GS3******/
//CTR's non-plotted telemetry should be displayed graphically/readable text
//STATUS: TODO
//        ID, time, packet #, cmd #, flight mode, ctr operation mode, mech state, cmd echo

/******GS4******/
//PQ's altitude, temp, bat volt, bat current, orientation, gps pos, solar panel volt's should be plotted in real time
//STATUS: ing; altitude, temp, bat volt, bat current plottable
//        TODO
//        orientation(3d or plot?), gps pos(time v lon/lat or 2d?)

/******GS5******/
//PQ's non-plotted telemetry should be displayed graphically/readable text
//STATUS: TODO
//        ID, time, packet #, cmd #, flight mode, mech state, cmd echo, image cmd, sci-exp cmd

/******GS6******/
//GS shall send cmd's to the CTR and the PQ
//STATUS: TODO
//        cmd interface not ready

/******GS7******/
//GS shall support sim mode
//STATUS: TODO
//        cmd interface not ready

/******GS8******/
//Sim mode shall read a file w/ air pressure profile and send updated air pressure values @ 1hz
//STATUS: TODO
//        cmd interface not ready

/******GS11*****/
//GS should count the # of received packets
//STATUS: done, check 'frame_count'; Frame.parseFrame()

/******GS12*****/
//GS should use large fonts(>=14), bold lines and dark text on light background
//STATUS: done

/******GS13*****/
//GS should generate a ASCII .csv with telemetry rqmt
//STATUS: TODO

/******GS14*****/
//each team shall devlop their own GS
//STATUS: ing

/******GS16*****/
//GS should be able to command the payload to operate in sim mode by sending two commands; SIM_ENABLE & SIM_ACTIVATE
//STATUS: TODO
//        cmd interface not ready
//        *implement ack check logic

/******GS17*****/
//GS should be able to activate all mech's on command
//STATUS: TODO
//        cmd interface not ready
