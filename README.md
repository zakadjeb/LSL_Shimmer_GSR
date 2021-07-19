LSLShimmerApplication
IMPORTANT: Works only with JDK 8 (x86)

ShimmerGSR Java application streaming data via LSL (LabRecorder).

- Make sure the GSR Shimmer is connected to the computer via bluetooth (Windows -> Bluetooth settings -> Add Device)
- BLUETOOTH PASSWORD: 1234

- Open the 'launch' batch file
- Open Device Manager
- Open 'Ports'
- Check which port is allocated to Bluetooth (typically COM3 or COM4)
- Type in 'COM3' or whatever COM-port was discovered, into the terminal that opened when hitten 'launch'

- Open LabRecorder and check if stream is running.

---------------

Once data has been acquired, a Matlab function can convert the .xdf-fil to .mat-file that can be opened by Ledalab, which  is a GSR analysis plugin to Matlab. 

- Add the 'xdftoledalab.m' file to your current Matlab file.
- It automatically finds the ShimmerGSR stream and converts the conductance.
- Use the F1-help for how to use. 