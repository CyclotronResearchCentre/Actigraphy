Automatic actigraphic recording analysis
==========

In other words, given actigraphic recodings, detect the sleep/wake periods in an automatic way.

Limitations/warnings:
---------------------
So far 
- the development were tested on only one kind of actigraphic recordings (from ActiWatch to be precise)
- it works and assumes that sleep patterns are regular and were acquired on a 'normal healthy' subject. All in all, the following 2 hypothesis are used: sleep for about 33% of the time in long continuous spell.
- some bit of code are hard-coded for a sampling interval of 60s. Hopefully this constraint will be (easily) lifted...
- for file selection, the code use the function spm_select from the SPM package. Should be replacable by the 'uigetfile' function from Matlab at some point...

Administrators:
- Christophe Phillips, email c_dot_phillips_at_ulg_dot_ac_dot_be
