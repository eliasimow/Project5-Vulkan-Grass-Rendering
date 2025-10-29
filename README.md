https://github.com/user-attachments/assets/830acb53-29e5-4a4c-8e53-ab2417369332


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

Lastly, we should add a wind effect, so our blades flow back and forth. I used simplex noise for my wind, sourced from Ashima Arts / Stefan Gustavson. We choose an arbitrary wind direction in the xz plane, and push our blades in that direction to a degree corresponding to the blade's default direction and a noise value sampled over time. Finally, we have a windy grass field!

![output](https://github.com/user-attachments/assets/5ef28fd0-da90-4f5b-b331-cda481814abb)

## Performance

### Culling Methods

![Recording 2025-10-28 221452](https://github.com/user-attachments/assets/71cb85e1-9528-44c4-8105-bdf56f944837)


We add three culls for performance. The first is a distance cull, such that no blade over a certain threshold should be drawn. The second is a frustrum cull, such that no blade outside the camera view should be drawn. The final is an orientation cull, such that no blade facing away from the camera should have its back side rendered. 


### Results

For performance testing, we worked with a large plane of size 105.f, with a default blade count of 1 << 23 unless otherwise specified.

First, let's look at the cumulative strain of blade count.

<img width="600" height="371" alt="Averaged FPS vs  Blade Count" src="https://github.com/user-attachments/assets/98dfe156-b4de-4aba-9a20-d85b3cb7d46a" />

Now, this is mostly as expected. When accounting for the logorithmic x scale, this is a largely linear relationship between number of drawn blades and the application performance. It's worth noting though that the number here is not actually the number of drawn blades to screen! Indeed, I made all these measurements with the three culling methods active. That means that the vast majority of blades were not being drawn. However, as the relationship between cull amount and blade amount is strictly linear, I felt no need to distinguish the two in my measurements here.

<img width="600" height="371" alt="FPS vs  Culling Method" src="https://github.com/user-attachments/assets/0be7cb4e-6860-44cf-ac83-9aada721469d" />

Next up is the comparison of our different culling methods. I made these with my scene size set to 105.f, and with 1 << 23 blades. The most apparent result is that the sum total of the performance gains when combining all three culling methods seems to be greater than each on their own. That's surprising to me, especially when considering the linear relationship between blades drawn and performance, as seen in the prior graph. My best theory is that, together, they push the 1 << 23 scene past some thread threshold on my GPU. I'd like to repeat this test on another laptop when possible to compare and contrast! Other than that, the results are mostly straightforward. The top performer is my orientation culling, which makes sense. Because I have it set to only draw blades underneath a .2 threshold, the majority of blades should be eliminated here. I'd still think that this should be a better improvement with that magnitude of that cull considered, but at least it does come in first. Distance performed worse than I expected, especially considering the large scene. But in further tests with a reduced max distance from its default 100 meters, we can see it starting to show its value:

<img width="600" height="371" alt="FPS vs  Max Distance" src="https://github.com/user-attachments/assets/ecc6826f-1e70-4bce-aaee-0cec1b9e5e81" />

These values were surveyed with only distance culling active. Lower max distance have an exponential performance boost! This makes sense; increasing the radius of our distance circle around the camera adds increasingly more blades to the circle of rendering. But while these performance increases are notable, so too is their cost: At low values, distance culling becomes the most visibly jarring of our three culling methods. So, in future applications of these methods, I'll have to be cogniziant of the artifacts distance cullings requires in order to be greatly effective.


## Closing Thoughts

I really enjoyed this lab! I hope to use the grass I've made here as a basis for the environment of my next project: procedural voxel based clouds! 
