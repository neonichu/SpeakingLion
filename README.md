SpeakingLion
============

SpeakingLion is a commandline speech synthesis tool for Mac OS X Lion.
It acts as a testing ground for me to learn about NSLinguisticTagger and
NSSpeechSynthesizer. 

It analyzes all text you feed to it via stdin and
will select the right voice for each sentence based on the determined
language. It should skip and ignore all text it cannot recognize. It
will tell you about missing voices, you install those using the
VoiceOver utility. This program runs only under Lion and was tested and
compiled using Xcode 4.2.

See LICENSE for licensing information.

--
Boris Buegling (<boris@icculus.org>)
