# Statistisk bildanalys för människa-dator-interaktion

Bachelor's thesis, Harald Freij, Viktor Nilsson, David Samuelsson and Simon Sigurdhsson, 2011.

## Abstract

This report describes the work with and the theory behind the implementation of a program that can identify a number of different static gestures with high accuracy. The report also describes methods which use hidden Markov models (HMM) to identify dynamic gestures.

The classification methods used are completely statistical, and use neither prefabricated hand models nor artificial neural networks. Hand identification requires the user to wear a shirt with long sleeves, but methods to identify wrists are described in the report, enabling relaxation of this requirement.

The analysis is done on prerecorded video clips, but real-time analysis has been implemented with satisfying results.

With Gaussian Mixture Models for skin identification and kNN classification for gesture recognition ten static gestures can be identified with an accuracy of 91.4 %. For analysis of dynamic gestures results are missing, as all methods are not implemented.

## Compiling the thesis

This thesis should compile on most TeX distributions. There's a Makefile, so you could just do `make pdf` in the main directory to compile the entire thesis.

## Licensing

The work herein is Copyright 2011 Harald Freij, Viktor Nilsson, David Samuelsson and Simon Sigurdhsson.
**No rights are given to reproduce or modify this work.**
