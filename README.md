Vulkan Grass Rendering
==================================

**University of Pennsylvania, CIS 565: GPU Programming and Architecture, Project 5**
*  Eli Asimow
* [LinkedIn](https://www.linkedin.com/in/eli-asimow/), [personal website](https://easimow.com)
* Tested on: Windows 11, AMD Ryzen 7 7435HS @ 2.08GHz 16GB, Nvidia GeForce RTX 4060 GPU

## Overview

Hello! Welcome to my Vulkan tesselated grass implementation. This application can easily render a million grass blades in a real time context, with each blade tesslating for further vertex detail. To acheive this result, I implemented several culling filters in a compute shader, which minimize the stress on the fragment stage.

## Process

### Initial Blades

<img width="1386" height="496" alt="Screenshot 2025-10-28 210250" src="https://github.com/user-attachments/assets/df5db13b-49ff-4224-a6f2-2ecaed8273bb" />

The first stage of the implementation was getting anything to show up at all! We render a simple plane, and then instance grass blades, scattered randomly across it. They are each a simple triangle of vertices. There was no use for compute or tescelation shaders at this stage, but I built them into the pipeline as empty shader steps in anticipation of the work to come.

### Tesselation

<img width="1469" height="643" alt="Screenshot 2025-10-28 210622" src="https://github.com/user-attachments/assets/123e664e-27f4-478e-9639-caec977ad010" />

For the next step, we add a division of our simple triangle mesh through our tesselation shaders. In our tesc shader, we set a level of 10, which divides our blade into ten individual tesselated levels for the tese shader, where we determine these levels placement using a bezier curve with three degrees. 

### Compute Shader Forces

Next, we add the physical forces that will animate our grass. The first is gravity -- although it's not too interesting on its own, as it just pushes the grass into the plane! 

<img width="1600" height="714" alt="Screenshot 2025-10-28 212548" src="https://github.com/user-attachments/assets/c9f89691-5877-4775-94f5-2a1fa23bdf50" />

We need to add a recovery force, which will pull our grass towards its initial position. Here's how the field looks after that:

<img width="1686" height="744" alt="image" src="https://github.com/user-attachments/assets/9407a4e6-1b24-4d0a-8557-09ef719a7988" />


